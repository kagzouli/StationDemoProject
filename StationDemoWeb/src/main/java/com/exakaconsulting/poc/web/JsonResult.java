package com.exakaconsulting.poc.web;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import io.swagger.annotations.ApiModelProperty;

public class JsonResult<T> implements Serializable{
	

	
	/**
	 * 
	 */
	private static final long serialVersionUID = 4558043804188367882L;

	@ApiModelProperty(value="The data to return")
	private transient T result;
	
	@ApiModelProperty(value="The list of informations")
	private List<String> infos = new ArrayList<>();
	
	@ApiModelProperty(value="The list of warnings.")
	private List<String> warning =  new ArrayList<>();
	
	@ApiModelProperty(value="The list of errors")
	private List<String> errors = new ArrayList<>();

	private boolean success;
	
	public T getResult() {
		return result;
	}

	public void setResult(T result) {
		this.result = result;
	}

	public List<String> getInfos() {
		return infos;
	}

	public void setInfos(List<String> infos) {
		this.infos = infos;
	}

	public List<String> getWarning() {
		return warning;
	}

	public void setWarning(List<String> warning) {
		this.warning = warning;
	}

	public List<String> getErrors() {
		return errors;
	}

	public void setErrors(List<String> errors) {
		this.errors = errors;
	}
	
	public void addInfo(final String info){
		this.infos.add(info);
	}
	
	public void addWarning(final String warning){
		this.warning.add(warning);
	}
	
	public void addError(final String error){
		this.success = false;
		this.errors.add(error);
	}

	public boolean isSuccess() {
		return success;
	}

	public void setSuccess(boolean success) {
		this.success = success;
	}

}
