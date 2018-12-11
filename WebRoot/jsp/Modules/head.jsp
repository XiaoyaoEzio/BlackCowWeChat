<%@ page language="java" import="java.util.*" pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="com.idbk.chargestation.wechat.*" %>
<% String path = request.getContextPath(); %>
<% WxConfig wxConfig = WeChat.getWxConfig(request); %>
<!DOCTYPE html>
<html lang="zh-cn">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1,user-scalable=0">
    <link rel="stylesheet" href="http://res.wx.qq.com/open/libs/weui/1.1.1/weui.min.css">
    <link rel="stylesheet" href="<%=path%>/include/css/mywx.css">