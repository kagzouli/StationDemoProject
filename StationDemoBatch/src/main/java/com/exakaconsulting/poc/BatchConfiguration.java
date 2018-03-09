package com.exakaconsulting.poc;


import org.springframework.batch.core.Job;
import org.springframework.batch.core.Step;
import org.springframework.batch.core.configuration.annotation.EnableBatchProcessing;
import org.springframework.batch.core.configuration.annotation.JobBuilderFactory;
import org.springframework.batch.core.configuration.annotation.StepBuilderFactory;
import org.springframework.batch.core.launch.support.RunIdIncrementer;
import org.springframework.batch.item.ItemProcessor;
import org.springframework.batch.item.ItemReader;
import org.springframework.batch.item.ItemWriter;
import org.springframework.batch.item.file.FlatFileItemReader;
import org.springframework.batch.item.file.mapping.BeanWrapperFieldSetMapper;
import org.springframework.batch.item.file.mapping.DefaultLineMapper;
import org.springframework.batch.item.file.transform.DelimitedLineTokenizer;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.io.ClassPathResource;

import com.exakaconsulting.poc.service.TrafficStationBean;

@Configuration
@EnableBatchProcessing
public class BatchConfiguration {
	
	@Autowired
    public JobBuilderFactory jobBuilderFactory;

    @Autowired
    public StepBuilderFactory stepBuilderFactory;
    
    @Bean
    public JobBuilderFactory test(){
    	return jobBuilderFactory;
    }
    
    @Bean
    public FlatFileItemReader<TrafficStationCsvBean> reader() {
        FlatFileItemReader<TrafficStationCsvBean> reader = new FlatFileItemReader<>();
        reader.setResource(new ClassPathResource("trafic-annuel-entrant-par-station-du-reseau-ferre.csv"));
        reader.setLineMapper(new DefaultLineMapper<TrafficStationCsvBean>() {{
            setLineTokenizer(new DelimitedLineTokenizer() {{
                setNames(new String[] { "rang", "reseau", "station", "traffic" , "correspondance1", "correspondance2" , "correspondance3"  , "correspondance4" , "correspondance5" , "ville" , "arrondissement" });
            }});
            setFieldSetMapper(new BeanWrapperFieldSetMapper<TrafficStationCsvBean>() {{
                setTargetType(TrafficStationCsvBean.class);
            }});
        }});
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


}
