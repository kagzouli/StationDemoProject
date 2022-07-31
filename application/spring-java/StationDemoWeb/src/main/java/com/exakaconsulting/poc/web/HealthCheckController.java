package com.exakaconsulting.poc.web;

import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.exakaconsulting.poc.service.TrafficStationBean;

import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiResponse;
import io.swagger.annotations.ApiResponses;

@CrossOrigin(origins="*" , allowedHeaders= "*" , exposedHeaders= {"Access-Control-Allow-Origin"}, methods={RequestMethod.GET , RequestMethod.POST, RequestMethod.PUT , RequestMethod.DELETE, RequestMethod.PATCH,RequestMethod.OPTIONS})
@RestController
@Api(value = "/")
public class HealthCheckController {
	
	@ApiOperation(value = "This method is use to search a traffic stations by criteria")
	@ApiResponses(
		value = {
				@ApiResponse(code = 200, message = "OK", response = TrafficStationBean.class , responseContainer="List"),
				@ApiResponse(code = 500, message = "Internal Server Error", response = Void.class),
		}
	)	
	@GetMapping(value = "/health", produces = { MediaType.APPLICATION_JSON_VALUE })
	@ResponseBody
	public ResponseEntity<String> health(){	
		return new ResponseEntity<>("OK" , HttpStatus.OK);

	}

}
