package net.shopxx.service;

import net.shopxx.entity.ShippingTraces;

import java.util.Set;

public interface ShippingTracesService extends BaseService<ShippingTraces,Long> {
    ShippingTraces findByCode(String deliveryCorpCode,String trackingNo);
    Set<ShippingTraces> findOrderTraces(Long id);

}
