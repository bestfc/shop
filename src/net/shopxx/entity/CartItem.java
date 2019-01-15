/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.entity;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Transient;

import com.fasterxml.jackson.annotation.JsonView;

import net.shopxx.Setting;
import net.shopxx.util.SystemUtils;

/**
 * Entity购物车项
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Entity
public class CartItem extends BaseEntity<Long> {

	private static final long serialVersionUID = 2979296789363163144L;

	/**
	 * 最大数量
	 */
	public static final Integer MAX_QUANTITY = 10000;

	/**
	 * 数量
	 */
	@JsonView(BaseView.class)
	@Column(nullable = false)
	private Integer quantity;

	/**
	 * SKU
	 */
	@JsonView(BaseView.class)
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(nullable = false, updatable = false)
	private Sku sku;

	/**
	 * 购物车
	 */
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(nullable = false, updatable = false)
	private Cart cart;

	/**
	 * 获取数量
	 * 
	 * @return 数量
	 */
	public Integer getQuantity() {
		return quantity;
	}

	/**
	 * 设置数量
	 * 
	 * @param quantity
	 *            数量
	 */
	public void setQuantity(Integer quantity) {
		this.quantity = quantity;
	}

	/**
	 * 获取SKU
	 * 
	 * @return SKU
	 */
	public Sku getSku() {
		return sku;
	}

	/**
	 * 设置SKU
	 * 
	 * @param sku
	 *            SKU
	 */
	public void setSku(Sku sku) {
		this.sku = sku;
	}

	/**
	 * 获取购物车
	 * 
	 * @return 购物车
	 */
	public Cart getCart() {
		return cart;
	}

	/**
	 * 设置购物车
	 * 
	 * @param cart
	 *            购物车
	 */
	public void setCart(Cart cart) {
		this.cart = cart;
	}

	/**
	 * 获取SKU重量
	 * 
	 * @return SKU重量
	 */
	@Transient
	public int getWeight() {
		if (getSku() != null && getSku().getWeight() != null && getQuantity() != null) {
			return getSku().getWeight() * getQuantity();
		} else {
			return 0;
		}
	}

	/**
	 * 获取赠送积分
	 * 
	 * @return 赠送积分
	 */
	@Transient
	public long getRewardPoint() {
		if (getSku() != null && getSku().getRewardPoint() != null && getQuantity() != null) {
			return getSku().getRewardPoint() * getQuantity();
		} else {
			return 0L;
		}
	}

	/**
	 * 获取兑换积分
	 * 
	 * @return 兑换积分
	 */
	@Transient
	public long getExchangePoint() {
		if (getSku() != null && getSku().getExchangePoint() != null && getQuantity() != null) {
			return getSku().getExchangePoint() * getQuantity();
		} else {
			return 0L;
		}
	}

	/**
	 * 获取价格
	 * 
	 * @return 价格
	 */
	@Transient
	public BigDecimal getPrice() {
		if (getSku() != null && getSku().getPrice() != null) {
			Setting setting = SystemUtils.getSetting();
			if (getCart() != null && getCart().getMember() != null && getCart().getMember().getMemberRank() != null) {
				MemberRank memberRank = getCart().getMember().getMemberRank();
				if (memberRank.getScale() != null) {
					return setting.setScale(getSku().getPrice().multiply(new BigDecimal(String.valueOf(memberRank.getScale()))));
				}
			}
			return setting.setScale(getSku().getPrice());
		} else {
			return BigDecimal.ZERO;
		}
	}

	/**
	 * 获取小计
	 * 
	 * @return 小计
	 */
	@JsonView(BaseView.class)
	@Transient
	public BigDecimal getSubtotal() {
		if (getQuantity() != null) {
			return getPrice().multiply(new BigDecimal(getQuantity()));
		} else {
			return BigDecimal.ZERO;
		}
	}

	/**
	 * 获取是否有效
	 * 
	 * @return 是否有效
	 */
	@Transient
	public boolean getIsActive() {
		return getSku() != null && getSku().getIsActive();
	}

	/**
	 * 获取是否上架
	 * 
	 * @return 是否上架
	 */
	@Transient
	public boolean getIsMarketable() {
		return getSku() != null && getSku().getIsMarketable();
	}

	/**
	 * 获取是否需要物流
	 * 
	 * @return 是否需要物流
	 */
	@Transient
	public boolean getIsDelivery() {
		return getSku() != null && getSku().getIsDelivery();
	}

	/**
	 * 获取是否库存不足
	 * 
	 * @return 是否库存不足
	 */
	@JsonView(BaseView.class)
	@Transient
	public boolean getIsLowStock() {
		return getQuantity() != null && getSku() != null && getQuantity() > getSku().getAvailableStock();
	}

	/**
	 * 增加SKU数量
	 * 
	 * @param quantity
	 *            数量
	 */
	@Transient
	public void add(int quantity) {
		if (quantity < 1) {
			return;
		}
		if (getQuantity() != null) {
			setQuantity(getQuantity() + quantity);
		} else {
			setQuantity(quantity);
		}
	}

	/**
	 * 获取店铺
	 * 
	 * @return 店铺
	 */
	@Transient
	public Store getStore() {
		if (getSku() != null && getSku().getProduct() != null) {
			return getSku().getProduct().getStore();
		}
		return null;
	}

	/**
	 * 获取促销名称
	 * 
	 * @param store
	 *            店铺
	 * @return 促销名称
	 */
	@Transient
	public List<String> getPromotionNames(Store store) {
		List<String> promotionNames = new ArrayList<>();
		for (Promotion promotion : getSku().getValidPromotions()) {
			if (promotion.getStore().equals(store)) {
				promotionNames.add(promotion.getName());
			}
		}
		return promotionNames;
	}

}