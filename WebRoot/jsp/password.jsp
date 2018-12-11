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
    <title>忘记密码</title>
    <link rel="stylesheet" href="<%=path%>/wx/css/mywx.css">
    <!-- 引入 WeUI -->
    <link rel="stylesheet" href="http://res.wx.qq.com/open/libs/weui/1.1.1/weui.min.css">    
    <script type="text/javascript" src="http://mat1.gtimg.com/libs/zepto/1.1.6/zepto.min.js"></script>
    <script type="text/javascript" src="https://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>
    <script type="text/javascript" src="https://res.wx.qq.com/open/libs/weuijs/1.0.0/weui.min.js"></script>
</head>
<body ontouchstart>
	<div class="weui-cells weui-cells_form">
		<!-- 用户名 -->
	    <div class="weui-cell weui-cell_vcode" id="div-name">
	        <div class="weui-cell__hd"><label class="weui-label">用户名</label></div>
	        <div class="weui-cell__bd">
	            <input id="name" name="name" class="weui-input" type="tel" maxlength="11" placeholder="手机号">
	        </div>
	        <div class="weui-cell__ft">
            	<i class="weui-icon-warn"></i>
        	</div>	        
	        <div class="weui-cell__ft">
            	<button class="weui-vcode-btn">获取验证码</button>
        	</div>        	
	    </div>
	    <!-- 验证码 -->
	    <div class="weui-cell" id="div-vcode">
	        <div class="weui-cell__hd"><label class="weui-label">验证码</label></div>
	        <div class="weui-cell__bd">
	            <input id="vcode" name="vcode" class="weui-input" type="number" pattern="[0-9]*" maxlength="6" placeholder="请输入验证码">
	        </div>
	        <div class="weui-cell__ft">
            	<i class="weui-icon-warn"></i>
        	</div>
	    </div>
	    <!-- 密码 -->
	    <div class="weui-cell" id="div-password">
	        <div class="weui-cell__hd"><label class="weui-label">密码</label></div>
	        <div class="weui-cell__bd">
	            <input id="password" name="password" class="weui-input" type="password" maxlength="20" placeholder="请输入密码，6-20位">
	        </div>
	        <div class="weui-cell__ft">
            	<i class="weui-icon-warn"></i>
        	</div>
	    </div>	    
	</div>
	
	<!-- 按钮两侧留有空隙 -->
	<div class="weui-btn-area">
	    <a id="bt-submit" href="#" class="weui-btn weui-btn_primary">确认</a>
	</div>
	
	<!-- 页脚 -->
	<div class="weui-footer weui-footer_fixed-bottom">
    	<p class="weui-footer__text">Copyright © 2018 <%=AppConfig.COMPANY %></p>
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
	
	wx.ready(function () {
		//隐藏 浏览器打开，防止接口泄漏
		wx.hideAllNonBaseMenuItem();
	});
	
	function resetPassword(name,vcode,password){
		$.ajax({
			  type: 'GET',
			  url: '<%=path%>/spring/proxy',
			  data: {
				  url:"/api/forget.do",
				  "username": name,
				  "newPassword": password,
				  "passwordConfirm": password,
				  "vcode": vcode
			  },
			  dataType: 'json',
			  timeout: 5000,
			  cache:false,
			  success: function(data){
			      if(data.status == 0){
			    	  weui.toast('重置成功', {
					         duration: 1000,
					         className: 'custom-classname',
					         callback: function(){ 
					        	 window.location.href = 'login.jsp'; 
					         }
					  });			    	  
			      } else {
			    	  weui.topTips(data.message, 2000);
			      }    			  
			  },
			  error: function(xhr, type){
				  weui.topTips('请求错误', 2000);
			  },
			  complete: function(xhr, options){
				  loading.hide();
			  }
		});
	};
	
	function checkInput(name,vcode,password){    	
		if(name == null || name.length != 11){
			$('#div-name').addClass('weui-cell_warn');
			return false;
		} else {
			$('#div-name').removeClass('weui-cell_warn');
		}
		if(vcode == null || vcode.length < 4 || vcode.length > 6){
			$('#div-vcode').addClass('weui-cell_warn');
			return false;
		} else {
			$('#div-vcode').removeClass('weui-cell_warn');
		}    	
		if(password == null || password.length < 4 || password.length > 20){
			$('#div-password').addClass('weui-cell_warn');
			return false;
		} else {
			$('#div-password').removeClass('weui-cell_warn');
		}    	
		return true;
	}
	
	function getVcode(name){
		$.ajax({
			  type: 'GET',
			  url: '<%=path%>/spring/sms',
			  data: {
				  "mobile": name,
				  "flag": false
			  },
			  dataType: 'json',
			  timeout: 6000,
			  cache:false,
			  success: function(data){  			  				
			      if(data.status == 0){
			    	//开始计时
			    	vcodeCooldown = false;
		    	var timeout = 120;
		    	var btVcode = $('.weui-vcode-btn');
		    	btVcode.html(timeout + "秒后重发");
		    	var timer = setInterval(function () {
		    		timeout--;
		    		if(timeout <= 0){
		    			clearInterval(timer);
		    			btVcode.html("获取验证码");
		    			vcodeCooldown = true;
		    		} else {
		    		   btVcode.html(timeout + "秒后重发");
		    		}
	            }, 1000);
			      } else {
			    	  weui.topTips(data.message, 2000);  		    	  
			      }    			  
			  },
			  error: function(xhr, type){
				  weui.topTips('请求错误', 2000);
			  },
			  complete: function(xhr, options){
			  	  loading.hide();
			  }
			});    	
	};
	
	//验证码发送是否冷却
	var vcodeCooldown = true;    
	var loading;
	
	$(function(){
		if(localStorage.getItem("idbk_charge_name") != undefined){
    		$("#name").val(localStorage.getItem("idbk_charge_name"));	
    	}
		
	    $('#bt-submit').on('click', function(){
	    	loading = weui.loading('数据提交中', {
			    className: 'custom-classname'
			});                       
	        //在这里实现登陆逻辑
	        var name = $('#name').val();
	        var vcode = $('#vcode').val();
			var password = $('#password').val();
	        if(checkInput(name,vcode,password)){
	        	resetPassword(name,vcode,password);	
	        } else {
	        	loading.hide();
	        }                    
	    });
	    
	    $('.weui-vcode-btn').on('click',function(){
	    	if(!vcodeCooldown){
	    		return;
	    	}
	    	var name = $('#name').val();
	    	if(name == null || name.length != 11){
	    		weui.topTips('请输入正确的手机号码！', 2000);
	    		$('#div-name').addClass('weui-cell_warn');
	    		return;
	    	}
	    	$('#div-name').removeClass('weui-cell_warn');
	    	loading = weui.loading('数据提交中', {
			    className: 'custom-classname'
			}); 
	    	getVcode(name);
	    });
	});

</script>
</body>
</html>