<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ page import="com.idbk.chargestation.wechat.*" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>
<!DOCTYPE html>
<html lang="zh-CH">
<head>
    <meta charset="UTF-8">
    <title>充电点信息</title>
    <meta name="keywords" content=""/>
    <meta name="description" content=""/>
    <meta name="viewport"
          content="initial-scale=1.0,maximum-scale=1.0,minimum-scale=1.0,user-scalable=0,width=device-width"/>
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
    <link rel="stylesheet" href="<%=path %>/wx/css/mysmart.css?v=1.2">
    <!-- 引入 WeUI -->
    <link rel="stylesheet" href="<%=path%>/wx/css/mywx.css">
    <script type="text/javascript" src=http://mat1.gtimg.com/libs/zepto/1.1.6/zepto.min.js></script>
    <script type="text/javascript" src="https://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>
    <link rel="stylesheet" href="https://res.wx.qq.com/open/libs/weui/1.1.2/weui.min.css">

    <script type="text/javascript" src="https://res.wx.qq.com/open/libs/weuijs/1.1.3/weui.min.js"></script>
    <style type="text/css">
        .weui-grid {
            background: #fff;
            color: #999
        }

        .weui-grids {
            width: 90%;
            text-align: center;
            margin-left: 5%;
            border-radius: 10px;
            border: 1px solid #1aad19;
        }

        .weui-grid {
            border-radius: 10px;
            padding: 0;
            width: 25%;
        }

        .weui-grids2 {
            width: 90%;
            text-align: center;
            margin-left: 5%;
        }

        .weui-grid2 {
            position: relative;
            float: left;
            width: 22%;
            margin-left: 2.5%;
            padding: 12px 0px;
            font-size: 13px;
            background: #d5d5d6;
            color: #888;
            border-radius: 5px;
        }

        .weui-grid2.on {
            background: #1aad19;
            color: #fff !important;
        }

        .weui-grid p {
            color: #999;
            line-height: 18px !important;
            margin-top: 0px !important;
        }

        .on {
            color: #fff !important;
            background: #1aad19 !important
        }

        .on p {
            color: white !important;
        }

        .on span {
            color: white !important;
        }

        .on div {
            color: white !important;
        }

        .weui-grid1 {
            position: relative;
            float: left;
            width: 33.33333333%;
            padding: 4px 0px;
            font-size: 13px;
            background: #f8f8f8;
            color: #999;
        }

        .node0 {
            font-size: 14px;
            padding-left: 6px;
            float: left;
            color: #888;
            font-weight: bold
        }

        .order-btn {
            width: 85%;
            background: #1aad19;
        }

        .errmsg-btn {
            background: #ccc;
        }

    </style>

