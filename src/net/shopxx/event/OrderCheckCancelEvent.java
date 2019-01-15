package net.shopxx.event;

import net.shopxx.entity.Order;
import org.springframework.context.ApplicationEvent;

public class OrderCheckCancelEvent extends ApplicationEvent {
    private Order order;
    public OrderCheckCancelEvent(Object source, Order order) {
        super(source);
        this.order = order;
    }
    public Order getOrder() {
        return order;
    }
}
