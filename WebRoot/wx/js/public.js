
function showErrorInfo(msg) {
	var $toast_conten = $('#toast-info-content');
	$toast_conten.html(msg);

}



/**
* 数字补零显示
*/
function p(s) {
    return s < 10 ? '0' + s: s;
}

/**
* 小数位限制
*/
function decimal(str,num){
	str = str+"";
	var reg = "^[0-9.]*$";
    if(str.match(reg) && str.indexOf(".")>=0){
		var val = str.split(".");
		if(val[1].length > num){
			return val[0]+'.'+val[1].substring(0,num);
		}else{
			return str;
		}
    }else{
    	return str;
    }
}