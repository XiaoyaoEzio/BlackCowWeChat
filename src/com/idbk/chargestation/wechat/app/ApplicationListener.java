package com.idbk.chargestation.wechat.app;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

import com.idbk.chargestation.wechat.AppConfig;

/**
 * 应用程序级别的启动<br/>
 * 初始化一些缓存什么的
 * @author lupc
 *
 */
public class ApplicationListener implements ServletContextListener {

	@Override
	public void contextInitialized(ServletContextEvent sce) {
		System.setProperty("vendor.name", AppConfig.VENDOR); 
	}

	@Override
	public void contextDestroyed(ServletContextEvent sce) {
		// TODO Auto-generated method stub
		
	}

}
