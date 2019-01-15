/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx;

import java.io.BufferedInputStream;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.util.Map;
import java.util.Properties;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.IOUtils;
import org.apache.commons.lang.StringUtils;
import org.jxls.common.Context;
import org.jxls.util.JxlsHelper;
import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.support.PropertiesLoaderUtils;
import org.springframework.web.servlet.view.AbstractView;

/**
 * Excel视图
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
public class ExcelView extends AbstractView {

	/**
	 * "强制下载"内容类型
	 */
	private static final String FORCE_DOWNLOAD_CONTENT_TYPE;

	/**
	 * 模板路径
	 */
	private static final String TEMPLATE_LOADER_PATH;

	/**
	 * 模板路径
	 */
	private String templatePath;

	/**
	 * 文件名称
	 */
	private String filename;

	static {
		Properties properties = null;
		try {
			properties = PropertiesLoaderUtils.loadProperties(new ClassPathResource(CommonAttributes.SHOPXX_PROPERTIES_PATH));
		} catch (IOException e) {
			throw new RuntimeException(e.getMessage(), e);
		}
		FORCE_DOWNLOAD_CONTENT_TYPE = properties.getProperty("force_download_content_type");
		TEMPLATE_LOADER_PATH = properties.getProperty("template.loader_path");
	}

	/**
	 * 构造方法
	 * 
	 * @param templatePath
	 *            模板路径
	 * @param filename
	 *            文件名称
	 */
	public ExcelView(String templatePath, String filename) {
		this.templatePath = templatePath;
		this.filename = filename;
		setContentType(FORCE_DOWNLOAD_CONTENT_TYPE);
	}

	@Override
	protected void renderMergedOutputModel(Map<String, Object> model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		if (StringUtils.isEmpty(response.getContentType())) {
			response.setContentType(getContentType());
		}
		if (!response.containsHeader("Content-disposition")) {
			if (StringUtils.isNotEmpty(filename)) {
				response.setHeader("Content-disposition", "attachment;filename=" + URLEncoder.encode(filename, "UTF-8"));
			} else {
				response.setHeader("Content-disposition", "attachment");
			}
		}
		InputStream inputStream = null;
		try {
			ServletContext servletContext = request.getSession().getServletContext();
			inputStream = new BufferedInputStream(new FileInputStream(servletContext.getRealPath(TEMPLATE_LOADER_PATH + templatePath)));
			OutputStream outputStream = response.getOutputStream();
			Context context = new Context(model);
			JxlsHelper.getInstance().processTemplate(inputStream, response.getOutputStream(), context);
			outputStream.flush();
		} catch (IOException e) {
			throw new RuntimeException(e.getMessage(), e);
		} finally {
			IOUtils.closeQuietly(inputStream);
		}
	}

}