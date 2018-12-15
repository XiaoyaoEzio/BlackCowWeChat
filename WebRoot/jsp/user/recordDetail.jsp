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
    <title>记录详情</title>
    <link rel="stylesheet" href="../../wx/css/mywx.css">
    <!-- 引入 WeUI -->
    <link rel="stylesheet" href="http://res.wx.qq.com/open/libs/weui/1.1.1/weui.min.css">    
    <script type="text/javascript" src="http://mat1.gtimg.com/libs/zepto/1.1.6/zepto.min.js"></script>
    <script type="text/javascript" src="https://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>
    <script type="text/javascript" src="https://res.wx.qq.com/open/libs/weuijs/1.0.0/weui.min.js"></script>
</head>
<body ontouchstart>

    <div class="page__bd">
              
    </div>        	 
	<div class="weui-cells__tips">系统验证支付可能会有延时，如果你已经支付，则继续支付会失败，不会让你重复支付。</div>
<script type="text/javascript">

	var tradingLogId = <%=request.getParameter("tradingLogId")%>;
	var tradingType = <%=request.getParameter("tradeType")%>;
	var tradingNo = -1;//交易流水号
	
	var titles = ["未定义",
	              "充电消费",
	              "微信充值"];
	var subTtitles = ["未定义",
	              "充电消费","微信充值"
	             ];
	var rechargeStatus = ["完成","等待支付","取消支付","订单失效"];
	
	var loading;
	
	$(function(){
		loading = weui.loading('数据加载中', {
		    className: 'custom-classname'
		});
		
		$.ajax({
        	type:"get",
        	dataType:"json",
        	cache:false,
        	data: {
        		"url":getURL(),
        		"id": tradingLogId,
        		"tradeType": tradingType
        	},
        	url:'<%=path%>/spring/proxy',
        	success:function(data){
        		if(data != null && data.status == 0){
        			tradingNo = data.tradingNo;
        			money = data.data.money;
        			refreshView(data.data);
        		}
        	},
        	error:function(){
        		
        	},
        	complete:function(){
        		loading.hide(); 
        	}
        });
	});
	
	function refreshView(data){
		switch (data.tradeType) {
		case 1://充电消费
			var p = createParent1(data);
			d(p,data);
			break;
		case 2:
			//这里还区分
			if(data.tradeStatusEnum == 1){
				//等待支付
				var p = createParent2(data);
				b(p,data);
			} else {
				//取消支付、交易完成、订单失效
				var p = createParent1(data);
				a(p,data);
			}
		default:
			break;
		}
	}
	
	//根据记录类型 去不同的地址请求数据
	function getURL(){
		var url = "#";
		if (tradingType == 1) {//消费
			url = "min/charge/record/comsume";
		} 
		if (tradingType == 2) {//充值
			url = "min/charge/record/recharge";
		}
		return url;
	}
	
	//充值
	function a(parent,data){
		var contain = $(parent).find('.weui-form-preview__bd');
		contain.append(createItem("交易流水号",data.tradingSn));
		contain.append(createItem("交易时间",data.tradeTime));
		contain.append(createItem("交易类型",titles[data.tradeType]));
		contain.append(createItem("交易状态",rechargeStatus[data.tradeStatusEnum]));
	}
	
	//充值-等待支付
	function b(parent,data){
		var contain = $(parent).find('.weui-form-preview__bd');
		contain.append(createItem("交易流水号",data.tradingSn));
		contain.append(createItem("交易时间",data.recordTime));
		contain.append(createItem("交易类型",titles[data.tradeType]));
		contain.append(createItem("交易状态",rechargeStatus[data.tradeStatusEnum]));
	}
	

	//退款金额
	function cc(parent,data){
		var contain = $(parent).find('.weui-form-preview__bd');
		contain.append(createItem("交易流水号",data.tradingSn));
		contain.append(createItem("交易时间",data.recordTime));
		contain.append(createItem("交易类型",titles[data.tradeType]));
		contain.append(createItem("交易状态",rechargeStatus[data.tradeStatusEnum]));
	}
	
	//充电消费
	function d(parent,data){
		var contain = $(parent).find('.weui-form-preview__bd');
		contain.append(createItem("交易流水号",data.tradingSn));
		contain.append(createItem("设备名",data.deviceName));
		contain.append(createItem("设备序号","#" + data.deviceSn));
		var chargeTime = data.chargeTime;
		if (chargeTime < 1) {
		    chargeTime = "不足 1 ";
        }
		contain.append(createItem("充电时长",chargeTime + "分钟"));
		contain.append(createItem("充电开始",data.startTime));
		contain.append(createItem("充电结束",data.stopTime));
		contain.append(createItem("通道",data.path + "口"));
		contain.append(createItem("消费金额",(data.totalFee / 100).toFixed(2) + "元"));
		contain.append(createItem("交易状态", rechargeStatus[data.tradeStatusEnum]));			
	}
	
	function createParent1(data){
		var html = ""
		    + "<div class=\"weui-form-preview\">"
		    +    "<div class=\"weui-form-preview__hd\">"
		    +        "<label class=\"weui-form-preview__label\">"+ subTtitles[data.tradeType] +"</label>"
		    +        "<em class=\"weui-form-preview__value\">¥" + (data.totalFee / 100).toFixed(2) + "</em>"
		    +    "</div>"
		    +    "<div class=\"weui-form-preview__bd\">"
		    +    "</div>"
		    +    "<div class=\"weui-form-preview__ft\">"
		    +		 "<a class=\"weui-form-preview__btn weui-form-preview__btn_primary\" href=\"javascript:history.back();\">确定</a>"
		    +    "</div>"
		    + "</div>"
		    + "";		
		return $('.page__bd').html(html);	
	}
	
	function createParent2(data){
		var html = ""
		    + "<div class=\"weui-form-preview\">"
		    +    "<div class=\"weui-form-preview__hd\">"
		    +        "<label class=\"weui-form-preview__label\">"+ subTtitles[data.tradeType] +"</label>"
		    +        "<em class=\"weui-form-preview__value\">¥" + (data.totalFee / 100).toFixed(2) + "</em>"
		    +    "</div>"
		    +    "<div class=\"weui-form-preview__bd\">"
		    +    "</div>"
		    +    "<div class=\"weui-form-preview__ft\">"
		    +        "<a class=\"weui-form-preview__btn weui-form-preview__btn_default\" href=\"javascript:cancelPay();\">取消支付</a>"
		    +        "<a class=\"weui-form-preview__btn weui-form-preview__btn_primary\" href=\"javascript:continuePay();\">继续支付</a>"
		    +    "</div>"
		    + "</div>"
		    + "";
		return $('.page__bd').html(html);
	}
	
	function createItem(name,value){
        var html = ""
        + "<div class=\"weui-form-preview__item\">"
        + 	"<label class=\"weui-form-preview__label\">" + name + "</label>"
        + 	"<span class=\"weui-form-preview__value\">" + value + "</span>"
        + "</div>"
    	+ "";
        return html;
	}
	
	function cancelPay(){
		loading = weui.loading('处理中', {
		    className: 'custom-classname'
		});		
		$.ajax({
        	type:"get",
        	dataType:"json",
        	cache:false,
        	data: {
        		"url":"/api/pay/alipay!revoke.do",
        		"model.tradingNo": tradingNo
        	},
        	url:'<%=path%>/spring/proxy',
        	success:function(data){
        		if(data != null && data.status == 0){        		
        			weui.toast('操作成功', {
     			         duration: 1500,
     			         className: 'custom-classname',
     			         callback: function(){ 
     			        	 history.back();
     			         }
 			    	});
        		} else {
        			weui.topTips(data.message, 1500);
        		}
        	},
        	error:function(){
        		weui.topTips('请求失败', 2000);
        	},
        	complete:function(){
        		loading.hide(); 
        	}
        });
	}
	
	function continuePay(){
		wxPay(money);		
	};
	
	function wxPay(val){
		var appid = '<%=AppConfig.APP_ID%>';//微信开放平台appid
		//state保存用户名和充值金额
    	var state = val + "|" + tradingNo;
    	var redirect_uri = encodeURIComponent("<%=AppConfig.DOMAIN%><%=path%>/spring/wx/prepay");
    	var url = "https://open.weixin.qq.com/connect/oauth2/authorize?appid=" + appid +"&redirect_uri=" + redirect_uri;
    	url += "&response_type=code&scope=snsapi_base&state="+state+"#wechat_redirect";
    	window.location.href = url;
	}
		
</script>
</body>
</html>