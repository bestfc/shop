package net.shopxx.dao.impl;

import net.shopxx.dao.PaymentTransactionCancelDao;
import net.shopxx.entity.PaymentTransactionCancel;
import org.springframework.stereotype.Repository;

import javax.persistence.TypedQuery;
import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Predicate;
import javax.persistence.criteria.Root;
import java.util.Date;
import java.util.List;

@Repository
public class PaymentTransactionCancelDaoImpl extends BaseDaoImpl<PaymentTransactionCancel, Long> implements PaymentTransactionCancelDao {
    @Override
    public List<PaymentTransactionCancel> findCancelList() {
        CriteriaBuilder criteriaBuilder = entityManager.getCriteriaBuilder();
        CriteriaQuery<PaymentTransactionCancel> criteriaQuery = criteriaBuilder.createQuery(PaymentTransactionCancel.class);
        Root<PaymentTransactionCancel> root = criteriaQuery.from(PaymentTransactionCancel.class);
        criteriaQuery.select(root);
        Predicate restrictions = criteriaBuilder.conjunction();
        //微信要求15s之后才能调用cancel接口
        Date searchDate = new Date(new Date().getTime()20 * 1000);
        restrictions = criteriaBuilder.and(restrictions, criteriaBuilder.lessThanOrEqualTo(root.<Date>get("createdDate"), searchDate));
        restrictions = criteriaBuilder.and(restrictions, criteriaBuilder.notEqual(root.<Date>get("bFinishCancel"), true));
        criteriaQuery.where(restrictions);
        TypedQuery<PaymentTransactionCancel> query = entityManager.createQuery(criteriaQuery);
        return query.getResultList();
    }
}
