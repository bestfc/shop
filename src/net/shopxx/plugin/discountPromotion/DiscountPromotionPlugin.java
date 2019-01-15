/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.plugin.discountPromotion;

import org.springframework.stereotype.Component;

import net.shopxx.entity.Promotion;
import net.shopxx.plugin.PromotionPlugin;

/**
 * Plugin折扣促销
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Component("discountPromotionPlugin")
public class DiscountPromotionPlugin extends PromotionPlugin {

	/**
	 * ID
	 */
	public static final String ID = "discountPromotionPlugin";

	@Override
	public String getName() {
		return "折扣促销";
	}

	@Override
	public String getVersion() {
		return "1.0";
	}

	@Override
	public String getAuthor() {
		return "SHOP++";
	}

	@Override
	public String getInstallUrl() {
		return "discount_promotion/install";
	}

	@Override
	public String getUninstallUrl() {
		return "discount_promotion/uninstall";
	}

	@Override
	public String getSettingUrl() {
		return "discount_promotion/setting";
	}

	@Override
	public String getPriceExpression(Promotion promotion, Boolean useAmountPromotion, Boolean useNumberPromotion) {
		if (promotion.getDiscount() == null) {
			return "";
		}
		if (promotion.getDiscount() < 1) {
			return "price*" + String.valueOf(promotion.getDiscount());
		} else {
			return "price-" + String.valueOf(promotion.getDiscount());
		}
	}

}