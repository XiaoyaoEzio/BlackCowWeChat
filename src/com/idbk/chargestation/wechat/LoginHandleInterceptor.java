package com.idbk.chargestation.wechat;

import java.io.IOException;
import java.net.URLEncoder;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;


/**
 * 继承SpringMVC 框架下的拦截器HandlerInterceptor，可以拦截访问WEB-INF文件下的文件
 * 登录拦截器
 * <p>注意：此拦截器仅拦截视图请求，不拦截json请求</p>
 * @author gqy
 *
 */
public class LoginHandleInterceptor implements HandlerInterceptor  {

	private static final Logger LOG = Logger.getLogger(LoginHandleInterceptor.class);

	public boolean preHandle(HttpServletRequest request,
			HttpServletResponse response, Object handler) throws Exception {
		LOG.info("加载了preHandle方法--------------------");

			return true;
	}
	
	public void postHandle(HttpServletRequest request,
			HttpServletResponse response, Object handler,
			ModelAndView modelAndView) throws Exception {
		LOG.info("加载了postHandle方法--------------------");
	}

	
	public void afterCompletion(HttpServletRequest request,
			HttpServletResponse response, Object handler, Exception ex)
					throws Exception {
		LOG.info("加载了afterCompletion方法--------------------");
	}

}
