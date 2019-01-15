/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.entity;

import java.io.Serializable;
import java.util.Date;

/**
 * EntitySitemap URL
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
public class SitemapUrl implements Serializable {

	private static final long serialVersionUID = -3028082695610264720L;

	/**
	 * 类型
	 */
	public enum Type {

		/**
		 * 文章
		 */
		article,

		/**
		 * 商品
		 */
		product
	}

	/**
	 * 更新频率
	 */
	public enum Changefreq {

		/**
		 * 经常
		 */
		always,

		/**
		 * 每小时
		 */
		hourly,

		/**
		 * 每天
		 */
		daily,

		/**
		 * 每周
		 */
		weekly,

		/**
		 * 每月
		 */
		monthly,

		/**
		 * 每年
		 */
		yearly,

		/**
		 * 从不
		 */
		never
	}

	/**
	 * 链接地址
	 */
	private String loc;

	/**
	 * 最后修改日期
	 */
	private Date lastmod;

	/**
	 * 更新频率
	 */
	private Changefreq changefreq;

	/**
	 * 权重
	 */
	private Float priority;

	/**
	 * 获取链接地址
	 * 
	 * @return 链接地址
	 */
	public String getLoc() {
		return loc;
	}

	/**
	 * 设置链接地址
	 * 
	 * @param loc
	 *            链接地址
	 */
	public void setLoc(String loc) {
		this.loc = loc;
	}

	/**
	 * 获取最后修改日期
	 * 
	 * @return 最后修改日期
	 */
	public Date getLastmod() {
		return lastmod;
	}

	/**
	 * 设置最后修改日期
	 * 
	 * @param lastmod
	 *            最后修改日期
	 */
	public void setLastmod(Date lastmod) {
		this.lastmod = lastmod;
	}

	/**
	 * 获取更新频率
	 * 
	 * @return 更新频率
	 */
	public Changefreq getChangefreq() {
		return changefreq;
	}

	/**
	 * 设置更新频率
	 * 
	 * @param changefreq
	 *            更新频率
	 */
	public void setChangefreq(Changefreq changefreq) {
		this.changefreq = changefreq;
	}

	/**
	 * 获取权重
	 * 
	 * @return 权重
	 */
	public Float getPriority() {
		return priority;
	}

	/**
	 * 设置权重
	 * 
	 * @param priority
	 *            权重
	 */
	public void setPriority(Float priority) {
		this.priority = priority;
	}

}