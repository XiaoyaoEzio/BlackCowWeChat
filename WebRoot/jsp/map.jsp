<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.idbk.chargestation.wechat.*" %>    
<%
    String path = request.getContextPath();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1,user-scalable=0">
    <title>充电点地图</title>
    <script type="text/javascript" src="<%=path%>/include/js/mypublic.js?ver=<%=AppConfig.JS_MY_PUBLIC%>"></script>
    
    <link rel="stylesheet" href="<%=path %>/wx/css/iconfont.css?v=1.0">
    <!--css-->
    <link rel="stylesheet" href="<%=path %>/wx/css/mysmart.css?v=0">
    <script src="<%=path %>/wx/js/flexible.js"></script>    
    <!-- 高德地图 -->
    <script type="text/javascript" src="http://webapi.amap.com/maps?v=1.4.3&key=<%=AppConfig.KEY_AMAP%>&plugin=AMap.MarkerClusterer"></script>
    <!--引入UI组件库（1.0版本） -->
    <script src="//webapi.amap.com/ui/1.0/main.js"></script>    
    <!-- 引入 WeUI -->
    <link rel="stylesheet" href="http://res.wx.qq.com/open/libs/weui/1.1.1/weui.min.css">    
    <script src="http://mat1.gtimg.com/libs/zepto/1.1.6/zepto.min.js"></script>
    <script type="text/javascript" src="https://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>
    <script type="text/javascript" src="https://res.wx.qq.com/open/libs/weuijs/1.0.0/weui.min.js"></script>
    <style type="text/css">
       html, body, #container {height:100%; overflow:hidden;}
       .scan-code {
            position:absolute;
            left:50%; bottom:70px;
            width:160px; margin-left:-80px; line-height:36px; text-align:center;
            font-size:1em; color:#fff; background:rgba(0,0,0,.6); border-radius:1.2em;
        }
        .ico-scan-code {
            display:inline-block; width:1em; height:1em;
            margin-right:.5em; vertical-align:-2px;
            background:url(<%=path%>/include/img/ico_scan-code.png) center no-repeat; background-size:99.9%;
        }
        .mylocation {
            position:absolute;
            bottom:130px; right:12px;
            width:40px; height:40px;        
        }   
        .nearby {
            position:absolute;
            bottom:190px; right:12px;
            width:40px; height:40px;        
        }
        .drawer {
            position:fixed; left:0; bottom:0; z-index:600;
            width:100%;
            background:#fff;
            box-shadow:0 -2px 5px rgba(0,0,0,.3);
            -webkit-transform:translateY(105%); transform:translateY(105%);
            -webkit-transition:ease-in-out .3s; transition:ease-in-out .3s;
        }
        .amap-ui-control-theme-usercontrol {
            bottom:50px;
        }
        .drawer.is-open {-webkit-transform:translateY(0); transform:translateY(0);}
    </style>
