<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html;charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>${message("member.register.title")}[#if showPowered] [/#if]</title>
<meta name="author" content="SHOP++ Team" />
<meta name="copyright" content="SHOP++" />
<link href="${base}/resources/member/css/animate.css" rel="stylesheet" type="text/css" />
<link href="${base}/resources/member/css/common.css" rel="stylesheet" type="text/css" />
<link href="${base}/resources/member/css/register.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" href="${base}/resources/member/css/element.min.css">
<script type="text/javascript" src="${base}/resources/member/js/jquery.js"></script>
<script type="text/javascript" src="${base}/resources/member/js/jquery.lSelect.js"></script>
<script type="text/javascript" src="${base}/resources/member/js/jquery.validate.js"></script>
<script type="text/javascript" src="${base}/resources/member/js/common.js"></script>
<script type="text/javascript" src="${base}/resources/member/datePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${base}/resources/member/js/vue.min.js"></script>
<script src="${base}/resources/member/js/element.min.js"></script>
<script type="text/javascript">
    $(function f() {
        var mob = (window.location.search).substring(1);
        if(mob!=null && mob != ""){
            $("#mobile").val(mob);
            document.getElementById("t1").style.display="none";
            document.getElementById("t2").style.display="none";
        }
    })

	$().ready(function() {

		var $registerForm = $("#registerForm");
		var $areaId = $("#areaId");
		var $captcha = $("#captcha");
		var $submit = $("input:submit");

		// 地区选择
		$areaId.lSelect({
			url: "${base}/common/area"
		});

		// 验证码图片
		$captcha.captchaImage();

		$.validator.addMethod("notAllNumber",
			function(value, element) {
				return this.optional(element) || /^.*[^\d].*$/.test(value);
			},
			"${message("member.register.notAllNumber")}"
		);

		// 表单验证
		$registerForm.validate({
			rules: {
				username: {
					required: true,
					minlength: 4,
					pattern: /^[0-9a-zA-Z_\u4e00-\u9fa5]+$/,
					notAllNumber: true,
					remote: {
						url: "${base}/member/register/check_username",
						cache: false
					}
				},
				password: {
					required: true,
					minlength: 8
				},
				rePassword: {
					required: true,
					equalTo: "#password"
				},
				mobile: {
					required: true,
					pattern: /^1[3|4|5|7|8]\d{9}$/,
					remote: {
						url: "${base}/member/register/check_mobile",
						cache: false
					}
				},
				email: {
					email: true,
					remote: {
						url: "${base}/member/register/check_email",
						cache: false
					}
				},
				captcha: "required"
				[@member_attribute_list]
					[#list memberAttributes as memberAttribute]
						[#if memberAttribute.isRequired || memberAttribute.pattern?has_content]
							,memberAttribute_${memberAttribute.id}: {
								[#if memberAttribute.isRequired]
									required: true
									[#if memberAttribute.pattern?has_content],[/#if]
								[/#if]
								[#if memberAttribute.pattern?has_content]
									pattern: /${memberAttribute.pattern}/
								[/#if]
							}
						[/#if]
					[/#list]
				[/@member_attribute_list]
			},
			messages: {
				username: {
					pattern: "${message("member.register.usernameIllegal")}",
					remote: "${message("member.register.usernameExist")}"
				},
				email: {
					remote: "${message("member.register.emailExist")}"
				},
				mobile: {
					pattern: "${message("member.register.mobileIllegal")}",
					remote: "${message("member.register.mobileExist")}"
				}
			},
			submitHandler: function(form) {
				$.ajax({
					url: $registerForm.attr("action"),
					type: "POST",
					data: $registerForm.serialize(),
					dataType: "json",
					beforeSend: function() {
						$submit.prop("disabled", true);
					},
					success: function() {
						setTimeout(function() {
							$submit.prop("disabled", false);
							location.href = "${base}/";
						}, 3000);
					},
					error: function(xhr, textStatus, errorThrown) {
						setTimeout(function() {
							$submit.prop("disabled", false);
						}, 3000);
						$captcha.captchaImage("refresh", true);
					}
				});
			}
		});

	});
</script>
</head>
<body>
	[#include "/shop/include/header.ftl" /]
	<div class="container register">
		<div class="row">
			<div class="span12">
				<div class="wrap">
					<div class="main clearfix">
						<div class="title">
							[#if socialUserId?has_content && uniqueId?has_content]
								<strong>${message("member.register.bind")}</strong>REGISTER BIND
							[#else]
								<strong>${message("member.register.title")}</strong>USER REGISTER
							[/#if]
						</div>
						<form id="registerForm" action="${base}/member/register/submit" method="post">
							<input name="socialUserId" type="hidden" value="${socialUserId}" />
							<input name="uniqueId" type="hidden" value="${uniqueId}" />
							<table>
								<tr>
									<th>
										<span class="requiredField">*</span>${message("member.register.username")}:
									</th>
									<td>
										<input type="text" name="username" class="text" maxlength="20" />
									</td>
								</tr>
								<tr>
									<th>
										<span class="requiredField">*</span>${message("member.register.password")}:
									</th>
									<td>
										<input type="password" id="password" name="password" class="text" maxlength="20" autocomplete="off" />
									</td>
								</tr>
								<tr>
									<th>
										<span class="requiredField">*</span>${message("member.register.rePassword")}:
									</th>
									<td>
										<input type="password" name="rePassword" class="text" maxlength="20" autocomplete="off" />
									</td>
								</tr>



                                <tr>
                                    <th>
									${message("member.register.email")}:
                                    </th>
                                    <td>
                                        <input type="text" name="email" class="text" maxlength="200" />
                                    </td>
                                </tr>
								[@member_attribute_list]
									[#list memberAttributes as memberAttribute]
										<tr>
											<th>
												[#if memberAttribute.isRequired]<span class="requiredField">*</span>[/#if]${memberAttribute.name}:
											</th>
											<td>
												[#if memberAttribute.type == "name"]
													<input type="text" name="memberAttribute_${memberAttribute.id}" class="text" maxlength="200" />
												[#elseif memberAttribute.type == "gender"]
													<span class="fieldSet">
														[#list genders as gender]
															<label>
																<input type="radio" name="memberAttribute_${memberAttribute.id}" value="${gender}" />${message("Member.Gender." + gender)}
															</label>
														[/#list]
													</span>
												[#elseif memberAttribute.type == "birth"]
													<input type="text" name="memberAttribute_${memberAttribute.id}" class="text" onfocus="WdatePicker();" />
												[#elseif memberAttribute.type == "area"]
													<span class="fieldSet">
														<input type="hidden" id="areaId" name="memberAttribute_${memberAttribute.id}" />
													</span>
												[#elseif memberAttribute.type == "address"]
													<input type="text" name="memberAttribute_${memberAttribute.id}" class="text" maxlength="200" />
												[#elseif memberAttribute.type == "zipCode"]
													<input type="text" name="memberAttribute_${memberAttribute.id}" class="text" maxlength="200" />
												[#elseif memberAttribute.type == "phone"]
													<input type="text" name="memberAttribute_${memberAttribute.id}" class="text" maxlength="200" />
												[#elseif memberAttribute.type == "text"]
													<input type="text" name="memberAttribute_${memberAttribute.id}" class="text" maxlength="200" />
												[#elseif memberAttribute.type == "select"]
													<select name="memberAttribute_${memberAttribute.id}">
														<option value="">${message("member.common.choose")}</option>
														[#list memberAttribute.options as option]
															<option value="${option}">
																${option}
															</option>
														[/#list]
													</select>
												[#elseif memberAttribute.type == "checkbox"]
													<span class="fieldSet">
														[#list memberAttribute.options as option]
															<label>
																<input type="checkbox" name="memberAttribute_${memberAttribute.id}" value="${option}" />${option}
															</label>
														[/#list]
													</span>
												[/#if]
											</td>
										</tr>
									[/#list]
								[/@member_attribute_list]
                                    <tr id="t1">
                                        <th>
                                            <span class="requiredField">*</span>${message("member.register.mobile")}:
                                        </th>
                                        <td>
                                            <input type="text" name="mobile" id="mobile" class="text" maxlength="200" />
                                        </td>
                                    </tr>
                                    [#if setting.captchaTypes?? && setting.captchaTypes?seq_contains("memberRegister")]
                                        <tr>
                                            <th>
                                                <span class="requiredField">*</span>${message("common.captcha.name")}:
                                            </th>
                                            <td>
                                                <span class="fieldSet">
                                                    <input type="text" id="captcha" name="captcha" class="text captcha" maxlength="4" autocomplete="off" />
                                                </span>
                                            </td>
                                        </tr>
                                    [/#if]
                                    <tr id="t2">
                                        <th>
                                        ${message("common.captcha.mname")}:
                                        </th>
                                        <td>
                                            <input type="text" id="mcaptcha" name="password" class="text captcha" maxlength="200" autocomplete="off" />
                                            <input type="button" id="btnSendCode1" class="mob-code" onclick="send()" value="发送验证码"/>

                                        </td>

                                        <th>
                                            &nbsp;
                                        </th>
                                    </tr>

								<tr>
									<th>
										&nbsp;
									</th>
									<td>
										<input type="submit" class="submit" value="${message("member.register.submit")}" />
									</td>
								</tr>
								<tr>
									<th>
										&nbsp;
									</th>
									<td>
										<a href="${base}/article/detail/1_1" target="_blank">${message("member.register.agreement")}</a>
									</td>
								</tr>
							</table>
							<div class="login">
								<dl>
									<dt>${message("member.register.hasAccount")}</dt>
									<dd>
										${message("member.register.tips")}
										<a href="${base}/member/login">${message("member.register.login")}</a>
									</dd>
								</dl>
							</div>
						</form>
					</div>
				</div>
			</div>
		</div>
	</div>
	[#include "/shop/include/footer.ftl" /]
</body>
<script>
    $("#btnSendCode1").click(function(){
        /*第一*/
        var phoneReg = /(^1[3|4|5|7|8]\d{9}$)|(^09\d{8}$)/;//手机号正则
        var count = 60; //间隔函数，1秒执行
        var InterValObj1; //timer变量，控制时间
        var curCount1;//当前剩余秒数
        curCount1 = count;
        var phone = $.trim($('#mobile').val());
        if (!phoneReg.test(phone)) {
            alert(" 请输入有效的手机号码");
            return false;
        }
        //向后台发送处理数据
        function SetRemainTime1() {
            if (curCount1 == 0) {
                window.clearInterval(InterValObj1);//停止计时器
                $("#btnSendCode1").removeAttr("disabled");//启用按钮
                $("#btnSendCode1").val("重新发送");
            }
            else {
                curCount1--;
                $("#btnSendCode1").val( + curCount1 + "秒再获取");
            }
        }
        $.ajax({
            type: "POST",
            url: "${base}/common/captcha/sms",
            cache: false, //禁用缓存
            // data: {mobNum: mob}, //传入组装的参数
            data:$("#registerForm").serialize(),
            dataType: "json",
            success: function (res) {
                //设置button效果，开始计时
                $("#btnSendCode1").attr("disabled", "true");
                $("#btnSendCode1").val( + curCount1 + "秒再获取");
                InterValObj1 = window.setInterval(SetRemainTime1, 1000); //启动计时器，1秒执行一次
                alert(res);
            }
        })
    });
</script>
</html>