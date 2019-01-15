/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.service.impl;

import java.util.ArrayList;
import java.util.List;

import javax.inject.Inject;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.Assert;

import net.shopxx.entity.SitemapIndex;
import net.shopxx.entity.SitemapUrl;
import net.shopxx.service.SitemapIndexService;
import net.shopxx.service.SitemapUrlService;

/**
 * ServiceSitemap索引
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Service
public class SitemapIndexServiceImpl implements SitemapIndexService {

	@Inject
	private SitemapUrlService sitemapUrlService;

	@Transactional(readOnly = true)
	public List<SitemapIndex> generate(SitemapUrl.Type type, int maxSitemapUrlSize) {
		Assert.notNull(type);
		Assert.state(maxSitemapUrlSize >= 0);

		List<SitemapIndex> sitemapIndexs = new ArrayList<>();
		Long sitemapUrlSize = sitemapUrlService.count(type);
		for (int i = 0; i < Math.ceil((double) sitemapUrlSize / (double) maxSitemapUrlSize); i++) {
			SitemapIndex sitemapIndex = new SitemapIndex();
			sitemapIndex.setType(type);
			sitemapIndex.setIndex(i);
			sitemapIndexs.add(sitemapIndex);
		}
		return sitemapIndexs;
	}

}