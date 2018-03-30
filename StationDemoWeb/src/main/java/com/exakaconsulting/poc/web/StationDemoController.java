package com.exakaconsulting.poc.web;

import java.util.Collections;
import java.util.List;
import java.util.Locale;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.context.MessageSource;
import org.springframework.http.MediaType;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.util.Assert;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.exakaconsulting.poc.service.AlreadyStationExistsException;
import com.exakaconsulting.poc.service.CriteriaSearchTrafficStation;
import com.exakaconsulting.poc.service.IStationDemoService;
import com.exakaconsulting.poc.service.IUserService;
import com.exakaconsulting.poc.service.StationDemoServiceImpl;
import com.exakaconsulting.poc.service.TechnicalException;
import com.exakaconsulting.poc.service.TrafficStationBean;
import com.exakaconsulting.poc.service.User;

import static com.exakaconsulting.poc.service.IConstantStationDemo.STATION_ALREADY_EXISTS;
import static com.exakaconsulting.poc.service.IConstantStationDemo.USER_SERVICE_DATABASE;

import javax.validation.Valid;


import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;

@CrossOrigin(origins="*" , allowedHeaders= "*" , exposedHeaders= {"Access-Control-Allow-Origin"}, methods={RequestMethod.GET , RequestMethod.POST, RequestMethod.PUT , RequestMethod.DELETE, RequestMethod.PATCH,RequestMethod.OPTIONS})
@RestController
@Api(value = "/", description = "This REST API is use to have informations about the traffic on the station.<br/>")
public class StationDemoController {
	
	
	/** Logger **/
	private static final Logger LOGGER = LoggerFactory.getLogger(StationDemoServiceImpl.class);

	public static final String FIND_STAT_CRIT = "/station/findStationsByCrit";
	
	@Autowired
	private IStationDemoService stationDemoService;
	
	@Autowired
	@Qualifier(USER_SERVICE_DATABASE)
	private IUserService userService;
	
	@Autowired
	private MessageSource messageSource;
	
	
	@ApiOperation(value = "This method is use to search a traffic stations by criteria", response = TrafficStationBean.class, responseContainer = "List")
	@RequestMapping(value = FIND_STAT_CRIT, method = { RequestMethod.POST}, consumes = {
			MediaType.APPLICATION_JSON_VALUE }, produces = { MediaType.APPLICATION_JSON_VALUE })
	@ResponseBody
	@PreAuthorize("hasRole('manager') OR hasRole('user')")
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
	
	@ApiOperation(value = "This method is use to count the number of traffic stations by criteria", response = Integer.class)
	@RequestMapping(value = "/station/countStationsByCrit", method = { RequestMethod.POST}, consumes = {
			MediaType.APPLICATION_JSON_VALUE }, produces = { MediaType.APPLICATION_JSON_VALUE })
	@ResponseBody
	@PreAuthorize("hasRole('manager') OR hasRole('user')")
	public Integer countSearchStations(@RequestBody CriteriaSearchTrafficStation criteria){	
		LOGGER.info("BEGIN of the method countSearchStations of the class " + StationDemoController.class.getName());

		Integer countStations = 0;
		try {
			Assert.notNull(criteria, "The criteria must be set");
			
			countStations = this.stationDemoService.countStations(criteria);
		} catch (Exception exception) {
			LOGGER.error(exception.getMessage(), exception);
			throw new TechnicalException(exception);
		}
		LOGGER.info("END of the method countSearchStations of the class " + StationDemoController.class.getName());
		return countStations;
	}
	
	@ApiOperation(value = "This method is use to search a traffic stations by id", response = TrafficStationBean.class)
	@RequestMapping(value = "/station/findStationById/{id}", method = { RequestMethod.GET}, produces = { MediaType.APPLICATION_JSON_VALUE })
	@ResponseBody
	@PreAuthorize("hasRole('manager') OR hasRole('user')")
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
	

