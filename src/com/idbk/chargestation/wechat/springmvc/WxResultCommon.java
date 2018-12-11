package com.idbk.chargestation.wechat.springmvc;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

/**
 * 显示操作结果的视图
 * @author lupc
 *
 */
@Controller
@RequestMapping("/wx/result")
public class WxResultCommon {

	private static final Logger LOG = Logger.getLogger(WxResultCommon.class);
	
	private static final String DEFAULT_DESC = "请点击确定返回个人主页！";
	
	private static final String DEFAULT_REDIRECT_URL = "/jsp/user.jsp";
	
	@RequestMapping("/success")
	public String showResultSuccess(
			ModelMap map,
			@RequestParam(value="desc",required=false,defaultValue=DEFAULT_DESC) String desc,
			@RequestParam(value="redirect_uri",required=false,defaultValue=DEFAULT_REDIRECT_URL) String redirectURL
			){
		map.put("desc", desc);
		map.put("redirectURL", redirectURL);
		return "common/success";
	}
	
	@RequestMapping("/failed")
	public String showResultFailed(
			ModelMap map,
			@RequestParam(value="desc",required=false,defaultValue=DEFAULT_DESC) String desc,
			@RequestParam(value="redirect_uri",required=false,defaultValue=DEFAULT_REDIRECT_URL) String redirectURL
			){
		map.put("desc", desc);
		map.put("redirectURL", redirectURL);
		return "common/failed";
	}
	
}
