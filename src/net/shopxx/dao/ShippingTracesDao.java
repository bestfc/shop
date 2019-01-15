package net.shopxx.dao;

import net.shopxx.entity.ShippingTraces;

public interface ShippingTracesDao extends BaseDao<ShippingTraces,Long>{
    ShippingTraces findByCode(String deliveryCorpCode,String trackingNo);
}
