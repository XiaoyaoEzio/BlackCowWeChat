package com.idbk.chargestation.wechat.json;

import com.google.gson.annotations.SerializedName;

public class JsonToken {

	@SerializedName("access_token")
	public String accessToken;
	
	@SerializedName("expires_in")
	public int expiresIn;
	
	@Override
	public String toString() {
		return "token:" + accessToken + ",expiresIn:" + expiresIn;
	}
	
}
