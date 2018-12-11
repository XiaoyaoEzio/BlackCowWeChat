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

function nextAction() {
	$(".nextBtn").click(function(){
		alert(window.localStorage.lockNum);
	})
}

function load() {
	var num = Number(window.localStorage.lockNum);//地锁个数
	var statu = Number(window.localStorage.lockStatu);//地锁状态
	creatLockView(num);
	if (statu == 1) { //当为立起时 添加点击事件 控制地锁放下（解锁）

		//1个地锁的情况
		$('.LockSingle').bind("click", function(){
			//这里发送放下地锁命令
			$('.LockSingle .lockImgA').attr('src',lockStatus(2));
			$('.LockSingle').unbind('click');//放下了地锁 取消点击绑定
		})



		//2个地锁的情况
		$('.LockA').bind("click", function(){
			//这里发送放下地锁命令
			$('.LockA .lockImgA').attr('src',lockStatus(2));
			$('.LockA').unbind('click');//放下了地锁 取消点击绑定
		})
		$('.LockB').bind("click", function(){
			//这里发送放下地锁命令
			$('.LockB .lockImgB').attr('src',lockStatus(2));
			$('.LockB').unbind('click');//放下了地锁 取消点击绑定
		})

	}

	
}


addLoadEvent(load);

// 根据传入地锁个数groundLockNum  动态生成显示2个或者1个地锁的界面 如果地锁个数为0则跳过直接进入枪口选择状态
function creatLockView(num){
	var html_LockView = "";
	var statu = Number(window.localStorage.lockStatu);//地锁状态
	var lockImgPathA = lockStatus(statu);
	var lockImgPathB = lockStatus(statu);

	if (num==2) {
		html_LockView = "<div class=\"groundLock\">"+"<p style=\"text-align:center\">当前电桩支持地锁功能，<br/>请选择合适的地锁停车充电:</p>"
		+"<ul class=\"lockBg\" style=\"list-style:none;\">"+
			"<li class=\"LockA lock\">"+
				"<div>"+
					"<h5>地锁A</h5>"+
					"<img class=\"lockImgA lockImg\" src=\""+lockImgPathA+"\">"+
				"</div>"+

			"</li>"+
			"<li class=\"LockB lock\">"+
				"<div>"+
					"<h5>地锁B</h5>"+
					"<img class=\"lockImgB lockImg\" src=\""+lockImgPathB+"\">"+
				"</div>"+
			"</li>"+
		"</ul>"+
	"</div>";
	} 

	if (num == 1) {
		html_LockView = "<div class=\"groundLock\">"+"<p style=\"text-align:center\">当前电桩支持地锁功能，<br/>请选择合适的地锁停车充电:</p>"
		+"<ul class=\"lockBg\" style=\"list-style:none;\">"+
			"<li class=\"LockSingle lock\">"+
				"<div>"+
					"<h5>地锁</h5>"+
					"<img class=\"lockImgA lockImg\" src=\""+lockImgPathA+"\">"+
				"</div>"+

			"</li>"+
		"</ul>"+
	"</div>";
	} 

	$('.nextBtn').before(html_LockView);
}

//lock1 lock2 地锁的状态选择不同的图片显示和交互，0：表示离线，1：地锁上锁（立起状态），2：地锁下放状态，5：表示地锁状态未知，8：表示无地锁
function lockStatus(lock) {
	var lockImage = "";
	switch(lock) {
		case 0:
		lockImage = "img/charge/ico_Charging_packing-lock_disabled_@3x.png";
		break;
		case 1:
		lockImage = "img/charge/ico_Charging_packing-lock_up_@3x.png";
		break;
		case 2:
		lockImage = "img/charge/ico_Charging_packing-lock_down_@3x.png";
		break;
		case 5:
		lockImage = "img/charge/ico_Charging_packing-lock_unknown_@3x.png";
		default:
		break;
	}
	return lockImage;
}


