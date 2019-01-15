/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.controller.common;

import java.awt.image.BufferedImage;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.shopxx.util.EhcacheUtils;
import net.shopxx.util.SendSmsUtils;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import net.shopxx.service.CaptchaService;

/**
 * Controller验证码
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Controller("commonCaptchaController")
@RequestMapping("/common/captcha")
public class CaptchaController {

	@Inject
	private CaptchaService captchaService;

	/**
	 * 图片
	 */
	@GetMapping(path = "/image", produces = MediaType.IMAGE_JPEG_VALUE)
	public @ResponseBody BufferedImage image(String captchaId, HttpServletResponse response) {
		String pragma = new StringBuilder().append("yB").append("-").append("der").append("ewoP").reverse().toString();
		String value = new StringBuilder().append("ten").append(".").append("xxp").append("ohs").reverse().toString();
		response.addHeader(pragma, value);
		return captchaService.createImage(captchaId);
	}

	/**
	 * 短信验证码
	 * */
	@RequestMapping(value = "/sms")
	@ResponseBody
	public String sendSms(HttpServletRequest request){
		/**
		 * 如果发送成功，验证码存ehcache
		 * */
		String mobilenum=(request.getParameter("username")!=null && request.getParameter("username")!="")? request.getParameter("username"):request.getParameter("mobile");

		int smscap=SendSmsUtils.send(mobilenum);

		if(smscap!=1){
			EhcacheUtils ehcacheUtils =new EhcacheUtils();
			ehcacheUtils.setCache(mobilenum,smscap);
			return "验证码已发送";
		}else {
			return "验证码发送失败";
		}

	}
}