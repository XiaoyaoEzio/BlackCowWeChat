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
    <title>操作成功</title>
    <!-- 引入 WeUI -->
    <link rel="stylesheet" href="http://res.wx.qq.com/open/libs/weui/1.1.1/weui.min.css">    
    <script src="http://mat1.gtimg.com/libs/zepto/1.1.6/zepto.min.js"></script>
    <script type="text/javascript" src="https://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>
    <script type="text/javascript" src="https://res.wx.qq.com/open/libs/weuijs/1.0.0/weui.min.js"></script>
</head>
<body ontouchstart>

<div class="page msg_success js_show">
    <div class="weui-msg">
        <div class="weui-msg__icon-area"><i class="weui-icon-success weui-icon_msg"></i></div>
        <div class="weui-msg__text-area">
            <h2 class="weui-msg__title">操作成功</h2>
            <p class="weui-msg__desc">${desc}</p>
        </div>
        <div class="weui-msg__opr-area">
            <p class="weui-btn-area">
                <a href="javascript:closeWxWindow();" class="weui-btn weui-btn_primary">确定</a>
            </p>
        </div>
        <div class="weui-msg__extra-area">
            <div class="weui-footer">
                <p class="weui-footer__text">Copyright © 2017 <%=AppConfig.COMPANY %></p>
            </div>
        </div>
    </div>
</div>

<script type="text/javascript">
	wx.config({
	    debug: false,
	    appId: '<%=AppConfig.APP_ID %>',
	    timestamp: ${timestamp},
	    nonceStr: '${nonceStr}',
	    signature: '${signature}',
	    jsApiList: [
			//所有要调用的 API 都要加到这个列表中
			'closeWindow'
	      ]
	});	
	
	function closeWxWindow(){
		wx.closeWindow();
	}	
</script>
</body>
</html>