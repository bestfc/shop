<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>${message("member.order.list")}[#if showPowered] [/#if]</title>
<meta name="author" content="SHOP++ Team" />
<meta name="copyright" content="SHOP++" />
<link href="${base}/resources/member/css/animate.css" rel="stylesheet" type="text/css" />
<link href="${base}/resources/member/css/common.css" rel="stylesheet" type="text/css" />
<link href="${base}/resources/member/css/member.css" rel="stylesheet" type="text/css" />
<link href="${base}/resources/member/css/tooltip.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="${base}/resources/member/js/jquery.js"></script>
<script type="text/javascript" src="${base}/resources/member/js/common.js"></script>
<script type="text/javascript" src="${base}/resources/member/js/tooltip.js"></script>
<script type="text/javascript">
	$().ready(function() {
		[#if flashMessage?has_content]
			$.alert("${flashMessage}");
		[/#if]
	});
</script>
</head>
<body>
<script>
    function showTraces(orderId) {
        $.ajax({
            type:"get",
            url:"${base}/member/order/traces?orderId="+orderId,
            success:function (result) {
				var content = "<div style='text-align: left'>";
                if(result.code==50000){
                    //成功
					console.log(result);
					$.each(result.data,function(index,val){
					    content+="<p>"+val.deliveryCorp+"："+val.trackingNo+"</p><hr/>" +
								"<ul>";
                        console.log(val);
                        console.log(123);
                        var track = JSON.parse(val.traces);
                        console.log(track);
                        $.each(track,function (index,val) {
                            content+="<li style='border-top: inset;border-top-width: thin;border-top-style: outset;line-height: 20px;padding: 8px 0px 8px 0px;'>" +
                                    "<p>"+val.acceptTime+"</p>" +
                                    "<p>"+val.acceptStation+"("+val.remark+")</p>"+
									"</li>";
                        });
                        content+="</ul>";
					});
                }
                else {
                    //异常
                    content+="<p>获取信息失败！</p>"
                }
                content+="</div>";
                var select="#show"+orderId;
                tipTraces(select,content);
            }
        })
    }
    function tipTraces(select,content) {
       /* $(select).tooltip({
			text: content,
			fontSize: '14px',
            theme: 'light',
            fontFamily: "'Open Sans', 'Roboto-Regular', Arial",
            delay: 400
        });*/
    }
</script>
	[#assign current = "orderList" /]
	[#include "/shop/include/header.ftl" /]
	<div class="container member">
		<div class="row">
			[#include "/member/include/navigation.ftl" /]
			<div class="span10">
				<div class="list">
					<div class="title">${message("member.order.list")}</div>
					<table class="list">
						<tr>
							<th class="firstTd">${message("member.orderItem.sku")}</th>
							<th>${message("OrderItem.name")}</th>
							<th>${message("OrderItem.quantity")}</th>
							<th>${message("Order.amount")}</th>
							<th>${message("Order.status")}</th>
							<th>${message("member.common.action")}</th>
						</tr>
						[#list page.content as order]
							<tr>
								<td colspan="6">
									<span>${order.sn}</span>
									<span>${message("member.order.time")}：${order.createdDate}</span>
									<span>[#if order.store.type == "self"]${message("member.order.self")}[/#if]</span>
								</td>
							</tr>
							[#list order.orderItems as orderItem]
								<tr>
									<td>
										<img src="${orderItem.thumbnail!setting.defaultThumbnailProductImage}" width="80" height="80" />
									</td>
									<td>
										${abbreviate(orderItem.name, 50, "...")}
									</td>
									<td class="rightBorder">
										${orderItem.quantity}
									</td>
									[#if orderItem_index < 1]
										<td rowspan="${order.orderItems?size}">
											${currency(order.amount, true)}
										</td>
										<td rowspan="${order.orderItems?size}">
											<span>${message("Order.Status." + order.status)}</span>
											[#if order.hasExpired()]
												<span class="silver">(${message("member.order.hasExpired")})</span>
											[/#if]
											[#if order.status=="shipped"]
											    <br/><a href="view?orderSn=${order.sn}" id="show${order.id}" onmouseover="showTraces(${order.id})" style="text-align: left;">[查看物流]</a>
											[/#if]
										</td>
										<td rowspan="${order.orderItems?size}">
											<a href="view?orderSn=${order.sn}">[${message("member.common.view")}]</a>
										</td>
									[/#if]	
								</tr>	
							[/#list]
						[/#list]						
					</table>			
					[#if !page.content?has_content]
						<p>${message("member.common.noResult")}</p>
					[/#if]
				</div>
				[@pagination pageNumber = page.pageNumber totalPages = page.totalPages pattern = "?pageNumber={pageNumber}"]
					[#include "/shop/include/pagination.ftl"]
				[/@pagination]
			</div>
		</div>
	</div>
	[#include "/shop/include/footer.ftl" /]
</body>
</html>