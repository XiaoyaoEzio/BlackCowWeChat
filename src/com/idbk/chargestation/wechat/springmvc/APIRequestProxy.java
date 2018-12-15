package com.idbk.chargestation.wechat.springmvc;

import com.google.gson.JsonSyntaxException;
import com.idbk.chargestation.wechat.AppConfig;
import com.idbk.chargestation.wechat.json.ProxyJsonBase;
import okhttp3.HttpUrl;
import okhttp3.MediaType;
import okhttp3.Request;
import okhttp3.RequestBody;
import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.List;

/**
 * 代理请求，将ajax请求代理到API接口服务器
 *
 * @author gqy
 */
@Controller
@RequestMapping("/spring")
public class APIRequestProxy extends BaseControler {

    private static final Logger LOG = Logger.getLogger(APIRequestProxy.class);

    @RequestMapping(value = "/proxy", produces = "application/json; charset=UTF-8")
    @ResponseBody
    public String proxyAPIRequest(
            HttpServletRequest req,
            HttpServletResponse response,
            @RequestParam(value = "url", required = true) String uri) {
        String result = SERVER_ERROR;

        try {
            //处理token
            String token = "none";
            try {
                HttpSession session = req.getSession(false);
                Object obj = session.getAttribute(AppConfig.KEY_USER_CACHE);
                Object tokenObj = session.getAttribute(AppConfig.KEY_TOKEN);
                token = (String) tokenObj;
                LOG.info("token:" + token);
            } catch (Exception e1) {
                LOG.warn("无法从缓存中获取token值，请求URI：" + uri);
            }

            HttpUrl tempUrl = HttpUrl.parse(AppConfig.HOST);
            HttpUrl.Builder build = tempUrl.newBuilder();

            // 处理uri以"/"开始造成路径问题
            String newUrl = uri;
            if (uri.startsWith("/")) {
                newUrl = uri.substring(1);
            }
            build.addPathSegments(newUrl);

            //将其他url参数添加进去
            List<String> parameterNames = new ArrayList<>(req.getParameterMap().keySet());

            if (token != null) {
                build.addQueryParameter("token", token);
            }
            for (String name : parameterNames) {
                if (name.equals("url"))
                    continue;
                LOG.debug(req.getParameter(name));
                build.addEncodedQueryParameter(name, req.getParameter(name));
            }
            LOG.debug(req.getQueryString());
            //
            HttpUrl url = build.build();
            LOG.info("proxy-requst:" + url.url().toString());

            Request request = null;
            LOG.debug("APIRequestProxy:METHOD=" + req.getMethod());
            if (req.getMethod().equalsIgnoreCase("get")) {
                request = new Request.Builder()
                        .url(url)
                        .build();
            } else {
                //不能转发大数据，否则内存会爆掉
                int len = req.getContentLength();
                byte[] data = new byte[len];
                req.getInputStream().read(data, 0, len);
                MediaType mediaType = MediaType.parse(
                        req.getContentType());
                RequestBody body = RequestBody
                        .create(mediaType, data);
                request = new Request.Builder()
                        .url(url)
                        .post(body)
                        .build();
            }

            result = httpRequest(request);
            if (result == null || result.equals("")) {
                LOG.debug("从远程服务器获取数据失败！");
                result = SERVER_ERROR;
            } else {
                LOG.debug(result);
                //对于大数据就直接返回，不要再转化了
                if (result.length() < 200) {
                    handleTokenInvalid(req, response, result);
                }
            }
        } catch (Exception e) {
            result = SERVER_ERROR;
            LOG.error(e.getMessage(), e);
        }
        return result;
    }

    /**
     * 处理一些特殊的登录问题
     *
     * @param req
     * @param json
     * @throws JsonSyntaxException
     */
    private void handleTokenInvalid(
            HttpServletRequest req,
            HttpServletResponse response,
            String json) throws JsonSyntaxException {
        ProxyJsonBase jb = getGson().fromJson(json, ProxyJsonBase.class);
        if (jb.status == 10000
                || jb.status == 40001
                || jb.status == 40002) {
            HttpSession session = req.getSession(false);
            if (session != null) {
                LOG.info("登录token超时");
                session.removeAttribute(AppConfig.KEY_USER_CACHE);
                session.removeAttribute(AppConfig.KEY_TOKEN);
            }

        }
    }

}
