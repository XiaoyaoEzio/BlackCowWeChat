package com.idbk.chargestation.wechat.springmvc;

import java.io.IOException;
import java.util.concurrent.TimeUnit;

import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.Response;

import com.google.gson.FieldNamingPolicy;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.annotations.SerializedName;
import com.idbk.chargestation.wechat.AppConfig;
import com.idbk.chargestation.wechat.json.JsonWxUserInfo;

public class BaseControler {

	protected static final String SERVER_ERROR = "{\"status\":-1,\"msg\":\"Proxy-数据获取失败\"}";
	
	protected static Gson getGson() {
		
		final GsonBuilder gsonBuilder = new GsonBuilder();
		Gson gson = gsonBuilder.disableHtmlEscaping()
				.setFieldNamingPolicy(FieldNamingPolicy.UPPER_CAMEL_CASE)
				.setPrettyPrinting()
				.serializeNulls()
				.setDateFormat("yyyy-MM-dd HH:mm:ss")
				.create();
		return gson;
	}

	protected static String httpRequest(Request request) throws IOException {
		OkHttpClient client =  new OkHttpClient.Builder()
						        .readTimeout(AppConfig.TIMEOUT_READ,TimeUnit.SECONDS)//设置读取超时时间
						        .writeTimeout(AppConfig.TIMEOUT_WRITE,TimeUnit.SECONDS)//设置写的超时时间
						        .connectTimeout(AppConfig.TIMEOUT_CONNECT,TimeUnit.SECONDS)//设置连接超时时间
						        .build();
		Response response = client.newCall(request).execute();  
		if (!response.isSuccessful())  
			throw new IOException("Unexpected code " + response);  
		return response.body().string();
	}
	
	/**
	 * 微信AUTH2验证 获取access_token的地址
	 */
	public static final String WX_AUTH2_URL_ACCESS_TOKEN = "https://api.weixin.qq.com/sns/oauth2/access_token?appid=%s&secret=%s&code=%s&grant_type=authorization_code";
	
	protected JsonWxAuth2AccessToken getAccessToken(String code){
		String url = String.format(
				WX_AUTH2_URL_ACCESS_TOKEN, 
				AppConfig.APP_ID,
				AppConfig.APP_SECRET,
				code);
		JsonWxAuth2AccessToken token = null;
		Request request = new Request.Builder()  
		.url(url) 		
		.build(); 
		try {
			String json = httpRequest(request);
			token = getGson().fromJson(json, JsonWxAuth2AccessToken.class);
			
		} catch (IOException e) {
			e.printStackTrace();
		}		
		return token;
	}
	
	protected JsonWxUserInfo getWxUserInfo(String accessToken, String openId) {
		JsonWxUserInfo result = null;
		String url = String.format("https://api.weixin.qq.com/sns/userinfo?access_token=%s&openid=%s&lang=zh_CN",
				accessToken,
				openId);
		Request request = new Request.Builder().url(url).build();
		try {
			String json = httpRequest(request);
			
			result = getGson().fromJson(json, JsonWxUserInfo.class);
			
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
		
		return result;
	}
	
	/**
	 * 微信网页auth2验证
	 * 通过code换取网页授权access_token
	 * @author lupc
	 *
	 */
	public static class JsonWxAuth2AccessToken {
			
		/**
		 * 网页授权接口调用凭证,注意：此access_token与基础支持的access_token不同
		 */
		@SerializedName("access_token")
		public String accessToken;
		
		/**
		 * access_token接口调用凭证超时时间，单位（秒）
		 */
		@SerializedName("expires_in")
		public int expiresIn;
		
		/**
		 * 用户刷新access_token
		 */
		@SerializedName("refresh_token")
		public String refreshToken;
		
		/**
		 * 用户唯一标识，请注意，在未关注公众号时，用户访问公众号的网页，也会产生一个用户和公众号唯一的OpenID
		 */
		@SerializedName("openid")
		public String openId;
		
		/**
		 * 用户授权的作用域，使用逗号（,）分隔
		 */
		@SerializedName("scope")
		public String scope;
		
		/**
		 * 只有在用户将公众号绑定到微信开放平台帐号后，才会出现该字段。
		 * 详见：获取用户个人信息（UnionID机制）
		 */
		@SerializedName("unionid")
		public String unionId;
	};

}
