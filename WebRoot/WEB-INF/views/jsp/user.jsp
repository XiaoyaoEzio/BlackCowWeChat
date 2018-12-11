
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.idbk.chargestation.wechat.*"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html>
<html lang="zh-CH">
<head>  
<head>
    <meta charset="UTF-8">
    <title>个人中心</title>
</head>
<body ontouchstart>
<script type="text/javascript">
	var locationStr = "<%=path%>/${locationUrl}"
	window.location.replace(locationStr);
</script>
</body>