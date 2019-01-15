/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.controller.admin;

import java.util.ArrayList;

import javax.inject.Inject;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import net.shopxx.Message;
import net.shopxx.entity.Area;
import net.shopxx.service.AreaService;

/**
 * Controller地区
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Controller("adminAreaController")
@RequestMapping("/admin/area")
public class AreaController extends BaseController {

	@Inject
	private AreaService areaService;

	/**
	 * 添加
	 */
	@GetMapping("/add")
	public String add(Long parentId, ModelMap model) {
		model.addAttribute("parent", areaService.find(parentId));
		return "admin/area/add";
	}

	/**
	 * 保存
	 */
	@PostMapping("/save")
	public String save(Area area, Long parentId, RedirectAttributes redirectAttributes) {
		area.setParent(areaService.find(parentId));
		if (!isValid(area)) {
			return ERROR_VIEW;
		}
		area.setFullName(null);
		area.setTreePath(null);
		area.setGrade(null);
		area.setChildren(null);
		area.setMembers(null);
		area.setReceivers(null);
		area.setOrders(null);
		area.setDeliveryCenters(null);
		area.setAreaFreightConfigs(null);
		areaService.save(area);
		addFlashMessage(redirectAttributes, SUCCESS_MESSAGE);
		return "redirect:list";
	}

	/**
	 * 编辑
	 */
	@GetMapping("/edit")
	public String edit(Long id, ModelMap model) {
		model.addAttribute("area", areaService.find(id));
		return "admin/area/edit";
	}

	/**
	 * 更新
	 */
	@PostMapping("/update")
	public String update(Area area, RedirectAttributes redirectAttributes) {
		if (!isValid(area)) {
			return ERROR_VIEW;
		}
		areaService.update(area, "fullName", "treePath", "grade", "parent", "children", "members", "receivers", "orders", "deliveryCenters", "areaFreightConfigs");
		addFlashMessage(redirectAttributes, SUCCESS_MESSAGE);
		return "redirect:list";
	}

	/**
	 * 列表
	 */
	@GetMapping("/list")
	public String list(Long parentId, ModelMap model) {
		Area parent = areaService.find(parentId);
		if (parent != null) {
			model.addAttribute("parent", parent);
			model.addAttribute("areas", new ArrayList<>(parent.getChildren()));
		} else {
			model.addAttribute("areas", areaService.findRoots());
		}
		return "admin/area/list";
	}

	/**
	 * 删除
	 */
	@PostMapping("/delete")
	public @ResponseBody Message delete(Long id) {
		areaService.delete(id);
		return SUCCESS_MESSAGE;
	}

}