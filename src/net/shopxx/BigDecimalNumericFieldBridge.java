/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx;

import java.math.BigDecimal;

import org.apache.lucene.document.Document;
import org.apache.lucene.index.IndexableField;
import org.hibernate.search.bridge.LuceneOptions;
import org.hibernate.search.bridge.TwoWayFieldBridge;

/**
 * BigDecimal类型转换
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
public class BigDecimalNumericFieldBridge implements TwoWayFieldBridge {

	/**
	 * 获取BigDecimal
	 * 
	 * @param name
	 *            名称
	 * @param document
	 *            Document
	 * @return BigDecimal
	 */
	@Override
	public Object get(String name, Document document) {
		IndexableField field = document.getField(name);
		return field != null ? new BigDecimal(field.stringValue()) : null;
	}

	/**
	 * 设置BigDecimal
	 * 
	 * @param name
	 *            名称
	 * @param value
	 *            值
	 * @param document
	 *            Document
	 * @param luceneOptions
	 *            LuceneOptions
	 */
	@Override
	public void set(String name, Object value, Document document, LuceneOptions luceneOptions) {
		if (value != null) {
			BigDecimal decimalValue = (BigDecimal) value;
			luceneOptions.addNumericFieldToDocument(name, decimalValue.doubleValue(), document);
		} else if (luceneOptions.indexNullAs() != null) {
			luceneOptions.addFieldToDocument(name, luceneOptions.indexNullAs(), document);
		}
	}

	/**
	 * 转换对象为字符串
	 * 
	 * @param object
	 *            对象
	 * @return 字符串
	 */
	@Override
	public final String objectToString(Object object) {
		return object != null ? object.toString() : null;
	}

}