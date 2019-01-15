/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.entity;

import java.lang.reflect.InvocationTargetException;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.Lob;
import javax.persistence.ManyToOne;
import javax.validation.constraints.Min;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Pattern;

import org.apache.commons.beanutils.PropertyUtils;
import org.apache.commons.lang.StringUtils;
import org.hibernate.validator.constraints.Length;
import org.hibernate.validator.constraints.NotEmpty;

/**
 * Entity快递单模板
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Entity
public class DeliveryTemplate extends BaseEntity<Long> {

	private static final long serialVersionUID = -3711024981692804054L;

	/**
	 * 属性标签名称
	 */
	private static final String ATTRIBUTE_TAG_NMAE = "{%s}";

	/**
	 * 店铺属性
	 */
	public enum StoreAttribute {

		/**
		 * 店铺名称
		 */
		storeName("name"),

		/**
		 * 店铺E-mail
		 */
		storeEmail("email"),

		/**
		 * 店铺手机
		 */
		storeMobile("mobile"),

		/**
		 * 店铺电话
		 */
		storePhone("phone"),

		/**
		 * 店铺地址
		 */
		storeAddress("address"),

		/**
		 * 店铺邮编
		 */
		storeZipCode("zipCode");

		/**
		 * 名称
		 */
		private String name;

		/**
		 * 构造方法
		 * 
		 * @param name
		 *            名称
		 */
		StoreAttribute(String name) {
			this.name = name;
		}

		/**
		 * 获取标签名称
		 * 
		 * @return 标签名称
		 */
		public String getTagName() {
			return String.format(DeliveryTemplate.ATTRIBUTE_TAG_NMAE, toString());
		}

		/**
		 * 获取值
		 * 
		 * @param store
		 *            店铺
		 * @return 值
		 */
		public String getValue(Store store) {
			if (store == null) {
				return null;
			}

			try {
				Object value = PropertyUtils.getProperty(store, name);
				return value != null ? String.valueOf(value) : StringUtils.EMPTY;
			} catch (IllegalAccessException e) {
				throw new RuntimeException(e.getMessage(), e);
			} catch (InvocationTargetException e) {
				throw new RuntimeException(e.getMessage(), e);
			} catch (NoSuchMethodException e) {
				throw new RuntimeException(e.getMessage(), e);
			}
		}

	}

	/**
	 * 发货点属性
	 */
	public enum DeliveryCenterAttribute {

		/**
		 * 发货点名称
		 */
		deliveryCenterName("name"),

		/**
		 * 发货点联系人
		 */
		deliveryCenterContact("contact"),

		/**
		 * 发货点地区
		 */
		deliveryCenterAreaName("areaName"),

		/**
		 * 发货点地址
		 */
		deliveryCenterAddress("address"),

		/**
		 * 发货点邮编
		 */
		deliveryCenterZipCode("zipCode"),

		/**
		 * 发货点电话
		 */
		deliveryCenterPhone("phone"),

		/**
		 * 发货点手机
		 */
		deliveryCenterMobile("mobile");

		/**
		 * 名称
		 */
		private String name;

		/**
		 * 构造方法
		 * 
		 * @param name
		 *            名称
		 */
		DeliveryCenterAttribute(String name) {
			this.name = name;
		}

		/**
		 * 获取标签名称
		 * 
		 * @return 标签名称
		 */
		public String getTagName() {
			return String.format(DeliveryTemplate.ATTRIBUTE_TAG_NMAE, toString());
		}

		/**
		 * 获取值
		 * 
		 * @param deliveryCenter
		 *            发货点
		 * @return 值
		 */
		public String getValue(DeliveryCenter deliveryCenter) {
			if (deliveryCenter == null) {
				return null;
			}

			try {
				Object value = PropertyUtils.getProperty(deliveryCenter, name);
				return value != null ? String.valueOf(value) : StringUtils.EMPTY;
			} catch (IllegalAccessException e) {
				throw new RuntimeException(e.getMessage(), e);
			} catch (InvocationTargetException e) {
				throw new RuntimeException(e.getMessage(), e);
			} catch (NoSuchMethodException e) {
				throw new RuntimeException(e.getMessage(), e);
			}
		}

	}

	/**
	 * 订单属性
	 */
	public enum OrderAttribute {

		/**
		 * 订单编号
		 */
		orderSn("sn"),

		/**
		 * 订单收货人
		 */
		orderConsignee("consignee"),

		/**
		 * 订单收货地区
		 */
		orderAreaName("areaName"),

		/**
		 * 订单收货地址
		 */
		orderAddress("address"),

		/**
		 * 订单收货邮编
		 */
		orderZipCode("zipCode"),

		/**
		 * 订单收货电话
		 */
		orderPhone("phone"),

		/**
		 * 订单附言
		 */
		orderMemo("memo");

		/**
		 * 名称
		 */
		private String name;

		/**
		 * 构造方法
		 * 
		 * @param name
		 *            名称
		 */
		OrderAttribute(String name) {
			this.name = name;
		}

		/**
		 * 获取标签名称
		 * 
		 * @return 标签名称
		 */
		public String getTagName() {
			return String.format(DeliveryTemplate.ATTRIBUTE_TAG_NMAE, toString());
		}

		/**
		 * 获取值
		 * 
		 * @param order
		 *            订单
		 * @return 值
		 */
		public String getValue(Order order) {
			if (order == null) {
				return null;
			}

			try {
				Object value = PropertyUtils.getProperty(order, name);
				return value != null ? String.valueOf(value) : StringUtils.EMPTY;
			} catch (IllegalAccessException e) {
				throw new RuntimeException(e.getMessage(), e);
			} catch (InvocationTargetException e) {
				throw new RuntimeException(e.getMessage(), e);
			} catch (NoSuchMethodException e) {
				throw new RuntimeException(e.getMessage(), e);
			}
		}

	}

	/**
	 * 名称
	 */
	@NotEmpty
	@Length(max = 200)
	@Column(nullable = false)
	private String name;

	/**
	 * 内容
	 */
	@NotEmpty
	@Lob
	@Column(nullable = false)
	private String content;

	/**
	 * 宽度
	 */
	@NotNull
	@Min(1)
	@Column(nullable = false)
	private Integer width;

	/**
	 * 高度
	 */
	@NotNull
	@Min(1)
	@Column(nullable = false)
	private Integer height;

	/**
	 * 偏移量X
	 */
	@NotNull
	@Column(nullable = false)
	private Integer offsetX;

	/**
	 * 偏移量Y
	 */
	@NotNull
	@Column(nullable = false)
	private Integer offsetY;

	/**
	 * 背景图
	 */
	@Length(max = 200)
	@Pattern(regexp = "^(?i)(http:\\/\\/|https:\\/\\/|\\/).*$")
	private String background;

	/**
	 * 是否默认
	 */
	@NotNull
	@Column(nullable = false)
	private Boolean isDefault;

	/**
	 * 备注
	 */
	@Length(max = 200)
	private String memo;

	/**
	 * 店铺
	 */
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(nullable = false, updatable = false)
	private Store store;

	/**
	 * 获取名称
	 * 
	 * @return 名称
	 */
	public String getName() {
		return name;
	}

	/**
	 * 设置名称
	 * 
	 * @param name
	 *            名称
	 */
	public void setName(String name) {
		this.name = name;
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
	 * 获取宽度
	 * 
	 * @return 宽度
	 */
	public Integer getWidth() {
		return width;
	}

	/**
	 * 设置宽度
	 * 
	 * @param width
	 *            宽度
	 */
	public void setWidth(Integer width) {
		this.width = width;
	}

	/**
	 * 获取高度
	 * 
	 * @return 高度
	 */
	public Integer getHeight() {
		return height;
	}

	/**
	 * 设置高度
	 * 
	 * @param height
	 *            高度
	 */
	public void setHeight(Integer height) {
		this.height = height;
	}

	/**
	 * 获取偏移量X
	 * 
	 * @return 偏移量X
	 */
	public Integer getOffsetX() {
		return offsetX;
	}

	/**
	 * 设置偏移量X
	 * 
	 * @param offsetX
	 *            偏移量X
	 */
	public void setOffsetX(Integer offsetX) {
		this.offsetX = offsetX;
	}

	/**
	 * 获取偏移量Y
	 * 
	 * @return 偏移量Y
	 */
	public Integer getOffsetY() {
		return offsetY;
	}

	/**
	 * 设置偏移量Y
	 * 
	 * @param offsetY
	 *            偏移量Y
	 */
	public void setOffsetY(Integer offsetY) {
		this.offsetY = offsetY;
	}

	/**
	 * 获取背景图
	 * 
	 * @return 背景图
	 */
	public String getBackground() {
		return background;
	}

	/**
	 * 设置背景图
	 * 
	 * @param background
	 *            背景图
	 */
	public void setBackground(String background) {
		this.background = background;
	}

	/**
	 * 获取是否默认
	 * 
	 * @return 是否默认
	 */
	public Boolean getIsDefault() {
		return isDefault;
	}

	/**
	 * 设置是否默认
	 * 
	 * @param isDefault
	 *            是否默认
	 */
	public void setIsDefault(Boolean isDefault) {
		this.isDefault = isDefault;
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
	 * 获取店铺
	 * 
	 * @return 店铺
	 */
	public Store getStore() {
		return store;
	}

	/**
	 * 设置店铺
	 * 
	 * @param store
	 *            店铺
	 */
	public void setStore(Store store) {
		this.store = store;
	}

}