package com.exakaconsulting.poc;

import org.springframework.batch.core.configuration.annotation.EnableBatchProcessing;
import org.springframework.batch.core.configuration.annotation.JobBuilderFactory;
import org.springframework.batch.core.configuration.annotation.StepBuilderFactory;
import org.springframework.batch.item.file.FlatFileItemReader;
import org.springframework.batch.item.file.mapping.BeanWrapperFieldSetMapper;
import org.springframework.batch.item.file.mapping.DefaultLineMapper;
import org.springframework.batch.item.file.transform.DelimitedLineTokenizer;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.io.ClassPathResource;

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
    public FlatFileItemReader<TrafficStationBean> reader() {
        FlatFileItemReader<TrafficStationBean> reader = new FlatFileItemReader<TrafficStationBean>();
        reader.setResource(new ClassPathResource("trafic-annuel-entrant-par-station-du-reseau-ferre.csv"));
        reader.setLineMapper(new DefaultLineMapper<TrafficStationBean>() {{
            setLineTokenizer(new DelimitedLineTokenizer() {{
                setNames(new String[] { "reseau", "station", "traffic" , "correspondance1", "correspondance2" , "correspondance3"  , "correspondance4" , "correspondance5" , "ville" , "arrondissement" });
            }});
            setFieldSetMapper(new BeanWrapperFieldSetMapper<TrafficStationBean>() {{
                setTargetType(TrafficStationBean.class);
            }});
        }});
        return reader;
    }


}
