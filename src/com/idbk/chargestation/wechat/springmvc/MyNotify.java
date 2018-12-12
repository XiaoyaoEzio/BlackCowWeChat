package com.idbk.chargestation.wechat.springmvc;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.StringWriter;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import okhttp3.MediaType;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.RequestBody;
import okhttp3.Response;

import org.apache.log4j.Logger;
import org.springframework.http.HttpRequest;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.google.gson.JsonObject;
import com.google.gson.annotations.SerializedName;
import com.idbk.chargestation.wechat.AppConfig;
import com.idbk.chargestation.wechat.WeChat;
import com.idbk.chargestation.wechat.WxConfig;

import freemarker.template.Configuration;
import freemarker.template.Template;
import freemarker.template.TemplateExceptionHandler;

/**
 * 接收充电业务相关的通知
 * @author lupc
 *
 */
@Controller
@RequestMapping("/spring/notify")
public class MyNotify extends BaseControler {

	private static final Logger LOG = Logger.getLogger(MyNotify.class);	
	
	private static Configuration configuration;
	
	/*
	 * 
	 * 
{ 
"Pow":0,
"TradingNo":"111111111111",
"Name":"170309001015",
"PileType":1,
"PowFee":223,
"ObjectUnitFsn":"170309001015",
"StartTime":"2017-04-01+16:09:15",
"EndTime":"2017-04-01+16:09:59",
"ChargeTime":1,
"ServerFee":200,
"TotalFee":223
}
	 * 
	 */
	
	/**
	 * 接收充电异常推送的接口<br/>
	 * 接收后，将该信息推送给微信用户
	 * @param notify
	 * @return
	 */
	@ResponseBody
	@RequestMapping("/bill/exception")
	public String notifyErrorBill(
			@RequestParam("jsonList") String jsonList,
			@RequestParam("token") String token
			) {
		//1.解析收到的 账单推送
		LOG.info(jsonList);
		ChargeErrorBillNotify noty = null;
		ErrorBill bill = null;
		try {
			noty = getGson().fromJson(jsonList, ChargeErrorBillNotify.class);
			bill = new ErrorBill(token,noty);
		} catch (Exception e) {
			LOG.error(e.getMessage(), e);
		}			
		if(bill == null){
			return "error";
		}
		
		Map<String,Object> root = new HashMap<String, Object>();
		root.put("data", bill);
		//2.生成模板消息		
		String json = getJson(root,ErrorBill.FILE_NAME);
		//3.发送给腾讯
		try {
			sendToTencent(json);
		} catch (Exception e) {
			return json + "连接发送腾讯服务器失败";
		}
			
		return "OK";
	}
	
	
	/**
	 * 接收充电账单推送的接口<br/>
	 * 接收后，将该账单推送给微信用户
	 * @param notify
	 * @return
	 */
	@ResponseBody
	@RequestMapping("/bill/charge")
	public String notifyChargeBill(
			@RequestParam("MsgType") String MsgType,
			@RequestParam("phone") String phone,
			@RequestParam("jsonList") String jsonList,
			@RequestParam("token") String token,
			@RequestParam("openid") String openid
			){
		
		/*
		 * 
		 MsgType=1&
		 phone=18319253630&
		 jsonList=%7B%22Pow%22%3A0%2C%22
		           Name%22%3A%22170309001015%22%2C%22
		           PileType%22%3A1%2C%22
		           PowFee%22%3A223%2C%22
		           ObjectUnitFsn%22%3A%22170309001015%22%2C%22
		           StartTime%22%3A%222017-04-01+16%3A09%3A15%22%2C%22
		           EndTime%22%3A%222017-04-01+16%3A09%3A59%22%2C%22
		           ChargeTime%22%3A1%2C%22
		           ServerFee%22%3A200%2C%22
		           TotalFee%22%3A223%7D&
		 token=0F59CD25547D8FB18676C0FE58E0FC8C 
		 * 
		 */
		
		//参数检查
		if(openid == null || openid.length() < 5){
			LOG.info("发送通知，参数缺少openid");
			return "openid required.";
		}
		
		//1.解析收到的 账单推送
		LOG.info(jsonList);
		ChargeBillNotify cbn = null;
		BillCharge bill = null;
		try {
			cbn = getGson().fromJson(jsonList, ChargeBillNotify.class);
			bill = new BillCharge(openid,cbn);
		} catch (Exception e) {
			LOG.error(e.getMessage(), e);
		}	
		
		if(bill == null){
			return "error";
		}
		Map<String,Object> root = new HashMap<String, Object>();
		root.put("data", bill);
		//2.生成模板消息		
		String json = getJson(root,BillCharge.FILE_NAME);
		//3.发送给腾讯
		sendToTencent(json);
		
		return "ok";
	}
	