</head>
<body ontouchstart>
<div class="weui-toptips weui-toptips_warn js_tooltips">错误提示</div>
<div class="container" id="container">
    <div class="page" style="opacity: 100">
        <!-- <div class="page__bd">
            <div class="weui-panel weui-panel_access">
                <img src="" style="width: 100%; "/>
                                </div>
        </div> -->
        <!--// 充电-->
        <!--// 充电BLOCK-->
        <div class="page__bd result_block" style="display: none">
            <div class="page__bd" style="text-align: center; margin-top: 8px;">
                <a href="javascript:;" class="weui-btn weui-btn_primary back_block"
                   style="width: 80%; background: #ffcc66; font-size: 13px; height: 32px; line-height: 33px;">返回上一页</a>
                <div style="clear:both"></div>

            </div>

            <div class="page__bd" style="text-align: center; margin-top: 8px;">

                <a href="javascript:;" class="weui-btn weui-btn_primary start_block"
                   style="width: 80%; background: #ffcc66; font-size: 13px; height: 32px; line-height: 32px;">正在启动</a>
                <div class="weui-cells__title">费用</div>
                <a href="javascript:;" class="weui-btn weui-btn_primary"
                   style="width: 80%; background: #ffcc66; font-size: 13px; line-height: 18px; padding: 8px 0;">购买套餐<br/>
                    <span class="package_name">2元30分</span>
                </a>
                <div class="page__bd"
                     style="text-align: left; padding-left: 8px; font-size: 12px; line-height: 20px; margin-top: 8px;">
                    <div class="weui-cells__title"><font color="#f1a225">电站：</font></div>
                </div>
            </div>
        </div>
        <!--// 充电BLOCK-->
        <div class="page__bd order_block" style="display: block">
            <input type="hidden" name="machine_number" value="437"/>
            <input type="hidden" name="order_sn" value=""/>
            <input type="hidden" name="line_num" value="1"/>
            <input type="hidden" name="chargeRank" id="chargeRank" value="2"/>

            <div class="weui-cells__title" style="clear: both">
                <span style="float: left">设备号 [${deviceSn}]</span>
                <span style="float: right; margin-right: 6px;" class="device_status">
                    <font class="online_status">[设备掉线]</font>
                </span>
                <div style="clear: both"></div>
            </div>
            <div class="weui-cells__title">
                <font color="#1aad19">电站：<span class="chargeName">测试充电点</span></font>
                <div style="clear: both"></div>
            </div>

            <div class="weui-grids pileList"></div>
            <div class="weui-grids2 nowPrice" style="margin-top: 8px;">
                <ul class="priceList" style="list-style: none;text-align: left;">
                    <li class='priceInfo'>电价：<span class='priceNum' style="color:#1aad19">2</span> 元/小时</li>
                </ul>
            </div>
            <div class="weui-grids2" style="margin-top: 8px;">
                <a href="javascript:;" class="weui-grid2 cdsc " data-id="0" id="chargeRank0">2小时</a>
                <a href="javascript:;" class="weui-grid2 cdsc " data-id="1" id="chargeRank1">4小时</a>
                <a href="javascript:;" class="weui-grid2 cdsc on" data-id="2" id="chargeRank2">6小时</a>
                <a href="javascript:;" class="weui-grid2 cdsc" data-id="3" id="chargeRank3">8小时</a>
                <%--<a href="javascript:;" class="weui-grid2 cdsc" data-id="4" id="chargeRank4">自动充满</a>--%>

                <div style="clear: both"></div>
            </div>
            <div class="page__bd" style="text-align: center; margin-top: 16px;">
                <a href="javascript:void(0);" onclick="starBegain()" class="weui-btn weui-btn_primary order-btn">开始充电
                </a>
                <div class="weui-panel__hd errmsg" style="display: none"><font color="red">移动信号太差，建议设备移到信号的区域</font>
                </div>
            </div>
        </div>
        <!--// 充电BLOCK-->
        <div class="page__bd"
             style="text-align: left; padding-left: 8px; font-size: 12px; line-height: 20px; ">
            <div class="weui-panel__hd"><font color="#1aad19"
                                              style="font-size: 16px; font-weight: bold">遇到问题请联系客服：</font><br/>
                注意事项：<br/>
                1.充电前请确定您的电瓶车电池插头插好<br/>
                2.请选择充电时长，开始充电<br/>
                3.充电完成后请放好插头<br/><br/>
            </div>
            <br/>
            <span style="color: green">更多优惠便利服务请关注本公众号：<%= AppConfig.APP_NAME%>公众号</span>
        </div>
    </div>
</div>

