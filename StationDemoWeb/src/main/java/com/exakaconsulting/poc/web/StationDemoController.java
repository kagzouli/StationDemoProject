package com.exakaconsulting.poc.web;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import javax.validation.Valid;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.util.Assert;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.exakaconsulting.poc.service.AlreadyStationExistsException;
import com.exakaconsulting.poc.service.ConstantStationDemo;
import com.exakaconsulting.poc.service.CriteriaSearchTrafficStation;
import com.exakaconsulting.poc.service.IStationDemoService;
import com.exakaconsulting.poc.service.OrderBean;
import com.exakaconsulting.poc.service.TrafficStationBean;
import com.exakaconsulting.poc.service.TrafficStationNotExists;

import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiResponse;
import io.swagger.annotations.ApiResponses;

@CrossOrigin(origins="*" , allowedHeaders= "*" , exposedHeaders= {"Access-Control-Allow-Origin"}, methods={RequestMethod.GET , RequestMethod.POST, RequestMethod.PUT , RequestMethod.DELETE, RequestMethod.PATCH,RequestMethod.OPTIONS})
@RestController
@Api(value = "/")
public class StationDemoController {
	
	
	/** Logger **/
	private static final Logger LOGGER = LoggerFactory.getLogger(StationDemoController.class);

	public static final String FIND_STAT_CRIT = "/station/stations";
		
	@Autowired
	private IStationDemoService stationDemoService;
	
	
	@Autowired
	private MessageSource messageSource;
	
	private static final String ERROR_ID_MUST_BE_SET = "The id must be set";
		
	
	@ApiOperation(value = "This method is use to search a traffic stations by criteria")
	@ApiResponses(
		value = {
				@ApiResponse(code = 200, message = "OK", response = TrafficStationBean.class , responseContainer="List"),
				@ApiResponse(code = 400, message = "Bad Request", response = Void.class),
				@ApiResponse(code = 401, message = "Unauthorized", response = Void.class),
				@ApiResponse(code = 403, message = "Forbidden", response = Void.class),
				@ApiResponse(code = 500, message = "Internal Server Error", response = Void.class),
		}
	)	
	@GetMapping(value = FIND_STAT_CRIT, consumes = {
			MediaType.APPLICATION_JSON_VALUE }, produces = { MediaType.APPLICATION_JSON_VALUE })
	@ResponseBody
	@PreAuthorize("hasRole('manager') OR hasRole('user')")
	public ResponseEntity<List<TrafficStationBean>> listSearchStations(
			@RequestParam(value="reseau", required=false) final String reseau,
			@RequestParam(value="station", required=false) final String station,
			@RequestParam(value="trafficMin", required=false) final Long trafficMin,
			@RequestParam(value="trafficMax", required=false) final Long trafficMax,
			@RequestParam(value="ville", required=false) final String ville,
			@RequestParam(value="arrondiss", required=false) final Integer arrondiss,
			@RequestParam(value="page" , required=false) final Integer page,
			@RequestParam(value="per_page" , required=false) final Integer perPage,
			@RequestParam(value="sort", required=false) final String sort){	
		
		if (LOGGER.isInfoEnabled()){
			LOGGER.info(String.format("BEGIN of the method listSearchStations of the class %s", StationDemoController.class.getName()));			
		}

		List<TrafficStationBean> listStationBean = Collections.emptyList();
		try {
			final CriteriaSearchTrafficStation criteria  = new CriteriaSearchTrafficStation(page,perPage);
			criteria.setReseau(reseau);
			criteria.setStation(station);
			criteria.setTrafficMin(trafficMin);
			criteria.setTrafficMax(trafficMax);
			criteria.setVille(ville);
			criteria.setArrondiss(arrondiss);
			List<OrderBean> listSortBean = new ArrayList<>();
			
			if (!StringUtils.isEmpty(sort)){
				final String[] keysValueSort = sort.split(",");
				if (keysValueSort != null){
					for (String keyValueSort : keysValueSort){
						String[] tabsKeyValueSort = keyValueSort.split(":");
						OrderBean orderBean = new OrderBean();
						orderBean.setColumn(tabsKeyValueSort[0]);
						
						if (tabsKeyValueSort.length > 1){
							orderBean.setDirection(tabsKeyValueSort[1]);
						}
						listSortBean.add(orderBean);
					}					
				}
			}
			criteria.setOrders(listSortBean); 

			
			listStationBean = this.stationDemoService.findStations(criteria);
		} catch (Exception exception) {
			LOGGER.error(exception.getMessage(), exception);
			return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
		}
		
		if (LOGGER.isInfoEnabled()){
			LOGGER.info(String.format("END of the method listSearchStations of the class %s", StationDemoController.class.getName()));			
		}
		return new ResponseEntity<>(listStationBean,HttpStatus.OK);
	}
	
