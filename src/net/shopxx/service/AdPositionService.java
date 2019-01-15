/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.service;

import net.shopxx.entity.AdPosition;

/**
 * Service广告位
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
public interface AdPositionService extends BaseService<AdPosition, Long> {

	/**
	 * 查找广告位
	 * 
	 * @param id
	 *            ID
	 * @param useCache
	 *            是否使用缓存
	 * @return 广告位
	 */
	AdPosition find(Long id, boolean useCache);

}