</body>
</html>
<script type="text/javascript">

    var priceNumberStr = "";

    $('.cdsc').click(function () {
        $('.cdsc').removeClass('on');
        $(this).addClass('on');
        $('.package_name').text($(this).text());
        $('input[name="chargeRank"]').val($(this).attr('data-id'));
    });

    //获取充电信息
    $(function () {
        checkStatus();
    });

    function checkStatus() {
        $.ajax({
            type: "POST",
            dataType: "json",
            cache: false,
            url: "<%=path%>/spring/proxy",
            data: {
                "url": "/min/charge/connect",
                "deviceSn": "${deviceSn}"
            },
            success: function (data) {
                if (data.status == 10009) {
                    weui.alert(data.msg, function () {
                        location.href = "<%=path%>/jsp/capture.jsp";
                    }, {
                        title: '温馨提示'
                    });
                    return;
                }
                if (data.status == 10000) {
                    window.location.replace = "<%=AppConfig.DOMAIN%><%=path%>/weChatLogin?tmp=spring/wx/charge?qrcodeResult=${deviceSn}";
                    return;
                }

                console.log(data);
                if (data.status == 0) {
                    initView(data);
                    window.setTimeout("checkStatus()", 15000); //定时刷新5s
                } else {
                    weui.topTips(data.msg, 2000);
                    $(".online_status").text("设备离线");
                    $(".online_status").attr("style", "color:#e64340");
                    checkStatus();
                }

            },
            error: function (Error) {
                console.log(Error);
                /* loading.hide(); */
                var msg = {
                    msg: "系统繁忙，请稍后重试",
                    url: "<%=path%>/spring/charge/scanqr",
                    link: "false"
                };
                localStorage.setItem("EAST_errorMsg", JSON.stringify(msg));
                window.location.href = "<%=path%>/spring/errorMsg";

            },
            complete: function () {
                console.log("完成检测当前用户是否有充电完成请求");

            }
        })
    }

    function initView(reqData) {
        if (reqData.data.online == 1) {
            $(".online_status").text("设备在线");
            $(".online_status").attr("style", "color:#f1a225");
        } else {
            $(".online_status").text("设备离线");
            $(".online_status").attr("style", "color:#e64340");
        }

        //单价设置
        priceNumberStr = Number(reqData.data.price / 100).toFixed(2);

        $(".priceNum").text(priceNumberStr);

        $(".chargeName").text(reqData.data.deviceName);

        /*var rankList = [2, 4, 6, 8];
        for (var i = 0; i < 4; i++)
        {
            var rank = rankList[i];
            $("#chargeRank" + i).text(priceNumberStr * rank + " 元 " + rank + " 小时");
        }*/

        if (reqData.data.pathTotal > 0) {
            $(".pileList").empty();
            for (var i = 0; i < reqData.data.path_state.length; i++) {
                var pileInfo = reqData.data.path_state[i];
                var statusStr = "";
                var statusStrclass = "";
                if (pileInfo.state == 1) {
                    statusStr = "使用中";
                } else {
                    statusStr = "空闲";
                    statusStrclass = "";
                }
                var pileHtml = ""
                    + "<a href=\"javascript:;\" class=\"weui-grid cdk " + statusStrclass + "\">"
                    + "<p class=\"weui-grid__label\">" + pileInfo.path + "</p>"
                    + "<div class=\"weui-grid__icon\">"
                    + "<img src=\"<%=path%>/wx/img/charge/gunConnect_normal.png\" alt=\"\">"
                    + "</div>"
                    + "<div class=\"weui-grid__label\">" + statusStr + "</div>"
                    + "</a>";
                var element = $(pileHtml);
                $(".pileList").append(element);
            }
        }


        $('.cdk').click(function () {
            $('.cdk').removeClass('on');
            $('.cdk img').attr('src', '<%=path%>/wx/img/charge/gunConnect_normal.png');
            $(this).addClass('on');
            $(this).find('img').attr('src', '<%=path%>/wx/img/charge/gunConnect_active.png');
        });
    }

    function starBegain() {
        var tempSelect = $('.on p').text();
        var chargeRank = $('#chargeRank').val();

        if (!tempSelect) {
            weui.alert('请选择需要开启的充电口');
            return;
        }

        $.ajax({
            type: "POST",
            dataType: "json",
            cache: false,
            url: "<%=path%>/spring/proxy",
            data: {
                "deviceSn": "${deviceSn}",
                "path": tempSelect,
                "url": "/min/charge/command/start",
                "chargeRank": chargeRank
            },

            success: function (data) {

                if (data.status === 10000) {//token失效
                    window.location.reload();//强制刷新进入登陆界面
                } else if (data.status === 10013) {
                    // 余额不足
                    weui.confirm('余额不足，是否前往充值？', {
                        title: '温馨提示',
                        buttons: [{
                            label: '取消',
                            type: 'default',
                            onClick: function () {

                            }
                        }, {
                            label: '前往',
                            type: 'primary',
                            onClick: function () {
                                window.location.replace("<%=path%>/jsp/user/recharge.jsp");
                            }
                        }]
                    });

                } else if (data.status === 0) {//开启成功
                    weui.toast('开启成功', {
                        duration: 1000,
                        className: 'custom-classname',
                        callback: function () {
                            location.replace("<%=path%>/jsp/myChargeList.jsp");
                        }
                    });
                } else {
                    weui.topTips(data.msg, 2000);
                }

            },
            error: function (Error) {
                console.log(Error);
                /* loading.hide(); */
                var msg = {
                    msg: "系统繁忙，请稍后重试",
                    url: "<%=path%>/spring/charge/scanqr",
                    link: "false"
                }
                localStorage.setItem("EAST_errorMsg", JSON.stringify(msg));
                window.location.href = "<%=path%>/spring/errorMsg";

            },
            complete: function () {
                console.log("完成检测当前用户是否有充电完成请求");

            }
        })

    }

    /*$('#showPicker').on('click', function (res) {
        weui.picker([{
                label: Number(priceNumberStr / 2).toFixed(2) + '元30分',
                value: '30'
            }, {
                label: Number(priceNumberStr * 3 / 4).toFixed(2) + '元45分',
                value: '45'
            }, {
                label: Number(priceNumberStr).toFixed(2) + '元60分钟',
                value: '60'
            }, {
                label: Number(priceNumberStr * 5 / 4).toFixed(2) + '元75分钟',
                value: '75'
            }, {
                label: Number(priceNumberStr * 3 / 2).toFixed(2) + '元90分钟',
                value: '90'
            }, {
                label: Number(priceNumberStr * 7 / 4).toFixed(2) + '元105分钟',
                value: '105'
            }, {
                label: Number(priceNumberStr * 2).toFixed(2) + '元120分钟',
                value: '120'
            }, {
                label: Number(priceNumberStr * 9 / 4).toFixed(2) + '元135分钟',
                value: '135'
            },],
            {
                onChange: function (result) {
                    // console.log(result);
                    $('#showPicker').text(result[0].label);
                    $('input[name="package_id"]').val(result[0].value);
                    $('.package_name').text(result[0].label);
                    //console.log(result[0]);
                },
                onConfirm: function (result) {
                    $('#showPicker').text(result[0].label);
                    $('input[name="package_id"]').val(result[0].value);
                    $('.package_name').text(result[0].label);
                    //console.log(result[0]);
                }
            });
    });*/

</script>