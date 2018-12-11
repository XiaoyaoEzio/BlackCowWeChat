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
    <script type="text/javascript" src="http://mat1.gtimg.com/libs/zepto/1.1.6/zepto.min.js"></script>
    <script type="text/javascript" src="https://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>
    <script type="text/javascript" src="https://res.wx.qq.com/open/libs/weuijs/1.0.0/weui.min.js"></script>
</head>
<body ontouchstart>

<!-- 
        <div class="weui-cell weui-cell_access">
            <div class="weui-cell__bd">
                <p>充电消费</p>
                <p style="font-size: 13px;color: #888888;">2017-03-13 16:34:00</p>
            </div>
            <div class="weui-cell__ft">
            	<p style="font-size: 13px;color: #E64340;">-16.23元</p>
            </div>
        </div>
 -->
            	
    <!-- 包含表格模块 -->
    <jsp:include page="../include/list.jsp"></jsp:include>

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
	    		"url": "/api/charge/wallet!all.do",
	    		"model.recordType": 16,//消费记录
	    		"model.pageIndex": pageIndex,
	    		"model.pageSize": pageSize
	    	},
	    	url:'<%=path%>/spring/proxy',
	    	success:function(data){
	    		if(data != null && data.status == 0){	    			
	    			if(data.allRecords != undefined && data.allRecords != null){
	    				$.each(data.allRecords,function(index, item){
	    					var html = createItem(item);
	    					myList.addItem(html);
	    				});
	    				list.requestFinish(true,data.allRecords.length);
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
		decodeDetailType(record.detailType) +
		"<p style=\"font-size: 13px;color: #888888;\">" + record.recordTime + "</p>" +
		"</div>" +
		"<div class=\"weui-cell__ft\">" +
		"<p style=\"font-size: 13px;color: #E64340;\">" + decodeRechargeStatus(record) + "</p>" +
		"</div>" +
		"</a>" +
		"";
		return item;
	};
	
	//
	function decodeRecordUrl(record){
		return "recordDetail.jsp?tradingLogId="
				+ record.tradingLogId 
				+ "&tradingType=" 
				+ record.tradingType
				+ "&detailType="
				+ record.detailType;
	}
	
	//订单类型
	function decodeDetailType(detailType){
		if(detailType == 1){
			return "<p>充电消费</p>";
		} else if(detailType == 2){
			return "<p>预约消费</p>";
		} else if(detailType == 3){
			return "<p>支付宝充值</p>";
		} else if(detailType == 4){
			return "<p>微信充值</p>";
		} else if(detailType == 5){
			return "<p>后台赠送</p>";
		} else if(detailType == 6){
			return "<p>充值赠送</p>";
		} else if(detailType == 7){
			return "<p>介绍赠送</p>";
		} else if(detailType == 8){
			return "<p>注册赠送</p>";
		} else if(detailType == 10){
			return "<p>停车费</p>";
		} else if(detailType == 16){
			return "<p>退款</p>";
		} else if(detailType == 18){
			return "<p>停车费(捷顺)</p>";
		} else {
			return "<p>未知类型</p>";
		}		
	};
	
	//订单状态
	function decodeRechargeStatus(record){
		if(record.rechargeStatus == 0){
			return "-" + record.money;
		} else if(record.rechargeStatus == 1){
			return "等待支付";
		} else if(record.rechargeStatus == 2){
			return "取消支付";
		} else if(record.rechargeStatus == 3){
			return "订单失效";
		} else {
			return "未知状态";
		}
	};

</script>
</body>
</html>