package net.shopxx.util.alibaba.model;



/**
 * @author  作者 tom
 * @date 创建时间：2018年1月25日 上午10:29:13
 * @version 1.0
 */
public class AlipayCFG {

	
	public static class TradeStatus{
		/**
		 * 交易创建，等待买家付款
		 */
		public static final String WAIT_BUYER_PAY = "WAIT_BUYER_PAY";
		/**
		 * 未付款交易超时关闭，或支付完成后全额退款
		 */
		public static final String TRADE_CLOSED = "TRADE_CLOSED";
		
		/**
		 * 交易支付成功
		 */
		public static final String TRADE_SUCCESS = "TRADE_SUCCESS";
		
		/**
		 * 交易结束，不可退款
		 */
		public static final String TRADE_FINISHED = "TRADE_FINISHED";
	}
	
	public static enum RequestStatus{
		SUCCESS("10000"),
		FAILURE("40004"),
		WAIT_BUYER_PAY("10003"),
		UNKNOW_ERROE("20000");
		
		private String code;

		private RequestStatus(String code) {
			this.code = code;
		}

		public String getCode() {
			return code;
		}
	}
}
