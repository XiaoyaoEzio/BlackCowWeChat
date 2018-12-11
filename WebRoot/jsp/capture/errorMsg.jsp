<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.idbk.chargestation.wechat.*"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html>

<html lang="zh-cmn-Hans">
<head>
    <meta charset="utf-8">
     <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width,initial-scale=1,user-scalable=0">
    <title>操作失败页面</title>
    <script type="text/javascript" src="http://mat1.gtimg.com/libs/zepto/1.1.6/zepto.js"></script>
    <link rel="stylesheet" type="text/css" href="https://res.wx.qq.com/open/libs/weui/1.1.1/weui.min.css">
    <script type="text/javascript" src='https://res.wx.qq.com/open/js/jweixin-1.0.0.js'></script>
    <script type="text/javascript" src='https://res.wx.qq.com/open/libs/weuijs/1.0.0/weui.min.js'></script>
    <script src="<%=path%>/wx/js/wxBase.js"></script>
    <link rel="stylesheet" type="text/css" href="<%=path%>/wx/css/style.css?ver=<%=AppConfig.CSS_WX_STYLE%>">
</head>
<body ontouchstart>
<!-- 微信的错误提示  -->
<div class="page">
    <div class="weui-msg">
        <div class="weui-msg__icon-area"><i class="weui-icon-warn weui-icon_msg"></i></div>
        <div class="weui-msg__text-area">
            <h2 class="weui-msg__title" id="textValue">操作失败</h2>
            <p class="weui-msg__desc"></p>
        </div>
        <div class="weui-msg__opr-area">
            <p class="weui-btn-area">
                <a class="weui-btn weui-btn_primary" onclick="applyClick()">确定</a>
            </p>
        </div>
     </div>
</div>

</body>
</html>
<script type="text/javascript">
    var dataStr = window.localStorage.getItem("EAST_errorMsg");
    dataStr = JSON.parse(dataStr);
    $("#textValue").html(dataStr.msg);
    if(dataStr.link == 'false'){
    	$("#linkedTag").hide();
    }
    
    function applyClick(){
    	 if (dataStr.hasOwnProperty("pop")) {
    		history.back();
    	} else {
        	location.href = dataStr.url;
    	}
    		
    
    	
    }
    

</script>