<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ page import="com.idbk.chargestation.wechat.*" %>

<%
    String path = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="zh-cn">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta id="viewport" name="viewport"
          content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no"/>
    <title>充电</title>
    <link rel="stylesheet" type="text/css" href="<%=path%>/include/css/charge.css?t=20171205">
    <script src="<%=path%>/wx/js/wxBase.js"></script>
    <!--图标字体-->
    <link rel="stylesheet" href="<%=path %>/wx/css/iconfont.css?v=1.0">
    <!--css-->
    <link rel="stylesheet" href="<%=path %>/wx/css/mysmart.css?v=11.2">
    <script src="<%=path %>/wx/js/flexible.js"></script>
    <!-- 引入 WeUI -->
    <link rel="stylesheet" href="http://res.wx.qq.com/open/libs/weui/1.1.1/weui.min.css">
    <script type="text/javascript" src="http://mat1.gtimg.com/libs/zepto/1.1.6/zepto.min.js"></script>
    <script type="text/javascript" src="https://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>
    <script type="text/javascript" src="https://res.wx.qq.com/open/libs/weuijs/1.0.0/weui.min.js"></script>
</head>
<body ontouchstart>
<div class="page__bd" style="height: 100%;">
    <div class="weui-tab">

        <jsp:include page="include/tabbar.jsp"></jsp:include>
    </div>
</div>

<script type="text/javascript">

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
            'scanQRCode',
            'hideAllNonBaseMenuItem'
        ]
    });

    wx.ready(function () {
        //隐藏 浏览器打开，防止接口泄漏
        wx.hideAllNonBaseMenuItem();
    });

    wx.error(function (res) {
        alert(JSON.stringify(res));
    });

</script>


<script type="text/javascript">

    $(function () {
        selectTabbar(1);
        console.log("测试");
        chargeTabStatus();
        // QRcode();
    });

    //获取JavaScript参数
    function getURLParameter(name, url) {
        return decodeURIComponent((new RegExp('[?|&]' + name + '=' + '([^&;]+?)(&|#|;|$)').exec(url) || [null, ''])[1].replace(/\+/g, '%20')) || null;
    }

    function QRcode() {
        if (isWeiXin()) {
            //判断是否微信浏览器
            wx.ready(function () {
                wx.scanQRCode({
                    needResult: 1, // 默认为0，扫描结果由微信处理，1则直接返回扫描结果，
                    scanType: ["qrCode", "barCode"], // 可以指定扫二维码还是一维码，默认二者都有
                    success: function (res) {
                        alert(res.resultStr);
                        var result = res.resultStr.replace(new RegExp(/\s/, 'g'), '');

                        if (result.length < 12 || result == null) {
                            //获取到的二维码格式不对

                            weui.alert('暂不支持您扫码的二维码', function () {
                                location.href = "<%=path%>/jsp/capture.jsp";
                            }, {
                                title: '温馨提示'
                            });
                            return;
                        }

                        /*   	if (result.length == 12) {
                                  finalResult = result;
                              } else {
                                  finalResult = getURLParameter("sn", result);
                              } */
                        <%-- location.href = "<%=path%>/spring/wx/charge?qrcodeResult="+ encodeURIComponent(result);--%>
                        location.href = result;
                    }
                });
            });
        }
        else {
            weui.topTips("请在微信中使用该功能", 3000);
        }
    };

    //检测当前用户是否有充电，如果有则提示用户进入充电界面
    function chargeTabStatus() {
        $.ajax({
            url: '<%=path%>/spring/proxy',
            type: 'GET',
            dataType: 'json',
            cache: false,
            data: {
                'url': '/min/charge/charging'
            },
            success: function (data) {
                console.log(data);
                if (data.status == 0) {

                    if (data.data != undefined || data.data != "" || data.data != null) {
                        dealwithTabStatusData(data.data);
                    } else {
                        QRcode();
                    }
                }

                if (data.status == 10000) {
                    window.location.replace = "<%=AppConfig.DOMAIN%><%=path%>/weChatLogin?tmp=jsp/capture.jsp";
                    return;
                }

                if (data.status == -1) {
                    showImportantErrorInfo(data);
                }
                if (data.status == 20007) {
                    QRcode();
                }
            },
            error: function (Error) {
                console.log(Error);
                QRcode();
                showImportantErrorInfo(Error);
            },
            complete: function () {
                console.log("complete");
            }

        });

    }

    function showImportantErrorInfo(msg) {
        weui.dialog({
            title: '提示',
            content: "请求失败，请重新获取",
            className: 'custom-classname',
            buttons: [{
                label: '取消',
                type: 'default',
                onClick: function () {
                    location.href = "<%=path%>/jsp/user.jsp";
                }
            }, {
                label: '重新加载',
                type: 'primary',
                onClick: function () {
                    chargeTabStatus();
                }
            }],
            isAndroid: false
        });
    }

    function dealwithTabStatusData(data) {

        weui.confirm('你当前有一个充电的业务正在进行，是否前往查看？', {
            title: '温馨提示',
            buttons: [{
                label: '取消',
                type: 'default',
                onClick: function () {
                    location.href = "<%=path%>/jsp/user.jsp";
                }
            }, {
                label: '前往',
                type: 'primary',
                onClick: function () {
                    location.href = "<%=path%>/jsp/myChargeList.jsp";
                }
            }]
        });

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

    $(".center-banner").click(function (event) {
        window.location.href = "user/info.jsp";
    });


</script>
</body>
</html>