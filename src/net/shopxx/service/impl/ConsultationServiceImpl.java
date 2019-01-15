/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.service.impl;

import java.util.Collections;
import java.util.List;

import javax.inject.Inject;

import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import net.shopxx.Filter;
import net.shopxx.Order;
import net.shopxx.Page;
import net.shopxx.Pageable;
import net.shopxx.dao.ConsultationDao;
import net.shopxx.dao.MemberDao;
import net.shopxx.dao.ProductDao;
import net.shopxx.entity.Consultation;
import net.shopxx.entity.Member;
import net.shopxx.entity.Product;
import net.shopxx.entity.Store;
import net.shopxx.service.ConsultationService;

/**
 * Service咨询
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Service
public class ConsultationServiceImpl extends BaseServiceImpl<Consultation, Long> implements ConsultationService {

	@Inject
	private ConsultationDao consultationDao;
	@Inject
	private MemberDao memberDao;
	@Inject
	private ProductDao productDao;

	@Transactional(readOnly = true)
	public List<Consultation> findList(Member member, Product product, Boolean isShow, Integer count, List<Filter> filters, List<Order> orders) {
		return consultationDao.findList(member, product, isShow, count, filters, orders);
	}

	@Transactional(readOnly = true)
	@Cacheable(value = "consultation", condition = "#useCache")
	public List<Consultation> findList(Long memberId, Long productId, Boolean isShow, Integer count, List<Filter> filters, List<Order> orders, boolean useCache) {
		Member member = memberDao.find(memberId);
		if (memberId != null && member == null) {
			return Collections.emptyList();
		}
		Product product = productDao.find(productId);
		if (productId != null && product == null) {
			return Collections.emptyList();
		}
		return consultationDao.findList(member, product, isShow, count, filters, orders);
	}

	@Transactional(readOnly = true)
	public Page<Consultation> findPage(Member member, Product product, Store store, Boolean isShow, Pageable pageable) {
		return consultationDao.findPage(member, product, store, isShow, pageable);
	}

	@Transactional(readOnly = true)
	public Long count(Member member, Product product, Boolean isShow) {
		return consultationDao.count(member, product, isShow);
	}

	@CacheEvict(value = "consultation", allEntries = true)
	public void reply(Consultation consultation, Consultation replyConsultation) {
		if (consultation == null || replyConsultation == null) {
			return;
		}
		consultation.setIsShow(true);

		replyConsultation.setIsShow(true);
		replyConsultation.setProduct(consultation.getProduct());
		replyConsultation.setForConsultation(consultation);
		replyConsultation.setStore(consultation.getStore());
		consultationDao.persist(replyConsultation);
	}

	@Override
	@Transactional
	@CacheEvict(value = "consultation", allEntries = true)
	public Consultation save(Consultation consultation) {
		return super.save(consultation);
	}

	@Override
	@Transactional
	@CacheEvict(value = "consultation", allEntries = true)
	public Consultation update(Consultation consultation) {
		return super.update(consultation);
	}

	@Override
	@Transactional
	@CacheEvict(value = "consultation", allEntries = true)
	public Consultation update(Consultation consultation, String... ignoreProperties) {
		return super.update(consultation, ignoreProperties);
	}

	@Override
	@Transactional
	@CacheEvict(value = "consultation", allEntries = true)
	public void delete(Long id) {
		super.delete(id);
	}

	@Override
	@Transactional
	@CacheEvict(value = "consultation", allEntries = true)
	public void delete(Long... ids) {
		super.delete(ids);
	}

	@Override
	@Transactional
	@CacheEvict(value = "consultation", allEntries = true)
	public void delete(Consultation consultation) {
		super.delete(consultation);
	}

}