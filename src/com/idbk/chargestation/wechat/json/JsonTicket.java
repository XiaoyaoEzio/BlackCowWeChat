package com.idbk.chargestation.wechat.json;

import com.google.gson.annotations.SerializedName;

public class JsonTicket {

	@SerializedName("errcode")
	public int errcode;
	
	@SerializedName("errmsg")
	public String errmsg;
	
	@SerializedName("ticket")
	public String ticket;
	
	@SerializedName("expires_in")
	public int expiresIn;
}
