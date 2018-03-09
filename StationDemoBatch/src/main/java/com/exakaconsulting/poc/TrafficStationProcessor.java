package com.exakaconsulting.poc;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.lang3.StringUtils;
import org.springframework.batch.item.ItemProcessor;

import com.exakaconsulting.poc.service.TrafficStationBean;

public class TrafficStationProcessor implements ItemProcessor<TrafficStationCsvBean, TrafficStationBean>{

	@Override
	public TrafficStationBean process(TrafficStationCsvBean item) throws Exception {
		TrafficStationBean trafficStationBean = new TrafficStationBean();
		
		if (item != null){
			trafficStationBean.setReseau(item.getReseau());
			trafficStationBean.setStation(item.getStation());
			trafficStationBean.setTraffic(item.getTraffic());
			
			List<String> listCorrespondances = new ArrayList<>();

			if (!StringUtils.isBlank(item.getCorrespondance1())){
				listCorrespondances.add(item.getCorrespondance1());
			}

			if (!StringUtils.isBlank(item.getCorrespondance2())){
				listCorrespondances.add(item.getCorrespondance2());
			}
			
			if (!StringUtils.isBlank(item.getCorrespondance3())){
				listCorrespondances.add(item.getCorrespondance3());
			}
			
			if (!StringUtils.isBlank(item.getCorrespondance4())){
				listCorrespondances.add(item.getCorrespondance4());
			}
			if (!StringUtils.isBlank(item.getCorrespondance5())){
				listCorrespondances.add(item.getCorrespondance5());
			}
			
			trafficStationBean.setListCorrespondance(listCorrespondances);

			
			trafficStationBean.setVille(item.getVille());			
			trafficStationBean.setArrondissement(item.getArrondissement());
		}
		return trafficStationBean;
	
	}
	

}
