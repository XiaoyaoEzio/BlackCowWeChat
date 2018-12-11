/*
 * 充电桩 微信公众号 公共js文件
 * 版本：V1.0.0
 * 作者：lupc
 * 注意：如果发布后，修改了内容，必须在app.properties里面升级版本号，防止缓存导致的错误
 */

//地球半径
var EARTH_RADIUS = 6378137.0;    //单位M

//
function rad(d)
{
	return d * Math.PI / 180.0;
}
	
//计算地球2点之间的距离
function getDistance(lat1,lng1,lat2,lng2) {
    var radLat1 = rad(lat1);
    var radLat2 = rad(lat2);
    var a = radLat1 - radLat2;
    var b = rad(lng1) - rad(lng2);
    var s = 2 * Math.asin(Math.sqrt(Math.pow(Math.sin(a/2),2) +
    Math.cos(radLat1)*Math.cos(radLat2)*Math.pow(Math.sin(b/2),2)));
    s = s *6378.137 ;// EARTH_RADIUS;
    s = Math.round(s * 10000) / 10000;
    
	if(s > 1){
		return s.toFixed(1) + "公里";
	} else {
		return parseInt(s*1000) + "米";
	}    	
}

//判断是否是微信客户端
function isWeiXin(){
	   var ua = window.navigator.userAgent.toLowerCase();
    if(ua.match(/MicroMessenger/i) == 'micromessenger'){
    	  return true;
    } else {
    	 return false;
    }
 }