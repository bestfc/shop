/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.controller.admin;

import java.util.HashMap;
import java.util.Map;

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
import net.shopxx.entity.Admin;
import net.shopxx.entity.Member;
import net.shopxx.entity.PointLog;
import net.shopxx.security.CurrentUser;
import net.shopxx.service.MemberService;
import net.shopxx.service.PointLogService;

/**
 * Controller积分
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Controller("adminPointController")
@RequestMapping("/admin/point")
public class PointController extends BaseController {

	@Inject
	private PointLogService pointLogService;
	@Inject
	private MemberService memberService;

	/**
	 * 检查会员
	 */
	@GetMapping("/check_member")
	public @ResponseBody Map<String, Object> checkMember(String username) {
		Map<String, Object> data = new HashMap<>();
		Member member = memberService.findByUsername(username);
		if (member == null) {
			data.put("message", Message.warn("admin.point.memberNotExist"));
			return data;
		}
		data.put("message", SUCCESS_MESSAGE);
		data.put("point", member.getPoint());
		return data;
	}

	/**
	 * 调整
	 */
	@GetMapping("/adjust")
	public String adjust() {
		return "admin/point/adjust";
	}

	/**
	 * 调整
	 */
	@PostMapping("/adjust")
	public String adjust(String username, long amount, String memo, @CurrentUser Admin currentUser, RedirectAttributes redirectAttributes) {
		Member member = memberService.findByUsername(username);
		if (member == null) {
			return ERROR_VIEW;
		}
		if (amount == 0) {
			return ERROR_VIEW;
		}
		if (member.getPoint() == null || member.getPoint() + amount < 0) {
			return ERROR_VIEW;
		}
		memberService.addPoint(member, amount, PointLog.Type.adjustment, memo);
		addFlashMessage(redirectAttributes, SUCCESS_MESSAGE);
		return "redirect:log";
	}

	/**
	 * 记录
	 */
	@GetMapping("/log")
	public String log(Long memberId, Pageable pageable, ModelMap model) {
		Member member = memberService.find(memberId);
		if (member != null) {
			model.addAttribute("member", member);
			model.addAttribute("page", pointLogService.findPage(member, pageable));
		} else {
			model.addAttribute("page", pointLogService.findPage(pageable));
		}
		return "admin/point/log";
	}

}