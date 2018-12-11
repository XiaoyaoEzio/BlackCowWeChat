<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.idbk.chargestation.wechat.*" %>	
<%
	String path = request.getContextPath();
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE html>
<html lang="zh-CH">
<head>
	<meta charset="UTF-8">
	<title>充电中</title>
	<meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <!-- Tell the browser to be responsive to screen width -->
    <meta id="viewport" name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no" /> 
 
    <script type="text/javascript" src="http://mat1.gtimg.com/libs/zepto/1.1.6/zepto.min.js"></script>
    <!-- 引入 WeUI -->
    <link rel="stylesheet" href="http://res.wx.qq.com/open/libs/weui/1.1.1/weui.min.css">    
    <script type="text/javascript" src="https://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>
	<script src="<%=path%>/wx/js/wxBase.js"></script>
    <script type="text/javascript" src="https://res.wx.qq.com/open/libs/weuijs/1.0.0/weui.min.js"></script>	
    <style type="text/css">
    	.order-btn{width: 80%;}
    </style>
</head>
<body ontouchstart>
	<div class="bodyContent">
        	
	</div>	  
     <div id="costDialog" class="dialog1" style="display: none;">
	    <div class="weui-mask"></div>
	    <div class="weui-dialog">
		  <div class="weui-dialog__hd"><strong class="weui-dialog__title" id="tradSn">充电消费</strong></div>      
	       <div class="weui-form-preview">
		    <div class="weui-form-preview__hd">
		        <label class="weui-form-preview__label">费用</label>
		        <em class="weui-form-preview__value" id="totalCost"></em>
		    </div>
		    <div class="weui-form-preview__bd" id="costTable">
		    </div>
		    <div class="weui-form-preview__ft">
		        <a class="weui-form-preview__btn weui-form-preview__btn_primary" href="javascript:" onclick="closeCostBill()">确定</a>
		    </div>
		  </div>
	    </div>
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
				'hideAllNonBaseMenuItem'      
              ]
        });
        window.stopChargeBool = false;
		window.heiniuDeviceSn = '';
		window.heiniuDevicePath = '';
		window.loading;
		$(function(){
			loading = weui.loading('数据加载中', {
   		    	className: 'custom-classname'
   			});
			currentChargingList();
		});

		//当前正在充电列表请求
		function currentChargingList() {
			$.ajax({
				type:"GET",
				dataType:"json",
		        cache:false,
				data:{
					"url":"min/charge/charging"
				},
				url:"<%=path%>/spring/proxy",
				success:function(req) {
					if (req.status == 0) {
						initChargeListView(req.data);
					} else {
						if(data.status == 10000){
					   	      window.location.replace = "<%=AppConfig.DOMAIN%><%=path%>/weChatLogin?tmp=jsp/myChargeList.jsp";
					   	      return;
						}
						var msgStr = '';
						if (req.status == -1) {
							msgStr = req.message;
						} else {
							msgStr = req.msg;
						}
						var msg = {
			 	   		        	msg:msgStr,
			 	   		        	pop:"true",
			 	   		        	link:"false"
			 	   		        }
			 	   		localStorage.setItem("EAST_errorMsg", JSON.stringify(msg));
				        window.location.href="<%=path%>/jsp/capture/errorMsg.jsp";
					};
				},
				error:function(error){

				},
				complete:function(){
					loading.hide();
				}
			});
		} 

		function chargeRefesh() {
			
			if (stopChargeBool == true) {
				return;
			}

			$.ajax({
				type:"GET",
				dataType:"json",
		        cache:false,
				data:{
					"url":"min/charge/refresh",
					"deviceSn":heiniuDeviceSn
				},
				url:"<%=path%>/spring/proxy",
				success:function(req) {
					if (req.status == 0) {
						refreshData(req.data);
					} else {
						if(data.status == 10000){
					   	      window.location.replace = "<%=AppConfig.DOMAIN%><%=path%>/weChatLogin?tmp=jsp/myChargeList.jsp";
					   	      return;
						}
					}
					window.setTimeout("chargeRefesh()",4000); //定时刷新4s;
				},
				error:function(error){

				},
				complete:function(){
					loading.hide();
				}
			});

		}

		function refreshData (data) {
			$(".chargeType").text("已充时长："+ parseSeconds2Str(data.chargeTime));
		}

		function parseSeconds2Str(seconds) {
		    var ss = seconds % 60;
		    seconds = (seconds - ss) / 60;
		    var mm = seconds % 60;
		    seconds = seconds - mm;
		    var hh = seconds / 60;
		    return (hh > 9 ? hh : ('0' + hh)) + ':' + (mm > 9 ? mm : ('0' + mm)) + ':' + (ss > 9 ? ss : ('0' + ss));
		}

		function initChargeListView(data) {
			heiniuDevicePath = data.path;
			heiniuDeviceSn = data.deviceSn;
			//充电口状态
			 var tipStrArray = ["未知","充电中","暂停中","已停止"];
		
			var pileNum = data.path;
			var chargeTimeStr = parseSeconds2Str(data.chargeTime);
			var priceNumberStr = Number(data.price/100).toFixed(2);
			var chargeItemHtml = ""
				// +"<a class=\"weui-cell weui-cell_access\">"
				// + "<div class=\"weui-cell__bd\">"
				+ "<div class=\"weui-cells\">"
		        + "<a href=\"javascript:0\" id =\""+123+"\" class=\"weui-media-box weui-media-box_appmsg weui-cell_access\">"
		        + "<div class=\"customImageView\" style=\"border-radius: 5px;border:1px solid #1aad19;margin-right: .8em;width:70px;max-height:100%;line-height: 50px;text-align: center;\">"
						
				+		"<div style=\"height: 60%;background: white;font-size: 24px;color: #1aad19;\">"+pileNum+"口</div>"

				+		"<div class=\"chargeTypeTip\" style=\"height: 40%;background: #1aad19;color: white;font-size: 12px;line-height: 25px\">"+tipStrArray[data.orderStateEnum]+"</div>"

		        +   "</div>"
		        +   "<div class=\"weui-media-box__bd\">" 
		        +        "<h5 class=\"weui-media-box__title chargeTitle\">"+ data.deviceName +"</h5>"
		        +        "<h5 class=\"weui-media-box__title weui-media-box__desc chargeNum\">序列号：" + data.deviceSn + "</h5>"
		        +        "<h5 class=\"weui-media-box__title weui-media-box__desc chargeType\">充电时长："+chargeTimeStr+"</h5>"
		        +        "<h5 class=\"weui-media-box__title weui-media-box__desc chargeStatus\">单&nbsp&nbsp&nbsp价："+priceNumberStr +"元/小时</h5>"
		        +	 "<h5 class=\"weui-media-box__title weui-media-box__desc chargeStatus\">开始时间："+data.beginTime+"</h5>"
		        +    "</div>"
		        
		        + "</a>"
		        +"</div>"
		        + "<div class=\"page__bd\" style=\"text-align: center; margin-top: 16px;\">"  
		        + "<a href=\"javascript:stopCharge();\" class=\"weui-btn weui-btn_primary order-btn\">结束充电"
                + "</a>"

			    + "</div>";
				
			$(".bodyContent").append(chargeItemHtml);
			chargeRefesh();
		}

		function stopCharge() {
			loading = weui.loading('数据加载中', {
   		    	className: 'custom-classname'
   			});
			$.ajax({
				type:"GET",
				dataType:"json",
		        cache:false,
				data:{
					"url":"min/charge/command/stop",
					"deviceSn":heiniuDeviceSn,
					"path":heiniuDevicePath
				},
				url:"<%=path%>/spring/proxy",
				success:function(req) {
					if (req.status == 0) {
						stopChargeBool = true;
						 weui.toast('成功停止', {
                             duration: 1000,
                             className: 'custom-classname',
                             callback: function(){ 
                                 showCostBill(req.data); 
                             }
                         });
					} else {
						if(data.status == 10000){
					   	      window.location.replace = "<%=AppConfig.DOMAIN%><%=path%>/weChatLogin?tmp=jsp/myChargeList.jsp";
					   	      return;
						}
						if (req.status == -1) {
							stopCharge();
							return;	
						}
						weui.topTips(req.msg,200);
					}
				},
				error:function(error){

				},
				complete:function(){
					loading.hide();
				}
			})
		}

		function showErrorTip() {
			weui.dialog({
                title: '提示',
                content: "结束充电请求无响应",
                className: 'custom-classname',
                buttons: [{
                    label: '取消',
                    type: 'default',
                    onClick: function () { 
                        
                    }
                }, {
                    label: '重新尝试',
                    type: 'primary',
                    onClick: function () { 
                        stopCharge();
                    }
                }],
                isAndroid:false
            });
		}

		function showCostBill(data) {
				//隐藏电价显示界面，防止账单弹框重叠
	 		$('#dialog ').hide();
	 		/*data={
	 				deviceSn: "429111890496002"
					endTime: "2018-09-14 11:28:59"
					startTime: "2018-09-12 14:10:50"
					totalFee: 271800
					totalPauseTime: 0
					tradingSn: "20180912141050659040
	 		}*/
	 		$('#totalCost').html('￥ '+ Number(data.totalFee/100).toFixed(2) + '元');
	 		var html = '<div style="background:#eee"><p>'+
	 						'<span class="weui-form-preview__label">交易流水号</span>' +
	 						'<span class="weui-form-preview__value">'+ data.tradingSn +'</span>' +
	 					'</p>' +
	 					'<p>' +
							'<span class="weui-form-preview__label">电桩编码</span>' +
							'<span class="weui-form-perview__value">'+ data.deviceSn +' </span>' + 
						'</p>' +
	 					'<p>' +
	 						'<span class="weui-form-preview__label">起始充电</span>' + 
	 						'<span class="weui-form-perview__value">' + data.startTime + ' </span>' +
	 					'</p>' +
	 					'<p>' +
	 						'<span class="weui-form-preview__label">结束充电</span>' +
	 						'<span class="weui-form-perview__value">'+ data.endTime +'</span>' + 
	 					'</p></div>';
	 		$('#costTable').html(html);
	 		$("#costDialog").show();
		}

		function closeCostBill(){
	 		location.replace("<%=path%>/jsp/user.jsp");
 		}

		$(function () { //解决iOS版本微信界面返回不刷新的问题
	  	    var isRefresh = false; 
	  		window.addEventListener('pageshow', function () { 
	    		if (isRefresh) { 
	      			window.location.reload(); 
	    		} 
	  		}); 
	  		window.addEventListener('pagehide', function () { 
	    		isRefresh = true; 
	  		}); 
	  	})


		</script>
</body>
</html>