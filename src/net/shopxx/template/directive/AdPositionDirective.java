/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.template.directive;

import java.io.IOException;
import java.util.Map;

import javax.inject.Inject;

import org.springframework.stereotype.Component;

import freemarker.core.Environment;
import freemarker.template.TemplateDirectiveBody;
import freemarker.template.TemplateException;
import freemarker.template.TemplateModel;
import net.shopxx.entity.AdPosition;
import net.shopxx.service.AdPositionService;

/**
 * 模板指令广告位
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Component
public class AdPositionDirective extends BaseDirective {

	/**
	 * 变量名称
	 */
	private static final String VARIABLE_NAME = "adPosition";

	@Inject
	private AdPositionService adPositionService;

	/**
	 * 执行
	 * 
	 * @param env
	 *            环境变量
	 * @param params
	 *            参数
	 * @param loopVars
	 *            循环变量
	 * @param body
	 *            模板内容
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public void execute(Environment env, Map params, TemplateModel[] loopVars, TemplateDirectiveBody body) throws TemplateException, IOException {
		Long id = getId(params);
		boolean useCache = useCache(params);
		AdPosition adPosition = adPositionService.find(id, useCache);
		setLocalVariable(VARIABLE_NAME, adPosition, env, body);
	}

}