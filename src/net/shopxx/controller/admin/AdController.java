/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.controller.admin;

import javax.inject.Inject;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import net.shopxx.Message;
import net.shopxx.Pageable;
import net.shopxx.entity.Ad;
import net.shopxx.service.AdPositionService;
import net.shopxx.service.AdService;

/**
 * Controller广告
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Controller("adminAdController")
@RequestMapping("/admin/ad")
public class AdController extends BaseController {

	@Inject
	private AdService adService;
	@Inject
	private AdPositionService adPositionService;

	/**
	 * 添加
	 */
	@GetMapping("/add")
	public String add(ModelMap model) {
		model.addAttribute("types", Ad.Type.values());
		model.addAttribute("adPositions", adPositionService.findAll());
		return "admin/ad/add";
	}

	/**
	 * 保存
	 */
	@PostMapping("/save")
	public String save(Ad ad, Long adPositionId, RedirectAttributes redirectAttributes) {
		ad.setAdPosition(adPositionService.find(adPositionId));
		if (!isValid(ad)) {
			return ERROR_VIEW;
		}
		if (ad.getBeginDate() != null && ad.getEndDate() != null && ad.getBeginDate().after(ad.getEndDate())) {
			return ERROR_VIEW;
		}
		if (Ad.Type.text.equals(ad.getType())) {
			ad.setPath(null);
		} else {
			ad.setContent(null);
		}
		adService.save(ad);
		addFlashMessage(redirectAttributes, SUCCESS_MESSAGE);
		return "redirect:list";
	}

	/**
	 * 编辑
	 */
	@GetMapping("/edit")
	public String edit(Long id, ModelMap model) {
		model.addAttribute("types", Ad.Type.values());
		model.addAttribute("ad", adService.find(id));
		model.addAttribute("adPositions", adPositionService.findAll());
		return "admin/ad/edit";
	}

	/**
	 * 更新
	 */
	@PostMapping("/update")
	public String update(Ad ad, Long adPositionId, RedirectAttributes redirectAttributes) {
		ad.setAdPosition(adPositionService.find(adPositionId));
		if (!isValid(ad)) {
			return ERROR_VIEW;
		}
		if (ad.getBeginDate() != null && ad.getEndDate() != null && ad.getBeginDate().after(ad.getEndDate())) {
			return ERROR_VIEW;
		}
		if (Ad.Type.text.equals(ad.getType())) {
			ad.setPath(null);
		} else {
			ad.setContent(null);
		}
		adService.update(ad);
		addFlashMessage(redirectAttributes, SUCCESS_MESSAGE);
		return "redirect:list";
	}

	/**
	 * 列表
	 */
	@GetMapping("/list")
	public String list(Pageable pageable, ModelMap model) {
		model.addAttribute("page", adService.findPage(pageable));
		return "admin/ad/list";
	}

	/**
	 * 删除
	 */
	@PostMapping("/delete")
	public @ResponseBody Message delete(Long[] ids) {
		adService.delete(ids);
		return SUCCESS_MESSAGE;
	}

}