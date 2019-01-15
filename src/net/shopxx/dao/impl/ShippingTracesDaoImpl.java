package net.shopxx.dao.impl;


import net.shopxx.dao.ShippingTracesDao;
import net.shopxx.entity.ShippingTraces;
import org.springframework.stereotype.Repository;

import javax.persistence.Query;
import java.util.List;

@Repository
public class ShippingTracesDaoImpl extends BaseDaoImpl<ShippingTraces,Long> implements ShippingTracesDao {
    @Override
    public ShippingTraces findByCode(String deliveryCorpCode, String trackingNo) {

        Query query=entityManager.createQuery("Select s from ShippingTraces s where s.deliveryCorpCode=:deliveryCorpCode and s.trackingNo=:trackingNo");
        query.setParameter("deliveryCorpCode",deliveryCorpCode);
        query.setParameter("trackingNo",trackingNo);
        List list = query.getResultList();
        if(list.size()>=1){
            return (ShippingTraces) query.getResultList().get(0);
        }
        else {
            return null;
        }
    }
}
