<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.idbk.chargestation.wechat.*" %>	
<%
	String path = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1,user-scalable=0">
    <title>充值</title>
    <link rel="stylesheet" href="<%=path%>/wx/css/mywx.css">
    <!-- 引入 WeUI -->
    <link rel="stylesheet" href="http://res.wx.qq.com/open/libs/weui/1.1.1/weui.min.css">    
    <script type="text/javascript" src="http://mat1.gtimg.com/libs/zepto/1.1.6/zepto.min.js"></script>
    <script type="text/javascript" src="https://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>
    <script type="text/javascript" src="https://res.wx.qq.com/open/libs/weuijs/1.0.0/weui.min.js"></script>
</head>
<body ontouchstart>

	<div class="weui-cells__title">选择金额</div>
	<div class="weui-cells weui-cells_radio">
        <label class="weui-cell weui-check__label" for="x11">
            <div class="weui-cell__bd">
                <p>10元</p>
            </div>
            <div class="weui-cell__ft">
                <input type="radio" class="weui-check" name="radio1" id="x11">
                <span class="weui-icon-checked"></span>
            </div>
        </label>
        <label class="weui-cell weui-check__label" for="x12">
            <div class="weui-cell__bd">
                <p>20元</p>
            </div>
            <div class="weui-cell__ft">
                <input type="radio" name="radio1" class="weui-check" id="x12" checked="checked">
                <span class="weui-icon-checked"></span>
            </div>
        </label>
        <label class="weui-cell weui-check__label" for="x13">
            <div class="weui-cell__bd">
                <p>30元</p>
            </div>
            <div class="weui-cell__ft">
                <input type="radio" name="radio1" class="weui-check" id="x13">
                <span class="weui-icon-checked"></span>
            </div>
        </label>
        <label class="weui-cell weui-check__label" for="x14">
            <div class="weui-cell__bd">
                <p>50元</p>
            </div>
            <div class="weui-cell__ft">
                <input type="radio" name="radio1" class="weui-check" id="x14">
                <span class="weui-icon-checked"></span>
            </div>
        </label>
        <%--<label class="weui-cell weui-check__label" for="x15">
            <div class="weui-cell__bd">
                <p>自定义</p>
            </div>
            <div class="weui-cell__ft">
                <input type="radio" name="radio1" class="weui-check" id="x15">
                <span class="weui-icon-checked"></span>
            </div>
        </label>  --%>
    </div>
    
    <%--<div class="weui-cells__title">充值金额（元）</div>
    <div class="weui-cells">
        <div class="weui-cell">
            <div class="weui-cell__bd">
                <input id="input_money" class="weui-input" type="number" placeholder="实际金额" value="20" maxlength="7" disabled="disabled">
            </div>
        </div>
    </div>--%>
    <input id="input_money" class="weui-input" type="hidden" placeholder="实际金额" value="20" maxlength="7"
           disabled="disabled">
    
    <div class="weui-btn-area">
    	<a href="javascript:;" class="weui-btn weui-btn_primary">微信充值</a>
    </div>

<script type="text/javascript">

	<%
		WxConfig wxConfig = WeChat.getWxConfig(request); 		
	%>		
	wx.config({
		debug: false,
		appId: '<%=AppConfig.APP_ID %>',
		timestamp: <%=wxConfig.timestamp %>,
		nonceStr: '<%=wxConfig.nonceStr %>',
		signature: '<%=wxConfig.signature %>',
		jsApiList: [
			//所有要调用的 API 都要加到这个列表中
			'closeWindow',
			'hideAllNonBaseMenuItem'
		  ]
	});	

	wx.ready(function () {
		//隐藏 浏览器打开，防止接口泄漏
		wx.hideAllNonBaseMenuItem();
	});

	var money = [10,20,30,50,""];

	$(function(){			
		$('input[type=radio]').on('change',function(e){
			var radios = $('input[type=radio]');
			$.each(radios,function(index,value){
				if($(value).is(':checked')){
					var input = $("#input_money"); 
					input.val(money[index]);
					if(index==4){
						input.removeAttr("disabled");
						input.focus();
					} else {
						input.attr("disabled","true");
					}
					return false;
				}
			});			
		});
		
        $('.weui-btn.weui-btn_primary').on('click',function(e){        	
        	var val = $("#input_money").val();
        	if(checkInput(val)){
        		wxPay(val);
        	}
        });
	});
	
	function checkInput(val){
		if(val == null || val.length < 1 
				|| val.length > 7 ){
			weui.topTips('金额必须为0.01-9999元', 2000);
			return false;
		}
		var i = parseFloat(val);
		if(isNaN(i)){
			weui.topTips('金额必须为0.01-9999元', 2000);
			return false;
		}
		if(i < 0.01 || i > 9999){
			weui.topTips('金额必须为1-9999元', 2000);
			return false;
		}
		return true;
	}
	
	function wxPay(val){
		var money = val;
		var appid = '<%=AppConfig.APP_ID%>';//微信开放平台appid
		//state保存用户名和充值金额
    	var state = money + "|-1";;
    	var redirect_uri = encodeURIComponent("<%=AppConfig.DOMAIN%><%=path%>/spring/wx/prepay");
    	var url = "https://open.weixin.qq.com/connect/oauth2/authorize?appid=" + appid +"&redirect_uri=" + redirect_uri;
    	url += "&response_type=code&scope=snsapi_base&state="+state+"#wechat_redirect";
    //	LOG.info("wxPay url:" + url);
    	window.location.href = url;
	}
		
</script>
</body>
</html>