	@ApiOperation(value = "This method is use to count the number of traffic stations by criteria")
	@ApiResponses(
			value = {
					@ApiResponse(code = 200, message = "OK", response = Integer.class),
					@ApiResponse(code = 400, message = "Bad Request", response = Void.class),
					@ApiResponse(code = 401, message = "Unauthorized", response = Void.class),
					@ApiResponse(code = 403, message = "Forbidden", response = Void.class),
					@ApiResponse(code = 500, message = "Internal Server Error", response = Void.class),
			}
	)	
	@GetMapping(value = "/station/stations/count", consumes = {
			MediaType.APPLICATION_JSON_VALUE }, produces = { MediaType.APPLICATION_JSON_VALUE })
	@ResponseBody
	@PreAuthorize("hasRole('manager') OR hasRole('user')")
	public ResponseEntity<Integer> countSearchStations(
			@RequestParam(value="reseau", required=false) final String reseau,
			@RequestParam(value="station", required=false) final String station,
			@RequestParam(value="trafficMin", required=false) final Long trafficMin,
			@RequestParam(value="trafficMax", required=false) final Long trafficMax,
			@RequestParam(value="ville", required=false) final String ville,
			@RequestParam(value="arrondiss", required=false) final Integer arrondiss
		){	
		if (LOGGER.isInfoEnabled()){
			LOGGER.info(String.format("BEGIN of the method countSearchStations of the class %s" , StationDemoController.class.getName()));			
		}

		Integer countStations = 0;
		try {
			final CriteriaSearchTrafficStation criteria  = new CriteriaSearchTrafficStation();
			criteria.setReseau(reseau);
			criteria.setStation(station);
			criteria.setTrafficMin(trafficMin);
			criteria.setTrafficMax(trafficMax);
			criteria.setVille(ville);
			criteria.setArrondiss(arrondiss);
			criteria.setOrders(new ArrayList<OrderBean>()); 
			
			countStations = this.stationDemoService.countStations(criteria);
		} catch (Exception exception) {
			LOGGER.error(exception.getMessage(), exception);
			return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
		}
		if (LOGGER.isInfoEnabled()){
			LOGGER.info(String.format("END of the method countSearchStations of the class %s",StationDemoController.class.getName()));
			
		}
		return new ResponseEntity<>(countStations,HttpStatus.OK);
	}
	
	@ApiOperation(value = "This method is use to search a traffic stations by id", response = TrafficStationBean.class)
	@ApiResponses(
			value = {
					@ApiResponse(code = 200, message = "OK", response = TrafficStationBean.class),
					@ApiResponse(code = 400, message = "Bad Request", response = Void.class),
					@ApiResponse(code = 401, message = "Unauthorized", response = Void.class),
					@ApiResponse(code = 403, message = "Forbidden", response = Void.class),
					@ApiResponse(code = 404, message = "Not Found", response = Void.class),
					@ApiResponse(code = 500, message = "Internal Server Error", response = Void.class),
			}
	)
	@GetMapping(value = "/station/stations/{id}", produces = { MediaType.APPLICATION_JSON_VALUE })
	@ResponseBody
	@PreAuthorize("hasRole('manager') OR hasRole('user')")
	public ResponseEntity<TrafficStationBean> findTrafficStationById(@PathVariable final Integer id){

		if (LOGGER.isInfoEnabled()){
			LOGGER.info(String.format("BEGIN of the method findTrafficStationById of the class %s" ,StationDemoController.class.getName()));			
		}
		TrafficStationBean trafficStationBean =  null;
		try {
			Assert.notNull(id, ERROR_ID_MUST_BE_SET);
			
			trafficStationBean = this.stationDemoService.findStationById(id);			
		}catch(TrafficStationNotExists exception){
			if (LOGGER.isWarnEnabled()){
				LOGGER.warn(String.format("The stationId %s does not exists", id));
			}
			return new ResponseEntity<>(HttpStatus.NOT_FOUND);
		}catch (Exception exception) {
			LOGGER.error(exception.getMessage(), exception);
			return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
		}
		
		if (LOGGER.isInfoEnabled()){
			LOGGER.info(String.format("END of the method findTrafficStationById of the class %s", StationDemoController.class.getName()));			
		}

		return new ResponseEntity<>(trafficStationBean,HttpStatus.OK);
		
	}
	

