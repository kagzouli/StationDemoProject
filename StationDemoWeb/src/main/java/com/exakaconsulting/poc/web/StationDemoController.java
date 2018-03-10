package com.exakaconsulting.poc.web;

import java.util.Collections;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.util.Assert;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.exakaconsulting.poc.service.CriteriaSearchTrafficStation;
import com.exakaconsulting.poc.service.IStationDemoService;
import com.exakaconsulting.poc.service.StationDemoServiceImpl;
import com.exakaconsulting.poc.service.TechnicalException;
import com.exakaconsulting.poc.service.TrafficStationBean;

import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;

@CrossOrigin(origins="*" , allowedHeaders= "*" , exposedHeaders= {"Access-Control-Allow-Origin"}, methods={RequestMethod.GET , RequestMethod.POST, RequestMethod.PUT , RequestMethod.DELETE, RequestMethod.OPTIONS})
@RestController
@Api(value = "/", description = "This REST API is use to have informations about the traffic on the station.<br/>")
public class StationDemoController {
	
	/** Logger **/
	private static final Logger LOGGER = LoggerFactory.getLogger(StationDemoServiceImpl.class);

	
	@Autowired
	private IStationDemoService stationDemoService;
	
	@ApiOperation(value = "This method is use to search a traffic stations by criteria", response = TrafficStationBean.class, responseContainer = "List")
	@RequestMapping(value = "/findStationsByCrit", method = { RequestMethod.POST}, consumes = {
			MediaType.APPLICATION_JSON_VALUE }, produces = { MediaType.APPLICATION_JSON_VALUE })
	@ResponseBody
	public List<TrafficStationBean> listSearchStations(@RequestBody CriteriaSearchTrafficStation criteria){	
		LOGGER.info("BEGIN of the method listSearchStations of the class " + StationDemoController.class.getName());

		List<TrafficStationBean> listStationBean = Collections.emptyList();
		try {
			Assert.notNull(criteria, "The criteria must be set");
			
			listStationBean = this.stationDemoService.findStations(criteria);
		} catch (Exception exception) {
			LOGGER.error(exception.getMessage(), exception);
			throw new TechnicalException(exception);
		}
		LOGGER.info("END of the method listSearchStations of the class " + StationDemoController.class.getName());
		return listStationBean;
	}
	
	
	@RequestMapping(value = "/findStationById/{id}", method = { RequestMethod.GET}, produces = { MediaType.APPLICATION_JSON_VALUE })
	@ResponseBody
	public TrafficStationBean findTrafficStationById(@PathVariable final Integer id){

		LOGGER.info("BEGIN of the method findTrafficStationById of the class " + StationDemoController.class.getName());
		TrafficStationBean trafficStationBean =  null;
		try {
			Assert.notNull(id, "The id must be set");
			
			trafficStationBean = this.stationDemoService.findStationById(id);
		} catch (Exception exception) {
			LOGGER.error(exception.getMessage(), exception);
			throw new TechnicalException(exception);
		}
		LOGGER.info("END of the method findTrafficStationById of the class " + StationDemoController.class.getName());

		return trafficStationBean; 
		
	}
	

}
