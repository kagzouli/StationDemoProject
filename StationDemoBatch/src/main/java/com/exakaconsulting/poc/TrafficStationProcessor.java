package com.exakaconsulting.poc;

import java.util.ArrayList;
import java.util.List;

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
			
			List<Integer> listCorrespondances = new ArrayList<>();

			if (item.getCorrespondance1() != null){
				listCorrespondances.add(item.getCorrespondance1());
			}

			if (item.getCorrespondance2() != null){
				listCorrespondances.add(item.getCorrespondance2());
			}
			
			if (item.getCorrespondance3() != null){
				listCorrespondances.add(item.getCorrespondance3());
			}
			
			if (item.getCorrespondance4() != null){
				listCorrespondances.add(item.getCorrespondance4());
			}
			if (item.getCorrespondance5() != null){
				listCorrespondances.add(item.getCorrespondance5());
			}
			
			trafficStationBean.setListCorrespondance(listCorrespondances);

			
			trafficStationBean.setVille(item.getVille());			
			trafficStationBean.setArrondissement(item.getArrondissement());
		}
		return trafficStationBean;
	
	}
	

}
