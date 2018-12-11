package com.idbk.chargestation.wechat;

import java.io.IOException;
import java.io.PrintWriter;
import java.security.MessageDigest;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;

import com.idbk.chargestation.wechat.springmvc.WeChatLoginTest;

/**
 * 这里接收并认证来自微信服务器的信息
 * 
 * 
 * */

@WebServlet("/")
public class WeChatCheck  extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private static final Logger LOG = Logger.getLogger(WeChatLoginTest.class);
	
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		// TODO Auto-generated method stub
		String result = requestCheck(req);

		resp.setContentType("text/plain;charset=UTF-8");
		PrintWriter out = resp.getWriter();
		try {
			out.println(result);
			out.flush(); 
		} catch (Exception e) {
			System.out.println(e);
		}
	}
	
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		// TODO Auto-generated method stub
		super.doPost(req, resp);
	}
	
	/**
	 * 验证消息的确来自微信服务器
	 * @param request
	 * @return
	 */
	private String requestCheck(HttpServletRequest request){
		String result = null;		
		String signature = request.getParameter("signature");
		String timestamp = request.getParameter("timestamp");
		String nonce = request.getParameter("nonce");
		String echostr = request.getParameter("echostr");
		//
		ArrayList<String> list=new ArrayList<String>();
		list.add(nonce);
		list.add(timestamp);
		list.add(AppConfig.WX_SERVER_PRE_TOKEN);
		//将token、timestamp、nonce三个参数进行字典序排序  
		Collections.sort(list,new Comparator<String>() {  
			  
			public int compare(String o1, String o2) {  
				return o1.compareTo(o2);  
			}  
		});
		//将三个参数字符串拼接成一个字符串进行sha1加密  
		String str = list.get(0)+list.get(1)+list.get(2);
		String r = SHA1(str);
		if(signature.equalsIgnoreCase(r.toString().toUpperCase())){
			result = echostr;
			LOG.info("微信服务器身份认证成功");
		} else {
			result = "认证失败";
			StringBuffer sb = new StringBuffer();
			sb.append("signature:" + signature);
			sb.append("，timestamp" + timestamp);
			sb.append("，nonce" + nonce);
			sb.append("，echostr" + echostr);
			LOG.warn("微信服务器身份认证失败，相关信息：" + sb.toString());
		}		
		return result;
	}

	private static final char[] HEX_DIGITS = { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f' };  
	private static String getFormattedText(byte[] bytes) {  
		int len = bytes.length;  
		StringBuilder buf = new StringBuilder(len * 2);  
		// 把密文转换成十六进制的字符串形式  
		for (int j = 0; j < len; j++) {  
			buf.append(HEX_DIGITS[(bytes[j] >> 4) & 0x0f]);  
			buf.append(HEX_DIGITS[bytes[j] & 0x0f]);  
		}  
		return buf.toString();  
	} 
	private String SHA1(String str) {  
		if (str == null) {  
			return null;  
		}  
		try {  
			MessageDigest messageDigest = MessageDigest.getInstance("SHA1");  
			messageDigest.update(str.getBytes());  
			return getFormattedText(messageDigest.digest());  
		} catch (Exception e) {  
			throw new RuntimeException(e);  
		}  
	}
}
