package com.exakaconsulting.poc.web;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.exakaconsulting.poc.service.IStationDemoService;
import com.exakaconsulting.poc.service.TrafficStationBean;

@RestController("/station")
public class StationDemoController {
	
	@Autowired
	private IStationDemoService stationDemoService;
	
	@RequestMapping(value = "/searchStation", method = { RequestMethod.GET}, consumes = {
			MediaType.APPLICATION_FORM_URLENCODED_VALUE }, produces = { MediaType.APPLICATION_JSON_VALUE })
	@ResponseBody
	public List<TrafficStationBean> listSearchStations() {
		List<TrafficStationBean> listTrafficStation = stationDemoService.searchStation();
		return listTrafficStation;
	}

	

}
