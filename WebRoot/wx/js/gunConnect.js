function addLoadEvent(func) {
  var oldonload = window.onload;
  if (typeof window.onload != 'function') {
    window.onload = func;
  } else {  
    window.onload = function() {
      oldonload();
      func();
    }
  }
}


function load() {
	var num = Number(window.localStorage.lockNum);//地锁个数
	var statu = Number(window.localStorage.lockStatu);//地锁状态
	creatLockView(num);
	if (statu == 1) { //当为立起时 添加点击事件 控制地锁放下（解锁）

		//1个地锁的情况
		$('.LockSingle').bind("click", function(){
			//这里发送放下地锁命令
			$('.LockSingle .lockImgA').attr('src',gunStatus(7));
			$('.LockSingle').unbind('click');//放下了地锁 取消点击绑定
		})



		//2个地锁的情况
		$('.LockA').bind("click", function(){
			//这里发送放下地锁命令
			$('.LockA .lockImgA').attr('src',gunStatus(7));
			$('.LockA').unbind('click');//放下了地锁 取消点击绑定
		})
		$('.LockB').bind("click", function(){
			//这里发送放下地锁命令
			$('.LockB .lockImgB').attr('src',gunStatus(7));
			$('.LockB').unbind('click');//放下了地锁 取消点击绑定
		})

	}

	
}


// 根据传入枪口个数GunNum  动态生成显示2个或者1个枪口的界面 
function creatGunView(num){
	var html_GunView = "";
	var statu = Number(window.localStorage.gunStatu);//枪口状态
	var gunImgPathA = gunStatus(statu);
	var gunImgPathB = gunStatus(statu);
	
	if (num==2) {
		html_gunView = "<div class=\"gunConnect\">"+"<p style=\"text-align:center\">该类型电桩支持地锁功能，请选择需要放下的地锁:</p>"
		+"<ul class=\"gunBg\" style=\"list-style:none;\">"+
			"<li class=\"gunA gun\">"+
				"<div>"+
					"<h5>枪口A</h5>"+
					"<img class=\"gunImgA gunImg\" src=\""+gunImgPathB+"\">"+
				"</div>"+

			"</li>"+
			"<li class=\"gunB gun\">"+
				"<div>"+
					"<h5>枪口B</h5>"+
					"<img class=\"gunImgB gunImg\" src=\""+gunImgPathB+"\">"+
				"</div>"+
			"</li>"+
		"</ul>"+
	"</div>";
	} 

	if (num == 1) {
		html_gunView = "<div class=\"gunConnect\">"+"<p style=\"text-align:center\">该类型电桩自带"+"<span style=\"color:#\">1</span>"+"把充电枪可供使用(枪1、枪2):</p>"
		+"<ul class=\"gunBg\" style=\"list-style:none;\">"+
			"<li class=\"gunSingle gun\">"+
				"<div>"+
					"<h5>枪口</h5>"+
					"<img class=\"gunImgA gunImg\" src=\""+gunImgPathA+"\">"+
				"</div>"+

			"</li>"+
		"</ul>"+
	"</div>";
	} 

	$('.nextBtn').before(html_gunView);
}

//gunA gunB 枪口的状态选择不同的图片显示和交互，	（电桩类型为4、5）A枪口的状态：1:故障；2:告警；3，空闲，4：充电中；5：完成；6：预约中；7：等待；10：离线
function gunStatus(gun) {
	var gunImage = "";
	if (gun == 7) { //枪口连接上了
		gunImage = "img/charge/ico_Charging_gun_connected_@3x.png";
	} else if (gun == 4 || gun == 5 || gun == 6 ) {//枪口被占用
		gunImage = "img/charge/ico_Charging_gun_disabled_@3x.png";
	} else if (gun == 1 || gun == 2 || gun == 10) {//故障或者离线
		gunImage = "img/charge/ico_Charging_gun_disabled_@3x.png";
	} else { // 未连接
		gunImage = "img/charge/ico_Charging_gun_disconnect_@3x.png";
	}


	return gunImage;
}