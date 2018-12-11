package com.idbk.chargestation.wechat;

import java.text.SimpleDateFormat;
import java.util.Date;

import org.apache.log4j.Logger;

/**
 * 微信网页SDK相关的数据（主要是调用微信网页SDK所需的权限）
 * @author gqy
 *
 */
public class WxConfig {
		
	private static final Logger LOG = Logger.getLogger(WxConfig.class);
	
	public String timestamp;
	
	public String nonceStr;
	
	public String signature;
	
	public String accessToken;
	private int tokenExpiresIn;
	private Date tokenTime;
	
	private int ticketExpiresIn;	
	private Date ticketTime;
	
	public String ticket;
	
	public WxConfig(){
		tokenTime = new Date();
		tokenExpiresIn = 0;
		
		ticketTime = new Date();
		ticketExpiresIn = 0;		
	}
	
	public void setTokenExpiresIn(String token,int expiresIn){
		this.accessToken = token;
		this.tokenExpiresIn = expiresIn;
		tokenTime = new Date();
	}
	
	public void setTicketExpiresIn(int expiresIn){
		this.ticketExpiresIn = expiresIn;
		ticketTime = new Date();
	}
	
	/**
	 * 检查token时效性
	 * @return
	 */
	public boolean checkTokenExpireIn(){		
		long span = new Date().getTime() - tokenTime.getTime();
		LOG.info(
				"wxconfig-token时间:" + formatDatetime(tokenTime) 
				+ ",超时时间(expirein)(秒):" + tokenExpiresIn 
				+ ",已过时间(span)(秒):" + span/1000);
		if((span - tokenExpiresIn * 1000) > 0){
			return true;
		}
		return false;
	}
	
	/**
	 * 判断是Ticket否过期
	 * @return
	 */
	public boolean checkTicketExpireIn(){		
		long span = new Date().getTime() - ticketTime.getTime();
		LOG.info(
				"wxconfig-ticket时间:" + formatDatetime(ticketTime)
				+ ",超时时间(expirein)(秒):" + ticketExpiresIn 
				+ ",已过时间(span)(秒):" + span/1000);
		if((span - ticketExpiresIn * 1000) > 0){
			return true;
		}
		return false;
	}
	
	public static String formatDatetime(Date date){
		String r = "";
		try {
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			r = sdf.format(date);
		} catch (Exception e) {
			// TODO: handle exception
		}
		return r;
	}
	
}
