package com.idbk.chargestation.wechat;

import java.io.IOException;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;

import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.Response;

import org.apache.log4j.Logger;

import com.google.gson.FieldNamingPolicy;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.idbk.chargestation.wechat.json.JsonTicket;
import com.idbk.chargestation.wechat.json.JsonToken;
import com.idbk.chargestation.wechat.util.MySHA1;

/**
 * 微信 中央管理类
 * 同一个微信公众号的所有token请求必须通过本类来管理
 * @author gqy
 *
 */
public class WeChat {

	private static final Logger LOG = Logger.getLogger(WeChat.class);

	public static WxConfig wxConfig = null;	
	
	private static final String URL_GET_TOKEN = "https://api.weixin.qq.com/cgi-bin/token";
	
	private static final GsonBuilder GsonBuilder = new GsonBuilder();
	
	public static WxConfig getWxConfig(){
		if(wxConfig == null || wxConfig.checkTokenExpireIn()){
			wxConfig = new WxConfig();
			//1、获取AccessToken  
			JsonToken token = getAccessToken();				
			//
			wxConfig.setTokenExpiresIn(token.accessToken,token.expiresIn);			
			
			LOG.debug("WxConfig init");
		}
		if(wxConfig.checkTicketExpireIn()){			
			//2、获取Ticket  
			JsonTicket ticket = getTicket(wxConfig.accessToken);
			//3、时间戳和随机字符串  
			String noncestr = UUID.randomUUID().toString().replace("-", "").substring(0, 16);//随机字符串  
			String timestamp = String.valueOf(System.currentTimeMillis() / 1000);//时间戳
			//
			wxConfig.nonceStr = noncestr;
			wxConfig.ticket = ticket.ticket;
			wxConfig.timestamp = timestamp;
			wxConfig.setTicketExpiresIn(ticket.expiresIn);
		}
		return wxConfig;
	}

	/**
	 * 使用此方法要特别注意 URL当中不能包含参数
	 * @param uri
	 * @return
	 */
	public static WxConfig getWxConfig(String uri){
		wxConfig = getWxConfig();
		//5、将参数排序并拼接字符串  
		String url = AppConfig.DOMAIN + uri;			
		String str = "jsapi_ticket="+wxConfig.ticket+"&noncestr="+wxConfig.nonceStr+"&timestamp="+wxConfig.timestamp+"&url="+url;  
		//6、将字符串进行sha1加密  
		String signature = MySHA1.SHA1(str); 
		//
		wxConfig.signature = signature;
		
		return wxConfig;
	}	
	
	public static WxConfig getWxConfig(HttpServletRequest request){
		LOG.info(request.getRequestURI());
		LOG.info((request.getQueryString() != null ? "?" + request.getQueryString() : ""));
		String url = request.getRequestURI() 
				+ (request.getQueryString() != null ? "?" + request.getQueryString() : "");;
		return getWxConfig(url);
	} 

	/**
	 * 获取accessToken
	 * @return {"access_token":"xxxx","expires_in":7200}
	 * @throws Exception
	 */
	private synchronized static JsonToken getAccessToken() {
		JsonToken result = null;
		String url = String.format(
				"%s?grant_type=%s&appid=%s&secret=%s",
				URL_GET_TOKEN,
				"client_credential",
				AppConfig.APP_ID,
				AppConfig.APP_SECRET);
		try {
			Request request = new Request.Builder()  
			.url(url) 		
			.build(); 
			OkHttpClient client = new OkHttpClient();
			Response response = client.newCall(request).execute();  
			if (!response.isSuccessful())  
				throw new IOException("Unexpected code " + response);  
			String json = response.body().string();

			LOG.debug(json);
			
			Gson gson = GsonBuilder.disableHtmlEscaping()
					.setFieldNamingPolicy(FieldNamingPolicy.UPPER_CAMEL_CASE)
					.setPrettyPrinting()
					.serializeNulls()
					.setDateFormat("yyyy-MM-dd HH:mm:ss")
					.create();
			result = gson.fromJson(json, JsonToken.class);
		} catch (Exception e) {
			LOG.error(e.getMessage(), e);
		}				
		return result;
	}

	private synchronized static JsonTicket getTicket(String accessToken) {  
		JsonTicket result = null;  
		String url = "https://api.weixin.qq.com/cgi-bin/ticket/getticket?access_token="+ accessToken +"&type=jsapi";//这个url链接和参数不能变  
		try {
			Request request = new Request.Builder()  
			.url(url) 		
			.build(); 
			OkHttpClient client = new OkHttpClient();
			Response response = client.newCall(request).execute();  
			if (!response.isSuccessful())  
				throw new IOException("Unexpected code " + response);
			String json = response.body().string();

			LOG.debug(json);
			
			Gson gson = GsonBuilder.disableHtmlEscaping()
					.setFieldNamingPolicy(FieldNamingPolicy.UPPER_CAMEL_CASE)
					.setPrettyPrinting()
					.serializeNulls()
					.setDateFormat("yyyy-MM-dd HH:mm:ss")
					.create();
			result = gson.fromJson(json, JsonTicket.class);
		} catch (Exception e) {  
			LOG.error(e.getMessage(), e);  
		}  
		return result; 		
	}	

	public static void main(String[] args) throws Exception {
		//1、获取AccessToken  
		JsonToken token = getAccessToken();
		System.out.println(token);
		//2、获取Ticket  
		JsonTicket ticket = getTicket(token.accessToken);
		//3、时间戳和随机字符串  
		String noncestr = UUID.randomUUID().toString().replace("-", "").substring(0, 16);//随机字符串  
		String timestamp = String.valueOf(System.currentTimeMillis() / 1000);//时间戳

		System.out.println("accessToken:"+token.accessToken+"\njsapi_ticket:"+ticket.ticket+"\n时间戳："+timestamp+"\n随机字符串："+noncestr);

		//4、获取url  
		String url="http://16d1fa95.ngrok.io/BlackCowWeChat/spring/wx/charge";

		//5、将参数排序并拼接字符串  
		String str = "jsapi_ticket="+ticket.ticket+"&noncestr="+noncestr+"&timestamp="+timestamp+"&url="+url;  

		//6、将字符串进行sha1加密  
		String signature = MySHA1.SHA1(str);  
		System.out.println("参数："+str+"\n签名："+signature); 
	}

}
