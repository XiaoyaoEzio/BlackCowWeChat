package com.idbk.chargestation.wechat.springmvc;

import com.idbk.chargestation.wechat.AppConfig;
import com.idbk.chargestation.wechat.util.MySHA1;
import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.ArrayList;

/**
 * 接收并处理微信接入时的请求
 * https://mp.weixin.qq.com/wiki?t=resource/res_main&id=mp1421135319
 */
@Controller
public class WeChatAuthorizedController {
    private static final Logger LOG = Logger.getLogger(WeChatAuthorizedController.class);

    @RequestMapping(value = "/wxAuth", method = RequestMethod.GET)
    @ResponseBody
    public String check(
            @RequestParam(name = "signature") String signature,
            @RequestParam(name = "timestamp") String timestamp,
            @RequestParam(name = "nonce") String nonce,
            @RequestParam(name = "echostr") String echostr
    ) {
        if (checkSignature(signature, timestamp, nonce)) {
            return echostr;
        }
        return "";
    }

    private boolean checkSignature(String signature, String timestamp, String nonce) {
        if (StringUtils.isEmpty(signature)) {
            LOG.error("signature为空");
            return false;
        }

        if (StringUtils.isEmpty(timestamp)) {
            LOG.error("timestamp为空");
            return false;
        }

        if (StringUtils.isEmpty(nonce)) {
            LOG.error("nonce为空");
            return false;
        }

        // 对三个参数(token, timestamp, nonce)进行排序
        ArrayList<String> list = new ArrayList<>();
        list.add(nonce);
        list.add(timestamp);
        list.add(AppConfig.WX_SERVER_PRE_TOKEN);
        list.sort(String::compareTo);

        //将三个参数字符串拼接成一个字符串进行sha1加密
        String str = list.get(0) + list.get(1) + list.get(2);
        String r = MySHA1.SHA1(str);

        if (signature.equalsIgnoreCase(r)) {
            LOG.info("微信服务器身份认证成功");
            return true;
        } else {
            String sb = "signature:" + signature +
                    "，timestamp:" + timestamp +
                    "，nonce:" + nonce;
            LOG.warn("微信服务器身份认证失败，相关信息：" + sb);
            return false;
        }
    }

}
