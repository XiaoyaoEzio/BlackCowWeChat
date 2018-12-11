<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.idbk.chargestation.wechat.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>	
<%
	String path = request.getContextPath();
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1,user-scalable=0">
    <title>充值确认</title>
    <link rel="stylesheet" href="<%=path%>/include/css/mywx.css">
    <!-- 引入 WeUI -->
    <link rel="stylesheet" href="http://res.wx.qq.com/open/libs/weui/1.1.1/weui.min.css">    
    <script type="text/javascript" src="http://mat1.gtimg.com/libs/zepto/1.1.6/zepto.js"></script>
    <script type="text/javascript" src="https://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>
    <script type="text/javascript" src="https://res.wx.qq.com/open/libs/weuijs/1.0.0/weui.min.js"></script>
</head>
<body ontouchstart>

    <div class="page__bd">
        <br>
        <div class="weui-form-preview">
            <div class="weui-form-preview__hd">
                <label class="weui-form-preview__label">充值金额</label>
                <em class="weui-form-preview__value">¥${money}</em>
            </div>
            <div class="weui-form-preview__bd">
                <div class="weui-form-preview__item">
                    <label class="weui-form-preview__label">商品</label>
                    <span class="weui-form-preview__value">预存充电费</span>
                </div>
                <div class="weui-form-preview__item">
                    <label class="weui-form-preview__label">收款方</label>
                    <span class="weui-form-preview__value"><%=AppConfig.COMPANY_FULL_NAME%></span>
                </div>
            </div>
            <div class="weui-form-preview__ft">
                <a class="weui-form-preview__btn weui-form-preview__btn_default" href="javascript:history.back();">取消</a>
                <button type="submit" class="weui-form-preview__btn weui-form-preview__btn_primary" href="javascript:">确认</button>
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
			'chooseWXPay',
			'hideAllNonBaseMenuItem'
	      ]
	});	
	
	wx.ready(function () {
		//隐藏 浏览器打开，防止接口泄漏
		wx.hideAllNonBaseMenuItem();
	});

	wx.error(function(res){
		alert(JSON.stringify(res));
	}); 
	
	var loading;

	function wxPay(data){		
		wx.chooseWXPay({
			timestamp: data.timestamp, // 支付签名时间戳，注意微信jssdk中的所有使用timestamp字段均为小写。但最新版的支付后台生成签名使用的timeStamp字段名需大写其中的S字符
		    nonceStr: data.noncestr, // 支付签名随机串，不长于 32 位
		    'package': "prepay_id=" + data.prepayid, // 统一支付接口返回的prepay_id参数值，提交格式如：prepay_id=***）
		    signType: 'MD5', // 签名方式，默认为'SHA1'，使用新版支付需传入'MD5'
		    paySign: data.sign, // 支付签名
		    success: function (res) {
		        // 支付成功后的回调函数
		        weui.toast('操作成功', {
			         duration: 2000,
			         className: 'custom-classname',
			         callback: function(){ 
			        	 //history.back();
			        	 window.location.replace("<%=path%>/jsp/user.jsp");
			         }
			    });
		    },
		    complete: function(res){
		    		loading.hide();	
		    },
		    error: function(res){		    	
		    	weui.topTips(res, 3000);
		    	loading.hide();
		    }
		});		
	}
	
	$(function(){		
		//weui.topTips("测试版本仅白名单用户支持充值", 2000);
		$('button[type=submit]').on('click',function(e){
			requestWxPayInfo();
		});
	});
	
	function requestWxPayInfo(){
		loading = weui.loading('请求中', {
	     	className: 'custom-classname'
		});
		
		var param = {
			"url": "/min/micropay/pay",
    		"rechargeFee": '${realMoney}', //金额，单位：分
    		"openId": '${openid}'	
		};
		if(${tradingNo} > 0){
			param["tradingSn"] = '${tradingNo}';
		}	
		$.ajax({
	    	type:"get",
	    	dataType:"json",
	    	cache:false,
	    	data: param,
	    	url:'<%=path%>/spring/proxy',
	    	success:function(data){	    		
	    		if(data != null && data.status == 0){	    			
	    			wxPay(data.data);
	    		} else {
	    			loading.hide();	
	    			weui.topTips(data.message, 2000);
	    		}
	    	},
	    	error:function(data){
	    		loading.hide();	
	    		weui.topTips('请求失败！', 2000);
	    	}
	    });
	}	

</script>
</body>
</html>