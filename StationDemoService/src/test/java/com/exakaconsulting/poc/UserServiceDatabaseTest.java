package com.exakaconsulting.poc;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringRunner;
import org.springframework.test.context.support.AnnotationConfigContextLoader;
import org.springframework.transaction.annotation.Transactional;

import com.exakaconsulting.poc.service.IUserService;
import com.exakaconsulting.poc.service.User;

import static com.exakaconsulting.poc.service.IConstantStationDemo.USER_SERVICE_DATABASE;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertNull;
import static org.junit.Assert.assertTrue;



@RunWith(SpringRunner.class)
@ContextConfiguration(loader=AnnotationConfigContextLoader.class,classes=ApplicationTest.class)
@Transactional
public class UserServiceDatabaseTest {
	
	private static final String ROLE_MANAGER = "manager";
	private static final String ROLE_USER = "user";
	
	private static final String USER_MANAGER = "Karim";
	private static final String USER_USER = "Didier";
	private static final String USER_NOT_EXISTS = "NotExists";
	
	@Autowired
	@Qualifier(USER_SERVICE_DATABASE)
	private IUserService userService;
	
	@Test
	public void testUserManager(){
		
		try{
			User manager = this.userService.authenticate(USER_MANAGER, USER_MANAGER);
			assertNotNull(manager);
			assertEquals(manager.getLogin(), USER_MANAGER);
			assertEquals(manager.getRole(), ROLE_MANAGER);
		}catch(Exception exception){
			assertTrue(false);
		}
	}
	
	@Test
	public void testUserUser(){
		try{
			User user = this.userService.authenticate(USER_USER , USER_USER);
			assertNotNull(user);
			assertEquals(user.getLogin(), USER_USER);
			assertEquals(user.getRole(), ROLE_USER);
		}catch(Exception exception){
			assertTrue(false);
		}		
	}
	
	@Test
	public void testUserNotExists(){
		try{
			User userNotExists = this.userService.authenticate(USER_NOT_EXISTS, USER_NOT_EXISTS);
			assertNull(userNotExists);
		}catch(Exception exception){
			assertTrue(false);
		}	
	}
	
	@Test
	public void testUserWrongPassword(){
		try{
			User wrongPassword = this.userService.authenticate(USER_MANAGER, USER_NOT_EXISTS);
			assertNull(wrongPassword);
		}catch(Exception exception){
			assertTrue(false);
		}
		
	}

}
