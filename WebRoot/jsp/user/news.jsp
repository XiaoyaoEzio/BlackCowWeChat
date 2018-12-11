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
    <title>我的消息</title>
    <link rel="stylesheet" href="../../wx/css/mywx.css">
    <!-- 引入 WeUI -->
    <link rel="stylesheet" href="http://res.wx.qq.com/open/libs/weui/1.1.1/weui.min.css">    
    <script type="text/javascript" src="http://mat1.gtimg.com/libs/zepto/1.1.6/zepto.min.js"></script>
    <script type="text/javascript" src="https://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>
    <script type="text/javascript" src="https://res.wx.qq.com/open/libs/weuijs/1.0.0/weui.min.js"></script>
</head>
<body ontouchstart>    
<!-- 
        <a class="weui-cell weui-cell_access" href="javascript:;">
            <div class="weui-cell__bd">
                <div>
                    <h6 class="weui-media-box__title">标题一</h6>
                    <p class="weui-media-box__desc">由各种物质组成的巨型球状天体，叫做星球。星球有一定的形状，有自己的运行轨道。</p>
                    <ul class="weui-media-box__info">
                        <li class="weui-media-box__info__meta">文字来源</li>
                        <li class="weui-media-box__info__meta">时间</li>
                        <li class="weui-media-box__info__meta weui-media-box__info__meta_extra">其它信息</li>
                    </ul>
                </div>
            </div>
            <div class="weui-cell__ft"></div>
        </a>
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
		list.requestFinish(true,0);
	}
	
	function createItem(data){
		var html = ""
			+"<a class=\"weui-cell weui-cell_access\" href=\'../point/detail.jsp?id=" + data.id + "'>"
		    +    "<div class=\"weui-cell__bd\">"
		    +        "<div>"
		    +            "<h6 class=\"weui-media-box__title\">" + data.name + "</h6>"
		    +            "<p class=\"weui-media-box__desc\">" + data.address + "</p>"
		    +            "<ul class=\"weui-media-box__info\">"
		    +                "<li class=\"weui-media-box__info__meta\">空闲电桩/总电桩：" + data.idleNum +"/"+ data.count4Pile +"</li>"
		    +            "</ul>"
		    +        "</div>"
		    +    "</div>"
		    +    "<div class=\"weui-cell__ft\"></div>"
		    +"</a>"		
			+ "";
		return html;
	};
	
</script>
</body>
</html>


