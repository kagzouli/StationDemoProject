package com.exakaconsulting.poc.security;

public class JwtUserDto {

 
    private String username;

    private String role;

 
    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }
}

