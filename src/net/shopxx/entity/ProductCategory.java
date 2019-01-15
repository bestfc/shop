/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.entity;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.ManyToMany;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.OrderBy;
import javax.persistence.PreRemove;
import javax.persistence.Transient;
import javax.validation.constraints.Digits;
import javax.validation.constraints.Min;
import javax.validation.constraints.NotNull;

import org.apache.commons.lang.StringUtils;
import org.hibernate.validator.constraints.Length;
import org.hibernate.validator.constraints.NotEmpty;

import freemarker.core.Environment;
import freemarker.template.TemplateException;
import net.shopxx.util.FreeMarkerUtils;

/**
 * Entity商品分类
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Entity
public class ProductCategory extends OrderedEntity<Long> {

	private static final long serialVersionUID = 5095521437302782717L;

	/**
	 * 树路径分隔符
	 */
	public static final String TREE_PATH_SEPARATOR = ",";

	/**
	 * 路径
	 */
	private static final String PATH = "/product/list/%d";

	/**
	 * 名称
	 */
	@NotEmpty
	@Length(max = 200)
	@Column(nullable = false)
	private String name;

	/**
	 * 页面标题
	 */
	@Length(max = 200)
	private String seoTitle;

	/**
	 * 页面关键词
	 */
	@Length(max = 200)
	private String seoKeywords;

	/**
	 * 页面描述
	 */
	@Length(max = 200)
	private String seoDescription;

	/**
	 * 普通店铺分佣比例
	 */
	@NotNull
	@Min(0)
	@Digits(integer = 3, fraction = 3)
	@Column(nullable = false, precision = 12, scale = 6)
	private Double generalRate;

	/**
	 * 自营店铺分佣比例
	 */
	@NotNull
	@Min(0)
	@Digits(integer = 3, fraction = 3)
	@Column(nullable = false, precision = 12, scale = 6)
	private Double selfRate;

	/**
	 * 树路径
	 */
	@Column(nullable = false)
	private String treePath;

	/**
	 * 层级
	 */
	@Column(nullable = false)
	private Integer grade;

	/**
	 * 上级分类
	 */
	@ManyToOne(fetch = FetchType.LAZY)
	private ProductCategory parent;

	/**
	 * 下级分类
	 */
	@OneToMany(mappedBy = "parent", fetch = FetchType.LAZY)
	@OrderBy("order asc")
	private Set<ProductCategory> children = new HashSet<>();

	/**
	 * 商品
	 */
	@OneToMany(mappedBy = "productCategory", fetch = FetchType.LAZY)
	private Set<Product> products = new HashSet<>();

	/**
	 * 关联品牌
	 */
	@ManyToMany(fetch = FetchType.LAZY)
	@OrderBy("order asc")
	private Set<Brand> brands = new HashSet<>();

	/**
	 * 关联促销
	 */
	@ManyToMany(fetch = FetchType.LAZY)
	@OrderBy("order asc")
	private Set<Promotion> promotions = new HashSet<>();

	/**
	 * 参数
	 */
	@OneToMany(mappedBy = "productCategory", fetch = FetchType.LAZY, cascade = CascadeType.REMOVE)
	@OrderBy("order asc")
	private Set<Parameter> parameters = new HashSet<>();

	/**
	 * 属性
	 */
	@OneToMany(mappedBy = "productCategory", fetch = FetchType.LAZY, cascade = CascadeType.REMOVE)
	@OrderBy("order asc")
	private Set<Attribute> attributes = new HashSet<>();

	/**
	 * 规格
	 */
	@OneToMany(mappedBy = "productCategory", fetch = FetchType.LAZY, cascade = CascadeType.REMOVE)
	@OrderBy("order asc")
	private Set<Specification> specifications = new HashSet<>();

	/**
	 * 店铺
	 */
	@ManyToMany(mappedBy = "productCategories", fetch = FetchType.LAZY)
	private Set<Store> stores = new HashSet<>();

	/**
	 * 经营分类申请
	 */
	@OneToMany(mappedBy = "productCategory", fetch = FetchType.LAZY, cascade = CascadeType.REMOVE)
	private Set<CategoryApplication> categoryApplications = new HashSet<>();

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
	 * 获取页面标题
	 * 
	 * @return 页面标题
	 */
	public String getSeoTitle() {
		return seoTitle;
	}

	/**
	 * 设置页面标题
	 * 
	 * @param seoTitle
	 *            页面标题
	 */
	public void setSeoTitle(String seoTitle) {
		this.seoTitle = seoTitle;
	}

	/**
	 * 获取页面关键词
	 * 
	 * @return 页面关键词
	 */
	public String getSeoKeywords() {
		return seoKeywords;
	}

	/**
	 * 设置页面关键词
	 * 
	 * @param seoKeywords
	 *            页面关键词
	 */
	public void setSeoKeywords(String seoKeywords) {
		this.seoKeywords = seoKeywords;
	}

	/**
	 * 获取页面描述
	 * 
	 * @return 页面描述
	 */
	public String getSeoDescription() {
		return seoDescription;
	}

	/**
	 * 设置页面描述
	 * 
	 * @param seoDescription
	 *            页面描述
	 */
	public void setSeoDescription(String seoDescription) {
		this.seoDescription = seoDescription;
	}

	/**
	 * 获取普通店铺分佣比例
	 * 
	 * @return 普通店铺分佣比例
	 */
	public Double getGeneralRate() {
		return generalRate;
	}

	/**
	 * 设置普通店铺分佣比例
	 * 
	 * @param generalRate
	 *            普通店铺分佣比例
	 */
	public void setGeneralRate(Double generalRate) {
		this.generalRate = generalRate;
	}

	/**
	 * 获取自营店铺分佣比例
	 * 
	 * @return 自营店铺分佣比例
	 */
	public Double getSelfRate() {
		return selfRate;
	}

	/**
	 * 设置自营店铺分佣比例
	 * 
	 * @param selfRate
	 *            自营店铺分佣比例
	 */
	public void setSelfRate(Double selfRate) {
		this.selfRate = selfRate;
	}

	/**
	 * 获取树路径
	 * 
	 * @return 树路径
	 */
	public String getTreePath() {
		return treePath;
	}

	/**
	 * 设置树路径
	 * 
	 * @param treePath
	 *            树路径
	 */
	public void setTreePath(String treePath) {
		this.treePath = treePath;
	}

	/**
	 * 获取层级
	 * 
	 * @return 层级
	 */
	public Integer getGrade() {
		return grade;
	}

	/**
	 * 设置层级
	 * 
	 * @param grade
	 *            层级
	 */
	public void setGrade(Integer grade) {
		this.grade = grade;
	}

	/**
	 * 获取上级分类
	 * 
	 * @return 上级分类
	 */
	public ProductCategory getParent() {
		return parent;
	}

	/**
	 * 设置上级分类
	 * 
	 * @param parent
	 *            上级分类
	 */
	public void setParent(ProductCategory parent) {
		this.parent = parent;
	}

	/**
	 * 获取下级分类
	 * 
	 * @return 下级分类
	 */
	public Set<ProductCategory> getChildren() {
		return children;
	}

	/**
	 * 设置下级分类
	 * 
	 * @param children
	 *            下级分类
	 */
	public void setChildren(Set<ProductCategory> children) {
		this.children = children;
	}

	/**
	 * 获取商品
	 * 
	 * @return 商品
	 */
	public Set<Product> getProducts() {
		return products;
	}

	/**
	 * 设置商品
	 * 
	 * @param products
	 *            商品
	 */
	public void setProducts(Set<Product> products) {
		this.products = products;
	}

	/**
	 * 获取关联品牌
	 * 
	 * @return 关联品牌
	 */
	public Set<Brand> getBrands() {
		return brands;
	}

	/**
	 * 设置关联品牌
	 * 
	 * @param brands
	 *            关联品牌
	 */
	public void setBrands(Set<Brand> brands) {
		this.brands = brands;
	}

	/**
	 * 获取关联促销
	 * 
	 * @return 关联促销
	 */
	public Set<Promotion> getPromotions() {
		return promotions;
	}

	/**
	 * 设置关联促销
	 * 
	 * @param promotions
	 *            关联促销
	 */
	public void setPromotions(Set<Promotion> promotions) {
		this.promotions = promotions;
	}

	/**
	 * 获取参数
	 * 
	 * @return 参数
	 */
	public Set<Parameter> getParameters() {
		return parameters;
	}

	/**
	 * 设置参数
	 * 
	 * @param parameters
	 *            参数
	 */
	public void setParameters(Set<Parameter> parameters) {
		this.parameters = parameters;
	}

	/**
	 * 获取属性
	 * 
	 * @return 属性
	 */
	public Set<Attribute> getAttributes() {
		return attributes;
	}

	/**
	 * 设置属性
	 * 
	 * @param attributes
	 *            属性
	 */
	public void setAttributes(Set<Attribute> attributes) {
		this.attributes = attributes;
	}

	/**
	 * 获取规格
	 * 
	 * @return 规格
	 */
	public Set<Specification> getSpecifications() {
		return specifications;
	}

	/**
	 * 设置规格
	 * 
	 * @param specifications
	 *            规格
	 */
	public void setSpecifications(Set<Specification> specifications) {
		this.specifications = specifications;
	}

	/**
	 * 获取店铺
	 * 
	 * @return 店铺
	 */
	public Set<Store> getStores() {
		return stores;
	}

	/**
	 * 设置店铺
	 * 
	 * @param stores
	 *            店铺
	 */
	public void setStores(Set<Store> stores) {
		this.stores = stores;
	}

	/**
	 * 获取经营分类申请
	 * 
	 * @return 经营分类申请
	 */
	public Set<CategoryApplication> getCategoryApplications() {
		return categoryApplications;
	}

	/**
	 * 设置经营分类申请
	 * 
	 * @param categoryApplications
	 *            经营分类申请
	 */
	public void setCategoryApplications(Set<CategoryApplication> categoryApplications) {
		this.categoryApplications = categoryApplications;
	}

	/**
	 * 获取路径
	 * 
	 * @return 路径
	 */
	@Transient
	public String getPath() {
		return String.format(ProductCategory.PATH, getId());
	}

	/**
	 * 获取所有上级分类ID
	 * 
	 * @return 所有上级分类ID
	 */
	@Transient
	public Long[] getParentIds() {
		String[] parentIds = StringUtils.split(getTreePath(), TREE_PATH_SEPARATOR);
		Long[] result = new Long[parentIds.length];
		for (int i = 0; i < parentIds.length; i++) {
			result[i] = Long.valueOf(parentIds[i]);
		}
		return result;
	}

	/**
	 * 获取所有上级分类
	 * 
	 * @return 所有上级分类
	 */
	@Transient
	public List<ProductCategory> getParents() {
		List<ProductCategory> parents = new ArrayList<>();
		recursiveParents(parents, this);
		return parents;
	}

	/**
	 * 解析页面标题
	 * 
	 * @return 页面标题
	 */
	@Transient
	public String resolveSeoTitle() {
		try {
			Environment environment = FreeMarkerUtils.getCurrentEnvironment();
			return FreeMarkerUtils.process(getSeoTitle(), environment != null ? environment.getDataModel() : null);
		} catch (IOException e) {
			return null;
		} catch (TemplateException e) {
			return null;
		}
	}

	/**
	 * 解析页面关键词
	 * 
	 * @return 页面关键词
	 */
	@Transient
	public String resolveSeoKeywords() {
		try {
			Environment environment = FreeMarkerUtils.getCurrentEnvironment();
			return FreeMarkerUtils.process(getSeoKeywords(), environment != null ? environment.getDataModel() : null);
		} catch (IOException e) {
			return null;
		} catch (TemplateException e) {
			return null;
		}
	}

	/**
	 * 解析页面描述
	 * 
	 * @return 页面描述
	 */
	@Transient
	public String resolveSeoDescription() {
		try {
			Environment environment = FreeMarkerUtils.getCurrentEnvironment();
			return FreeMarkerUtils.process(getSeoDescription(), environment != null ? environment.getDataModel() : null);
		} catch (IOException e) {
			return null;
		} catch (TemplateException e) {
			return null;
		}
	}

	/**
	 * 递归上级分类
	 * 
	 * @param parents
	 *            上级分类
	 * @param productCategory
	 *            商品分类
	 */
	private void recursiveParents(List<ProductCategory> parents, ProductCategory productCategory) {
		if (productCategory == null) {
			return;
		}
		ProductCategory parent = productCategory.getParent();
		if (parent != null) {
			parents.add(0, parent);
			recursiveParents(parents, parent);
		}
	}

	/**
	 * 删除前处理
	 */
	@PreRemove
	public void preRemove() {
		Set<Store> stores = getStores();
		if (stores != null) {
			for (Store store : stores) {
				store.getProductCategories().remove(this);
			}
		}
	}

}