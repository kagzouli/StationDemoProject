package com.exakaconsulting.poc;


import org.springframework.batch.core.BatchStatus;
import org.springframework.batch.core.JobExecution;
import org.springframework.batch.test.JobLauncherTestUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.core.ValueOperations;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.junit.jupiter.SpringExtension;

import com.exakaconsulting.poc.service.TrafficStationBean;

import static org.junit.jupiter.api.Assertions.assertEquals;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;

@ExtendWith(SpringExtension.class)
@SpringBootTest(classes = BatchTestConfiguration.class)
@ActiveProfiles("test")
public class BatchTest{

	@Autowired
	private JobLauncherTestUtils jobLauncherTestUtils;
	
	@MockBean
	private RedisTemplate<String, TrafficStationBean> redisTemplate;

	@MockBean
	private ValueOperations<String, TrafficStationBean> valuesOperation;


	@Test
	public void launchJob() throws Exception {

		// testing a job
		JobExecution jobExecution = jobLauncherTestUtils.launchJob();

		// Testing a individual step
		// JobExecution jobExecution = jobLauncherTestUtils.launchStep("step1");

		assertEquals(BatchStatus.COMPLETED, jobExecution.getStatus());

	}

}
