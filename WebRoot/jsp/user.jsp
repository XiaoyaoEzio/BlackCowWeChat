
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
    <meta name="keywords" content=""/>
    <meta name="description" content=""/>
    <meta name="viewport" content="initial-scale=1.0,maximum-scale=1.0,minimum-scale=1.0,user-scalable=0,width=device-width"/>
    <meta http-equiv="Cache-Control" content="no-siteapp"/>
    <meta name="generator" content=""/>
    <meta name="format-detection" content="telephone=no"/>
    <meta name="apple-mobile-web-app-capable" content="yes"/>
    <meta name="apple-mobile-web-app-title" content=""/>
    <meta name="apple-mobile-web-app-status-bar-style" content="default"/>
    <meta name="mobile-web-app-capable" content="yes">
    <meta name="msapplication-TileColor" content="">
    <script src="<%=path %>/wx/js/flexible.js"></script>
    <!--图标字体-->
    <link rel="stylesheet" href="<%=path %>/wx/css/iconfont.css?v=1.0">
    <!--css-->
    <link rel="stylesheet" href="<%=path %>/wx/css/mysmart.css?v=1.30">
</head>
	<!-- 引入 WeUI -->
    <link rel="stylesheet" href="http://res.wx.qq.com/open/libs/weui/1.1.1/weui.min.css">
    <link rel="stylesheet" href="<%=path%>/wx/css/mywx.css">    
    <script type="text/javascript" src=http://mat1.gtimg.com/libs/zepto/1.1.6/zepto.min.js></script>
    <script type="text/javascript" src="https://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>
    <script type="text/javascript" src="https://res.wx.qq.com/open/libs/weuijs/1.0.0/weui.min.js"></script>
</head>
<body ontouchstart>
<div class="page__bd" style="height: 100%;">
	<div class="weui-tab">
	<div class="weui-tab__panel">
		
	<div class="view contain-footer body-c">
    <!--banner-->
    <div class="center-banner">
        <div class="head-portrait">
            <div class="head-img">
                <img class="my-data-head" src="http://thirdwx.qlogo.cn/mmopen/7mDeM3Wice1ejkXPEpD6XsDNfBkYVs2ia9c0V3ic4n6J1lKTWmNZlDzYf47bicuLWCGk9rsKAbbWEicqU8HZjZ25no3gaSLYjLxNK/132" alt="">
            </div>
            <div class="head-content">
                <div class="serial-number">账户：<span id='name'>未知</span></div>
                <div class="serial-number1">账户余额：<span id='balance'>1</span>元</div>
            </div>
        </div>
    </div>
    <!--快捷按钮-->
    <div class="order-kj">
        <div class="order-item">
            <a href="user/recharge.jsp" class="block">
                <i class="iconfont icon-chongzhi1 icon-color_4"></i>
                <p>充值</p>
            </a>
        </div>
      
        <div class="order-item">
            <a href="tel:400-655-4446" class="block">
                <i class="iconfont icon-kefu icon-color_4"></i>
                <p>客服</p>
            </a>
        </div>
    </div>
    <!--导航-->
    <div class="navigation margin-t_10">

        <div class="navigation-cell">
            <a href="user/rechargeRecord.jsp" class="navigation-link">
                <div class="cell-icon">
                    <i class="iconfont icon-ccgl-pandianjilu-3 icon-color_3"></i>
                </div>
                <div class="cell-content">交易记录</div>
                <div class="cell-yb">
                    <i class="iconfont icon-youbian"></i>
                </div>
            </a>
        </div>
      
        <div class="navigation-cell">
            <a href="user/news.jsp" class="navigation-link">
                <div class="cell-icon">
                    <i class="iconfont icon-xiaoxi icon-color_3"></i>
                </div>
                <div class="cell-content">我的消息</div>
                <div class="cell-yb">
                    <i class="iconfont icon-youbian"></i>
                </div>
            </a>
        </div>
        <div class="navigation-cell">
            <a href="http://www.cdzhisheng.com/SmartCS/AgentM/User/login.html" class="navigation-link">
                <div class="cell-icon">
                    <i class="iconfont icon-zhanghu icon-color_3"></i>
                </div>
                <div class="cell-content">运营商登录</div>
                <div class="cell-yb">
                    <i class="iconfont icon-youbian"></i>
                </div>
            </a>
        </div>
        
        <div class="navigation-cell">
            <a href="#" class="navigation-link">
                <div class="cell-icon">
                    <i class="iconfont icon-dianchatouicon icon-color_3"></i>
                </div>
                <div class="cell-content">加盟我们</div>
                <div class="cell-yb">
                    <i class="iconfont icon-youbian"></i>
                </div>
            </a>
        </div>
        
         <div class="navigation-cell">
            <a href="#" class="navigation-link">
                <div class="cell-icon">
                    <i class="iconfont icon-baocuo icon-color_3"></i>
                </div>
                <div class="cell-content">意见反馈</div>
                <div class="cell-yb">
                    <i class="iconfont icon-youbian"></i>
                </div>
            </a>
        </div>
        
        <div class="navigation-cell">
            <a href="<%=path%>/<%=AppConfig.LICENSE%>" class="navigation-link">
                <div class="cell-icon"> 
                    <i class="iconfont icon-bangzhu icon-color_4"></i>
                </div>
                <div class="cell-content">使用协议</div>
                <div class="cell-yb">
                    <i class="iconfont icon-youbian"></i>
                </div>
            </a>
        </div>
    </div>	  
		</div>
	
		<jsp:include page="include/tabbar.jsp"></jsp:include>
	</div>
