/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.controller.member;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringUtils;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.fasterxml.jackson.annotation.JsonView;

import net.shopxx.Pageable;
import net.shopxx.Results;
import net.shopxx.entity.BaseEntity;
import net.shopxx.entity.Member;
import net.shopxx.entity.Message;
import net.shopxx.exception.UnauthorizedException;
import net.shopxx.security.CurrentUser;
import net.shopxx.service.MemberService;
import net.shopxx.service.MessageService;

/**
 * Controller消息
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Controller("memberMessageController")
@RequestMapping("/member/message")
public class MessageController extends BaseController {

	/**
	 * 每页记录数
	 */
	private static final int PAGE_SIZE = 10;

	@Inject
	private MessageService messageService;
	@Inject
	private MemberService memberService;

	/**
	 * 添加属性
	 */
	@ModelAttribute
	public void populateModel(Long draftMessageId, Long memberMessageId, @CurrentUser Member currentUser, ModelMap model) {
		Message draftMessage = messageService.find(draftMessageId);
		if (draftMessage != null && !currentUser.equals(draftMessage.getSender())) {
			throw new UnauthorizedException();
		}
		model.addAttribute("draftMessage", draftMessage);

		Message memberMessage = messageService.find(memberMessageId);
		if (memberMessage != null && !currentUser.equals(memberMessage.getSender()) && !currentUser.equals(memberMessage.getReceiver())) {
			throw new UnauthorizedException();
		}
		model.addAttribute("memberMessage", memberMessage);
	}

	/**
	 * 检查用户名是否合法
	 */
	@GetMapping("/check_username")
	public @ResponseBody boolean checkUsername(String username, @CurrentUser Member currentUser) {
		return StringUtils.isNotEmpty(username) && !StringUtils.equalsIgnoreCase(username, currentUser.getUsername()) && memberService.usernameExists(username);
	}

	/**
	 * 发送
	 */
	@GetMapping("/send")
	public String send(@ModelAttribute(binding = false, name = "draftMessage") Message draftMessage, Model model) {
		if (draftMessage != null && draftMessage.getIsDraft()) {
			model.addAttribute("draftMessage", draftMessage);
		}
		return "member/message/send";
	}

	/**
	 * 发送
	 */
	@PostMapping("/send")
	public String send(@ModelAttribute(binding = false, name = "draftMessage") Message draftMessage, String username, String title, String content, @RequestParam(defaultValue = "false") Boolean isDraft, @CurrentUser Member currentUser, HttpServletRequest request,
			RedirectAttributes redirectAttributes) {
		if (!isValid(Message.class, "title", title) || !isValid(Message.class, "content", content)) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}
		if (draftMessage != null && draftMessage.getIsDraft()) {
			messageService.delete(draftMessage);
		}
		Member receiver = null;
		if (StringUtils.isNotEmpty(username)) {
			receiver = memberService.findByUsername(username);
			if (currentUser.equals(receiver)) {
				return UNPROCESSABLE_ENTITY_VIEW;
			}
		}
		Message message = new Message();
		message.setTitle(title);
		message.setContent(content);
		message.setIp(request.getRemoteAddr());
		message.setIsDraft(isDraft);
		message.setSenderRead(true);
		message.setReceiverRead(false);
		message.setSenderDelete(false);
		message.setReceiverDelete(false);
		message.setSender(currentUser);
		message.setReceiver(receiver);
		message.setForMessage(null);
		message.setReplyMessages(null);
		messageService.save(message);
		if (isDraft) {
			addFlashMessage(redirectAttributes, "member.message.saveDraftSuccess");
			return "redirect:draft";
		} else {
			addFlashMessage(redirectAttributes, "member.message.sendSuccess");
			return "redirect:list";
		}
	}

	/**
	 * 查看
	 */
	@GetMapping("/view")
	public String view(@ModelAttribute(binding = false, name = "memberMessage") Message memberMessage, @CurrentUser Member currentUser, Model model) {
		if (memberMessage == null || memberMessage.getIsDraft() || memberMessage.getForMessage() != null) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}
		if ((currentUser.equals(memberMessage.getReceiver()) && memberMessage.getReceiverDelete()) || (currentUser.equals(memberMessage.getSender()) && memberMessage.getSenderDelete())) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}
		if (currentUser.equals(memberMessage.getReceiver())) {
			memberMessage.setReceiverRead(true);
		} else {
			memberMessage.setSenderRead(true);
		}
		messageService.update(memberMessage);
		model.addAttribute("memberMessage", memberMessage);
		return "member/message/view";
	}

	/**
	 * 回复
	 */
	@PostMapping("/reply")
	public String reply(@ModelAttribute(binding = false, name = "memberMessage") Message memberMessage, String content, @CurrentUser Member currentUser, HttpServletRequest request, RedirectAttributes redirectAttributes) {
		if (!isValid(Message.class, "content", content)) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}
		if (memberMessage == null || memberMessage.getIsDraft() || memberMessage.getForMessage() != null) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}
		if ((currentUser.equals(memberMessage.getReceiver()) && memberMessage.getReceiverDelete()) || (currentUser.equals(memberMessage.getSender()) && memberMessage.getSenderDelete())) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}
		Message message = new Message();
		message.setTitle("reply: " + memberMessage.getTitle());
		message.setContent(content);
		message.setIp(request.getRemoteAddr());
		message.setIsDraft(false);
		message.setSenderRead(true);
		message.setReceiverRead(false);
		message.setSenderDelete(false);
		message.setReceiverDelete(false);
		message.setSender(currentUser);
		message.setReceiver(currentUser.equals(memberMessage.getReceiver()) ? memberMessage.getSender() : memberMessage.getReceiver());
		message.setForMessage(null);
		message.setReplyMessages(null);
		if ((currentUser.equals(memberMessage.getReceiver()) && !memberMessage.getSenderDelete()) || (currentUser.equals(memberMessage.getSender()) && !memberMessage.getReceiverDelete())) {
			message.setForMessage(memberMessage);
		}
		messageService.save(message);

		if (currentUser.equals(memberMessage.getSender())) {
			memberMessage.setSenderRead(true);
			memberMessage.setReceiverRead(false);
		} else {
			memberMessage.setSenderRead(false);
			memberMessage.setReceiverRead(true);
		}
		messageService.update(memberMessage);

		if ((currentUser.equals(memberMessage.getReceiver()) && !memberMessage.getSenderDelete()) || (currentUser.equals(memberMessage.getSender()) && !memberMessage.getReceiverDelete())) {
			addFlashMessage(redirectAttributes, SUCCESS_MESSAGE);
			return "redirect:view?memberMessageId=" + memberMessage.getId();
		} else {
			addFlashMessage(redirectAttributes, "member.message.replySuccess");
			return "redirect:list";
		}
	}

	/**
	 * 列表
	 */
	@GetMapping("/list")
	public String list(Integer pageNumber, @CurrentUser Member currentUser, Model model) {
		Pageable pageable = new Pageable(pageNumber, PAGE_SIZE);
		model.addAttribute("page", messageService.findPage(currentUser, pageable));
		return "member/message/list";
	}

	/**
	 * 列表
	 */
	@GetMapping(path = "/list", produces = MediaType.APPLICATION_JSON_VALUE)
	@JsonView(BaseEntity.BaseView.class)
	public ResponseEntity<?> list(Integer pageNumber, @CurrentUser Member currentUser) {
		Pageable pageable = new Pageable(pageNumber, PAGE_SIZE);
		return ResponseEntity.ok(messageService.findPage(currentUser, pageable).getContent());
	}

	/**
	 * 草稿箱
	 */
	@GetMapping("/draft")
	public String draft(Integer pageNumber, @CurrentUser Member currentUser, Model model) {
		Pageable pageable = new Pageable(pageNumber, PAGE_SIZE);
		model.addAttribute("page", messageService.findDraftPage(currentUser, pageable));
		return "member/message/draft";
	}

	/**
	 * 草稿箱
	 */
	@GetMapping(path = "/draft", produces = MediaType.APPLICATION_JSON_VALUE)
	@JsonView(BaseEntity.BaseView.class)
	public ResponseEntity<?> draft(Integer pageNumber, @CurrentUser Member currentUser) {
		Pageable pageable = new Pageable(pageNumber, PAGE_SIZE);
		return ResponseEntity.ok(messageService.findDraftPage(currentUser, pageable).getContent());
	}

	/**
	 * 删除
	 */
	@PostMapping("/delete")
	public ResponseEntity<?> delete(Long messageId, @CurrentUser Member currentUser) {
		messageService.delete(messageId, currentUser);
		return Results.OK;
	}

}