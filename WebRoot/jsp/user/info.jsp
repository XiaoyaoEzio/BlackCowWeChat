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
    <title>个人信息</title>
    <link rel="stylesheet" href="<%=path%>/wx/css/mywx.css">
    <!-- 引入 WeUI -->
    <link rel="stylesheet" href="http://res.wx.qq.com/open/libs/weui/1.1.1/weui.min.css">    
    <script type="text/javascript" src="http://mat1.gtimg.com/libs/zepto/1.1.6/zepto.min.js"></script>
    <script type="text/javascript" src="https://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>
    <script type="text/javascript" src="https://res.wx.qq.com/open/libs/weuijs/1.0.0/weui.min.js"></script>
</head>
<body ontouchstart>

	<div class="weui-cells__title">基本信息</div>
    <div class="weui-cells weui-cells_form">
        
        <div class="weui-cell">
            <div class="weui-cell__hd"><label class="weui-label">昵称</label></div>
            <div class="weui-cell__bd">
                <input id="input-nickname" class="weui-input" disabled="disabled" type="input" maxlength="20" placeholder="请输入昵称">
            </div>
        </div>
        <div class="weui-cell weui-cell_select weui-cell_select-after">
          	<div class="weui-cell__hd">
              	<label for="" class="weui-label">性别</label>
          	</div>
          	<div class="weui-cell__bd">
              	<select class="weui-select" id="select-sex" option="1">
                	<option value="1">男</option>
                	<option value="2">女</option>
              </select>
            </div>
        </div>      
    </div>
	<div class="weui-cells__title">个性签名</div>
	<div class="weui-cells weui-cells_form">
        <div class="weui-cell">
            <div class="weui-cell__bd">
                <textarea id="input-signature" class="weui-textarea" placeholder="请输入签名" maxlength="30" rows="2"></textarea>
                <div class="weui-textarea-counter"><span id="span-word-count">0</span>/30</div>
            </div>
        </div>
    </div>
    
    <div class="weui-btn-area">
		<a class="weui-btn weui-btn_primary" href="javascript:submit();" id="showTooltips">保存</a>
    </div>    
    
	<div class="weui-cells__title">账户</div>
	<div class="weui-cells">
        <a class="weui-cell weui-cell_access" href="javascript:resetpassword();">
            <div class="weui-cell__bd">
                <p>修改密码</p>
            </div>
            <div class="weui-cell__ft">
            </div>
        </a>
    </div>
<script type="text/javascript">
		
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
        		"url":"min/user/get"
        	},
        	url:'<%=path%>/spring/proxy',
        	success:function(data){
        		if(data.status == 0){
        			refreshView(data.data);	
        		} else {
        			weui.topTips(data.message, 30000);
        		}        		
        	},
        	error:function(){
        		weui.topTips('数据请求失败！', 30000);
        	},
        	complete:function(){
        		loading.hide();
        	}
        });		
		
		$('#input-signature').on('input propertychange', function() {
			var count = $(this).val().length;
			$("#span-word-count").html(count);
		});
	});
	
	function refreshView(data){
		if (data.phoneNum == undefined || data.phoneNum == null) {
			$("#input-loginname").val("");
		} else {
			$("#input-loginname").val(data.phoneNum);
		}
		var name = decodeURIComponent(escape(atob(data.userName)));
		$("#input-nickname").val(name);		
		if(data.signature != undefined && data.signature != null){
			$("#input-signature").val(data.signature);
			$("#span-word-count").html(data.signature.length);	
		}
		$('#select-sex').val(data.gender);
	}
	
	//修改用户昵称和签名
	function submit(){
		var loginname = $("#input-loginname").val();
		var nickName = $("#input-nickname").val();
		var signature = $("#input-signature").val();
		var sex = $('#select-sex').val();
		if(nickName == "" || nickName.length < 2){
			weui.topTips('昵称长度为2-20个字', 2000);
			return;
		}		
		$.ajax({
	  		  type: 'GET',
	  		  url: '<%=path%>/spring/proxy',
	  		  data: { 
	  			  "url": "min/user/edit",
	  			  "userName": nickName,
	  			  "signature": signature,
	  			  "gender": sex
	  		  },
	  		  dataType: 'json',
	  		  timeout: 5000,
	  		  success: function(data){	
	  		      if(data.status == 0){
	  		    	  weui.toast('保存成功', {
						         duration: 1000,
						         className: 'custom-classname'}
	  		    	  );
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
	
	//修改密码
	function resetpassword() {
		weui.topTips("本版本暂不支持",2000);
	}

	//上传头像
	function uploadHeader(){
		weui.topTips("本版本暂不支持",2000);
	}
	
	
</script>
</body>
</html>