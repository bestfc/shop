package net.shopxx.util.alibaba.model;

/**
 * @author  作者 tom
 * @date 创建时间：2018年1月25日 上午10:10:07
 * @version 1.0
 */
public class AlipayPayParam {
	
	/**
	 * 商户订单号，需要保证不重复
	 */
	private String outTradeNo;
	
	/**
	 * 条码支付固定传入bar_code
	 */
	private String scene = "bar_code";
	
	/**
	 * 用户付款码，25~30开头的长度为16~24位的数字，实际字符串长度以开发者获取的付款码长度为准
	 */
	private String authCode;
	
	/**
	 * 订单标题
	 */
	private String subject;
	
	/**
	 * 商户门店编号
	 */
	private String storeId;
	
	/**
	 * 订单金额
	 */
	private String totalAmount;
	
	/**
	 * 交易超时时间
	 */
	private String timeoutExpress = "2m";

	public String getOutTradeNo() {
		return outTradeNo;
	}

	public void setOutTradeNo(String outTradeNo) {
		this.outTradeNo = outTradeNo;
	}

	public String getScene() {
		return scene;
	}

	public void setScene(String scene) {
		this.scene = scene;
	}

	public String getAuthCode() {
		return authCode;
	}

	public void setAuthCode(String authCode) {
		this.authCode = authCode;
	}

	public String getSubject() {
		return subject;
	}

	public void setSubject(String subject) {
		this.subject = subject;
	}

	public String getStoreId() {
		return storeId;
	}

	public void setStoreId(String storeId) {
		this.storeId = storeId;
	}

	public String getTotalAmount() {
		return totalAmount;
	}

	public void setTotalAmount(String totalAmount) {
		this.totalAmount = totalAmount;
	}

	public String getTimeoutExpress() {
		return timeoutExpress;
	}

	public void setTimeoutExpress(String timeoutExpress) {
		this.timeoutExpress = timeoutExpress;
	}
	
	public String toString(){
		return "{" +
				"    \"out_trade_no\":\""+ outTradeNo + "\"," +
				"    \"scene\":\""+ scene + "\"," +
				"    \"auth_code\":\""+ authCode + "\"," +
				"    \"subject\":\""+ subject + "\"," +
				"    \"store_id\":\""+ storeId + "\"," +
				"    \"timeout_express\":\""+ timeoutExpress + "\"," +
				"    \"total_amount\":\""+ totalAmount + "\"" +
				"  }";
	}
	
	public static void main(String[] args) {
		AlipayPayParam alipayParam = new AlipayPayParam.Builder()
		.outTradeNo("1234567")
		.authCode("55555")
		.storeId("11111")
		.subject("aaaa")
		.totalAmount("99")
		.build();
		System.out.println(alipayParam.toString());
	}
	
	public static class Builder{
		/**
		 * 商户订单号，需要保证不重复
		 */
		private String outTradeNo;
		
		/**
		 * 条码支付固定传入bar_code
		 */
		private String scene = "bar_code";
		
		/**
		 * 用户付款码，25~30开头的长度为16~24位的数字，实际字符串长度以开发者获取的付款码长度为准
		 */
		private String authCode;
		
		/**
		 * 订单标题
		 */
		private String subject;
		
		/**
		 * 商户门店编号
		 */
		private String storeId;
		
		/**
		 * 订单金额
		 */
		private String totalAmount;
		
		/**
		 * 交易超时时间
		 */
		private String timeoutExpress = "2m";

		public Builder() {
			super();
		}

		public Builder(String outTradeNo, String authCode, String subject, String storeId, String totalAmount) {
			super();
			this.outTradeNo = outTradeNo;
			this.authCode = authCode;
			this.subject = subject;
			this.storeId = storeId;
			this.totalAmount = totalAmount;
		}

		public Builder outTradeNo(String outTradeNo) {
			this.outTradeNo = outTradeNo;
			return this;
		}

		public Builder scene(String scene) {
			this.scene = scene;
			return this;
		}

		public Builder authCode(String authCode) {
			this.authCode = authCode;
			return this;
		}

		public Builder subject(String subject) {
			this.subject = subject;
			return this;
		}

		public Builder storeId(String storeId) {
			this.storeId = storeId;
			return this;
		}

		public Builder totalAmount(String totalAmount) {
			this.totalAmount = totalAmount;
			return this;
		}

		public Builder timeoutExpress(String timeoutExpress) {
			this.timeoutExpress = timeoutExpress;
			return this;
		}
		
		
		public AlipayPayParam build(){
			return new AlipayPayParam(this);
		}
	}

	public AlipayPayParam(Builder builder) {
		super();
		this.outTradeNo = builder.outTradeNo;
		this.scene = builder.scene;
		this.authCode = builder.authCode;
		this.subject = builder.subject;
		this.storeId = builder.storeId;
		this.totalAmount = builder.totalAmount;
		this.timeoutExpress = builder.timeoutExpress;
	}
	
	
}
