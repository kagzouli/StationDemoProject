package com.exakaconsulting.poc.web;

import javax.servlet.Filter;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.mock.web.MockHttpServletResponse;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringRunner;
import org.springframework.test.context.support.AnnotationConfigContextLoader;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.test.web.servlet.request.MockHttpServletRequestBuilder;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.context.WebApplicationContext;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;

import java.util.List;

import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.httpBasic;
import static org.junit.Assert.*;

import com.exakaconsulting.poc.service.CriteriaSearchTrafficStation;
import com.exakaconsulting.poc.service.TrafficStationBean;
import com.fasterxml.jackson.databind.JavaType;
import com.fasterxml.jackson.databind.ObjectMapper;

@RunWith(SpringRunner.class)
@ContextConfiguration(loader=AnnotationConfigContextLoader.class,classes=ApplicationWebTest.class)
@Transactional
public class StationRESTTest {
	
	private MockMvc mockMvc;
	
	private static final String GET_REQUEST = "GET";
	private static final String POST_REQUEST = "POST";


	@Autowired
	private WebApplicationContext wac;

	@Autowired
	private ObjectMapper mapper;

	
	@Autowired
	private Filter springSecurityFilterChain;
	
	@Before
	public void setUp() {
		mockMvc = MockMvcBuilders.webAppContextSetup(this.wac).addFilters(springSecurityFilterChain).build();


	}
	
	/**
	 * Method to search stations that exists.<br/>
	 * 
	 */
	@Test
	public void findStationsExists(){
		
		// Construct bean search.
		final String METRO = "Metro";
		CriteriaSearchTrafficStation criteria = new CriteriaSearchTrafficStation();
		criteria.setReseau(METRO);
		
		try {
			final String responseContent  = this.retrieveResultConsumes(StationDemoController.FIND_STAT_CRIT, criteria, POST_REQUEST);
			assertNotNull(responseContent);
			
			JavaType javaType = mapper.getTypeFactory().constructCollectionType(List.class, TrafficStationBean.class);
			final List<TrafficStationBean> listTrafficStation = mapper.readValue(responseContent, javaType);
			
			assertNotNull(listTrafficStation);
			assertEquals(listTrafficStation.size(), 66);
			
			
		} catch (Exception e) {
			assertTrue(false);
		}

		
	}

	
	/**
	 * Method to retrieve jsonResult from the request and initial request object
	 * 
	 * @param urlToTest
	 * @param initialObject
	 * @return
	 * @throws Exception
	 */
	protected String retrieveResultConsumes(final String urlToTest, final Object initialObject , final String requestType)
			throws Exception {

		final String json = mapper.writeValueAsString(initialObject);

		MockHttpServletRequestBuilder resultActions = null;
		switch(requestType){
			case GET_REQUEST:
				resultActions = get(urlToTest);
				break;
			default:
				resultActions = post(urlToTest);
				break;
		}
		
		final MvcResult mvcResult = mockMvc.perform(resultActions.with(httpBasic("", "")).accept(MediaType.APPLICATION_JSON)
				.contentType(MediaType.APPLICATION_JSON).content(json)).andReturn();

		assertNotNull(mvcResult);

		final MockHttpServletResponse response = mvcResult.getResponse();
		assertNotNull(response);

		final String responseContent = response.getContentAsString();
		assertNotNull(responseContent);
		return responseContent;
	}
	
}
