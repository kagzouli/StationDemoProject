package com.exakaconsulting.poc;


import javax.sql.DataSource;

import org.h2.Driver;
import org.springframework.batch.core.Job;
import org.springframework.batch.core.Step;
import org.springframework.batch.core.configuration.annotation.EnableBatchProcessing;
import org.springframework.batch.core.configuration.annotation.JobBuilderFactory;
import org.springframework.batch.core.configuration.annotation.StepBuilderFactory;
import org.springframework.batch.core.launch.support.RunIdIncrementer;
import org.springframework.batch.item.ItemProcessor;
import org.springframework.batch.item.ItemReader;
import org.springframework.batch.item.ItemWriter;
import org.springframework.batch.item.database.ItemPreparedStatementSetter;
import org.springframework.batch.item.database.JdbcBatchItemWriter;
import org.springframework.batch.item.file.FlatFileItemReader;
import org.springframework.batch.item.file.mapping.BeanWrapperFieldSetMapper;
import org.springframework.batch.item.file.mapping.DefaultLineMapper;
import org.springframework.batch.item.file.transform.DelimitedLineTokenizer;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;
import org.springframework.core.io.ClassPathResource;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;
import org.springframework.jdbc.datasource.DriverManagerDataSource;

import com.exakaconsulting.poc.service.TrafficStationBean;

import static com.exakaconsulting.poc.service.IConstantStationDemo.INSERT_TRAFFIC_SQL;
import static com.exakaconsulting.poc.service.IConstantStationDemo.DATASOURCE_STATION;



@Configuration
@EnableBatchProcessing
public class BatchConfiguration {
	
	@Bean(DATASOURCE_STATION)
    @Primary
    public DataSource dataSource() {
		DriverManagerDataSource banqueDatasource = new DriverManagerDataSource();
		banqueDatasource.setDriverClassName(Driver.class.getName());
		banqueDatasource.setUrl("jdbc:h2:~/data/trafstats1;INIT=create schema if not exists users1\\;RUNSCRIPT FROM 'classpath:db-data-h2-trafstat.sql'");
		banqueDatasource.setUsername("sa");
		banqueDatasource.setPassword("");
		return banqueDatasource;
    }

	
    @Bean
    public FlatFileItemReader<TrafficStationCsvBean> reader() {
        FlatFileItemReader<TrafficStationCsvBean> reader = new FlatFileItemReader<>();
        reader.setResource(new ClassPathResource("trafic-annuel-entrant-par-station-du-reseau-ferre.csv"));
        reader.setLinesToSkip(1);
        
        // Create a delimitedLineTokenizer
        DelimitedLineTokenizer delimitterLine =  new DelimitedLineTokenizer();
        delimitterLine.setNames("rang", "reseau", "station", "traffic" , "correspondance1", "correspondance2" , "correspondance3"  , "correspondance4" , "correspondance5" , "ville" , "arrondissement" , "column12" , "column13" , "column14" , "column15" );
            delimitterLine.setDelimiter(";");
       
        
        // Create a BeanWrapperFieldSetMapper
        BeanWrapperFieldSetMapper<TrafficStationCsvBean> beanWrapper =  new BeanWrapperFieldSetMapper<>(); 
        beanWrapper.setTargetType(TrafficStationCsvBean.class);
        
        // Create a DefaultLineMapper
        DefaultLineMapper<TrafficStationCsvBean> defaultLineMapper = new DefaultLineMapper<>();
        defaultLineMapper.setLineTokenizer(delimitterLine);
        defaultLineMapper.setFieldSetMapper(beanWrapper);
        
        reader.setLineMapper(defaultLineMapper);
        return reader;
    }
    
    @Bean 
    public ItemProcessor<TrafficStationCsvBean, TrafficStationBean> processor() {
        return new TrafficStationProcessor(); 
    }

    
	@Bean
	public Step step1(StepBuilderFactory stepBuilderFactory, 
	      ItemReader<TrafficStationCsvBean> reader, ItemWriter<TrafficStationBean> writer, 
	      ItemProcessor<TrafficStationCsvBean, TrafficStationBean> processor) {
	    return stepBuilderFactory.get("step1")
	            .<TrafficStationCsvBean, TrafficStationBean> chunk(10)
	            .reader(reader)
	            .processor(processor)
	            .writer(writer)
	            .build();
	}
	
	@Bean
	public Job importCitiesJob(JobBuilderFactory jobs, Step s1) {
	    return jobs.get("importCitiesJob")
	            .incrementer(new RunIdIncrementer())
	            .flow(s1)
	            .end()
	            .build();
	}
	
	@Bean
    ItemWriter<TrafficStationBean> csvFileDatabaseItemWriter(DataSource dataSource,
                                                     NamedParameterJdbcTemplate jdbcTemplate) {
        JdbcBatchItemWriter<TrafficStationBean> databaseItemWriter = new JdbcBatchItemWriter<>();
        databaseItemWriter.setDataSource(dataSource);
        databaseItemWriter.setJdbcTemplate(jdbcTemplate);
 
        databaseItemWriter.setSql(INSERT_TRAFFIC_SQL);
 
        ItemPreparedStatementSetter<TrafficStationBean> valueSetter = 
                new TrafficStationPreparedStatement();
        databaseItemWriter.setItemPreparedStatementSetter(valueSetter);
 
        return databaseItemWriter;
    }
	 

}
