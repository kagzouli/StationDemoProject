package com.exakaconsulting.poc.web;

import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;

@CrossOrigin(origins="*" , allowedHeaders= "*" , exposedHeaders= {"Access-Control-Allow-Origin"}, methods={RequestMethod.GET , RequestMethod.POST, RequestMethod.PUT , RequestMethod.DELETE, RequestMethod.PATCH,RequestMethod.OPTIONS})
@RestController
@Tag(name = "health")
public class HealthCheckController {
	
	@Operation(summary = "This method is use to search a traffic stations by criteria")
	@ApiResponses(
		value = {
				@ApiResponse(responseCode = "200", description = "OK", content = { @Content(mediaType = "application/json", schema = @Schema(implementation = String.class))}),
				@ApiResponse(responseCode = "500", description = "Internal Server Error", content = { @Content(mediaType = "application/json", schema = @Schema(implementation = Void.class))}),
		}
	)	
	@GetMapping(value = "/health", produces = { MediaType.APPLICATION_JSON_VALUE })
	@ResponseBody
	public ResponseEntity<String> health(){	
		return new ResponseEntity<>("OK" , HttpStatus.OK);

	}

}
