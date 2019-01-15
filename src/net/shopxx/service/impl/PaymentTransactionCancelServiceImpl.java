package net.shopxx.service.impl;


import net.shopxx.dao.PaymentTransactionCancelDao;
import net.shopxx.entity.PaymentTransaction;
import net.shopxx.entity.PaymentTransactionCancel;
import net.shopxx.plugin.PaymentPlugin;
import net.shopxx.service.PaymentTransactionCancelService;
import net.shopxx.service.PluginService;
import org.apache.commons.lang.BooleanUtils;
import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import java.util.List;

/**
 * Service支付取消事务
 */
@Service
public class PaymentTransactionCancelServiceImpl extends BaseServiceImpl<PaymentTransaction, Long>
		implements PaymentTransactionCancelService {
	private Logger log = LoggerFactory.getLogger(this.getClass());

	@Inject
	private PaymentTransactionCancelDao paymentTransactionCancelDao;

	@Inject
	private PluginService pluginService;

	private Thread cancelThread = null;

	private void RunCancel(){
		while(true){
			List<PaymentTransactionCancel> retList = paymentTransactionCancelDao.findCancelList();
			if(retList != null && retList.size() > 0){
				for(PaymentTransactionCancel cancel : retList){
					PaymentTransaction paymentTransaction = cancel.getPaymentTransaction();
					String paymentPluginId = paymentTransaction.getPaymentPluginId();
					PaymentPlugin paymentPlugin = StringUtils.isNotEmpty(paymentPluginId)
							? pluginService.getPaymentPlugin(paymentPluginId) : null;
					if (paymentPlugin == null || BooleanUtils.isNotTrue(paymentPlugin.getIsEnabled())) {
						log.error("exception plugin not enable" + paymentPluginId);
						continue;
					}
					cancel.setbFinishCancel(paymentPlugin.cancel(paymentTransaction.getSn()));
				}
			}
		}
	}
	private synchronized void CreateCancelhread(){
		//检查线程是否启动
		if(cancelThread == null){
			cancelThread = new Thread(){
				public void run(){
					RunCancel();
				}
			};
			cancelThread.start();
		}
	}
	@Override
	public void CreatePaymentTransactionCancel(PaymentTransaction paymentTransaction, String refundReason) {
		PaymentTransactionCancel cancel = new PaymentTransactionCancel();
		cancel.setReason(refundReason);
		cancel.setPaymentTransaction(paymentTransaction);
		cancel.setbFinishCancel(false);
		paymentTransactionCancelDao.persist(cancel);
		if(cancelThread == null){
			CreateCancelhread();
		}
	}
}