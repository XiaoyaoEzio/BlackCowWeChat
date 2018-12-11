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
    <title>停车缴费</title>
    <link rel="stylesheet" href="<%=path%>/wx/css/mywx.css">
    <!-- 引入 WeUI -->
    <link rel="stylesheet" href="http://res.wx.qq.com/open/libs/weui/1.1.1/weui.min.css">    
    <script src="http://mat1.gtimg.com/libs/zepto/1.1.6/zepto.min.js"></script>
    <script type="text/javascript" src="https://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>
    <script type="text/javascript" src="https://res.wx.qq.com/open/libs/weuijs/1.0.0/weui.min.js"></script>
</head>
<body ontouchstart>
	<div class="page__bd"> 
        <div class="weui-cells__title">选择支付方式</div>
        <div class="weui-cells weui-cells_radio">
            <label class="weui-cell weui-check__label" for="x11">
                <div class="weui-cell__bd">
                    <p>余额支付
                    	<c:if test="${supportAccountPay == 'true'}" var="res1">
                    	   <span style="color:green;font-size:13px;margin-left:5px;">余额：${myMoney}</span>
                    	</c:if>
                    	<c:if test="${supportAccountPay == 'false'}" var="res2">
                    	   <span style="color:red;font-size:13px;margin-left:5px;">余额：${myMoney} 余额不足</span>
                    	</c:if>
                    </p>
                </div>
                <div class="weui-cell__ft">
                    <input type="radio" class="weui-check" name="radio1" id="x11">
                    <span class="weui-icon-checked"></span>
                </div>
            </label>
            <label class="weui-cell weui-check__label" for="x12">
                <div class="weui-cell__bd">
                    <p>即时支付</p>
                </div>
                <div class="weui-cell__ft">
                    <input type="radio" name="radio1" class="weui-check" id="x12" checked="checked">
                    <span class="weui-icon-checked"></span>
                </div>
            </label>
        </div>
        <br>
        <div class="weui-form-preview">
            <div class="weui-form-preview__hd">
                <label class="weui-form-preview__label">付款金额</label>
                <em class="weui-form-preview__value">¥${money}</em>
            </div>
            <div class="weui-form-preview__bd">
                <div class="weui-form-preview__item">
                    <label class="weui-form-preview__label">商品</label>
                    <span class="weui-form-preview__value">停车缴费</span>
                </div>
                <div class="weui-form-preview__item">
                    <label class="weui-form-preview__label">车牌号</label>
                    <span class="weui-form-preview__value">${carNo}</span>
                </div>
                <div class="weui-form-preview__item">
                    <label class="weui-form-preview__label">入场时间</label>
                    <span class="weui-form-preview__value">${parkingStartTime}</span>
                </div>
                <div class="weui-form-preview__item">
                    <label class="weui-form-preview__label">停车时长</label>
                    <span class="weui-form-preview__value">${parkingTime}</span>
                </div>
                <div class="weui-form-preview__item">
                    <label class="weui-form-preview__label">停车费</label>
                    <span class="weui-form-preview__value">￥${parkingMoney}</span>
                </div>
                <div class="weui-form-preview__item">
                    <label class="weui-form-preview__label">充电优惠</label>
                    <span class="weui-form-preview__value">￥${benefit}</span>
                </div>
                <div class="weui-form-preview__item">
                    <label class="weui-form-preview__label">实际费用</label>
                    <span class="weui-form-preview__value">￥${money}</span>
                </div>
            </div>
            <div class="weui-form-preview__ft">
                <a class="weui-form-preview__btn weui-form-preview__btn_default" href="<%=path%>/jsp/user.jsp">取消</a>
                <button id="bt_submit" type="submit" class="weui-form-preview__btn weui-form-preview__btn_primary" href="javascript:pay();">支付</button>
            </div>
        </div>
        <div class="weui-cells__tips">注意：</div>
        <div class="weui-cells__tips">1.实际费用=停车费-充电优惠，充电优惠指您充电后系统赠送给您的停车补助费用。</div>
        <div class="weui-cells__tips">2.支付成功后，<em style="color:red">请在半小时内离开停车场</em>，超时后出场必须再次请求缴费并支付差额费用。</div>
    </div>

