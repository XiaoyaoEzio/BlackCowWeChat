package com.idbk.chargestation.wechat.springmvc;

import com.idbk.chargestation.wechat.AppConfig;
import com.idbk.chargestation.wechat.LoginCache;
import com.idbk.chargestation.wechat.json.JsonWxUserInfo;
import com.idbk.chargestation.wechat.json.ProxyJsonLogin;
import okhttp3.HttpUrl;
import okhttp3.Request;
import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.util.Base64Utils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.regex.PatternSyntaxException;

@Controller
@RequestMapping("/spring/wx")
public class chargeModelView extends BaseControler {

    private static final Logger LOG = Logger.getLogger(chargeModelView.class);


    @RequestMapping(value = "/charge", method = RequestMethod.GET)
    public String inputCarNumber(
            ModelMap map,
            @RequestParam(value = "qrcodeResult", required = true) String qrcodeResult
    ) {
        LOG.debug("----qrcodeResult " + qrcodeResult);
        map.put("deviceSn", qrcodeResult);
        //返回数据
        return "jsp/chargePointInfo";
    }

    /**
     * 根据openid获取回调
     *
     * @param map
     * @param code
     * @param state
     * @return
     * @throws IOException
     */
    @RequestMapping("/weChatAuthorized")
    public String WeChatAuthorizedInfo(
            HttpServletRequest request, HttpServletResponse response,
            ModelMap map, String code, String state, String tmp
    ) throws IOException {
        LOG.debug("-----code= " + code);
        LOG.debug("----state=" + state);
        LOG.debug("----tmp=" + tmp);
        JsonWxAuth2AccessToken tokenInfo = getAccessToken(code);
        JsonWxUserInfo userInfo = getWxUserInfo(tokenInfo.accessToken, tokenInfo.openId);

        HttpSession session = request.getSession(true);

        LoginCache cache = new LoginCache();
        cache.setToken(userInfo.nickname, userInfo.openid, tokenInfo.accessToken, userInfo.headimgurl);
        HttpSession tempSession = request.getSession(false);

        tempSession.setAttribute(AppConfig.KEY_USER_CACHE, cache);
        map.put("username", userInfo.nickname);
        map.put("headImageUrl", userInfo.headimgurl);
        map.put("openId", userInfo.openid);

        LOG.debug("-----tokenInfo= " + tokenInfo);
        String result;
        try {
            result = login(request, userInfo.openid);
            ProxyJsonLogin token = getGson().fromJson(result, ProxyJsonLogin.class);

            if (token.status == 0) {
                tempSession.setAttribute(AppConfig.KEY_TOKEN, token.data.token);
            }

            if (token.status == 10009) {
                String name = userInfo.nickname;

                //暂时解决，处理特殊字符问题，直接编码提交，前端需解码显示
                String temNicName = Base64Utils.encodeToString(name.getBytes("UTF-8"));


                LOG.debug("name----" + name + "-----//-tempName= " + temNicName);

                String registerStr = register(request, userInfo.openid, temNicName, userInfo.sex);

                ProxyJsonLogin ss = getGson().fromJson(registerStr, ProxyJsonLogin.class);

                if (ss.status == 0) {
                    tempSession.setAttribute(AppConfig.KEY_TOKEN, ss.data.token);
                } else {
                    return "common/failed";
                }
            }

        } catch (Exception e) {
            // TODO: handle exception
            return "common/failed";
        }
        map.put("locationUrl", tmp);

        return "jsp/user";
    }

    //使用此特殊符号过滤有个bug ，当昵称中只有特殊符号时，返回为"" 存入数据库异常
    public static String StringFilter(String str) throws PatternSyntaxException {
        // 只允许字母和数字 // String regEx ="[^a-zA-Z0-9]";
        // 清除掉所有特殊字符
        String regEx = "[`~!@#$%^&*()+=|{}':;',\\[\\].<>/?~！@#￥%……&*（）——+|{}【】‘；：”“’。，、？]";
        Pattern p = Pattern.compile(regEx);
        Matcher m = p.matcher(str);
        return m.replaceAll("").trim();
    }

    public String login(
            HttpServletRequest req,
            @RequestParam(value = "openId", required = true) String openId) {
        //基本的输入验证
        String result = "";

        try {
            HttpUrl httpUrl = HttpUrl.parse(AppConfig.HOST);
            HttpUrl.Builder builder = httpUrl.newBuilder();
            HttpUrl url = builder.addPathSegment("min")
                    .addPathSegment("user")
                    .addPathSegment("login")
                    .addQueryParameter("openId", openId)
                    .build();
            Request request = new Request.Builder()
                    .url(url)
                    .build();
            result = httpRequest(request);
            LOG.debug(result);
            ProxyJsonLogin jb = getGson().fromJson(result, ProxyJsonLogin.class);
            if (jb.status == 0) {
                //表示登录成功
                HttpSession session = req.getSession(true);
                LoginCache cache = new LoginCache();
                //cache.setToken(jb.data.token);
                //session.setAttribute(AppConfig.KEY_USER_CACHE, cache);
            }
        } catch (Exception e) {
            result = SERVER_ERROR;
            LOG.error(e.getMessage(), e);
        }
        return result;
    }

    public String register(
            HttpServletRequest req,
            @RequestParam(value = "openId", required = true) String openId,
            @RequestParam(value = "userName", required = true) String userName,
            @RequestParam(value = "gender", required = true) int gender
    ) {
        //基本的输入验证
        String result = "";
        try {
            HttpUrl httpUrl = HttpUrl.parse(AppConfig.HOST);
            HttpUrl.Builder builder = httpUrl.newBuilder();
            HttpUrl url = builder.addPathSegment("min")
                    .addPathSegment("user")
                    .addPathSegment("register")
                    .addQueryParameter("openId", openId)
                    .addQueryParameter("userName", userName)
                    .addQueryParameter("gender", "" + gender)
                    .build();
            Request request = new Request.Builder()
                    .url(url)
                    .build();
            result = httpRequest(request);

            LOG.debug(result);

            ProxyJsonLogin jb = getGson().fromJson(result, ProxyJsonLogin.class);
            if (jb.status == 0) {
                //表示登录成功
                HttpSession session = req.getSession(true);
//				LoginCache cache = new LoginCache();
                //cache.setToken(jb.data.token);
                //session.setAttribute(AppConfig.KEY_USER_CACHE, cache);
                session.setAttribute(AppConfig.KEY_TOKEN, jb.data.token);
            }
        } catch (Exception e) {
            result = SERVER_ERROR;
            LOG.error(e.getMessage(), e);
        }
        return result;
    }

}
