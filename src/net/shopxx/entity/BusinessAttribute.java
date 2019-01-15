/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.entity;

import java.util.ArrayList;
import java.util.List;

import javax.persistence.Column;
import javax.persistence.Convert;
import javax.persistence.Converter;
import javax.persistence.Entity;
import javax.validation.constraints.NotNull;

import org.hibernate.validator.constraints.Length;
import org.hibernate.validator.constraints.NotEmpty;

import net.shopxx.BaseAttributeConverter;

/**
 * Entity商家注册项
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Entity
public class BusinessAttribute extends OrderedEntity<Long> {

	private static final long serialVersionUID = -2636800237333705047L;

	/**
	 * 类型
	 */
	public enum Type {

		/**
		 * 名称
		 */
		name,

		/**
		 * 营业执照
		 */
		licenseNumber,

		/**
		 * 营业执照图片
		 */
		licenseImage,

		/**
		 * 法人姓名
		 */
		legalPerson,

		/**
		 * 法人身份证
		 */
		idCard,

		/**
		 * 法人身份证图片
		 */
		idCardImage,

		/**
		 * 电话
		 */
		phone,

		/**
		 * 组织机构代码
		 */
		organizationCode,

		/**
		 * 组织机构代码证图片
		 */
		organizationImage,

		/**
		 * 纳税人识别号
		 */
		identificationNumber,

		/**
		 * 税务登记证图片
		 */
		taxImage,

		/**
		 * 银行开户名
		 */
		bankName,

		/**
		 * 公司银行账号
		 */
		bankAccount,

		/**
		 * 文本
		 */
		text,

		/**
		 * 单选项
		 */
		select,

		/**
		 * 多选项
		 */
		checkbox,

		/**
		 * 图片
		 */
		image,

		/**
		 * 日期
		 */
		date
	}

	/**
	 * 名称
	 */
	@NotEmpty
	@Length(max = 200)
	@Column(nullable = false)
	private String name;

	/**
	 * 类型
	 */
	@NotNull(groups = Save.class)
	@Column(nullable = false, updatable = false)
	private BusinessAttribute.Type type;

	/**
	 * 配比
	 */
	@Length(max = 200)
	private String pattern;

	/**
	 * 是否启用
	 */
	@NotNull
	@Column(nullable = false)
	private Boolean isEnabled;

	/**
	 * 是否必填
	 */
	@NotNull
	@Column(nullable = false)
	private Boolean isRequired;

	/**
	 * 属性序号
	 */
	@Column(updatable = false)
	private Integer propertyIndex;

	/**
	 * 可选项
	 */
	@Column(length = 4000)
	@Convert(converter = OptionConverter.class)
	private List<String> options = new ArrayList<>();

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
	 * 获取类型
	 * 
	 * @return 类型
	 */
	public BusinessAttribute.Type getType() {
		return type;
	}

	/**
	 * 设置类型
	 * 
	 * @param type
	 *            类型
	 */
	public void setType(BusinessAttribute.Type type) {
		this.type = type;
	}

	/**
	 * 获取配比
	 * 
	 * @return 配比
	 */
	public String getPattern() {
		return pattern;
	}

	/**
	 * 设置配比
	 * 
	 * @param pattern
	 *            配比
	 */
	public void setPattern(String pattern) {
		this.pattern = pattern;
	}

	/**
	 * 获取是否启用
	 * 
	 * @return 是否启用
	 */
	public Boolean getIsEnabled() {
		return isEnabled;
	}

	/**
	 * 设置是否启用
	 * 
	 * @param isEnabled
	 *            是否启用
	 */
	public void setIsEnabled(Boolean isEnabled) {
		this.isEnabled = isEnabled;
	}

	/**
	 * 获取是否必填
	 * 
	 * @return 是否必填
	 */
	public Boolean getIsRequired() {
		return isRequired;
	}

	/**
	 * 设置是否必填
	 * 
	 * @param isRequired
	 *            是否必填
	 */
	public void setIsRequired(Boolean isRequired) {
		this.isRequired = isRequired;
	}

	/**
	 * 获取属性序号
	 * 
	 * @return 属性序号
	 */
	public Integer getPropertyIndex() {
		return propertyIndex;
	}

	/**
	 * 设置属性序号
	 * 
	 * @param propertyIndex
	 *            属性序号
	 */
	public void setPropertyIndex(Integer propertyIndex) {
		this.propertyIndex = propertyIndex;
	}

	/**
	 * 获取可选项
	 * 
	 * @return 可选项
	 */
	public List<String> getOptions() {
		return options;
	}

	/**
	 * 设置可选项
	 * 
	 * @param options
	 *            可选项
	 */
	public void setOptions(List<String> options) {
		this.options = options;
	}

	/**
	 * 类型转换可选项
	 * 
	 * @author SHOP++ Team
	 * @version 5.0
	 */
	@Converter
	public static class OptionConverter extends BaseAttributeConverter<List<String>> {
	}

}