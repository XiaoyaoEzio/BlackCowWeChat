package com.idbk.chargestation.wechat.springmvc;

import java.io.IOException;
import java.util.Date;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import okhttp3.HttpUrl;
import okhttp3.Request;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.idbk.chargestation.wechat.AppConfig;
import com.idbk.chargestation.wechat.LoginCache;
import com.idbk.chargestation.wechat.WeChat;
import com.idbk.chargestation.wechat.WxConfig;
import com.idbk.chargestation.wechat.json.JsonWxUserInfo;
import com.idbk.chargestation.wechat.json.ProxyJsonLogin;
import com.idbk.chargestation.wechat.util.MyDES;


/**
 * 登录控制
 * @author lupc
 *
 */
@Controller
public class Login extends BaseControler {

	private static final Logger LOG = Logger.getLogger(Login.class);

	@RequestMapping("/login")
	@ResponseBody
	public String login(
			HttpServletRequest req,
			@RequestParam(value="username", required=true) String username,
			@RequestParam(value="password", required=true) String password,
			@RequestParam(value="openId", required=false) String openId){
		//基本的输入验证
		String result = "";
		
		try {
			HttpUrl httpUrl = HttpUrl.parse(AppConfig.HOST);
			HttpUrl.Builder builder = httpUrl.newBuilder();
			HttpUrl url = builder.addPathSegment("min")
					.addPathSegment("user")
					.addPathSegment("login")
					.addQueryParameter("username", username)
					.addQueryParameter("password", password)
					.addQueryParameter("openId", openId)
					.build();
			Request request = new Request.Builder()  
					.url(url) 		
					.build();   		    		
			result = httpRequest(request);
					
			LOG.debug(result);
			
			if(result != null){
				LOG.debug(result);	
			}			
			ProxyJsonLogin jb = getGson().fromJson(result, ProxyJsonLogin.class);
			if(jb.status == 0){
				//表示登录成功
				HttpSession session = req.getSession(true);
				LoginCache cache = new LoginCache();
				cache.setToken(username,password,jb.data.token,jb.userRole);
				session.setAttribute(AppConfig.KEY_USER_CACHE, cache);
				if(jb.openId == null){
					//此时表示 服务器不支持绑定openid，客户端不需要去绑定openid
					session.setAttribute(AppConfig.KEY_HAS_OPEN_ID, "openid-not-surport");
				}else if(jb.openId.equals("")){
					//此时表示 服务器支持绑定openid，且当前用户没有绑定openid
					session.removeAttribute(AppConfig.KEY_HAS_OPEN_ID);
				} else if(jb.openId.length() > 10){
					//此时表示：用户已经绑定openid
					session.setAttribute(AppConfig.KEY_HAS_OPEN_ID, jb.openId.subSequence(1, 8));
					JsonWxUserInfo wxUser = getWxUserInfo(this,jb.openId);
					if(wxUser != null && wxUser.errcode == 0){
						session.setAttribute(AppConfig.KEY_WX_HEAD_IMG_URL, wxUser.headimgurl);	
					}										
				}  else {
					//不会有此情形
					session.removeAttribute(AppConfig.KEY_HAS_OPEN_ID);
				}
			}
		} catch (Exception e) {
			result = SERVER_ERROR;
			LOG.error(e.getMessage(),e);
		}
		return result;
	}	
	
	public static JsonWxUserInfo getWxUserInfo(BaseControler base,String openid){
		JsonWxUserInfo userInfo = null;
		try {
			String json = getWxHeadImg(base,openid);
			userInfo = base.getGson().fromJson(json, JsonWxUserInfo.class);
		} catch (Exception e) {
			LOG.error(e.getMessage(),e);
		}		
		return userInfo;
	}
	
	/**
	 * 获取用户微信头像url
	 * @param openid
	 * @return
	 */
	private static String getWxHeadImg(BaseControler base,String openid){
		String result = "";
		WxConfig wc = WeChat.getWxConfig();
		String url = String.format(
				"https://api.weixin.qq.com/cgi-bin/user/info?access_token=%s&openid=%s&lang=zh_CN", 
				wc.accessToken,
				openid);
		Request request = new Request.Builder()  
		.url(url) 		
		.build();   		    		
		try {
			result = base.httpRequest(request);
		} catch (IOException e) {
			LOG.error(e.getMessage(),e);
		}
		return result;
	}
	