	@ApiOperation(value = "This method is use to insert a traffic station", response = Boolean.class , responseContainer= "JsonResult")
	@RequestMapping(value = "/station/insertStation", method = { RequestMethod.PUT}, consumes = {
			MediaType.APPLICATION_JSON_VALUE }, produces = { MediaType.APPLICATION_JSON_VALUE })
	@ResponseBody
	@PreAuthorize("hasRole('manager')")
	public JsonResult<Boolean> insertTrafficStation(@Valid @RequestBody final TrafficStationBean trafficStationBean){
		
		LOGGER.info("BEGIN of the method insertTrafficStation of the class " + StationDemoController.class.getName());
		JsonResult<Boolean> jsonResult = new JsonResult<>();
		try {
			Assert.notNull(trafficStationBean, "The trafficStationBean must be set");
			
			final Integer returnValue = this.stationDemoService.insertTrafficStation(trafficStationBean);
			jsonResult.setResult(returnValue > 0 ? true : false);
			jsonResult.setSuccess(true);
		}catch(AlreadyStationExistsException exception){
			LOGGER.warn(exception.getMessage());
			jsonResult.addError(messageSource.getMessage(STATION_ALREADY_EXISTS, new Object[]{ trafficStationBean.getStation()}, Locale.FRENCH));
			jsonResult.setSuccess(false);
		}catch (Exception exception) {
			LOGGER.error(exception.getMessage(), exception);
			throw new TechnicalException(exception);
		}
		LOGGER.info("END of the method insertTrafficStation of the class " + StationDemoController.class.getName());

		return jsonResult;
	}
	
	@ApiOperation(value = "This method is use to update a traffic station", response = Void.class , responseContainer = "JsonResult")
	@RequestMapping(value = "/station/updateStation/{id}", method = { RequestMethod.PATCH}, produces = { MediaType.APPLICATION_JSON_VALUE })
	@ResponseBody
	@PreAuthorize("hasRole('manager')")
	public JsonResult<Void> updateTrafficStation(@RequestParam Long newTraffic, @RequestParam String newCorr, @PathVariable Integer id){
		LOGGER.info("BEGIN of the method updateTrafficStation of the class " + StationDemoController.class.getName());
		JsonResult<Void> jsonResult = new JsonResult<>();
		try {
			Assert.notNull(id, "The id must be set");
			
			this.stationDemoService.updateTrafficStation(newTraffic, newCorr, id);
			jsonResult.setSuccess(true);
		} catch (Exception exception) {
			LOGGER.error(exception.getMessage(), exception);
			throw new TechnicalException(exception);
		}
		LOGGER.info("END of the method updateTrafficStation of the class " + StationDemoController.class.getName());		
		return jsonResult;
	}
	
	@ApiOperation(value = "This method is use to delete a traffic station", response = Void.class , responseContainer = "JsonResult")
	@RequestMapping(value = "/station/deleteStation/{id}", method = { RequestMethod.DELETE}, produces = { MediaType.APPLICATION_JSON_VALUE })
	@ResponseBody
	@PreAuthorize("hasRole('manager')")
	public JsonResult<Void>  deleteTrafficStation(@PathVariable final Integer id){
		LOGGER.info("BEGIN of the method deleteTrafficStation of the class " + StationDemoController.class.getName());
		JsonResult<Void> jsonResult = new JsonResult<>();
		try {
			Assert.notNull(id, "The id must be set");
			this.stationDemoService.deleteTrafficStation(id);
			jsonResult.setSuccess(true);
		} catch (Exception exception) {
			LOGGER.error(exception.getMessage(), exception);
			throw new TechnicalException(exception);
		}
		LOGGER.info("END of the method deleteTrafficStation of the class " + StationDemoController.class.getName());	
		return jsonResult;
		
	}
	
	@ApiOperation(value = "This method is use to get the role of the user" , response = String.class )
	@RequestMapping(value = "/user/retrieveRole", method = { RequestMethod.GET}, consumes = {
			MediaType.APPLICATION_FORM_URLENCODED_VALUE }, produces = { MediaType.APPLICATION_JSON_VALUE })
	@ResponseBody
	@PreAuthorize("hasRole('manager') OR hasRole('user')")
	public User findRoleByLogin(@RequestParam(required=true) final String login ){
		LOGGER.info("BEGIN of the method findRoleByLogin of the class " + StationDemoController.class.getName());
		User user = null;
		try {
			user = this.userService.findUserByLogin(login);
			
		
		} catch (Exception exception) {
			LOGGER.error(exception.getMessage(), exception);
			throw new TechnicalException(exception);
		}
		LOGGER.info("END of the method findRoleByLogin of the class " + StationDemoController.class.getName());	
		return user;
	}

	
	
	

	

}
