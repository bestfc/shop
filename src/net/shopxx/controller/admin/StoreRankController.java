/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.controller.admin;

import javax.inject.Inject;

import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import net.shopxx.Message;
import net.shopxx.Pageable;
import net.shopxx.entity.StoreRank;
import net.shopxx.service.StoreRankService;

/**
 * Controller店铺等级
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Controller("adminStoreRankController")
@RequestMapping("/admin/store_rank")
public class StoreRankController extends BaseController {

	@Inject
	private StoreRankService storeRankService;

	/**
	 * 检查名称是否唯一
	 */
	@GetMapping("/check_name")
	public @ResponseBody boolean checkName(Long id, String name) {
		return StringUtils.isNotEmpty(name) && storeRankService.nameUnique(id, name);
	}

	/**
	 * 添加
	 */
	@GetMapping("/add")
	public String add() {
		return "admin/store_rank/add";
	}

	/**
	 * 保存
	 */
	@PostMapping("/save")
	public String save(StoreRank storeRank, RedirectAttributes redirectAttributes) {
		if (!isValid(storeRank)) {
			return ERROR_VIEW;
		}
		if (storeRankService.nameExists(storeRank.getName())) {
			return ERROR_VIEW;
		}
		storeRank.setStores(null);
		storeRankService.save(storeRank);
		addFlashMessage(redirectAttributes, SUCCESS_MESSAGE);
		return "redirect:list";
	}

	/**
	 * 编辑
	 */
	@GetMapping("/edit")
	public String edit(Long id, ModelMap model) {
		model.addAttribute("storeRank", storeRankService.find(id));
		return "admin/store_rank/edit";
	}

	/**
	 * 更新
	 */
	@PostMapping("/update")
	public String update(StoreRank storeRank, RedirectAttributes redirectAttributes) {
		if (!isValid(storeRank)) {
			return ERROR_VIEW;
		}
		StoreRank pStoreRank = storeRankService.find(storeRank.getId());
		if (pStoreRank == null) {
			return ERROR_VIEW;
		}
		if (!storeRankService.nameUnique(storeRank.getId(), storeRank.getName())) {
			return ERROR_VIEW;
		}

		storeRankService.update(storeRank, "stores");
		addFlashMessage(redirectAttributes, SUCCESS_MESSAGE);
		return "redirect:list";
	}

	/**
	 * 列表
	 */
	@GetMapping("/list")
	public String list(Pageable pageable, ModelMap model) {
		model.addAttribute("page", storeRankService.findPage(pageable));
		return "admin/store_rank/list";
	}

	/**
	 * 删除
	 */
	@PostMapping("/delete")
	public @ResponseBody Message delete(Long[] ids) {
		if (ids != null) {
			for (Long id : ids) {
				StoreRank storeRank = storeRankService.find(id);
				if (storeRank != null && storeRank.getStores() != null && !storeRank.getStores().isEmpty()) {
					return Message.error("admin.storeRank.deleteExistNotAllowed", storeRank.getName());
				}
			}
			long totalCount = storeRankService.count();
			if (ids.length >= totalCount) {
				return Message.error("admin.common.deleteAllNotAllowed");
			}
			storeRankService.delete(ids);
		}
		storeRankService.delete(ids);
		return SUCCESS_MESSAGE;
	}

}