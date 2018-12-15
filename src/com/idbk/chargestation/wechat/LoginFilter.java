package com.idbk.chargestation.wechat;

import org.apache.log4j.Logger;
import org.springframework.util.StringUtils;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.Date;


/**
 * 登录过滤器
 *
 * @author gqy
 */
public class LoginFilter implements Filter {

    private static final Logger LOG = Logger.getLogger(LoginFilter.class);

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(
            ServletRequest servletRequest,
            ServletResponse servletResponse,
            FilterChain chain
    ) throws IOException, ServletException {

        HttpServletRequest request = (HttpServletRequest) servletRequest;
        HttpServletResponse response = (HttpServletResponse) servletResponse;

        String currentURLWithDomain = request.getRequestURL().toString();
        LOG.debug("含域名全路径包currentURL:" + currentURLWithDomain);

        String currentURI = request.getRequestURI();
        LOG.debug("无域名的全路径currentURI:" + currentURI);

        String ctxPath = request.getContextPath();//工程名如果为ROOT则为null
        //除掉项目名称时访问页面当前路径
        String targetURL = currentURI.substring(ctxPath.length());
        //
        String redirectURI = currentURI +
                (request.getQueryString() == null ? "" : "?" + request.getQueryString());
        LOG.debug("redirectURI:" + redirectURI);
        LOG.debug(targetURL + "------ctxPath:" + ctxPath + "----------currentURL:" + currentURI);

        //判断登录是否超时
        HttpSession session = request.getSession(false);

        if (session == null) {//跳转授权
            LOG.debug("无 session");
            redirectToAuthorizeView(request, response);
            return;
        } else {
            String creationTime = formatDatetime(session.getCreationTime());
            String lastAccessedTime = formatDatetime(session.getLastAccessedTime());
            int sessionTimeout = session.getMaxInactiveInterval();

            Object obj = session.getAttribute(AppConfig.KEY_USER_CACHE);
            if (obj == null) {
                redirectToAuthorizeView(request, response);
            } else {
                if (obj instanceof LoginCache) {
                    LoginCache cache = (LoginCache) obj;
                    if (!cache.checkLogin()) {
                        redirectToAuthorizeView(request, response);
                    } else {
                        String log = String.format(
                                "状态：登录中,session创建时间：%s,session最后访问时间：%s,session超时时间：%s 秒",
                                creationTime,
                                lastAccessedTime,
                                sessionTimeout);
                        LOG.debug(log);
                        chain.doFilter(request, response);
                        return;
                    }
                } else {
                    redirectToAuthorizeView(request, response);
                }
            }
        }
        //到这里表示 该页面不需要登录即可访问
        chain.doFilter(request, response);
        return;

    }


    private void redirectToAuthorizeView(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String fromURI = request.getRequestURI();
        LOG.debug("fromURT: " + fromURI);

        String deviceSn = request.getParameter("deviceSn");
        String state;
        if (!StringUtils.isEmpty(fromURI) && fromURI.contains("user")) {
            state = "1";
        } else if (!StringUtils.isEmpty(fromURI) && fromURI.contains("capture")) {
            state = "2";
        } else if (!StringUtils.isEmpty(fromURI) && fromURI.contains("map")) {
            state = "3";
        } else if (!StringUtils.isEmpty(fromURI) && fromURI.contains("chargePointInfo")){
            state = deviceSn;
        } else {
            state = "0";
        }
        String fromFullURI = AppConfig.DOMAIN + request.getContextPath() + "/spring/wx/weChatAuthorized";
        LOG.info("fromFullURI:" + fromFullURI);
        //微信授权路径
        String weChatAuthorizedURI = "https://open.weixin.qq.com/connect/oauth2/authorize"
                + "?appid=" + AppConfig.APP_ID
                + "&redirect_uri=" + URLEncoder.encode(fromFullURI, "utf-8")
                + "&response_type=code"
                + "&scope=snsapi_userinfo"
                + "&state=" + state + "#wechat_redirect";
        response.sendRedirect(weChatAuthorizedURI);
    }

    @Override
    public void destroy() {
        // TODO Auto-generated method stub

    }

    private String formatDatetime(long time) {
        String result = "";
        try {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            result = sdf.format(new Date(time));
        } catch (Exception e) {

        }
        return result;
    }

}
