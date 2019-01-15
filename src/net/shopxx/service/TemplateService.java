/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.service;

import net.shopxx.TemplateConfig;

/**
 * Service模板
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
public interface TemplateService {

	/**
	 * 读取模板文件内容
	 * 
	 * @param templateConfigId
	 *            模板配置ID
	 * @return 模板文件内容
	 */
	String read(String templateConfigId);

	/**
	 * 读取模板文件内容
	 * 
	 * @param templateConfig
	 *            模板配置
	 * @return 模板文件内容
	 */
	String read(TemplateConfig templateConfig);

	/**
	 * 写入模板文件内容
	 * 
	 * @param templateConfigId
	 *            模板配置ID
	 * @param content
	 *            模板文件内容
	 */
	void write(String templateConfigId, String content);

	/**
	 * 写入模板文件内容
	 * 
	 * @param templateConfig
	 *            模板配置
	 * @param content
	 *            模板文件内容
	 */
	void write(TemplateConfig templateConfig, String content);

}