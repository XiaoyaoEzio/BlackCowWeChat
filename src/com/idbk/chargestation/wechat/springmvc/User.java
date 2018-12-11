package com.idbk.chargestation.wechat.springmvc;

import org.springframework.stereotype.Controller;

@Controller
public class User extends BaseControler {

//	private static final Logger LOG = Logger.getLogger(User.class);
//	
//	/**
//	 * 短信接口(由于服务器需要加密，因此这里做转发)
//	 * @param mobile
//	 * @param flag
//	 * @return
//	 */
//	@RequestMapping("/user/sms")
//	@ResponseBody
//	public String getVCode(
//			HttpServletRequest req,
//			@RequestParam(value="mobile", required=true) String mobile){
//		//基本的输入验证
//		String result = "";
//		String token = "";
//		try {
//			//处理token
//			HttpSession session = req.getSession(false);
//			if(session != null){
//				Object obj = session.getAttribute(AppConfig.KEY_USER_CACHE);
//				if(obj instanceof LoginCache){
//					LoginCache cache = (LoginCache)obj;
//					if(cache.checkLogin()){
//						token = cache.getToken();
//					}
//				}				
//			}	
//			LOG.info("修改密码token:" + token);
//			
//			String timestamp = new Date().getTime() + "";
//			String para = "mobile="+mobile+"&timeStamp="+timestamp;//请求参数以及排序
//			String data = MyDES.MD5Encrypt(para.getBytes("UTF-8"));			
//			String sign = MyDES.encrypt(data, MyDES.KEY);
//			String url = String.format(
//					"%s%s?model.mobile=%s&model.timeStamp=%s&model.sign=%s&%s=%s&model.agentId=%s", 
//					AppConfig.HOST, 
//					"/api/other/sms.do", 
//					mobile,
//					timestamp,
//					sign,
//					AppConfig.KEY_TOKEN,
//					token,
//					AppConfig.VENDOR_ID);
//			Request request = new Request.Builder()  
//			.url(url) 		
//			.build();   		    		
//			result = httpRequest(request);
//		} catch (Exception e) {
//			LOG.error(e.getMessage(),e);
//		}
//		return result;
//	}
//	
//	@RequestMapping("/user/mobileBind")
//	@ResponseBody
//	public String mobileBindReq(
//			HttpServletRequest req,
//			@RequestParam(value="mobile", required=true) String mobile,
//			@RequestParam(value="password", required=true) String password){
//		//基本的输入验证
//		String result = "";
//		String token = "";
//		try {
//			//处理token
//			HttpSession session = req.getSession(false);
//			if(session != null){
//				Object obj = session.getAttribute(AppConfig.KEY_USER_CACHE);
//				if(obj instanceof LoginCache){
//					LoginCache cache = (LoginCache)obj;
//					if(cache.checkLogin()){
//						token = cache.getToken();
//					}
//				}				
//			}	
//			LOG.info("修改密码token:" + token);
//			String timestamp = new Date().getTime() + "";
//			String url = String.format(
//					"%s%s?model.mobile=%s&model.password=%s&%s=%s&model.agentId=%s&model.timeStamp=%s", 
//					AppConfig.HOST, 
//					"/api/user/subenterprise!bind.do", 
//					mobile,
//					password,
//					AppConfig.KEY_TOKEN,
//					token,
//					AppConfig.VENDOR_ID,
//					timestamp);
//			Request request = new Request.Builder()  
//			.url(url) 		
//			.build();   		    		
//			result = httpRequest(request);
//		} catch (Exception e) {
//			LOG.error(e.getMessage(),e);
//		}
//		return result;
//	}
//	
//	@RequestMapping("/user/cancelBind")
//	@ResponseBody
//	public String cancelBindReq(
//			HttpServletRequest req,
//			@RequestParam(value="password", required=true) String password){
//		//基本的输入验证
//		String result = "";
//		String token = "";
//		try {
//			//处理token
//			HttpSession session = req.getSession(false);
//			if(session != null){
//				Object obj = session.getAttribute(AppConfig.KEY_USER_CACHE);
//				if(obj instanceof LoginCache){
//					LoginCache cache = (LoginCache)obj;
//					if(cache.checkLogin()){
//						token = cache.getToken();
//					}
//				}				
//			}	
//			LOG.info("修改密码token:" + token);
//			
//			String timestamp = new Date().getTime() + "";
//			String url = String.format(
//					"%s%s?model.password=%s&%s=%s&model.agentId=%s&model.timeStamp=%s", 
//					AppConfig.HOST, 
//					"/api/user/subenterprise!unbind.do", 
//					password,
//					AppConfig.KEY_TOKEN,
//					token,
//					AppConfig.VENDOR_ID,
//					timestamp);
//			Request request = new Request.Builder()  
//			.url(url) 		
//			.build();   		    		
//			result = httpRequest(request);
//		} catch (Exception e) {
//			LOG.error(e.getMessage(),e);
//		}
//		return result;
//	}
}
