/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.entity;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;

/**
 * Entity库存记录
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Entity
public class StockLog extends BaseEntity<Long> {

	private static final long serialVersionUID = 5550452675645134078L;

	/**
	 * 类型
	 */
	public enum Type {

		/**
		 * 入库
		 */
		stockIn,

		/**
		 * 出库
		 */
		stockOut
	}

	/**
	 * 类型
	 */
	@Column(nullable = false, updatable = false)
	private StockLog.Type type;

	/**
	 * 入库数量
	 */
	@Column(nullable = false, updatable = false)
	private Integer inQuantity;

	/**
	 * 出库数量
	 */
	@Column(nullable = false, updatable = false)
	private Integer outQuantity;

	/**
	 * 当前库存
	 */
	@Column(nullable = false, updatable = false)
	private Integer stock;

	/**
	 * 备注
	 */
	@Column(updatable = false)
	private String memo;

	/**
	 * SKU
	 */
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(nullable = false, updatable = false)
	private Sku sku;

	/**
	 * 获取类型
	 * 
	 * @return 类型
	 */
	public StockLog.Type getType() {
		return type;
	}

	/**
	 * 设置类型
	 * 
	 * @param type
	 *            类型
	 */
	public void setType(StockLog.Type type) {
		this.type = type;
	}

	/**
	 * 获取入库数量
	 * 
	 * @return 入库数量
	 */
	public Integer getInQuantity() {
		return inQuantity;
	}

	/**
	 * 设置入库数量
	 * 
	 * @param inQuantity
	 *            入库数量
	 */
	public void setInQuantity(Integer inQuantity) {
		this.inQuantity = inQuantity;
	}

	/**
	 * 获取出库数量
	 * 
	 * @return 出库数量
	 */
	public Integer getOutQuantity() {
		return outQuantity;
	}

	/**
	 * 设置出库数量
	 * 
	 * @param outQuantity
	 *            出库数量
	 */
	public void setOutQuantity(Integer outQuantity) {
		this.outQuantity = outQuantity;
	}

	/**
	 * 获取当前库存
	 * 
	 * @return 当前库存
	 */
	public Integer getStock() {
		return stock;
	}

	/**
	 * 设置当前库存
	 * 
	 * @param stock
	 *            当前库存
	 */
	public void setStock(Integer stock) {
		this.stock = stock;
	}

	/**
	 * 获取备注
	 * 
	 * @return 备注
	 */
	public String getMemo() {
		return memo;
	}

	/**
	 * 设置备注
	 * 
	 * @param memo
	 *            备注
	 */
	public void setMemo(String memo) {
		this.memo = memo;
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

}