/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.event;

import net.shopxx.entity.User;

/**
 * Event用户注册
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
public class UserRegisteredEvent extends UserEvent {

	private static final long serialVersionUID = 3930447081075693577L;

	/**
	 * 构造方法
	 * 
	 * @param source
	 *            事件源
	 * @param user
	 *            用户
	 */
	public UserRegisteredEvent(Object source, User user) {
		super(source, user);
	}

}