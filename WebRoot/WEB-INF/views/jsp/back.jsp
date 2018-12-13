<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ page import="com.idbk.chargestation.wechat.*" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";

%>
<!DOCTYPE html>
<html lang="zh-CH">
<head>
    <meta charset="UTF-8">
    <title>跳转中</title>
</head>
<body>
<script type="text/javascript">
    var locationStr = "<%=basePath%>${locationUrl}";
    window.location.replace(locationStr);
</script>
</body>