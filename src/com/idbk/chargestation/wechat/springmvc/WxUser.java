package com.idbk.chargestation.wechat.springmvc;

import com.idbk.chargestation.wechat.AppConfig;
import com.idbk.chargestation.wechat.LoginCache;
import com.idbk.chargestation.wechat.json.JsonWxUserInfo;
import com.idbk.chargestation.wechat.json.ProxyJsonLogin;
import okhttp3.Request;
import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

@Controller
@RequestMapping("/spring/wx")
public class WxUser extends BaseControler {

	private static final Logger LOG = Logger.getLogger(WxUser.class);
	
	/**
	 * 微信授权后会回调本地址，在此接收code和openid
	 * @param req
	 * @param code
	 * @param state
	 * @return
	 */
	@RequestMapping("/bind_openid")
	public String getWxAuth2Code(
			HttpServletRequest req,
			@RequestParam(value="code") String code,
			@RequestParam(value="state") String state
			){
		//拉取access_token
		JsonWxAuth2AccessToken token = getAccessToken(code);
		if(token == null){
			return "redirect:/jsp/wx/faild.jsp";
		} else {
			LOG.debug("openId:" + token.openId);
			//将openid绑定到数据库
			boolean result = bindOpenid(req,token.openId);
			if(result){
				return "wx/bind";	
			} else {
				return "redirect:/jsp/wx/faild.jsp";	
			}
		}
	}
	
	/**
	 * 用户绑定openid
	 * @param req
	 * @param openid
	 * @return
	 */
	private boolean bindOpenid(
			HttpServletRequest req,
			String openid
			){
		boolean result = false;
		result = true;
		try {
			HttpSession session = req.getSession(false);
			Object obj = session.getAttribute(AppConfig.KEY_USER_CACHE);
			LoginCache cache = (LoginCache)obj;
			
			String name = cache.getName();
			String password = cache.getPassword();
			
			String url = String.format(
					"%s%s?username=%s&password=%s&openId=%s", 
					AppConfig.HOST, 
					"/min/user/login", 
					name,
					password,
					openid);			      			
			Request request = new Request.Builder()  
			.url(url) 		
			.build();   		    		
			String temp = httpRequest(request);
			
			ProxyJsonLogin jb = getGson().fromJson(temp, ProxyJsonLogin.class);
			if(jb.status == 0){
				//表示登录成功
				cache.refreshToken(jb.data.token);
				//更新openid
				if(jb.openId == null){
					//此时表示 服务器不支持绑定openid，客户端不需要去绑定openid
					session.setAttribute(AppConfig.KEY_HAS_OPEN_ID, "openid-not-surport");
				}else if(jb.openId.equals("")){
					//此时表示 服务器支持绑定openid，且当前用户没有绑定openid
					session.removeAttribute(AppConfig.KEY_HAS_OPEN_ID);
				} else if(jb.openId.length() > 10){
					//此时表示：用户已经绑定openid
					session.setAttribute(AppConfig.KEY_HAS_OPEN_ID, jb.openId.subSequence(1, 8));
					JsonWxUserInfo wxUser = Login.getWxUserInfo(this,jb.openId);
					if(wxUser != null && wxUser.errcode == 0){
						session.setAttribute(AppConfig.KEY_WX_HEAD_IMG_URL, wxUser.headimgurl);	
					}
				}  else {
					//不会有此情形
					session.removeAttribute(AppConfig.KEY_HAS_OPEN_ID);
				}
				result = true;
			}
		} catch (Exception e) {
			LOG.error(e.getMessage(),e);
		}
		return result;
	}

}
