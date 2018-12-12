package com.idbk.chargestation.wechat;

import org.apache.log4j.Logger;
import org.springframework.util.StringUtils;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import java.io.IOException;

/**
 * 过滤来自微信服务器的接入请求
 */
public class WxAuthFilter implements Filter {
    private static final Logger LOG = Logger.getLogger(LoginFilter.class);

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {

    }

    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain)
            throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) servletRequest;
        String queryString = request.getQueryString();
        LOG.debug(queryString);

        // 如果包含四个参数说明是微信的接入认证，转发至相应Controller
        if (!StringUtils.isEmpty(queryString) && queryString.contains("signature") && queryString.contains
                ("timestamp") && queryString.contains("nonce") && queryString.contains("echostr")) {
            request.getRequestDispatcher("/wxAuth").forward(servletRequest, servletResponse);
        }

        // 其他情况放行
        filterChain.doFilter(servletRequest, servletResponse);
    }

    @Override
    public void destroy() {

    }
}
