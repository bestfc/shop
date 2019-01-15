/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.entity;

import java.io.IOException;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Transient;

import org.hibernate.validator.constraints.Length;

import freemarker.core.Environment;
import freemarker.template.TemplateException;
import net.shopxx.util.FreeMarkerUtils;

/**
 * EntitySEO设置
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Entity
public class Seo extends BaseEntity<Long> {

	private static final long serialVersionUID = -3503657242384822672L;

	/**
	 * 类型
	 */
	public enum Type {

		/**
		 * 首页
		 */
		index,

		/**
		 * 文章列表
		 */
		articleList,

		/**
		 * 文章搜索
		 */
		articleSearch,

		/**
		 * 文章详情
		 */
		articleDetail,

		/**
		 * 商品列表
		 */
		productList,

		/**
		 * 商品搜索
		 */
		productSearch,

		/**
		 * 商品详情
		 */
		productDetail,

		/**
		 * 品牌列表
		 */
		brandList,

		/**
		 * 品牌详情
		 */
		brandDetail,

		/**
		 * 店铺首页
		 */
		storeIndex,

		/**
		 * 店铺搜索
		 */
		storeSearch
	}

	/**
	 * 类型
	 */
	@Column(nullable = false, updatable = false, unique = true)
	private Seo.Type type;

	/**
	 * 页面标题
	 */
	@Length(max = 200)
	private String title;

	/**
	 * 页面关键词
	 */
	@Length(max = 200)
	private String keywords;

	/**
	 * 页面描述
	 */
	@Length(max = 200)
	private String description;

	/**
	 * 获取类型
	 * 
	 * @return 类型
	 */
	public Seo.Type getType() {
		return type;
	}

	/**
	 * 设置类型
	 * 
	 * @param type
	 *            类型
	 */
	public void setType(Seo.Type type) {
		this.type = type;
	}

	/**
	 * 获取页面标题
	 * 
	 * @return 页面标题
	 */
	public String getTitle() {
		return title;
	}

	/**
	 * 设置页面标题
	 * 
	 * @param title
	 *            页面标题
	 */
	public void setTitle(String title) {
		this.title = title;
	}

	/**
	 * 获取页面关键词
	 * 
	 * @return 页面关键词
	 */
	public String getKeywords() {
		return keywords;
	}

	/**
	 * 设置页面关键词
	 * 
	 * @param keywords
	 *            页面关键词
	 */
	public void setKeywords(String keywords) {
		if (keywords != null) {
			keywords = keywords.replaceAll("[,\\s]*,[,\\s]*", ",").replaceAll("^,|,$", "");
		}
		this.keywords = keywords;
	}

	/**
	 * 获取页面描述
	 * 
	 * @return 页面描述
	 */
	public String getDescription() {
		return description;
	}

	/**
	 * 设置页面描述
	 * 
	 * @param description
	 *            页面描述
	 */
	public void setDescription(String description) {
		this.description = description;
	}

	/**
	 * 解析页面标题
	 * 
	 * @return 页面标题
	 */
	@Transient
	public String resolveTitle() {
		try {
			Environment environment = FreeMarkerUtils.getCurrentEnvironment();
			return FreeMarkerUtils.process(getTitle(), environment != null ? environment.getDataModel() : null);
		} catch (IOException e) {
			return null;
		} catch (TemplateException e) {
			return null;
		}
	}

	/**
	 * 解析页面关键词
	 * 
	 * @return 页面关键词
	 */
	@Transient
	public String resolveKeywords() {
		try {
			Environment environment = FreeMarkerUtils.getCurrentEnvironment();
			return FreeMarkerUtils.process(getKeywords(), environment != null ? environment.getDataModel() : null);
		} catch (IOException e) {
			return null;
		} catch (TemplateException e) {
			return null;
		}
	}

	/**
	 * 解析页面描述
	 * 
	 * @return 页面描述
	 */
	@Transient
	public String resolveDescription() {
		try {
			Environment environment = FreeMarkerUtils.getCurrentEnvironment();
			return FreeMarkerUtils.process(getDescription(), environment != null ? environment.getDataModel() : null);
		} catch (IOException e) {
			return null;
		} catch (TemplateException e) {
			return null;
		}
	}

}