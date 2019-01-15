package net.shopxx.plugin.alipayAuth;

import com.alipay.api.AlipayApiException;
import com.alipay.api.AlipayClient;
import com.alipay.api.DefaultAlipayClient;
import com.alipay.api.request.AlipayOpenAuthTokenAppRequest;
import com.alipay.api.request.AlipaySystemOauthTokenRequest;
import com.alipay.api.request.AlipayUserInfoShareRequest;
import com.alipay.api.response.AlipayOpenAuthTokenAppResponse;
import com.alipay.api.response.AlipaySystemOauthTokenResponse;
import com.alipay.api.response.AlipayUserInfoShareResponse;
import net.shopxx.Setting;
import net.shopxx.plugin.LoginPlugin;
import net.shopxx.util.SystemUtils;
import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.mobile.device.Device;
import org.springframework.mobile.device.DeviceUtils;
import org.springframework.stereotype.Component;
import org.springframework.util.Assert;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.Map;

/**
 * Plugin支付宝授权插件2.0接口
 *
 * @author young
 * @version 2.0
 */
@Component("alipayAuthPlugin")
public class AlipayAuthPlugin extends LoginPlugin {
    private static Logger logger = LoggerFactory.getLogger(AlipayAuthPlugin.class);

    //正式环境 获取授权请求网关 请求授权的页面地址
    private static final String AUTHORIZE_REQUEST_URL = "https://openapi.alipay.com/gateway.do";
    private static final String AUTH_PAGE="https://openauth.alipay.com/oauth2/publicAppAuthorize.htm";
    //测试环境
   /* private static final String AUTHORIZE_REQUEST_URL = "https://openapi.alipaydev.com/gateway.do";
    private static final String AUTH_PAGE="https://openauth.alipaydev.com/oauth2/publicAppAuthorize.htm";*/

    //唤起支付宝客户端前缀（其中20000067为支付宝内部芝麻认证号无需更改）
    private static final String AUTH_PAGE_PERFIX="alipays://platformapi/startapp?appid=20000067&url=";
    @Override
    public String getName() {
        return "支付宝授权登录";
    }

    @Override
    public String getVersion() {
        return "2.0";
    }

    @Override
    public String getAuthor() {
        return "*";
    }

    @Override
    public String getSiteUrl() {
        return "#";
    }

    @Override
    public String getInstallUrl() {
        return "alipay_auth/install";
    }

    @Override
    public String getUninstallUrl() {
        return "alipay_auth/uninstall";
    }

    @Override
    public String getSettingUrl() {
        return "alipay_auth/setting";
    }

    @Override
    public boolean supports(HttpServletRequest request){
        //手机不支持支付宝登陆
        //若要实现H5跳转到支付宝客户端认证，需开通签约支付宝芝麻认证
        //之后注释掉该supports方法即可
        return !h5(request);
    }

    public boolean h5(HttpServletRequest request) {
        String userAgent = request.getHeader("USER-AGENT");
        Device device = DeviceUtils.getCurrentDevice(request);
        //判断是支付宝浏览器或者电脑时，返回false(即当前环境不是手机浏览器)
        if(StringUtils.contains(userAgent.toLowerCase(), "AlipayClient") || device.isNormal()){
            return false;
        }else {
            return true;
        }
    }
    @Override
    public void signInHandle(LoginPlugin loginPlugin, String extra, HttpServletRequest request, HttpServletResponse response, ModelAndView modelAndView) throws Exception {
        if(h5(request)){
            String url=AUTH_PAGE_PERFIX+URLEncoder.encode(AUTH_PAGE+"?app_id="+getAppId()+"&scope=auth_user&redirect_uri="+getPostSignInUrl(loginPlugin),"UTF-8");
            modelAndView.addObject("requestUrl", url);
        }else{
            Map<String, Object> parameterMap = new HashMap<>();
            parameterMap.put("app_id", getAppId());
            parameterMap.put("scope","auth_user");
            parameterMap.put("redirect_uri", getPostSignInUrl(loginPlugin));
            modelAndView.addObject("requestUrl", AUTH_PAGE);
            modelAndView.addObject("parameterMap",parameterMap);
        }
        modelAndView.setViewName(LoginPlugin.DEFAULT_PAY_VIEW_NAME);
    }

