package com.idbk.chargestation.wechat.json;

import com.google.gson.annotations.SerializedName;

public class ProxyJsonBase {

	@SerializedName("status")
	public int status;
	
	@SerializedName("message")
	public String message;
	
	@SerializedName("token")
	public String token;
}
