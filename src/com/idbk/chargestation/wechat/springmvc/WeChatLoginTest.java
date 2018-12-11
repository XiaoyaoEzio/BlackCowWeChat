package com.idbk.chargestation.wechat.springmvc;

import java.io.IOException;
import java.net.URLEncoder;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;

import com.idbk.chargestation.wechat.AppConfig;

@WebServlet("/weChatLogin")
public class WeChatLoginTest  extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private static final Logger LOG = Logger.getLogger(WeChatLoginTest.class);
	
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		// TODO Auto-generated method stub
		String code = req.getParameter("code");
		String state = req.getParameter("state");
		String tempUrl = req.getParameter("tmp");
		if (code != null) {
			if (code.length() != 0 && state.equals("STATE")) {
				String ss = AppConfig.DOMAIN + req.getContextPath() + "/spring/wx/weChatAuthorized"+"?code="+code+"&state=STATE&tmp="+tempUrl;
				resp.sendRedirect(ss);
				return;
			}
		}
		
		String fromURI = req.getRequestURI();
		LOG.debug(req.getRequestURL());
		String fromFullURI = AppConfig.DOMAIN + req.getContextPath() + "/weChatLogin?tmp="+tempUrl;
		LOG.info(fromFullURI);
		//微信授权路径，snsapi_userinfo 授权获取code 
		String weChatAuthoriedURI = "https://open.weixin.qq.com/connect/oauth2/authorize?appid=" + AppConfig.APP_ID 
				+ "&redirect_uri=" + URLEncoder.encode(fromFullURI, "utf-8") + "&response_type=code&scope=snsapi_userinfo&state=STATE#wechat_redirect";
		
		resp.sendRedirect(weChatAuthoriedURI);
	}
	
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		// TODO Auto-generated method stub
		super.doPost(req, resp);
	}
	
}