<script type="text/javascript">
	
	var loading;
	//当前是否支持余额支付（由服务器直接赋值）
	var supportAccountPay = ${supportAccountPay};
	//1:即时支付；0：余额支付	
	var payMethod = 1;
	
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
		
	//微信支付
	function wxPay(data){		
		wx.chooseWXPay({
			timestamp: data.timestamp, // 支付签名时间戳，注意微信jssdk中的所有使用timestamp字段均为小写。但最新版的支付后台生成签名使用的timeStamp字段名需大写其中的S字符
		    nonceStr: data.noncestr, // 支付签名随机串，不长于 32 位
		    'package': "prepay_id=" + data.prepayid, // 统一支付接口返回的prepay_id参数值，提交格式如：prepay_id=***）
		    signType: 'MD5', // 签名方式，默认为'SHA1'，使用新版支付需传入'MD5'
		    paySign: data.sign, // 支付签名
		    success: function (res) {
		    	//通知 服务器 支付结果（仅供参考）
		    	notifyPayResult(data.tradingNo,true);		       
		    },
		    complete: function(res){
		    	loading.hide();	
		    },
		    error: function(res){		    	
		    	weui.topTips(res, 3000);
		    }
		});		
	}
	
	//根据客户的结果通知 服务器本次支付结果（客户端结果仅供参考）
	function notifyPayResult(tradingSn,result){
		loading = weui.loading('支付成功，执行后续操作', {
	     	className: 'custom-classname'
		});
		$.ajax({
	    	type:"get",
	    	dataType:"json",
	    	cache:false,
	    	data: {
	    		"url": "/api/jslife/createorderno!notice.do",
	    		"tradingSn":tradingSn,//交易流水号
	    		"hasPaid":result //支付结果
	    	},
	    	url:'<%=path%>/spring/proxy',
	    	complete:function(){
	    		loading.hide();	
	    		//不论是否成功，都跳转
	    		window.location.href = "<%=path%>/spring/wx/result/success";
	    	}
	    });
	}
	
	function requestWxPayInfo(){
		loading = weui.loading('请求中', {
	     	className: 'custom-classname'
		});
		
		var param = {
			"url": "/api/pay/micropay.do",
    		"model.rechargeValue": '${moneyToWx}', //金额，单位：分
    		"model.tradeType": 2,//公众号支付-停车费
    		"model.openId": '${openid}'	
		};
		$.ajax({
	    	type:"get",
	    	dataType:"json",
	    	cache:false,
	    	data: param,
	    	url:'<%=path%>/spring/proxy',
	    	success:function(data){	    		
	    		if(data != null && data.status == 0){	    			
	    			wxPay(data);
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
	
	//余额支付
	function requestAccountPayInfo(){
		loading = weui.loading('请求中', {
	     	className: 'custom-classname'
		});
		var param = {
			"url": "/api/jslife/payself.do",
    		"payFee": '${moneyToWx}' //金额，单位：分
		};
		$.ajax({
	    	type:"get",
	    	dataType:"json",
	    	cache:false,
	    	data: param,
	    	url:'<%=path%>/spring/proxy',
	    	success:function(data){	    		
	    		if(data != null && data.status == 0){	    			
	    			//支付成功
		    		window.location.href = "<%=path%>/spring/wx/result/success";
	    		} else {
	    			weui.topTips(data.message, 2000);
	    		}
	    	},
	    	error:function(data){	    		
	    		weui.topTips('请求失败！', 2000);
	    	},
	    	complete:function(xhr, options){
	    		loading.hide();	
	    	}
	    });		
	}
		
	$(function(){
		
		if(supportAccountPay){
			//支持的话默认选择 余额支付
			var x11 = $("#x11");
			x11.attr('checked','true');
			//选择余额支付
			payMethod = 0;
		} else {
			//不支持的话禁用余额支付
			var x11 = $("#x11");
			x11.attr("disabled","true");
			//选择即时支付
			payMethod = 1;
			var x12 = $("#x12");
			x12.attr('checked','true');
		}
		
		//增加支付方式 监听事件
		$("#x11,#x12").on("change",function() { 
			if(this.id == "x11"){
				payMethod = 0;
			} else if(this.id == "x12"){
				payMethod = 1;
			}
		}); 
		
		//支付确认监听事件
		$("#bt_submit").on("click",function(){
			//根据支付方式调用不同的接口
			if(payMethod == 0){
				//余额支付
				requestAccountPayInfo();
			} else {
				//即时支付
				requestWxPayInfo();	
			}
		});
	});
	
</script>

</body>
</html>