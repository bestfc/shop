/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.event;

import net.shopxx.entity.Cart;
import net.shopxx.entity.Sku;

/**
 * Event移除购物车SKU
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
public class CartRemovedEvent extends CartEvent {

	private static final long serialVersionUID = 6638396637072338544L;

	/**
	 * SKU
	 */
	private Sku sku;

	/**
	 * 构造方法
	 * 
	 * @param source
	 *            事件源
	 * @param cart
	 *            购物车
	 * @param sku
	 *            SKU
	 */
	public CartRemovedEvent(Object source, Cart cart, Sku sku) {
		super(source, cart);
		this.sku = sku;
	}

	/**
	 * 获取SKU
	 * 
	 * @return SKU
	 */
	public Sku getSku() {
		return sku;
	}

}