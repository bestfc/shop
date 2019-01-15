package net.shopxx.entity;

import com.fasterxml.jackson.annotation.JsonView;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Lob;

@Entity
public class ShippingTraces extends BaseEntity<Long> {
    private static final long serialVersionUID = -261737051893669935L;
    /**
     * 运单号
     */
    @JsonView(BaseView.class)
    @Column(nullable = false, updatable = false)
    private String trackingNo;

    /**
     * 物流公司代码
     */
    @JsonView(BaseView.class)
    @Column(updatable = false)
    private String deliveryCorpCode;

    /**
     * 物流公司名
     */
    @JsonView(BaseView.class)
    @Column(updatable = false)
    private String deliveryCorp;

    /**
     * 物流信息，Json数组形式
     */
    @JsonView(BaseView.class)
    @Lob
    @Column(columnDefinition = "TEXT")
    private String traces;

    public String getTrackingNo() {
        return trackingNo;
    }

    public void setTrackingNo(String trackingNo) {
        this.trackingNo = trackingNo;
    }

    public String getDeliveryCorpCode() {
        return deliveryCorpCode;
    }

    public void setDeliveryCorpCode(String deliveryCorpCode) {
        this.deliveryCorpCode = deliveryCorpCode;
    }

    public String getDeliveryCorp() {
        return deliveryCorp;
    }

    public void setDeliveryCorp(String deliveryCorp) {
        this.deliveryCorp = deliveryCorp;
    }

    public String getTraces() {
        return traces;
    }

    public void setTraces(String traces) {
        this.traces = traces;
    }
}
