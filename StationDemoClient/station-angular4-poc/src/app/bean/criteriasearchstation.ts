import { OrderBean } from "./orderbean";


export class CriteriaSearchStation {
    	
	reseau : string;
	
	station : string;
	
	trafficMin : number;
	
	// Max traffic
	trafficMax : number;
	
	//Starts with
    ville : string;

    page: number;

	perPage: number;

	orders : Array<OrderBean> = [];
	

	constructor(reseau? : string, station?: string, trafficMin? : number, trafficMax? : number , ville? : string, page? : number , perPage? : number){
		this.reseau     = reseau;
		this.station    = station;
		this.trafficMin = trafficMin;
		this.trafficMax = trafficMax;
		this.ville      = ville;
		this.page       = page;
		this.perPage = perPage;
	}
 }