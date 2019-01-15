package net.shopxx.entity;

import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.OneToOne;
import javax.validation.constraints.NotNull;

/**
 * Entity支付事务取消
 * 
 * @author fantiejia Team
 * @version 5.0
 */
@Entity
public class PaymentTransactionCancel extends BaseEntity<Long> {

	private static final long serialVersionUID = 5940192764031208143L;

	@NotNull
	@OneToOne(fetch = FetchType.LAZY)
	private PaymentTransaction paymentTransaction;

	private String reason;
	private Boolean bFinishCancel;

	public String getReason() {
		return reason;
	}

	public void setReason(String reason) {
		this.reason = reason;
	}
	public Boolean getbFinishCancel() {
		return bFinishCancel;
	}

	public void setbFinishCancel(Boolean bFinishCancel) {
		this.bFinishCancel = bFinishCancel;
	}

	public PaymentTransaction getPaymentTransaction() {
		return paymentTransaction;
	}

	public void setPaymentTransaction(PaymentTransaction paymentTransaction) {
		this.paymentTransaction = paymentTransaction;
	}
}