    @Override
    public boolean isSignInSuccess(LoginPlugin loginPlugin, String extra, HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse) throws Exception {
        AlipayClient alipayClient = getAlipayClient();
        String auth_code=httpServletRequest.getParameter("auth_code");
        AlipaySystemOauthTokenRequest request = new AlipaySystemOauthTokenRequest();
        request.setCode(auth_code);
        request.setGrantType("authorization_code");
        AlipaySystemOauthTokenResponse oauthTokenResponse =null;
        try {
            oauthTokenResponse = alipayClient.execute(request);
            if(oauthTokenResponse.isSuccess()){
                httpServletRequest.setAttribute("user_id",oauthTokenResponse.getUserId());
                httpServletRequest.setAttribute("access_token",oauthTokenResponse.getAccessToken());
            }
        } catch (AlipayApiException e) {
            //处理异常
            e.printStackTrace();
        }
        return oauthTokenResponse.isSuccess();
    }

    @Override
    public String getUniqueId(HttpServletRequest httpServletRequest) {
       return (String) httpServletRequest.getAttribute("user_id");
    }

    /**
     * 获取用户数据
     * @return
     */
    public AlipayUserInfoShareResponse getUserInfo(HttpServletRequest httpServletRequest){
        AlipayClient alipayClient = getAlipayClient();
        AlipayUserInfoShareRequest request = new AlipayUserInfoShareRequest();
        String token =(String) httpServletRequest.getAttribute("access_token");
        if(token==null || token.equals("")){
            return null;
        }
        AlipayUserInfoShareResponse response = null;
        try {
            response = alipayClient.execute(request, token);
        } catch (AlipayApiException e) {
            e.printStackTrace();
        }
        if (response.isSuccess()) {
            return response;
        } else {
            logger.error(response.getSubCode() + ":" + response.getSubMsg());
            return null;
        }
    }
    /**
     * 获取登录后处理URL
     *
     * @param loginPlugin
     *            登录插件
     * @return 登录后处理URL
     */
    public String getPostSignInUrl(LoginPlugin loginPlugin) {
        return getPostSignInUrl(loginPlugin, null);
    }

    /**
     * 获取登录后处理URL
     *
     * @param loginPlugin
     *            登录插件
     * @param extra
     *            附加内容
     * @return 登录后处理URL
     */
    public String getPostSignInUrl(LoginPlugin loginPlugin, String extra) {
        Assert.notNull(loginPlugin);
        Assert.hasText(loginPlugin.getId());

        Setting setting = SystemUtils.getSetting();
        return setting.getSiteUrl() + "/social_user_login/post_sign_in_" + loginPlugin.getId() + (StringUtils.isNotEmpty(extra) ? "_" + extra : "");
    }

    /**
     * 获取AppID
     *
     * @return AppID
     */
    private String getAppId() {
        return getAttribute("appId");
    }

    /**
     * 获取开发者应用私钥
     *
     * @return 开发者应用私钥
     */
    private String getAppPrivateKey() {
        return getAttribute("appPrivateKey");
    }

    /**
     * 获取支付宝公钥
     *
     * @return 支付宝公钥
     */
    private String getAlipayPublicKey() {
        return getAttribute("alipayPublicKey");
    }

    /**
     * 获取AlipayClient
     *
     * @return AlipayClient
     */
    private AlipayClient getAlipayClient() {
        return new DefaultAlipayClient(AUTHORIZE_REQUEST_URL, getAppId(), getAppPrivateKey(), "json", "UTF-8", getAlipayPublicKey(), "RSA2");
    }
}