	@ApiOperation(value = "This method is use to insert a traffic station")
	@ApiResponses(
			value = {
					@ApiResponse(code = 201, message = "OK", response = Integer.class),
					@ApiResponse(code = 400, message = "Bad Request", response = Void.class),
					@ApiResponse(code = 401, message = "Unauthorized", response = Void.class),
					@ApiResponse(code = 403, message = "Forbidden", response = Void.class),
					@ApiResponse(code = 409, message = "Conflict", response = String.class , responseContainer="List"),
					@ApiResponse(code = 500, message = "Internal Server Error", response = Void.class),
			}
	)
	@PutMapping(value = "/station/stations", consumes = {
			MediaType.APPLICATION_JSON_VALUE }, produces = { MediaType.APPLICATION_JSON_VALUE })
	@ResponseBody
	@PreAuthorize("hasRole('manager')")
	public ResponseEntity<Object> insertTrafficStation(@Valid @RequestBody final TrafficStationBean trafficStationBean){
		
		if (LOGGER.isInfoEnabled()){
			LOGGER.info(String.format("BEGIN of the method insertTrafficStation of the class %s" , StationDemoController.class.getName()));			
		}
		
		Integer returnValue = -1;
		try {
			Assert.notNull(trafficStationBean, "The trafficStationBean must be set");			
			returnValue = this.stationDemoService.insertTrafficStation(trafficStationBean);
		}catch(AlreadyStationExistsException exception){
			LOGGER.warn(exception.getMessage());
			List<String> errors = new ArrayList<>();
			errors.add(messageSource.getMessage(ConstantStationDemo.STATION_ALREADY_EXISTS, new Object[]{ trafficStationBean.getStation()}, LocaleContextHolder.getLocale()));
			return new ResponseEntity<>(errors,HttpStatus.CONFLICT);
		}catch (Exception exception) {
			LOGGER.error(exception.getMessage(), exception);
			return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
		}
		
		
		if (LOGGER.isInfoEnabled()){
			LOGGER.info(String.format("END of the method insertTrafficStation of the class %s" , StationDemoController.class.getName()));			
		}

		return new ResponseEntity<>(returnValue,HttpStatus.CREATED);
	}
	
	@ApiOperation(value = "This method is use to update a traffic station")
	@ApiResponses(
			value = {
					@ApiResponse(code = 200, message = "OK", response = Void.class),
					@ApiResponse(code = 400, message = "Bad Request", response = Void.class),
					@ApiResponse(code = 401, message = "Unauthorized", response = Void.class),
					@ApiResponse(code = 403, message = "Forbidden", response = Void.class),
					@ApiResponse(code = 404, message = "Forbidden", response = Void.class),
					@ApiResponse(code = 500, message = "Internal Server Error", response = Void.class),
			}
	)
	@PatchMapping(value = "/station/stations/{id}", produces = { MediaType.APPLICATION_JSON_VALUE })
	@ResponseBody
	@PreAuthorize("hasRole('manager')")
	public ResponseEntity<Void> updateTrafficStation(@RequestParam Long newTraffic, @RequestParam String newCorr, @PathVariable Integer id){
		if (LOGGER.isInfoEnabled()){
			LOGGER.info(String.format("BEGIN of the method updateTrafficStation of the class %s", StationDemoController.class.getName()));			
		}
		try {
			Assert.notNull(id, ERROR_ID_MUST_BE_SET);
			
			this.stationDemoService.updateTrafficStation(newTraffic, newCorr, id);
		}catch(TrafficStationNotExists exception) {
			return new ResponseEntity<>(HttpStatus.NOT_FOUND);
		}catch (Exception exception) {
			LOGGER.error(exception.getMessage(), exception);
			return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
		}
		
		if (LOGGER.isInfoEnabled()){
			LOGGER.info(String.format("END of the method updateTrafficStation of the class %s" , StationDemoController.class.getName()));					
		}
		return new ResponseEntity<>(HttpStatus.OK);
	}
	
	@ApiOperation(value = "This method is use to delete a traffic station")
	@ApiResponses(
			value = {
					@ApiResponse(code = 204, message = "No Content", response = Void.class),
					@ApiResponse(code = 400, message = "Bad Request", response = Void.class),
					@ApiResponse(code = 401, message = "Unauthorized", response = Void.class),
					@ApiResponse(code = 403, message = "Forbidden", response = Void.class),
					@ApiResponse(code = 404, message = "Not Found", response = Void.class),
					@ApiResponse(code = 500, message = "Internal Server Error", response = Void.class),
		                    
	})
	@DeleteMapping(value = "/station/stations/{id}", produces = { MediaType.APPLICATION_JSON_VALUE })
	@ResponseBody
	@PreAuthorize("hasRole('manager')")
	public ResponseEntity<Void>  deleteTrafficStation(@PathVariable final Integer id){
		if (LOGGER.isInfoEnabled()){
			LOGGER.info(String.format("BEGIN of the method deleteTrafficStation of the class %s"  , StationDemoController.class.getName()));			
		}
		try {
			Assert.notNull(id, ERROR_ID_MUST_BE_SET);
			this.stationDemoService.deleteTrafficStation(id);
		}catch(TrafficStationNotExists exception) {
			return new ResponseEntity<>(HttpStatus.NOT_FOUND);
		}catch (Exception exception) {
			LOGGER.error(exception.getMessage(), exception);
			return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
		}
		
		if (LOGGER.isInfoEnabled()){
			LOGGER.info(String.format("END of the method deleteTrafficStation of the class %s" , StationDemoController.class.getName()));				
		}
		return new ResponseEntity<>(HttpStatus.NO_CONTENT);
		
	}

}
