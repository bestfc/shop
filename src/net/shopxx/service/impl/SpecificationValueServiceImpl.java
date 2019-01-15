/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.service.impl;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.util.Assert;

import net.shopxx.entity.SpecificationItem;
import net.shopxx.entity.SpecificationValue;
import net.shopxx.service.SpecificationValueService;

/**
 * Service规格值
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Service
public class SpecificationValueServiceImpl implements SpecificationValueService {

	public boolean isValid(List<SpecificationItem> specificationItems, List<SpecificationValue> specificationValues) {
		Assert.notEmpty(specificationItems);
		Assert.notEmpty(specificationValues);

		if (specificationValues.size() != specificationValues.size()) {
			return false;
		}
		for (int i = 0; i < specificationValues.size(); i++) {
			SpecificationItem specificationItem = specificationItems.get(i);
			SpecificationValue specificationValue = specificationValues.get(i);
			if (specificationItem == null || specificationValue == null || !specificationItem.isValid(specificationValue)) {
				return false;
			}
		}
		return true;
	}

}