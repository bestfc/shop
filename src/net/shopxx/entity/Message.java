/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.entity;

import java.util.HashSet;
import java.util.Set;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.OrderBy;

import org.hibernate.validator.constraints.Length;
import org.hibernate.validator.constraints.NotEmpty;

import com.fasterxml.jackson.annotation.JsonView;

/**
 * Entity消息
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Entity
public class Message extends BaseEntity<Long> {

	private static final long serialVersionUID = -5035343536762850722L;

	/**
	 * 标题
	 */
	@JsonView(BaseView.class)
	@NotEmpty
	@Column(nullable = false, updatable = false)
	private String title;

	/**
	 * 内容
	 */
	@NotEmpty
	@Length(max = 4000)
	@Column(nullable = false, updatable = false, length = 4000)
	private String content;

	/**
	 * ip
	 */
	@Column(nullable = false, updatable = false)
	private String ip;

	/**
	 * 是否为草稿
	 */
	@Column(nullable = false, updatable = false)
	private Boolean isDraft;

	/**
	 * 发件人已读
	 */
	@JsonView(BaseView.class)
	@Column(nullable = false)
	private Boolean senderRead;

	/**
	 * 收件人已读
	 */
	@JsonView(BaseView.class)
	@Column(nullable = false)
	private Boolean receiverRead;

	/**
	 * 发件人删除
	 */
	@Column(nullable = false)
	private Boolean senderDelete;

	/**
	 * 收件人删除
	 */
	@Column(nullable = false)
	private Boolean receiverDelete;

	/**
	 * 发件人
	 */
	@JsonView(BaseView.class)
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(updatable = false)
	private Member sender;

	/**
	 * 收件人
	 */
	@JsonView(BaseView.class)
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(updatable = false)
	private Member receiver;

	/**
	 * 原消息
	 */
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(updatable = false)
	private Message forMessage;

	/**
	 * 回复消息
	 */
	@OneToMany(mappedBy = "forMessage", fetch = FetchType.LAZY, cascade = CascadeType.REMOVE)
	@OrderBy(value = "createdDate asc")
	private Set<Message> replyMessages = new HashSet<>();

	/**
	 * 获取标题
	 * 
	 * @return 标题
	 */
	public String getTitle() {
		return title;
	}

	/**
	 * 设置标题
	 * 
	 * @param title
	 *            标题
	 */
	public void setTitle(String title) {
		this.title = title;
	}

	/**
	 * 获取内容
	 * 
	 * @return 内容
	 */
	public String getContent() {
		return content;
	}

	/**
	 * 设置内容
	 * 
	 * @param content
	 *            内容
	 */
	public void setContent(String content) {
		this.content = content;
	}

	/**
	 * 获取ip
	 * 
	 * @return ip
	 */
	public String getIp() {
		return ip;
	}

	/**
	 * 设置ip
	 * 
	 * @param ip
	 *            ip
	 */
	public void setIp(String ip) {
		this.ip = ip;
	}

	/**
	 * 获取是否为草稿
	 * 
	 * @return 是否为草稿
	 */
	public Boolean getIsDraft() {
		return isDraft;
	}

	/**
	 * 设置是否为草稿
	 * 
	 * @param isDraft
	 *            是否为草稿
	 */
	public void setIsDraft(Boolean isDraft) {
		this.isDraft = isDraft;
	}

	/**
	 * 获取发件人已读
	 * 
	 * @return 发件人已读
	 */
	public Boolean getSenderRead() {
		return senderRead;
	}

	/**
	 * 设置发件人已读
	 * 
	 * @param senderRead
	 *            发件人已读
	 */
	public void setSenderRead(Boolean senderRead) {
		this.senderRead = senderRead;
	}

	/**
	 * 获取收件人已读
	 * 
	 * @return 收件人已读
	 */
	public Boolean getReceiverRead() {
		return receiverRead;
	}

	/**
	 * 设置收件人已读
	 * 
	 * @param receiverRead
	 *            收件人已读
	 */
	public void setReceiverRead(Boolean receiverRead) {
		this.receiverRead = receiverRead;
	}

	/**
	 * 获取发件人删除
	 * 
	 * @return 发件人删除
	 */
	public Boolean getSenderDelete() {
		return senderDelete;
	}

	/**
	 * 设置发件人删除
	 * 
	 * @param senderDelete
	 *            发件人删除
	 */
	public void setSenderDelete(Boolean senderDelete) {
		this.senderDelete = senderDelete;
	}

	/**
	 * 获取收件人删除
	 * 
	 * @return 收件人删除
	 */
	public Boolean getReceiverDelete() {
		return receiverDelete;
	}

	/**
	 * 设置收件人删除
	 * 
	 * @param receiverDelete
	 *            收件人删除
	 */
	public void setReceiverDelete(Boolean receiverDelete) {
		this.receiverDelete = receiverDelete;
	}

	/**
	 * 获取发件人
	 * 
	 * @return 发件人
	 */
	public Member getSender() {
		return sender;
	}

	/**
	 * 设置发件人
	 * 
	 * @param sender
	 *            发件人
	 */
	public void setSender(Member sender) {
		this.sender = sender;
	}

	/**
	 * 获取收件人
	 * 
	 * @return 收件人
	 */
	public Member getReceiver() {
		return receiver;
	}

	/**
	 * 设置收件人
	 * 
	 * @param receiver
	 *            收件人
	 */
	public void setReceiver(Member receiver) {
		this.receiver = receiver;
	}

	/**
	 * 获取原消息
	 * 
	 * @return 原消息
	 */
	public Message getForMessage() {
		return forMessage;
	}

	/**
	 * 设置原消息
	 * 
	 * @param forMessage
	 *            原消息
	 */
	public void setForMessage(Message forMessage) {
		this.forMessage = forMessage;
	}

	/**
	 * 获取回复消息
	 * 
	 * @return 回复消息
	 */
	public Set<Message> getReplyMessages() {
		return replyMessages;
	}

	/**
	 * 设置回复消息
	 * 
	 * @param replyMessages
	 *            回复消息
	 */
	public void setReplyMessages(Set<Message> replyMessages) {
		this.replyMessages = replyMessages;
	}

}