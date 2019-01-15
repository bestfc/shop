/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.service.impl;

import java.io.File;
import java.io.IOException;

import javax.inject.Inject;
import javax.servlet.ServletContext;

import org.apache.commons.io.FileUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.util.Assert;

import net.shopxx.TemplateConfig;
import net.shopxx.service.TemplateService;
import net.shopxx.util.SystemUtils;

/**
 * Service模板
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Service
public class TemplateServiceImpl implements TemplateService {

	@Value("${template.loader_path}")
	private String templateLoaderPath;

	@Inject
	private ServletContext servletContext;

	public String read(String templateConfigId) {
		Assert.hasText(templateConfigId);

		TemplateConfig templateConfig = SystemUtils.getTemplateConfig(templateConfigId);
		return read(templateConfig);
	}

	public String read(TemplateConfig templateConfig) {
		Assert.notNull(templateConfig);

		try {
			String templatePath = servletContext.getRealPath(templateLoaderPath + templateConfig.getTemplatePath());
			File templateFile = new File(templatePath);
			return FileUtils.readFileToString(templateFile, "UTF-8");
		} catch (IOException e) {
			throw new RuntimeException(e.getMessage(), e);
		}
	}

	public void write(String templateConfigId, String content) {
		Assert.hasText(templateConfigId);

		TemplateConfig templateConfig = SystemUtils.getTemplateConfig(templateConfigId);
		write(templateConfig, content);
	}

	public void write(TemplateConfig templateConfig, String content) {
		Assert.notNull(templateConfig);

		try {
			String templatePath = servletContext.getRealPath(templateLoaderPath + templateConfig.getTemplatePath());
			File templateFile = new File(templatePath);
			FileUtils.writeStringToFile(templateFile, content, "UTF-8");
		} catch (IOException e) {
			throw new RuntimeException(e.getMessage(), e);
		}
	}

}