</div>
				
</body>
</html>
<script type="text/javascript">
      	
    // loading
    $(function(){
    	//
    	selectTabbar(2);
    	
    	//载入微信头像
    	loadWxHeadImg();
    	            
        $('#bt-logout').on('click', function(){                        
        	loading = weui.loading('数据加载中', {
    		    className: 'custom-classname'
    		});
            //在这里实现登出逻辑
            $.ajax({
	        	type:"get",
	        	dataType:"text",
	        	cache:false,
	        	url:'<%=path%>/spring/logout',
	        	success:function(data){
					console.log(data);
	        	},
	        	complete:function(){
	        		
	        		window.location.href = 'login.jsp';
	        		
	        	}
	        });           
        });       
        
        loadUserInfo();
    });
    
    function loadUserInfo(){
    	var loading = weui.loading('数据加载中', {
		    className: 'custom-classname'
		});
        $.ajax({
        	type:"POST",
        	dataType:"json",
        	cache:false,
        	data: {
        		"url":"min/user/get"
        	},
        	url:'<%=path%>/spring/proxy',
        	success:function(data){
        		if(data.status == 0){
        			fillData(data.data);
        		} else if(data.status == 10000){
	   	      window.location.href = "<%=AppConfig.DOMAIN%><%=path%>/weChatLogin?tmp=jsp/user.jsp";        		
        		} else {
        			showImportantErrorInfo(data.msg);
        		}
        	},
        	error:function(){
        		showImportantErrorInfo("加载用户信息失败！");
        	},
        	complete:function(){
        		loading.hide(); 
        	}
        });   	
    }    
    
    function showImportantErrorInfo(msg){		    
    	weui.dialog({
		    title: '提示',
		    content: msg,
		    className: 'custom-classname',
		    buttons: [{
		        label: '取消',
		        type: 'default',
		        onClick: function () { 
		        	
	        		//window.location.href = 'login.jsp';
	        		
		        }
		    }, {
		        label: '重新加载',
		        type: 'primary',
		        onClick: function () { 
		        	loadUserInfo(); 	 
		        }
		    }],
		    isAndroid:false
		});
    }
    
    //是否支持 绑定微信openid
	<%
		HttpSession tempSession = request.getSession(false);
		Object obj = tempSession.getAttribute(AppConfig.KEY_USER_CACHE);
		LoginCache lc = (LoginCache)obj;
	%>
	var wxHeadImgURL = "<%=lc.getUserRole()%>";
    
    function loadWxHeadImg(){
    	//如果用户已经绑定Openid    	
		if(wxHeadImgURL != "" && wxHeadImgURL != "null"){
			$(".my-data-head").attr("src",wxHeadImgURL);
		}
    }
    
    var host = '<%=AppConfig.HOST_FOR_IMG%>';
    
    function fillData(data){
    		var name = decodeURIComponent(escape(atob(data.userName)));	   
     	$("#name").html(name);
	    	$("#balance").html(Number(data.balance/100).toFixed(2));
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

    	$(".center-banner").click(function(event) {
    		window.location.href = "user/info.jsp";
    	});

</script>