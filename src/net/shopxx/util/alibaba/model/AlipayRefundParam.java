package net.shopxx.util.alibaba.model;

/**
 * @author  作者 tom
 * @date 创建时间：2018年1月25日 上午10:10:07
 * @version 1.0
 */
public class AlipayRefundParam {
	
	/**
	 * 商户订单号
	 */
	private String outTradeNo;

	/**
	 * 支付宝交易号
	 */
	private String tradeNo;

	/**
	 * 订单no保证不重复
	 */
	private String out_request_no;
	
	/**
	 * 退款金额
	 */
	private String refundAmount;
	
	/**
	 * 退款原因
	 */
	private String refundReason;
	
	/**
	 * 操作员Id
	 */
	private String operatorId;
	
	/**
	 * 商户的门店编号
	 */
	private String storeId;
	
	/**
	 * 商户的终端编号
	 */
	private String terminalId;

	public String getOut_request_no() {
		return out_request_no;
	}

	public void setOut_request_no(String out_request_no) {
		this.out_request_no = out_request_no;
	}

	public String getOutTradeNo() {
		return outTradeNo;
	}

	public void setOutTradeNo(String outTradeNo) {
		this.outTradeNo = outTradeNo;
	}

	public String getStoreId() {
		return storeId;
	}

	public void setStoreId(String storeId) {
		this.storeId = storeId;
	}
	
	public String getTradeNo() {
		return tradeNo;
	}

	public void setTradeNo(String tradeNo) {
		this.tradeNo = tradeNo;
	}

	public String getRefundAmount() {
		return refundAmount;
	}

	public void setRefundAmount(String refundAmount) {
		this.refundAmount = refundAmount;
	}

	public String getRefundReason() {
		return refundReason;
	}

	public void setRefundReason(String refundReason) {
		this.refundReason = refundReason;
	}

	public String getOperatorId() {
		return operatorId;
	}

	public void setOperatorId(String operatorId) {
		this.operatorId = operatorId;
	}

	public String getTerminalId() {
		return terminalId;
	}

	public void setTerminalId(String terminalId) {
		this.terminalId = terminalId;
	}

	public String toString(){
		return "{" +
				"\"out_trade_no\":\""+ outTradeNo + "\"" +
				",\"refund_amount\":\""+ refundAmount + "\"" +
				",\"refund_reason\":\""+ refundReason + "\"" +
				(storeId == null ? "" : ",\"store_id\":\""+ storeId + "\"") +
				(operatorId == null ? "" : ",\"operator_id\":\""+ operatorId + "\"") +
				(terminalId == null ? "" : ",\"terminal_id\":\""+ terminalId + "\"") +
				(out_request_no == null ? "" : ",\"out_request_no\":\""+ out_request_no + "\"") +
				"  }";
	}
	
	public static void main(String[] args) {
		AlipayRefundParam alipayParam = new AlipayRefundParam.Builder()
		.outTradeNo("1234567")
		.storeId("11111")
		.build();
		System.out.println(alipayParam.toString());
	}
	
	public static class Builder{
		/**
		 * 商户订单号，需要保证不重复
		 */
		private String outTradeNo;
		
		/**
		 * 支付宝交易号
		 */
		private String tradeNo;
		/**
		 * 订单no保证不重复
		 */
		private String out_request_no;

		/**
		 * 退款金额
		 */
		private String refundAmount;
		
		/**
		 * 退款原因
		 */
		private String refundReason;
		
		/**
		 * 操作员Id
		 */
		private String operatorId;
		
		/**
		 * 商户的门店编号
		 */
		private String storeId;
		
		/**
		 * 商户的终端编号
		 */
		private String terminalId;

		public Builder() {
			super();
		}
		
		public Builder outTradeNo(String outTradeNo) {
			this.outTradeNo = outTradeNo;
			return this;
		}

		public Builder tradeNo(String tradeNo) {
			this.tradeNo = tradeNo;
			return this;
		}

		public Builder refundAmount(String refundAmount) {
			this.refundAmount = refundAmount;
			return this;
		}

		public Builder refundReason(String refundReason) {
			this.refundReason = refundReason;
			return this;
		}

		public Builder storeId(String storeId) {
			this.storeId = storeId;
			return this;
		}

		public Builder operatorId(String operatorId) {
			this.operatorId = operatorId;
			return this;
		}

		public Builder terminalId(String terminalId) {
			this.terminalId = terminalId;
			return this;
		}

		public Builder out_request_no(String out_request_no){
			this.out_request_no = out_request_no;
			return this;
		}
		
		
		public AlipayRefundParam build(){
			return new AlipayRefundParam(this);
		}
	}

	public AlipayRefundParam(Builder builder) {
		super();
		this.outTradeNo = builder.outTradeNo;
		this.tradeNo = builder.tradeNo;
		this.refundAmount = builder.refundAmount;
		this.refundReason = builder.refundReason;
		this.storeId = builder.storeId;
		this.operatorId = builder.operatorId;
		this.terminalId = builder.terminalId;
		this.out_request_no = builder.out_request_no;
	}
	
	
}
