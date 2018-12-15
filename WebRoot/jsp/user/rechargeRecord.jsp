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
    <title>消费记录</title>
    <link rel="stylesheet" href="../../wx/css/mywx.css">
    <!-- 引入 WeUI -->
    <link rel="stylesheet" href="http://res.wx.qq.com/open/libs/weui/1.1.1/weui.min.css">    
    <script type="text/javascript" src=http://mat1.gtimg.com/libs/zepto/1.1.6/zepto.min.js></script>
    <script type="text/javascript" src="https://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>
    <script type="text/javascript" src="https://res.wx.qq.com/open/libs/weuijs/1.0.0/weui.min.js"></script>
</head>
<body ontouchstart>

    <!-- 子项模板 -->
    <!-- 
        <a class="weui-cell weui-cell_access" href="#">
            <div class="weui-cell__bd">
                <p>微信充值</p>
                <p style="font-size: 13px;color: #888888;">2017-03-13 16:34:00</p>
            </div>
            <div class="weui-cell__ft">
            	<p style="font-size: 13px;color: #0BB20C;">+50.00元</p>
            </div>
        </a>
     -->
    
    <!-- 包含表格模块 -->
    <%--<jsp:include page="../include/list.jsp"></jsp:include>--%>
    <%@ include file="../include/list.jsp"%>
<script type="text/javascript">
	
	$(function(){		
		myList
		.setDataInvoker(requestData)
		.begin();
	});
	
	function requestData(pageIndex,pageSize){
		var list = this;
		$.ajax({
	    	type:"get",
	    	dataType:"json",
	    	cache:false,
	    	data: {
	    		"url": "min/charge/record/all",
	    		"pageIndex": pageIndex,
	    		"pageSize": pageSize
	    	},
	    	url:'<%=path%>/spring/proxy',
	    	success:function(data){
	    		if(data != null && data.status == 0){	    			
	    			if(data.data.records != undefined && data.data.records != null){
	    				$.each(data.data.records,function(index, item){
	    					var html = createItem(item);
	    					myList.addItem(html);
	    				});
	    				list.requestFinish(true,data.data.records.length);
	    			}
	    		} else {
	    			list.requestFinish(false);
	    		}
	    	},
	    	error:function(data){
	    		list.requestFinish(false);
	    	}
	    });		
	}
	
	function createItem(record){
		var item = "" +
		"<a class=\"weui-cell weui-cell_access\" href=\"" + decodeRecordUrl(record) +"\">" +
		"<div class=\"weui-cell__bd\">" +
		decodeDetailType(record.tradeType) +
		"<p style=\"font-size: 13px;color: #888888;\">" + record.tradeTime + "</p>" +
		"</div>" +
		"<div class=\"weui-cell__ft\">" +
		"<p style=\"font-size: 13px;color: #0BB20C;\">" + decodeRechargeStatus(record) + "</p>" +
		"</div>" +
		"</a>" +
		"";
		return item;
	};
	
	//
	function decodeRecordUrl(record){
		return "recordDetail.jsp?tradingLogId="
				+ record.id 
				+ "&tradeType=" 
				+ record.tradeType;
	}
	
	//订单类型
	function decodeDetailType(detailType){
		if(detailType == 1){
			return "<p>充电消费</p>";
		} else if(detailType == 2){
			return "<p>微信充值</p>";
		} else if(detailType == 3){
			return "<p>支付宝充值</p>";
		} else if(detailType == 8){
			return "<p>赠送</p>";
		} else if (detailType == 16) {
			return "<p>退款</p>";
		} else {
			return "<p>未知类型</p>";
		}		
	};
	
	//订单状态
	function decodeRechargeStatus(record){
		if(record.tradeStatusEnum == 0){
			if (record.tradeType == 1) {
				return "-" +  Number(record.totalFee/100).toFixed(2);
			} else {
				return "+" +  Number(record.totalFee/100).toFixed(2);
			}
			
			
		} else if(record.tradeStatusEnum == 1){
			return "等待支付";
		} else if(record.tradeStatusEnum == 2){
			return "取消支付";
		} else if(record.tradeStatusEnum == 3){
			return "订单失效";
		} else {
			return "未知状态";
		}
	};
	
</script>
</body>
</html>


