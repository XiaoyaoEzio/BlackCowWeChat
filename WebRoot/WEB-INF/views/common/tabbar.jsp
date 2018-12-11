<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	String path = request.getContextPath();
%>	
	 <div id="tabbar" class="weui-tabbar footer-in">
        
         <a href="javascript:;" class="weui-tabbar__item footer-link">
             <i class="iconfont icon-saoma footer-icon "></i>
             <p class="footer-content">充电</p>
         </a>
         <a href="javascript:;" class="weui-tabbar__item footer-link">
             <i class="iconfont icon-wode footer-icon "></i>
             <p class="footer-content">我的</p>
         </a>
     </div>
     
     
   <%--    <div class="footer-in ">
            <a href="/mobile/index/charge_is" class="footer-link">
                <i class="iconfont icon-shandian footer-icon"></i>
                <p class="footer-content">我的充电</p>
            </a> 
            <a href="/mobile/entrance/scan_qr?type=scan&vender_id=2" class="footer-link active">
                <i class="iconfont icon-saoma footer-icon"></i>
                <p class="footer-content">扫码充电</p>
            </a>
            <a class="footer-link" href="<%=path %>/spring/info">
                <i class="iconfont icon-wode footer-icon"></i>
                <p class="footer-content">个人中心</p>
            </a>
        </div> --%>
     
     <script type="text/javascript">
     	
     	var defaultURL = "javascript:;";
     	var tab_urls = [
     	                "<%=path%>/jsp/capture.jsp",
     	                "<%=path%>/jsp/user.jsp"
     	                ];
     	var img_active = [
    						 "<%=path%>/include/img/btn_tabbar_charging_active.png",
     	                  "<%=path%>/include/img/btn_tabbar_me_active.png"
     	                  ];
     	var img_normal = [
						 "<%=path%>/include/img/btn_tabbar_charging_normal.png",
						 "<%=path%>/include/img/btn_tabbar_me_normal.png"
     	                  ];
     	
     	function selectTabbar(index){
     		var tabbar = $("#tabbar");
     		var tabitems = tabbar.find(".weui-tabbar__item");
     		$.each(tabitems,function(i,n){
     			$(n).attr("href",tab_urls[i]);
     			$(n).find(".footer-link").eq(0).removeClass("active");
     		});     		     		
     		tabitems.eq(index-1).addClass("weui-bar__item_on");
     		tabitems.eq(index-1).addClass("active");
     		tabitems.eq(index-1).attr("href",defaultURL);
     		tabitems.eq(index-1).find(".footer-link").eq(0).addClass("active");
     	}
     
     </script>