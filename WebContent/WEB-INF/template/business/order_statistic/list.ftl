<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	<title>${message("business.orderStatistic.list")} </title>
	<link href="${base}/favicon.ico" rel="icon">
	<link href="${base}/resources/business/css/bootstrap.css" rel="stylesheet">
	<link href="${base}/resources/business/css/font-awesome.css" rel="stylesheet">
	<link href="${base}/resources/business/css/animate.css" rel="stylesheet">
	<link href="${base}/resources/business/css/bootstrap-datetimepicker.css" rel="stylesheet">
	<link href="${base}/resources/business/css/adminLTE.css" rel="stylesheet">
	<link href="${base}/resources/business/css/common.css" rel="stylesheet">
	<!--[if lt IE 9]>
		<script src="${base}/resources/business/js/html5shiv.js"></script>
		<script src="${base}/resources/business/js/respond.js"></script>
	<![endif]-->
	<script src="${base}/resources/business/js/jquery.js"></script>
	<script src="${base}/resources/business/js/bootstrap.js"></script>
	<script src="${base}/resources/business/js/velocity.js"></script>
	<script src="${base}/resources/business/js/velocity.ui.js"></script>
	<script src="${base}/resources/business/js/moment.js"></script>
	<script src="${base}/resources/business/js/bootstrap-datetimepicker.js"></script>
	<script src="${base}/resources/business/js/g2.js"></script>
	<script src="${base}/resources/business/js/adminLTE.js"></script>
	<script src="${base}/resources/business/js/common.js"></script>
	<script type="text/javascript">
		$().ready(function() {
			
			var $orderStatisticForm = $("#orderStatisticForm");
			var $type = $("[name='type']");
			var $period = $("[name='period']");
			var $export = $("#export");
			var $typeItem = $("[data-type]");
			var $periodItem = $("[data-period]");
			var $beginDate = $("[name='beginDate']");
			var $endDate = $("[name='endDate']");
			var dateFormat = "YYYY-MM-DD";
			
			// 类型
			$typeItem.click(function() {
				var $element = $(this);
				var type = $element.data("type");
				
				$element.addClass("active").siblings().removeClass("active");
				$type.val(type);
				
				loadData();
			});
			
			// 周期
			$periodItem.click(function() {
				var $element = $(this);
				var period = $element.data("period");
				
				switch(period) {
					case "year":
						dateFormat = "YYYY";
						break;
					case "month":
						dateFormat = "YYYY-MM";
						break;
					default:
						dateFormat = "YYYY-MM-DD";
				}
				
				$element.addClass("active").siblings().removeClass("active");
				$period.val(period);
				$beginDate.data("DateTimePicker").format(dateFormat);
				$endDate.data("DateTimePicker").format(dateFormat);
				
				loadData();
			});
			
			// 日期
			$beginDate.add($endDate).on("dp.change", function() {
				loadData();
			});
			
			// 图表
			var chart = new G2.Chart({
				id: "chart",
				height: 400,
				forceFit: true
			});
			
			chart.source([], {
				date: {
					type: "time",
					alias: "${message("Statistic.date")}",
					tickCount: 10,
					formatter: function(value) {
						return moment(value).format(dateFormat);
					}
				},
				value: {}
			});
			chart.line().position("date*value").color("#66baff");
			chart.render();
			
			// 加载数据
			function loadData() {
				$.ajax({
					url: $orderStatisticForm.attr("action"),
					type: $orderStatisticForm.attr("method"),
					data: $orderStatisticForm.serialize(),
					dataType: "json",
					success: function(data) {
						chart.col("value", {
							alias: $typeItem.filter(".active").data("type-name")
						});
						chart.changeData(data);
					}
				});
			};
			
			loadData();
			
			// 导出
			$export.click(function() {
				setTimeout(function() {
					chart.downloadImage();
				}, 1000);
			});
		
		});
	</script>
</head>
<body class="hold-transition sidebar-mini">
	<div class="wrapper">
		[#include "/business/include/main_header.ftl" /]
		[#include "/business/include/main_sidebar.ftl" /]
		<div class="content-wrapper">
			<div class="container-fluid">
				<section class="content-header">
					<h1>${message("business.orderStatistic.list")}</h1>
					<ol class="breadcrumb">
						<li>
							<a href="/shop/business/index">
								<i class="fa fa-home"></i>
								${message("business.common.index")}
							</a>
						</li>
						<li class="active">${message("business.orderStatistic.list")}</li>
					</ol>
				</section>
				<section class="content">
					<div class="row">
						<div class="col-xs-12">
							<form id="orderStatisticForm" action="${base}/business/order_statistic/data" method="get">
								<input name="type" type="hidden" value="${type}">
								<input name="period" type="hidden" value="${period}">
								<div class="box">
									<div class="box-header">
										<div class="col-xs-3">
											<div class="btn-group">
												<button id="export" class="btn btn-default" type="button">
													<i class="fa fa-download"></i>
													${message("business.orderStatistic.export")}
												</button>
												<div class="btn-group">
													<button class="btn btn-default dropdown-toggle" type="button" data-toggle="dropdown">
														${message("business.orderStatistic.type")}
														<span class="caret"></span>
													</button>
													<ul class="dropdown-menu">
														[#list types as value]
															<li[#if value == type] class="active"[/#if] data-type="${value}" data-type-name="${message("Statistic.Type." + value)}">
																<a href="javascript:;">${message("Statistic.Type." + value)}</a>
															</li>
														[/#list]
													</ul>
												</div>
												<div class="btn-group">
													<button class="btn btn-default dropdown-toggle" type="button" data-toggle="dropdown">
														${message("business.orderStatistic.period")}
														<span class="caret"></span>
													</button>
													<ul class="dropdown-menu" role="menu">
														[#list periods as value]
															<li[#if value == period] class="active"[/#if] data-period="${value}">
																<a href="javascript:;">${message("Statistic.Period." + value)}</a>
															</li>
														[/#list]
													</ul>
												</div>
											</div>
										</div>
										<div class="col-xs-4">
											<div class="input-group" data-provide="datetimerangepicker">
												<div class="input-group-addon">${message("business.common.dateRange")}</div>
												<input name="beginDate" class="form-control" type="text" value="${beginDate?string("yyyy-MM-dd")}">
												<div class="input-group-addon">-</div>
												<input name="endDate" class="form-control" type="text" value="${endDate?string("yyyy-MM-dd")}">
											</div>
										</div>
									</div>
									<div class="box-body">
										<div id="chart"></div>
									</div>
								</div>
							</form>
						</div>
					</div>
				</section>
			</div>
		</div>
		[#include "/business/include/main_footer.ftl" /]
	</div>
</body>
</html>