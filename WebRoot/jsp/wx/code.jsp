<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.idbk.chargestation.wechat.*" %>	
<%
	String path = request.getContextPath();
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
	<meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1,user-scalable=0">
    <title>准备微信绑定</title>
    <script type="text/javascript" src="http://mat1.gtimg.com/libs/zepto/1.1.6/zepto.min.js"></script>
</head>
<body>
<script type="text/javascript">

	$(function(){			
		wxOauth2();		
	});
	
	function wxOauth2(){		
		var appid = '<%=AppConfig.APP_ID%>';//微信开放平台appid
		//state保存用户名和充值金额
    	var state = "nothing";;
    	var redirect_uri = encodeURIComponent("<%=AppConfig.DOMAIN%>/ChargingStation-WeChat/spring/wx/bind_openid");
    	var url = "https://open.weixin.qq.com/connect/oauth2/authorize?appid=" + appid +"&redirect_uri=" + redirect_uri;
    	url += "&response_type=code&scope=snsapi_base&state="+state+"#wechat_redirect";
    	window.location.href = url;
	}
		
</script>
</body>
</html>