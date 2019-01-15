/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.event;

import net.shopxx.entity.Cart;

/**
 * Event清空购物车SKU
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
public class CartClearedEvent extends CartEvent {

	private static final long serialVersionUID = -5881246837387897341L;

	/**
	 * 构造方法
	 * 
	 * @param source
	 *            事件源
	 * @param cart
	 *            购物车
	 */
	public CartClearedEvent(Object source, Cart cart) {
		super(source, cart);
	}

}