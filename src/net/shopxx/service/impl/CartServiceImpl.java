/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.service.impl;

import javax.inject.Inject;
import javax.persistence.LockModeType;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringUtils;
import org.springframework.context.ApplicationEventPublisher;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.Assert;

import net.shopxx.dao.CartDao;
import net.shopxx.dao.CartItemDao;
import net.shopxx.entity.Cart;
import net.shopxx.entity.CartItem;
import net.shopxx.entity.Member;
import net.shopxx.entity.Sku;
import net.shopxx.event.CartAddedEvent;
import net.shopxx.event.CartClearedEvent;
import net.shopxx.event.CartMergedEvent;
import net.shopxx.event.CartModifiedEvent;
import net.shopxx.event.CartRemovedEvent;
import net.shopxx.service.CartService;
import net.shopxx.service.UserService;
import net.shopxx.util.WebUtils;

/**
 * Service购物车
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Service
public class CartServiceImpl extends BaseServiceImpl<Cart, Long> implements CartService {

	@Inject
	private ApplicationEventPublisher applicationEventPublisher;
	@Inject
	private CartDao cartDao;
	@Inject
	private CartItemDao cartItemDao;
	@Inject
	private UserService userService;

	@Transactional(readOnly = true)
	public Cart getCurrent() {
		Member currentUser = userService.getCurrent(Member.class);
		return currentUser != null ? currentUser.getCart() : getAnonymousCart();
	}

	public Cart create() {
		Member currentUser = userService.getCurrent(Member.class, LockModeType.PESSIMISTIC_WRITE);
		if (currentUser != null && currentUser.getCart() != null) {
			return currentUser.getCart();
		}
		Cart cart = new Cart();
		if (currentUser != null) {
			cart.setMember(currentUser);
			currentUser.setCart(cart);
		}
		cartDao.persist(cart);
		return cart;
	}

	public void add(Cart cart, Sku sku, int quantity) {
		Assert.notNull(cart);
		Assert.isTrue(!cart.isNew());
		Assert.notNull(sku);
		Assert.isTrue(!sku.isNew());
		Assert.state(quantity > 0);

		addInternal(cart, sku, quantity);

		applicationEventPublisher.publishEvent(new CartAddedEvent(this, cart, sku, quantity));
	}

	public void modify(Cart cart, Sku sku, int quantity) {
		Assert.notNull(cart);
		Assert.isTrue(!cart.isNew());
		Assert.notNull(sku);
		Assert.isTrue(!sku.isNew());
		Assert.isTrue(cart.contains(sku, null));
		Assert.state(quantity > 0);

		if (CartItem.MAX_QUANTITY != null && quantity > CartItem.MAX_QUANTITY) {
			return;
		}

		CartItem cartItem = cart.getCartItem(sku, null);
		cartItem.setQuantity(quantity);

		applicationEventPublisher.publishEvent(new CartModifiedEvent(this, cart, sku, quantity));
	}

	public void remove(Cart cart, Sku sku) {
		Assert.notNull(cart);
		Assert.isTrue(!cart.isNew());
		Assert.notNull(sku);
		Assert.isTrue(!sku.isNew());
		Assert.isTrue(cart.contains(sku, null));

		CartItem cartItem = cart.getCartItem(sku, null);
		cartItemDao.remove(cartItem);
		cart.remove(cartItem);

		applicationEventPublisher.publishEvent(new CartRemovedEvent(this, cart, sku));
	}

	public void clear(Cart cart) {
		Assert.notNull(cart);
		Assert.isTrue(!cart.isNew());

		for (CartItem cartItem : cart) {
			cartItemDao.remove(cartItem);
		}
		cart.clear();

		applicationEventPublisher.publishEvent(new CartClearedEvent(this, cart));
	}

	public void merge(Cart cart) {
		Assert.notNull(cart);
		Assert.isTrue(!cart.isNew());
		Assert.notNull(cart.getMember());

		Cart anonymousCart = getAnonymousCart();
		if (anonymousCart != null) {
			for (CartItem cartItem : anonymousCart) {
				Sku sku = cartItem.getSku();
				int quantity = cartItem.getQuantity();
				addInternal(cart, sku, quantity);
			}
			cartDao.remove(anonymousCart);
		}

		applicationEventPublisher.publishEvent(new CartMergedEvent(this, cart));
	}

	public void deleteExpired() {
		cartDao.deleteExpired();
	}

	/**
	 * 获取匿名购物车
	 * 
	 * @return 匿名购物车，若不存在则返回null
	 */
	private Cart getAnonymousCart() {
		HttpServletRequest request = WebUtils.getRequest();
		if (request == null) {
			return null;
		}
		String key = WebUtils.getCookie(request, Cart.KEY_COOKIE_NAME);
		Cart cart = StringUtils.isNotEmpty(key) ? cartDao.find("key", key) : null;
		return cart != null && cart.getMember() == null ? cart : null;
	}

	/**
	 * 添加购物车SKU
	 * 
	 * @param cart
	 *            购物车
	 * @param sku
	 *            SKU
	 * @param quantity
	 *            数量
	 */
	private void addInternal(Cart cart, Sku sku, int quantity) {
		Assert.notNull(cart);
		Assert.isTrue(!cart.isNew());
		Assert.notNull(sku);
		Assert.isTrue(!sku.isNew());
		Assert.state(quantity > 0);

		if (cart.contains(sku, null)) {
			CartItem cartItem = cart.getCartItem(sku, null);
			if (CartItem.MAX_QUANTITY != null && cartItem.getQuantity() + quantity > CartItem.MAX_QUANTITY) {
				return;
			}
			cartItem.add(quantity);
		} else {
			if (Cart.MAX_CART_ITEM_SIZE != null && cart.size() >= Cart.MAX_CART_ITEM_SIZE) {
				return;
			}
			if (CartItem.MAX_QUANTITY != null && quantity > CartItem.MAX_QUANTITY) {
				return;
			}
			CartItem cartItem = new CartItem();
			cartItem.setQuantity(quantity);
			cartItem.setSku(sku);
			cartItem.setCart(cart);
			cartItemDao.persist(cartItem);
			cart.add(cartItem);
		}
	}

}