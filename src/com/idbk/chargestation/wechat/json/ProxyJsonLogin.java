package com.idbk.chargestation.wechat.json;

import com.google.gson.annotations.SerializedName;


public class ProxyJsonLogin {
	
	public class myData {
		@SerializedName("token")
		public String token;
		
		@SerializedName("outTime")
		public int outTime;
	}
	
	@SerializedName("status")
	public int status;
	
	@SerializedName("msg")
	public String msg;
	
	@SerializedName("data")
	public myData data ;
	
	@SerializedName("userRole")
	public String userRole;
	
	/**
	 * token的超时时间（单位：分钟）
	 */
	@SerializedName("outTime")
	public int outTime;
	
	/**
	 * wx的openid
	 */
	@SerializedName("openId")
	public String openId;
}
