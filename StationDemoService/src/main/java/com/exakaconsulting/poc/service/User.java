package com.exakaconsulting.poc.service;

import java.io.Serializable;

public class User implements Serializable{

	private static final long serialVersionUID = 3772162822836333399L;

	/** login **/
	private String login;
	
	
	/** Role **/
	private String role;

	public String getLogin() {
		return login;
	}

	public void setLogin(String login) {
		this.login = login;
	}

	public String getRole() {
		return role;
	}

	public void setRole(String role) {
		this.role = role;
	}
	
	


}
