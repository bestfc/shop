/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.dao.impl;

import org.springframework.stereotype.Repository;

import net.shopxx.dao.DeliveryCorpDao;
import net.shopxx.entity.DeliveryCorp;

import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Predicate;
import javax.persistence.criteria.Root;
import java.util.List;

/**
 * Dao物流公司
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Repository
public class DeliveryCorpDaoImpl extends BaseDaoImpl<DeliveryCorp, Long> implements DeliveryCorpDao {

    @Override
    public List<DeliveryCorp> findUseTotal() {
        CriteriaBuilder criteriaBuilder = entityManager.getCriteriaBuilder();
        CriteriaQuery<DeliveryCorp> criteriaQuery = criteriaBuilder.createQuery(DeliveryCorp.class);
        Root<DeliveryCorp> root = criteriaQuery.from(DeliveryCorp.class);
        criteriaQuery.select(root);
        Predicate restrictions = criteriaBuilder.conjunction();
        restrictions = criteriaBuilder.and(restrictions, criteriaBuilder.and(criteriaBuilder.equal(root.get("bUse"), true)));
        criteriaQuery.where(restrictions);
        return super.findList(criteriaQuery, null, null, null, null);
    }
}