package com.idbk.chargestation.wechat.springmvc;

import java.math.RoundingMode;
import java.text.DecimalFormat;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.idbk.chargestation.wechat.WeChat;
import com.idbk.chargestation.wechat.WxConfig;

/**
 * 微信充值
 * @author lupc
 *
 */
@Controller
@RequestMapping("/wx")
public class WxPay extends BaseControler {

	private static final Logger LOG = Logger.getLogger(WxPay.class);
	
		
	/**
	 * 微信支付之前的openid获取
	 * @param req
	 * @param code
	 * @param state
	 * @return
	 */
	@RequestMapping("/prepay")
	public String prepay(
			HttpServletRequest req,
			ModelMap map,
			@RequestParam(value="code") String code,
			@RequestParam(value="state") String state){
		if(code == null || state == null){
			//表示获取失败
			return "redirect:/jsp/wx/faild.jsp";
		}
		//1.从state中获取参数
		
		//2.拉取access_token
		JsonWxAuth2AccessToken token = getAccessToken(code);		
		if(token == null){
			return "redirect:/jsp/wx/faild.jsp";
		} else {
			LOG.debug("openId:" + token.openId);
			
			String[] ss = state.split("\\|");
			MyMonety money = new MyMonety(ss[0]);
			map.addAttribute("money", money.moneyForDisplay);//充值金额-显示		
			map.addAttribute("realMoney", money.moneyForCharge);//充值金额-实际
			map.addAttribute("tradingNo", ss[1]);//交易流水号
			map.addAttribute("openid", token.openId);
			//根据URL进行签名
			WxConfig wxConfig = WeChat.getWxConfig(req); 
			map.addAttribute("timestamp", wxConfig.timestamp);
			map.addAttribute("nonceStr", wxConfig.nonceStr);
			map.addAttribute("signature", wxConfig.signature);
			return "wx/auth";
		}
	}
			
	public static class MyMonety {
		
		/**
		 * 显示用的金额，以元为单位，最小0.01元
		 */
		public String moneyForDisplay;
		
		/**
		 * 实际充值金额，以分为单位，最小1分
		 */
		public int moneyForCharge;
		
		/**
		 * 将用户输入转化为内部值，如果用户输入非法，则默认为0.01元
		 * <p>用户输入格式必须满足</p>
		 * <ul>
		 * <li>最大9999，最小0.01</li>
		 * <li>最多只能有2个小数位(如果小数位数大于2，则直接截取，而不是四舍五入)</li>
		 * </ul>
		 * @param money 用户输入的金额，以元为单位，最小0.01元
		 */
		public MyMonety(String money){
			//默认值
			moneyForDisplay = "0.01";
			moneyForCharge = 1;
			try {
				double t = Double.parseDouble(money);
				if(t >= 0.01 && t <= 9999){
					//保留2位小数（截取而不是四舍五入）
					DecimalFormat df = new DecimalFormat("###0.00");
					df.setRoundingMode(RoundingMode.DOWN);
					moneyForDisplay = df.format(t);
					moneyForCharge = (int)(t * 100);
				}				
			} catch (Exception e) {
				
			}
		}
				
	}
	
}
