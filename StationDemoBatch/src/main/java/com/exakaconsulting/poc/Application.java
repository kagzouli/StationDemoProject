package com.exakaconsulting.poc;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;

import org.apache.commons.lang3.StringUtils;

public class Application {
	
	static final File file = new File("D:\\Karim\\dev\\workspace\\StationDemoProject\\StationDemoBatch\\src\\main\\resources\\trafic-annuel-entrant-par-station-du-reseau-ferre.csv");

	
	public static void main(String[] args){
		
		try(FileWriter fileWriter = new FileWriter(new File("D:\\Karim\\dev\\workspace\\Swriter.txt"));
				BufferedReader fileReader = new BufferedReader(new FileReader(file))
				){
			
			String chaine = "";
			fileReader.readLine();
			while ((chaine = fileReader.readLine()) != null){
				final String utf8 =new String(chaine.getBytes(),"UTF-8");
				
				String[] values = utf8.split(";");
				
				fileWriter.append("INSERT INTO TRAF_STAT(TRAF_RESE, TRAF_STAT, TRAF_TRAF, TRAF_CORR, TRAF_VILL, TRAF_ARRO) values ")
				.append("(' ")
				.append(values[1])
				.append("' , '")
				.append(StringUtils.replace(values[2], "'", "''"))
				.append("' , '")
				.append(values[3])
				.append("' , '");
				
				String corrs = "";
				
				final String corr1 = values[4];
				if (!StringUtils.isBlank(corr1)){
					corrs = corr1;
				}

				final String corr2 = values[5];
				if (!StringUtils.isBlank(corr2)){
					corrs = corrs + "," + corr2;
				}

				final String corr3 = values[6];
				if (!StringUtils.isBlank(corr3)){
					corrs = corrs + "," + corr3;
				}
				
				final String corr4 = values[7];
				if (!StringUtils.isBlank(corr4)){
					corrs = corrs + "," + corr4;
				}
				
				final String corr5 = values[8];
				if (!StringUtils.isBlank(corr5)){
					corrs = corrs + "," + corr5;
				}

				fileWriter.append(corrs).append("' ,'").append(values[9]);
				
				if (values.length < 10){
					fileWriter.append("' , '").append(values[10]).append("')");
				}else{
					fileWriter.append("' , ").append("NULL").append(")");
				}
				
				fileWriter.append(";");
				
				
				fileWriter.append("\n");

				

			}
			
			 
			
		}catch(Exception exception){
			exception.printStackTrace();
		}
	}
}

