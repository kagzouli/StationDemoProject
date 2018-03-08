package com.exakaconsulting.poc;

import org.springframework.batch.item.ItemProcessor;

public class TrafficStationProcessor implements ItemProcessor<TrafficStationCsvBean, TrafficStationBean>{

	@Override
	public TrafficStationBean process(TrafficStationCsvBean item) throws Exception {
		TrafficStationBean trafficStationBean = new TrafficStationBean();
		
		if (item != null){
			trafficStationBean.setReseau(item.getReseau());
			trafficStationBean.setStation(item.getStation());
			trafficStationBean.setTraffic(item.getTraffic());	
			trafficStationBean.setCorrespondance1(item.getCorrespondance1());
			trafficStationBean.setCorrespondance2(item.getCorrespondance2());
			trafficStationBean.setCorrespondance3(item.getCorrespondance3());
			trafficStationBean.setCorrespondance4(item.getCorrespondance4());
			trafficStationBean.setCorrespondance5(item.getCorrespondance5());
			trafficStationBean.setVille(item.getVille());			
			trafficStationBean.setArrondissement(item.getArrondissement());
		}
		return trafficStationBean;
	
	}

}