	public static final String URL_SEND_TEMPLATE_MSG = "https://api.weixin.qq.com/cgi-bin/message/template/send";
	
	private static final MediaType MEDIA_TYPE_JSON = MediaType.parse("application/x-www-form-urlencoded; charset=utf-8");
	
	private void sendToTencent(String json){
		WxConfig wc = WeChat.getWxConfig("aaa");
		
		String url = String.format(
				"%s?access_token=%s",
				URL_SEND_TEMPLATE_MSG,
				wc.accessToken);
		try {
			okhttp3.RequestBody body = okhttp3.RequestBody
					.create(MEDIA_TYPE_JSON, json);
			Request request = new Request.Builder()  
			.url(url) 
			.post(body)
			.build(); 
			OkHttpClient client = new OkHttpClient();
			Response response = client.newCall(request).execute();  
			if (!response.isSuccessful())  
				throw new IOException("Unexpected code " + response);
			LOG.info(response.body().string());
		} catch (Exception e) {
			LOG.error(e.getMessage(), e);
		}
	}
	
	private static Configuration getFreemarkerConfig() {
		try {
			if(configuration == null){
				configuration = new Configuration(Configuration.VERSION_2_3_25);
				String path = MyNotify.class.getClassLoader().getResource("").getPath();
				String fullPath = path + "/vendor/"  + AppConfig.VENDOR;				
				configuration.setDirectoryForTemplateLoading(new File(fullPath));
				configuration.setDefaultEncoding("UTF-8");
				configuration.setTemplateExceptionHandler(TemplateExceptionHandler.RETHROW_HANDLER);
				configuration.setLogTemplateExceptions(false);
			}
		} catch (Exception e) {
			configuration = null;
			LOG.fatal(e.getMessage(), e);
		}
		return configuration;
	}
	
	private String getJson(Map<String, ?> root,String fileName) {
		String t = null;
		try {			
			Template template = getFreemarkerConfig().getTemplate(fileName);						
			StringWriter sw = new StringWriter();
			template.process(root, sw);				
			t = sw.toString();
			LOG.debug(t);
		} catch (Exception e) {
			LOG.error(e.getMessage(), e);
		}
		return t;
	}
		
	public static class BillCharge {
		
		public static final String FILE_NAME = "ChargeBill.ftlh";
		
		private String openId;
		
		private String logid;
		
		private String pileSn;
		
		private String timeSpend;
		
		private String money;
		
		private String finishTime;
		
		public BillCharge(String openId,ChargeBillNotify cbn){
			this.openId = openId;
			logid = cbn.tradingNo;
			pileSn = cbn.ObjectUnitFsn;
			timeSpend = getTimeSpend(cbn.StartTime,cbn.EndTime);
			//这里要将 分转化成元
			money = convertF2Y(cbn.totalFee) + "元";
			finishTime = cbn.EndTime;
		}
		
		/**
		 * 将分转化成元的字符串
		 * @param fen
		 * @return
		 */
		private String convertF2Y(long fen){
			return String.format("%.2f", (fen/100d + 0.000005));			
		}
		
		/**
		 * 返回 xx天xx小时xx分，如果小于1天则不显示天
		 * @param begin
		 * @param end
		 * @return
		 */
		private String getTimeSpend(String begin,String end){
			String result = "无法计算";
			try {
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
				Date b = sdf.parse(begin);
				Date e = sdf.parse(end);
				int timespan = (int)(e.getTime() - b.getTime());
				int day = 0,hour = 0,minute = 0;
				day = timespan / (1000 * 60 * 60 * 24);
				hour = timespan % (1000 * 60 * 60 * 24) / (1000 * 60 * 60);
				minute = timespan % (1000 * 60 * 60) / (1000 * 60);
				minute = minute == 0 ? 1:minute; 
				if(day > 0 ){
					result = day + "天" + hour + "时" + minute + "分";
				} else if(hour > 0){
					result = hour + "时" + minute + "分";
				} else {
					result = minute + "分";
				}				
			} catch (Exception e) {
				// TODO: handle exception
			}			
			return result;
		}

