package net.shopxx.service.impl;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import net.shopxx.dao.ShippingTracesDao;
import net.shopxx.entity.Order;
import net.shopxx.entity.OrderShipping;
import net.shopxx.entity.ShippingTraces;
import net.shopxx.plugin.kdniaoExpress.KdniaoTrackQuery;
import net.shopxx.plugin.kdniaoExpress.TrackinfoModel;
import net.shopxx.service.OrderService;
import net.shopxx.service.ShippingTracesService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashSet;
import java.util.Set;

@Service
public class ShippingTracesServiceImpl  extends BaseServiceImpl<ShippingTraces,Long> implements ShippingTracesService {
    @Autowired
    ShippingTracesDao shippingTracesDao;
    @Autowired
    OrderService orderService;
    @Autowired
    KdniaoTrackQuery kdniaoTrackQuery;

    @Override
    public ShippingTraces findByCode(String deliveryCorpCode, String trackingNo) {

        return shippingTracesDao.findByCode(deliveryCorpCode,trackingNo);
    }

    @Override
    public Set<ShippingTraces> findOrderTraces(Long id) {
        Set<ShippingTraces> shippingTracesSet = new HashSet<>();
        Order order = orderService.find(id);
        Set<OrderShipping> orderShippings = order.getOrderShippings();
        for (OrderShipping orderShipping : orderShippings){
            String deliveryCorpCode = orderShipping.getDeliveryCorpCode();
            String trackingNo = orderShipping.getTrackingNo();
            if(trackingNo!=null && !trackingNo.equals("")){
                ShippingTraces shippingTraces = findByCode(deliveryCorpCode,trackingNo);
                if(shippingTraces == null){
                    try {
                        TrackinfoModel info = kdniaoTrackQuery.getOrderTracesByJson(deliveryCorpCode,trackingNo);
                        if(info.getSuccess()){
                            shippingTraces = new ShippingTraces();
                            shippingTraces.setDeliveryCorpCode(deliveryCorpCode);
                            shippingTraces.setDeliveryCorp(orderShipping.getDeliveryCorp());
                            shippingTraces.setTrackingNo(trackingNo);
                            System.out.println(JSON.toJSONString(info.getTraces()));
                            shippingTraces.setTraces(JSON.toJSONString(info.getTraces()));
                        }else {
                            continue;
                        }
                    } catch (Exception e) {
                        throw new RuntimeException(e.getMessage(),e);
                    }
                }
                shippingTracesSet.add(shippingTraces);
            }
        }
        return shippingTracesSet;
    }
}
