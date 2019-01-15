package net.shopxx.plugin;

import net.shopxx.entity.PluginConfig;
import net.shopxx.service.PluginConfigService;
import org.apache.commons.lang.builder.CompareToBuilder;
import org.springframework.stereotype.Component;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;

public abstract class ExpressPlugin  implements Comparable<ExpressPlugin> {

    /**
     * "登录方式名称"属性名称
     */
    public static final String EXPRESS_API_ATTRIBUTE_NAME = "expressapiName";


    /**
     * "描述"属性名称
     */
    public static final String DESCRIPTION_ATTRIBUTE_NAME = "description";


    @Inject
    private PluginConfigService pluginConfigService;

    /**
     * 获取ID
     *
     * @return ID
     */
    public String getId() {
        return getClass().getAnnotation(Component.class).value();
    }

    /**
     * 获取名称
     *
     * @return 名称
     */
    public abstract String getName();

    /**
     * 获取版本
     *
     * @return 版本
     */
    public abstract String getVersion();

    /**
     * 获取作者
     *
     * @return 作者
     */
    public abstract String getAuthor();

    /**
     * 获取网址
     *
     * @return 网址
     */
    public abstract String getSiteUrl();

    /**
     * 获取安装URL
     *
     * @return 安装URL
     */
    public abstract String getInstallUrl();

    /**
     * 获取卸载URL
     *
     * @return 卸载URL
     */
    public abstract String getUninstallUrl();

    /**
     * 获取设置URL
     *
     * @return 设置URL
     */
    public abstract String getSettingUrl();

    /**
     * 获取是否已安装
     *
     * @return 是否已安装
     */
    public boolean getIsInstalled() {
        return pluginConfigService.pluginIdExists(getId());
    }

    /**
     * 获取插件配置
     *
     * @return 插件配置
     */
    public PluginConfig getPluginConfig() {
        return pluginConfigService.findByPluginId(getId());
    }

    /**
     * 获取是否已启用
     *
     * @return 是否已启用
     */
    public boolean getIsEnabled() {
        PluginConfig pluginConfig = getPluginConfig();
        return pluginConfig != null ? pluginConfig.getIsEnabled() : false;
    }

    /**
     * 获取属性值
     *
     * @param name
     *            属性名称
     * @return 属性值
     */
    public String getAttribute(String name) {
        PluginConfig pluginConfig = getPluginConfig();
        return pluginConfig != null ? pluginConfig.getAttribute(name) : null;
    }

    /**
     * 获取排序
     *
     * @return 排序
     */
    public Integer getOrder() {
        PluginConfig pluginConfig = getPluginConfig();
        return pluginConfig != null ? pluginConfig.getOrder() : null;
    }

    /**
     * 获取接口名称
     *
     * @return 登录方式名称
     */
    public String getExpressApiName() {
        PluginConfig pluginConfig = getPluginConfig();
        return pluginConfig != null ? pluginConfig.getAttribute(EXPRESS_API_ATTRIBUTE_NAME) : null;
    }

    /**
     * 获取描述
     *
     * @return 描述
     */
    public String getDescription() {
        PluginConfig pluginConfig = getPluginConfig();
        return pluginConfig != null ? pluginConfig.getAttribute(DESCRIPTION_ATTRIBUTE_NAME) : null;
    }

    /**
     * 是否支持
     *
     * @param request
     *            HttpServletRequest
     * @return 是否支持
     */
    public boolean supports(HttpServletRequest request) {
        return true;
    }

    public int compareTo(ExpressPlugin expressPlugin) {
        if (expressPlugin == null) {
            return 1;
        }
        return new CompareToBuilder().append(getOrder(), expressPlugin.getOrder()).append(getId(), expressPlugin.getId()).toComparison();
    }
}