</head>
<body ontouchstart>

    <div class="page__bd" style="height: 100%;">
        <div class="weui-tab">
            <div class="weui-tab__panel">
                <div id="container" tabindex="0"></div>
                <img class="mylocation" alt="epile" src="<%=path%>/include/img/btn_map_gps.png">
            </div>
            
        </div>
        <jsp:include page="include/tabbar.jsp"></jsp:include>
    </div>  
         
    <script type="text/javascript">
    
        var loading;
        var latitude = 33.05408,longitude = 109.36858;        
        
        var map = new AMap.Map('container',{
            resizeEnable: true,
            //mapStyle:'fresh',
            zoom: 8,
            center: [longitude,latitude]
        });
        
        //设置DomLibrary，jQuery或者Zepto
        AMapUI.setDomLibrary($);
        //加载BasicControl，loadUI的路径参数为模块名中 'ui/' 之后的部分
        AMapUI.loadUI(['control/BasicControl'], function(BasicControl) {                
            //缩放控件
            map.addControl(new BasicControl.Zoom({
                position: 'lb',//位置靠左
                theme:"userControl", //自定义class
                showZoomNum: false //显示zoom值
            }));
            //微调控件位置
            $(".amap-ui-control-theme-usercontrol").attr("style","bottom:50px");
        });
        
        $(function(){
            selectTabbar(0);
            if(!isWeiXin()){
                weui.topTips("非微信环境不支持定位",3000);    
            }   
            loading = weui.loading('数据加载中', {
                className: 'custom-classname'
            });
            //地图中心移动到定位点
            $(".mylocation").on("click",function(){
                //移动到定位点                
                var zoomLevel = map.getZoom();
                map.setZoomAndCenter(zoomLevel, [longitude,latitude]);
            });

            //加载所有充电点
            requestPoints();
        });
                                
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
                'getLocation'
              ]
        });
        
        wx.ready(function () {      
            wx.getLocation({
                type: 'gcj02', // 默认为wgs84的gps坐标，如果要返回直接给openLocation用的火星坐标，可传入'gcj02'
                success: function (res) {
                    latitude = res.latitude; // 纬度，浮点数，范围为90 ~ -90
                    longitude = res.longitude; // 经度，浮点数，范围为180 ~ -180。
                    var speed = res.speed; // 速度，以米/每秒计
                    var accuracy = res.accuracy; // 位置精度
                    addLocationMarkerAndMove(longitude,latitude);
                },
                cancel: function (res) {
                    weui.topTips('获取地理位置失败', 3000);
                },
                error: function(res){
                    weui.topTips('获取地理位置失败', 3000);
                }
            });         
        }); 
        
       function requestPoints(){
            $.ajax({
                   type:"get",
                   dataType:"json",
                   cache:false,
                   url:'point.json',
                   success:function(data){
                       if(data.status == 0 && data.points != undefined && data.points != null){
                           addMarkers(data.points);
                       } else {
                            weui.topTips('没有找到附近充电点', 3000);
                       }
                   },
                   error: function(){
                       weui.topTips('充电点请求失败！', 3000);
                   },
                   complete: function(){
                       loading.hide();
                   }
               });
        };
        var cluster, markers = [];
        
        //添加markers（少量点用此方法）
        function addMarkers(points){    
            $.each(points, function(key, item){
                marker = new AMap.Marker({
                    icon: getMarkerIcon(item.operatorId),
                    position: new AMap.LngLat(item.lng,item.lat),
                    title: item.name,
                    offset : new AMap.Pixel(-16,-45)
                    //map: map,
                });
                marker.content = item;
                marker.on('click', markerClick);
                markers.push(marker);
            });
            addCluster();
        };      
        
        var _renderCluserMarker = function (context) {
            var factor = Math.pow(context.count/markers.length, 1/18)
            var div = document.createElement('div');
            /*var Hue = 180 - factor* 180;
            var bgColor = 'hsla('+Hue+',100%,50%,0.7)';
            var fontColor = 'hsla('+Hue+',100%,20%,1)';
            var borderColor = 'hsla('+Hue+',100%,40%,1)';
            var shadowColor = 'hsla('+Hue+',100%,50%,1)';
            */
            div.style.backgroundColor = '#1daa23'
            var size = Math.round(25 + Math.pow(context.count/markers.length,1/5) * 20);
            div.style.width = div.style.height = size+'px';
            div.style.border = 'solid 1px '+ '#fff';
            div.style.borderRadius = size/2 + 'px';
            div.style.boxShadow = '0 0 8px '+ '#1daa23';
            div.innerHTML = context.count;
            div.style.lineHeight = size+'px';
            div.style.color = '#fff';
            div.style.fontSize = '16px';
            div.style.textAlign = 'center';
            context.marker.setOffset(new AMap.Pixel(-size/2,-size/2));
            context.marker.setContent(div)
         };
         
        function addCluster(tag) {
            cluster = new AMap.MarkerClusterer(map,markers,{
                gridSize:80,
                renderCluserMarker:_renderCluserMarker
            });
        };
        
        var canHideDrawer = true;
        // 点击空白处隐藏充电点底部抽屉
        map.on('click', function(e) {
            if(canHideDrawer){
                $('#drawer').removeClass('is-open');    
            }           
        });
        
        //点击充电点
        function markerClick(e){
            var point = e.target.content;
            //移动地图中心
            var zoomLevel = map.getZoom();
            var lngLat = map.lngLatToContainer(e.target.getPosition(), zoomLevel);
            var pixel = new AMap.Pixel(lngLat.getX(),lngLat.getY()+90);
            map.setCenter(map.containerToLngLat(pixel, zoomLevel));
            //显示信息窗
            showPointInfo(point);           
        }
        
        function showPointInfo(point){
            $('#drawer').addClass('is-open');
            showPoint(latitude, longitude, point);
            //window.location = "point/detail.jsp?id=" + point.id;
        }
        
        //定位成功后添加定位点 以及 移动地图中心到该定位点
        function addLocationMarkerAndMove(lng,lat){
            var img = getImageURL('/wx/img/map/location_marker.png');
            var icon = new AMap.Icon({
                image: img,
                size: new AMap.Size(25, 25),
                imageSize:new AMap.Size(25, 25),
                zIndex:300
            });
            var locateMarker = new AMap.Marker({
                icon: icon,
                position: new AMap.LngLat(lng,lat),
                offset : new AMap.Pixel(-12,-12),
                zIndex: 101,
                map: map,
            });
            //移动到定位点
            var zoomLevel = map.getZoom();
            var lngLat = map.lngLatToContainer(locateMarker.getPosition(), zoomLevel);
            var pixel = new AMap.Pixel(lngLat.getX(),lngLat.getY());
            map.setCenter(map.containerToLngLat(pixel, zoomLevel));
        }
        
        //根据 业主id返回图标
        function getMarkerIcon(operatorId){
            var uri = "<%=path%>/include/img/ico_map_marker.png";
           
            var icon = new AMap.Icon({
                image: uri,
                size: new AMap.Size(32, 45),
                imageSize:new AMap.Size(32, 45),
                zIndex:299
            });
            return icon;
        }

        //将 图片的相对地址 转化为 URL
        function getImageURL(uri){
            return "<%=path%>" + uri;
        }
        
    </script>
</body>
</html>