		public String getOpenId() {
			return openId;
		}

		public String getLogid() {
			return logid;
		}

		public String getPileSn() {
			return pileSn;
		}

		public String getTimeSpend() {
			return timeSpend;
		}

		public String getMoney() {
			return money;
		}

		public String getFinishTime() {
			return finishTime;
		}

		public void setOpenId(String openId) {
			this.openId = openId;
		}

		public void setLogid(String logid) {
			this.logid = logid;
		}

		public void setPileSn(String pileSn) {
			this.pileSn = pileSn;
		}

		public void setTimeSpend(String timeSpend) {
			this.timeSpend = timeSpend;
		}

		public void setMoney(String money) {
			this.money = money;
		}

		public void setFinishTime(String finishTime) {
			this.finishTime = finishTime;
		}
				
	}
	
	
	public static class ChargeBillNotify {
		
		@SerializedName("TradingNo")
		public String tradingNo;
		
		/**
		 * 电费 
		 */
		@SerializedName("Pow")
		public double pow;
		
		/**
		 * 
		 */
		@SerializedName("Name")
		public String name;
		
		/**
		 * 
		 */
		@SerializedName("PileType")
		public int PileType;
		
		@SerializedName("PowFee")
		public int PowFee;
		
		@SerializedName("ObjectUnitFsn")
		public String ObjectUnitFsn;
		
		@SerializedName("StartTime")
		public String StartTime;
		
		@SerializedName("EndTime")
		public String EndTime;
		
		@SerializedName("ChargeTime")
		public int ChargeTime;
		
		/*
		 * 服务费
		 */
		@SerializedName("ServerFee")
		public double ServerFee;
		
		/**
		 * 总费用（单位：分）
		 */
		@SerializedName("TotalFee")
		public long totalFee;
	}
	
	public static class ChargeErrorBillNotify {
		
		@SerializedName("objectUnitFsn")
		public String objectUnitFsn;
		
		@SerializedName("name")
		public String name;
		
		@SerializedName("time")
		public String time;
		
		@SerializedName("pow")
		public double pow;
		
		@SerializedName("reasonOfEnd")
		public String reasonOfEnd;
		
		@SerializedName("openid")
		public String openid;
	}
	
	public static class ErrorBill {
		public static final String FILE_NAME = "ErrorBill.ftlh";
	
		private String objectUnitFsn;
		
		private String name;
		
		private String time;
		
		private String pow;
		
		private String reasonOfEnd;
		
		private String openId;
		
		private String token;
		
		ErrorBill(String token,ChargeErrorBillNotify notify) {
			try {
				
				this.token = token;
				this.openId = notify.openid;
				name = notify.name;
				objectUnitFsn = notify.objectUnitFsn;
				pow = String.format("%.2f度", notify.pow/100);//保留两位小数
				reasonOfEnd = notify.reasonOfEnd;
				time = notify.time;
			} catch (Exception e) {
				LOG.error(e.getMessage(),e);
			}
			
			
			
		}
		
		public String getOpenId() {
			return openId;
		}
		public String getObjectUnitFsn() {
			return objectUnitFsn;
		}
		public String getName() {
			return name;
		}
		public String getTime() {
			return time;
		}
		public String getPow() {
			return pow;
		}

		public String getReasonOfEnd() {
			return reasonOfEnd;
		}
		
		public String getToken() {
			return token;
		}
		
		public void setOpenId(String openId) {
			this.openId = openId;
		}

		public void setObjectUnitFsn(String objectUnitFsn) {
			this.objectUnitFsn = objectUnitFsn;
		}

		public void setName(String name) {
			this.name = name;
		}

		public void setTime(String time) {
			this.time = time;
		}

		public void setPow(String pow) {
			this.pow = pow;
		}

		public void setReasonOfEnd(String reasonOfEnd) {
			this.reasonOfEnd = reasonOfEnd;
		}
			
		
		public void setToken(String token) {
			this.token = token;
		}
	}
}
