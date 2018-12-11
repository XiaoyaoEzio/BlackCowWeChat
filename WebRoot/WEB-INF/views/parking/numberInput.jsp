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
    <title>输入车牌号</title>
    <link rel="stylesheet" href="<%=path%>/wx/css/mywx.css">
    <!-- 引入 WeUI -->
    <link rel="stylesheet" href="http://res.wx.qq.com/open/libs/weui/1.1.1/weui.min.css">    
    <script src="http://mat1.gtimg.com/libs/zepto/1.1.6/zepto.min.js"></script>
    <script type="text/javascript" src="https://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>
    <script type="text/javascript" src="https://res.wx.qq.com/open/libs/weuijs/1.0.0/weui.min.js"></script>
</head>
<body ontouchstart>	
	<form id="form1" action="<%=path%>/spring/wx/parking/bill" method="post" enctype="application/x-www-form-urlencoded">
	<div class="weui-cells__title">车牌号</div>
   	<div class="weui-cells">
		<div class="weui-cell weui-cell_select weui-cell_select-before">
            <div class="weui-cell__hd">
                <select name="carNum1" class="weui-select" id="selectProvince">
                    <option>京</option>
			        <option>津</option>
			        <option>冀</option>
			        <option>晋</option>
			        <option>蒙</option>
			        <option>辽</option>
			        <option>吉</option>
			        <option>黑</option>
			        <option>沪</option>
			        <option>苏</option>
			        <option>浙</option>
			        <option>皖</option>
			        <option>闽</option>
			        <option>赣</option>
			        <option>鲁</option>
			        <option>豫</option>
			        <option>鄂</option>
			        <option>湘</option>
			        <option>粤</option>
			        <option>桂</option>
			        <option>琼</option>
			        <option>渝</option>
			        <option>川</option>
			        <option>贵</option>
			        <option>云</option>
			        <option>藏</option>
			        <option>陕</option>
			        <option>甘</option>
			        <option>青</option>
			        <option>宁</option>
			        <option>新</option>
			        <option>港</option>
			        <option>澳</option>
                </select>
            </div>
            <div class="weui-cell__bd">
                <input id="inputCarNumber" name="carNum2" class="weui-input" type="text" placeholder="请输入车牌号" maxlength="20">
            </div>
        </div>
    </div>
    
    <div class="weui-cells__tips">注意：</div>
    <div class="weui-cells__tips">1.车牌号<em style="color:red">字母区分大小写</em></div>
    <div class="weui-cells__tips">2.港澳地区车牌请选择【港】【澳】，暂不支持台湾地区车牌</div>    
    <input type="hidden" name="openid" value="${openid}">
    </form>
    <div class="weui-btn-area">
        <a class="weui-btn weui-btn_primary" href="javascript:" id="btSubmit">确定</a>
    </div>
    <script type="text/javascript">
   		
    
    	$(function(){    	
    		if(localStorage.carProvince != undefined){
    			$("#selectProvince").val(localStorage.carProvince);	
        	} 
    		if(localStorage.carNumber != undefined){
    			$("#inputCarNumber").val(localStorage.carNumber);	
        	}
    		
    		$("#btSubmit").on("click",function(){
    			var num = $("#inputCarNumber").val();
    			if(num == null || num.length < 3){
    				weui.topTips("请输入正确的车牌号！",1500);
    				return;
    			}
    			var province = $("#selectProvince").val();
    			//组合成最后的车牌号    			
    			//将数据保存到本地，防止下次重复操作
				localStorage.carNumber = num;
				localStorage.carProvince = province;
				//直接使用form提交，避开tomcat URL汉字编码问题
				document.getElementById("form1").submit();
    		});
    	});
   
   </script>
</body>
</html>