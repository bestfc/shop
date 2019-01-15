<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>${message("admin.memberDeposit.adjust")} </title>
<meta name="author" content="SHOP++ Team" />
<meta name="copyright" content="SHOP++" />
<link href="${base}/resources/admin/css/common.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="${base}/resources/admin/js/jquery.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/jquery.tools.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/jquery.validate.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/common.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/input.js"></script>
<script type="text/javascript">
$().ready(function() {

	var $inputForm = $("#inputForm");
	var $username = $("#username");
	var $balance = $("#balance");
	var $amount = $("#amount");
	var balance = null;
	
	[@flash_message /]
	
	// 检查会员
	$username.change(function() {
		if ($.trim($username) == "") {
			return;
		}
		$.ajax({
			url: "check_member",
			type: "GET",
			data: {username: $username.val()},
			dataType: "json",
			success: function(data) {
				if (data.message.type == "success") {
					balance = data.balance;
					$balance.text("${message("admin.memberDeposit.balance")}: " + currency(data.balance, true, true)).closest("tr").show();
				} else {
					balance = null;
					$username.val("");
					$balance.closest("tr").hide();
					$.message(data.message);
				}
			}
		});
	});
	
	// 表单验证
	$inputForm.validate({
		rules: {
			username: {
				required: true
			},
			amount: {
				required: true,
				decimal: {
					integer: 12,
					fraction: ${setting.priceScale}
				}
			}
		},
		submitHandler: function(form) {
			var amount = parseFloat($amount.val());
			if (amount == 0) {
				$.message("warn", "${message("admin.memberDeposit.nonzero")}");
				return false;
			}
			if (balance != null && balance + amount < 0) {
				$.message("warn", "${message("admin.memberDeposit.insufficientBalance")}");
				return false;
			}
			$(form).find("input:submit").prop("disabled", true);
			form.submit();
		}
	});

});
</script>
</head>
<body>
	<div class="breadcrumb">
		<a href="${base}/admin/index">${message("admin.breadcrumb.home")}</a> &raquo; ${message("admin.memberDeposit.adjust")}
	</div>
	<form id="inputForm" action="adjust" method="post">
		<table class="input tabContent">
			<tr>
				<th>
					<span class="requiredField">*</span>${message("admin.memberDeposit.memberUsername")}:
				</th>
				<td>
					<input type="text" id="username" name="username" class="text" maxlength="20" />
				</td>
			</tr>
			<tr class="hidden">
				<th>
					&nbsp;
				</th>
				<td>
					<span id="balance"></span>
				</td>
			</tr>
			<tr>
				<th>
					<span class="requiredField">*</span>${message("admin.memberDeposit.amount")}:
				</th>
				<td>
					<input type="text" id="amount" name="amount" class="text" maxlength="16" title="${message("admin.memberDeposit.amountTitle")}" />
				</td>
			</tr>
			<tr>
				<th>
					${message("admin.memberDeposit.memo")}:
				</th>
				<td>
					<input type="text" name="memo" class="text" maxlength="200" />
				</td>
			</tr>
			<tr>
				<th>
					&nbsp;
				</th>
				<td>
					<input type="submit" class="button" value="${message("admin.common.submit")}" />
					<input type="button" class="button" value="${message("admin.common.back")}" onclick="history.back(); return false;" />
				</td>
			</tr>
		</table>
	</form>
</body>
</html>