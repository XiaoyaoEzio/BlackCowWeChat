package com.idbk.chargestation.wechat;

/**
 * 用户会话缓存
 * @author gqy
 *
 */
public class LoginCache {

	private String name;
	
	private String password;
	
	private String userRole;
	
	private String token;
	
	private boolean loginState;
	
	public void refreshToken(String token){
		this.token = token;
	}
	
	public void setToken(String name,String password, String token, String userRole){
		this.name = name;
		this.password = password;
		this.userRole = userRole;
		this.token = token;
		loginState = true;
	}
	
	public String getToken(){
		return token;
	}
	
	public boolean checkLogin(){
		return loginState;
	}

	public String getPassword() {
		return password;
	}

	public String getName() {
		return name;
	}

	public String getUserRole() {
		return userRole;
	}
}
