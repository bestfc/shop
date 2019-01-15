/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.controller.admin;

import java.math.BigDecimal;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.BooleanUtils;
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
import net.shopxx.entity.BaseEntity;
import net.shopxx.entity.Member;
import net.shopxx.entity.MemberAttribute;
import net.shopxx.service.MemberAttributeService;
import net.shopxx.service.MemberRankService;
import net.shopxx.service.MemberService;
import net.shopxx.service.UserService;

/**
 * Controller会员
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Controller("adminMemberController")
@RequestMapping("/admin/member")
public class MemberController extends BaseController {

	@Inject
	private MemberService memberService;
	@Inject
	private UserService userService;
	@Inject
	private MemberRankService memberRankService;
	@Inject
	private MemberAttributeService memberAttributeService;

	/**
	 * 检查用户名是否存在
	 */
	@GetMapping("/check_username")
	public @ResponseBody boolean checkUsername(String username) {
		return StringUtils.isNotEmpty(username) && !memberService.usernameExists(username);
	}

	/**
	 * 检查E-mail是否唯一
	 */
	@GetMapping("/check_email")
	public @ResponseBody boolean checkEmail(Long id, String email) {
		return StringUtils.isNotEmpty(email) && memberService.emailUnique(id, email);
	}

	/**
	 * 检查手机是否唯一
	 */
	@GetMapping("/check_mobile")
	public @ResponseBody boolean checkMobile(Long id, String mobile) {
		return StringUtils.isNotEmpty(mobile) && memberService.mobileUnique(id, mobile);
	}

	/**
	 * 查看
	 */
	@GetMapping("/view")
	public String view(Long id, ModelMap model) {
		Member member = memberService.find(id);
		model.addAttribute("genders", Member.Gender.values());
		model.addAttribute("memberAttributes", memberAttributeService.findList(true, true));
		model.addAttribute("member", member);
		return "admin/member/view";
	}

	/**
	 * 添加
	 */
	@GetMapping("/add")
	public String add(ModelMap model) {
		model.addAttribute("genders", Member.Gender.values());
		model.addAttribute("memberRanks", memberRankService.findAll());
		model.addAttribute("memberAttributes", memberAttributeService.findList(true, true));
		return "admin/member/add";
	}

	/**
	 * 保存
	 */
	@PostMapping("/save")
	public String save(Member member, Long memberRankId, HttpServletRequest request, RedirectAttributes redirectAttributes) {
		member.setMemberRank(memberRankService.find(memberRankId));
		if (!isValid(member, BaseEntity.Save.class)) {
			return ERROR_VIEW;
		}
		if (memberService.usernameExists(member.getUsername())) {
			return ERROR_VIEW;
		}
		if (memberService.emailExists(member.getEmail())) {
			return ERROR_VIEW;
		}
		if (StringUtils.isNotEmpty(member.getMobile()) && memberService.mobileExists(member.getMobile())) {
			return ERROR_VIEW;
		}
		member.removeAttributeValue();
		for (MemberAttribute memberAttribute : memberAttributeService.findList(true, true)) {
			String[] values = request.getParameterValues("memberAttribute_" + memberAttribute.getId());
			if (!memberAttributeService.isValid(memberAttribute, values)) {
				return ERROR_VIEW;
			}
			Object memberAttributeValue = memberAttributeService.toMemberAttributeValue(memberAttribute, values);
			member.setAttributeValue(memberAttribute, memberAttributeValue);
		}
		member.setPoint(0L);
		member.setBalance(BigDecimal.ZERO);
		member.setAmount(BigDecimal.ZERO);
		member.setIsLocked(false);
		member.setLockDate(null);
		member.setLastLoginIp(null);
		member.setLastLoginDate(null);
		member.setSafeKey(null);
		member.setCart(null);
		member.setOrders(null);
		member.setSocialUsers(null);
		member.setPaymentTransactions(null);
		member.setMemberDepositLogs(null);
		member.setCouponCodes(null);
		member.setReceivers(null);
		member.setReviews(null);
		member.setConsultations(null);
		member.setProductFavorites(null);
		member.setProductNotifies(null);
		member.setInMessages(null);
		member.setOutMessages(null);
		member.setPointLogs(null);
		memberService.save(member);
		addFlashMessage(redirectAttributes, SUCCESS_MESSAGE);
		return "redirect:list";
	}

	/**
	 * 编辑
	 */
	@GetMapping("/edit")
	public String edit(Long id, ModelMap model) {
		Member member = memberService.find(id);
		model.addAttribute("genders", Member.Gender.values());
		model.addAttribute("memberRanks", memberRankService.findAll());
		model.addAttribute("memberAttributes", memberAttributeService.findList(true, true));
		model.addAttribute("member", member);
		return "admin/member/edit";
	}

	/**
	 * 更新
	 */
	@PostMapping("/update")
	public String update(Member member, Long id, Long memberRankId, Boolean unlock, HttpServletRequest request, RedirectAttributes redirectAttributes) {
		member.setMemberRank(memberRankService.find(memberRankId));
		if (!isValid(member)) {
			return ERROR_VIEW;
		}
		if (!memberService.emailUnique(id, member.getEmail())) {
			return ERROR_VIEW;
		}
		if (StringUtils.isNotEmpty(member.getMobile()) && !memberService.mobileUnique(id, member.getMobile())) {
			return ERROR_VIEW;
		}
		member.removeAttributeValue();
		for (MemberAttribute memberAttribute : memberAttributeService.findList(true, true)) {
			String[] values = request.getParameterValues("memberAttribute_" + memberAttribute.getId());
			if (!memberAttributeService.isValid(memberAttribute, values)) {
				return ERROR_VIEW;
			}
			Object memberAttributeValue = memberAttributeService.toMemberAttributeValue(memberAttribute, values);
			member.setAttributeValue(memberAttribute, memberAttributeValue);
		}
		Member pMember = memberService.find(id);
		if (pMember == null) {
			return ERROR_VIEW;
		}
		if (BooleanUtils.isTrue(pMember.getIsLocked()) && BooleanUtils.isTrue(unlock)) {
			userService.unlock(member);
			memberService.update(member, "username", "encodedPassword", "point", "balance", "amount", "lastLoginIp", "lastLoginDate", "loginPluginId", "safeKey", "cart", "orders", "socialUsers", "paymentTransactions", "memberDepositLogs", "couponCodes", "receivers", "reviews", "consultations",
					"productFavorites", "productNotifies", "inMessages", "outMessages", "pointLogs");
		} else {
			memberService.update(member, "username", "encodedPassword", "point", "balance", "amount", "isLocked", "lockDate", "lastLoginIp", "lastLoginDate", "loginPluginId", "safeKey", "cart", "orders", "socialUsers", "paymentTransactions", "memberDepositLogs", "couponCodes", "receivers",
					"reviews", "consultations", "productFavorites", "productNotifies", "inMessages", "outMessages", "pointLogs");
		}
		addFlashMessage(redirectAttributes, SUCCESS_MESSAGE);
		return "redirect:list";
	}

	/**
	 * 列表
	 */
	@GetMapping("/list")
	public String list(Pageable pageable, ModelMap model) {
		model.addAttribute("memberRanks", memberRankService.findAll());
		model.addAttribute("memberAttributes", memberAttributeService.findAll());
		model.addAttribute("page", memberService.findPage(pageable));
		return "admin/member/list";
	}

	/**
	 * 删除
	 */
	@PostMapping("/delete")
	public @ResponseBody Message delete(Long[] ids) {
		if (ids != null) {
			for (Long id : ids) {
				Member member = memberService.find(id);
				if (member != null && member.getBalance().compareTo(BigDecimal.ZERO) > 0) {
					return Message.error("admin.member.deleteExistDepositNotAllowed", member.getUsername());
				}
			}
			memberService.delete(ids);
		}
		return SUCCESS_MESSAGE;
	}

}