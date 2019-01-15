/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.plugin;

import java.math.BigDecimal;

import javax.inject.Inject;

import org.apache.commons.lang.builder.CompareToBuilder;
import org.apache.commons.lang.builder.EqualsBuilder;
import org.apache.commons.lang.builder.HashCodeBuilder;
import org.springframework.stereotype.Component;

import net.shopxx.entity.PluginConfig;
import net.shopxx.entity.Promotion;
import net.shopxx.service.PluginConfigService;

/**
 * Plugin促销插件
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
public abstract class PromotionPlugin implements Comparable<PromotionPlugin> {

	/**
	 * "价格"属性名称
	 */
	public static final String PRICE = "price";

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
	 * 获取价格
	 * 
	 * @return 价格
	 */
	public BigDecimal getPrice() {
		PluginConfig pluginConfig = getPluginConfig();
		return pluginConfig != null && pluginConfig.getAttribute(PRICE) != null ? new BigDecimal(pluginConfig.getAttribute(PRICE)) : BigDecimal.ZERO;
	}

	/**
	 * 获取价格运算表达式
	 * 
	 * @param promotion
	 *            促销
	 * @param useAmountPromotion
	 *            是否使用金额促销
	 * @param useNumberPromotion
	 *            是否使用数量促销
	 * @return 价格运算表达式
	 */
	public abstract String getPriceExpression(Promotion promotion, Boolean useAmountPromotion, Boolean useNumberPromotion);

	/**
	 * 重写equals方法
	 * 
	 * @param obj
	 *            对象
	 * @return 是否相等
	 */
	@Override
	public boolean equals(Object obj) {
		if (obj == null) {
			return false;
		}
		if (getClass() != obj.getClass()) {
			return false;
		}
		if (this == obj) {
			return true;
		}
		PromotionPlugin other = (PromotionPlugin) obj;
		return new EqualsBuilder().append(getId(), other.getId()).isEquals();
	}

	/**
	 * 重写hashCode方法
	 * 
	 * @return HashCode
	 */
	@Override
	public int hashCode() {
		return new HashCodeBuilder(17, 37).append(getId()).toHashCode();
	}

	/**
	 * 实现compareTo方法
	 * 
	 * @param promotionPlugin
	 *            登录插件
	 * @return 比较结果
	 */
	public int compareTo(PromotionPlugin promotionPlugin) {
		if (promotionPlugin == null) {
			return 1;
		}
		return new CompareToBuilder().append(getOrder(), promotionPlugin.getOrder()).append(getId(), promotionPlugin.getId()).toComparison();
	}

}