	@RequestMapping("/logout")
	@ResponseBody
	public String logout(
			HttpServletRequest req
			){
		HttpSession session = req.getSession(false);
		if(session != null){
			session.removeAttribute(AppConfig.KEY_USER_CACHE);
			session.invalidate();
		}
		return "ok";
	}
	
	/**
	 * 注册需要单独处理下，注册成功后将将登陆状态保持到会话中
	 * @param req
	 * @param username
	 * @param password
	 * @param vcode
	 * @return
	 */
	@RequestMapping("/register")
	@ResponseBody
	public String register(
			HttpServletRequest req,
			@RequestParam("username") String username,
			@RequestParam("password") String password,
			@RequestParam("vcode") String vcode,
			@RequestParam("gender") String sex){
		//基本的输入验证
		String result = "";
		try {
			HttpUrl httpUrl = HttpUrl.parse(AppConfig.HOST);
			HttpUrl.Builder builder = httpUrl.newBuilder();
			HttpUrl url = builder.addPathSegment("min")
					.addPathSegment("user")
					.addPathSegment("register")
					.addQueryParameter("userName", username)
					.addQueryParameter("password", password)
					.addQueryParameter("vCode", vcode)
					.addQueryParameter("gender", sex)
					.build();
			Request request = new Request.Builder()  
					.url(url) 		
					.build();   		    		
			result = httpRequest(request);
					
			LOG.debug(result);
			ProxyJsonLogin jb = getGson().fromJson(result, ProxyJsonLogin.class);
			//如果注册成功，还需要 将其状态置为 登录状态
			if(jb.status == 0){
				//表示登录成功
				HttpSession session = req.getSession(true);
				LoginCache cache = new LoginCache();
				cache.setToken(username,password,jb.data.token,"");
				session.setAttribute(AppConfig.KEY_USER_CACHE, cache);
				//注册的时候，肯定没有绑定过openid，但是也不知道服务器是否支持openid
				session.removeAttribute(AppConfig.KEY_HAS_OPEN_ID);
			}
		} catch (Exception e) {
			result = SERVER_ERROR;
			LOG.error(e.getMessage(),e);
		}
		return result;
	}
	
	/**
	 * 短信接口(由于服务器需要加密，因此这里做转发)
	 * @param mobile
	 * @param flag
	 * @return
	 */
	@RequestMapping("/sms")
	@ResponseBody
	public String getVCode(
			HttpServletRequest req,
			@RequestParam(value="phoneNum", required=true) String phoneNum,
			@RequestParam(value="type",required=true) int type){
		//基本的输入验证
		String result = "";
		String token = "";
		try {
			//处理token
			HttpSession session = req.getSession(false);
			if(session != null){
				Object obj = session.getAttribute(AppConfig.KEY_USER_CACHE);
				if(obj instanceof LoginCache){
					LoginCache cache = (LoginCache)obj;
					if(cache.checkLogin()){
						token = cache.getToken();
					}
				}				
			}
		} catch (Exception e1) {
			LOG.warn("无法从缓存中获取token值");
		}
		
		if (type == 2 || type == 3 ) {
			if (token.equals("") || token == null) {
				LOG.warn("登录失效,缺少token");
				return "{\"status\":-2,\"message\":\"登录超时(失效)，请重新登录\"}";
			}
		}
		
		try {
			String timestamp = new Date().getTime() + "";
			String para = "phoneNum="+phoneNum+"&timeStamp="+timestamp;//请求参数以及排序
			String data = MyDES.MD5Encrypt(para.getBytes("UTF-8"));			
			String sign = MyDES.encrypt(data, MyDES.KEY);
			
			
			HttpUrl tempUrl =  HttpUrl.parse(AppConfig.HOST);	
			HttpUrl.Builder build = tempUrl.newBuilder();
			HttpUrl url = build
			.addPathSegment("min")
			.addPathSegment("sms")
			.addPathSegment("get")
			.addQueryParameter("phoneNum", phoneNum)
			.addQueryParameter("type", type + "")
			.addQueryParameter("timeStamp", timestamp)
			.addQueryParameter("sign", sign)
			.addQueryParameter("token", token)
			.build();
			LOG.info(url);
			Request request = new Request.Builder()  
			.url(url) 		
			.build();   		    		
			result = httpRequest(request);
			LOG.info(result);
		} catch (Exception e) {
			result = SERVER_ERROR;
			LOG.error(e.getMessage(),e);
		}
		return result;
	}
	

}
