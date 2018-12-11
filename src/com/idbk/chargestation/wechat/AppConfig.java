package com.idbk.chargestation.wechat;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

import javax.servlet.http.HttpServletRequest;

/**
 * 一些全局变量的配置
 * @author gaoqy
 *
 */
public class AppConfig {
	
	//--------------分发级别的配置-----------------------
	
	public static final String ENV_RELEASE = "RELEASE";
	public static final String ENV_DEBUG = "DEBUG";
	
		
	/**
	 * 当前 是否是测试环境
	 */
	public static final String ENV;
	/**
	 * 当前 服务提供商(该字段决定了使用哪个配置文件)
	 */
	public static final String VENDOR;
	
	//-----------------------------------------------
	
	/**
	 * 公众号appid
	 */
	public static final String APP_ID;
	public static final String APP_SECRET; 
	
	/**
	 * 如果要使用动态菜单，在微信服务器配置的预留token值
	 */
	public static final String WX_SERVER_PRE_TOKEN;
	
	/**
	 * 公众号后台域名
	 */
	public static final String DOMAIN;
	
	/**
	 * api接口域名
	 */		
	public static final String HOST;
	/**
	 * api接口工程包名
	 */	
	public static final String PROJECTPATH;
	/**
	 * 接口域名（头像专用）
	 */
	public static final String HOST_FOR_IMG;
	
	
	/**
	 * app下载地址
	 */
	public static final String APP_URL;

	/**
	 * 公司简称
	 */
	public static final String COMPANY;
	/**
	 * 公司全名
	 */
	public static final String COMPANY_FULL_NAME;
	/**
	 * 公司电话
	 */
	public static final String COMPANY_TEL;
	/**
	 * 公司官网
	 */
	public static final String COMPANY_URL;
	
	/**
	 * 用户协议文件地址（相对根目录）
	 */
	public static final String LICENSE;
	
	/**
	 * 应用名称
	 */
	public static final String APP_NAME;
	
	
	public static final String KEY_AMAP;
	
	//------------------分发级功能开关--------------------------
	
	/**
	 * 是否支持 绑定微信 openid
	 */
	public static final String AC_SUPPORT_OPENID;
	
	//------------------------------------------------------
	
	/**
	 * 各种配置参数的配置文件
	 */
	private static final String CONFIG_FILE = "/app.properties";
	
	static {
		Properties prop = getConfig(CONFIG_FILE); 
		
		ENV = prop.getProperty("ENV", ENV_RELEASE);
		VENDOR = prop.getProperty("VENDOR", "znyd");
		
		//先判断 是否是测试环境
		if(ENV.equals(ENV_RELEASE)){
			//根据 服务提供商名称 加载对应的配置文件
			String fileName = "/app_" + VENDOR + ".properties";
			prop = getConfig(fileName);
		} else {
			prop = getConfig("/app_debug.properties");
		}
		
		DOMAIN = prop.getProperty("DOMAIN", "http://wx.eastevs.com");
		HOST = prop.getProperty("HOST", "http://wx.eastevs.com");
		PROJECTPATH = prop.getProperty("PROJECTPATH","");
		HOST_FOR_IMG = prop.getProperty("HOST_FOR_IMG", "http://wx.eastevs.com");
		
		APP_ID = prop.getProperty("APP_ID", "wx07e7e64417d90717");
		APP_SECRET = prop.getProperty("APP_SECRET", "2b93d3697a3f30159c457415e2b2f2bd");
		WX_SERVER_PRE_TOKEN = prop.getProperty("WX_SERVER_PRE_TOKEN", "2b93d3697a3f30159c457415e2b2f2bd");
		
		KEY_AMAP = prop.getProperty("KEY_AMAP", "66666666666666666");
				
		APP_URL = prop.getProperty("APP_URL", "http://a.app.qq.com/o/simple.jsp?pkgname=com.idbk.chargestation");
		COMPANY = prop.getProperty("COMPANY", "中能易电");
		COMPANY_FULL_NAME = prop.getProperty("COMPANY_FULL_NAME", "中能易电新能源技术公司");
		COMPANY_TEL = prop.getProperty("COMPANY_TEL", "0769-22897777");
		COMPANY_URL = prop.getProperty("COMPANY_URL", "http://echarpile.com");
		APP_NAME = prop.getProperty("APP_NAME", "易电桩");
		LICENSE = prop.getProperty("LICENSE", "jsp/other/license.jsp");
		
		//----
		AC_SUPPORT_OPENID = prop.getProperty("AC_SUPPORT_OPENID", "false");
	}	
	
	static Properties getConfig(String file) {
		Properties prop = new Properties(); 
		InputStream in = null;
		in = AppConfig.class.getResourceAsStream(file);
		try {
			prop.load(in);
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			if(in != null){
        		try {
        			in.close();
				} catch (Exception e2) {
					e2.printStackTrace();
				}
        	}
		}
		return prop;
	}
	
	public static final String getAppURL(HttpServletRequest request){
		if(APP_URL.equals("noapp")){
			return request.getContextPath() + "/jsp/other/noapp.jsp";
		} else {
			return APP_URL;
		}
	}
	
	//---------------------------------------------------------
	
	/**
	 * 程序内部参数配置文件
	 */
	private static final String CONFIG_PARA_FILE = "/para.properties";
	
	//--------------应用参数的配置-----------------------
	
	public static final int TIMEOUT_CONNECT;
	public static final int TIMEOUT_READ;
	public static final int TIMEOUT_WRITE;
	
	//--------------js/css文件版本管理-----------------------
	public static final String JS_MY_PUBLIC;
	public static final String CSS_MY_PUBLIC;
	public static final String CSS_WX_STYLE;
	public static final String CSS_MY_WX;
	
	static {
		Properties prop = getConfig(CONFIG_PARA_FILE); 
		
		TIMEOUT_CONNECT = Integer.parseInt(prop.getProperty("TIMEOUT_CONNECT", "3000"));
		TIMEOUT_READ = Integer.parseInt(prop.getProperty("TIMEOUT_READ", "120000"));
		TIMEOUT_WRITE = Integer.parseInt(prop.getProperty("TIMEOUT_WRITE", "6000"));
		
		JS_MY_PUBLIC = prop.getProperty("JS_MY_PUBLIC", "1.0.0");
		CSS_MY_PUBLIC = prop.getProperty("CSS_MY_PUBLIC", "1.0.0");
		CSS_WX_STYLE = prop.getProperty("CSS_WX_STYLE", "1.0.1");
		CSS_MY_WX = prop.getProperty("CSS_MY_WX", "1.0.1");
	}
	
	//---------------应用级map的键名称--------------------------
		
	public static final String KEY_USER_CACHE = "user_cache";
	
	public static final String KEY_TOKEN = "myAppToken";
	
	public static final String KEY_HAS_OPEN_ID = "has_open_id";
	
	public static final String KEY_WX_HEAD_IMG_URL = "wx_head_image_url";
	
}
