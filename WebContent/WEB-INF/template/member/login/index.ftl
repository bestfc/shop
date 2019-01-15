<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html;charset=utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <title>${message("member.login.title")}[#if showPowered] [/#if]</title>
    <meta name="author" content="SHOP++ Team" />
    <meta name="copyright" content="SHOP++" />
    <link href="${base}/resources/member/css/animate.css" rel="stylesheet" type="text/css" />
    <link href="${base}/resources/member/css/common.css" rel="stylesheet" type="text/css" />
    <link href="${base}/resources/member/css/login.css" rel="stylesheet" type="text/css" />
    <link rel="stylesheet" href="${base}/resources/member/css/element.min.css">
    <script type="text/javascript" src="${base}/resources/member/js/jquery.js"></script>
    <script type="text/javascript" src="${base}/resources/member/js/jquery.validate.js"></script>
    <script type="text/javascript" src="${base}/resources/member/js/common.js"></script>
    <script type="text/javascript">
        $().ready(function() {

            var $loginForm = $("#loginForm");
            var $mobloginForm = $("#mobloginForm");

            var $username = $("#username");
            var $password = $("#password");
            var $captcha = $("#captcha");

            var $isRememberUsername = $("#isRememberUsername");
            var $submit = $("input:submit");
            var $captcha2 = $("#captcha2");
            var $mobilenum=$("#mobile");

            // 记住用户名
            if (getCookie("memberUsername") != null) {
                $isRememberUsername.prop("checked", true);
                $username.val(getCookie("memberUsername"));
                $password.focus();
            } else {
                $isRememberUsername.prop("checked", false);
                $username.focus();
            }

            // 验证码图片
            $captcha.captchaImage();
            $captcha2.captchaImage();

            // 表单验证、记住用户名
            $loginForm.validate({
                rules: {
                    username: "required",
                    password: "required",
                    captcha: "required"
                },
                submitHandler: function(form) {
                    $.ajax({
                        url: $loginForm.attr("action"),
                        type: "POST",
                        data: $loginForm.serialize(),
                        dataType: "json",
                        beforeSend: function() {
                            $submit.prop("disabled", true);
                        },
                        success: function(data) {
                            $submit.prop("disabled", false);
                            if ($isRememberUsername.prop("checked")) {
                                addCookie("memberUsername", $username.val(), {expires: 7 * 24 * 60 * 60});
                            } else {
                                removeCookie("memberUsername");
                            }
					[#if redirectUrl?has_content]
						location.href = "${redirectUrl?js_string}";
                    [#else]
						if (data.redirectUrl != null) {
                            location.href = data.redirectUrl;
                        } else {
                            location.href = "${base}/";
                        }
                    [/#if]
                        },
                        error: function(xhr, textStatus, errorThrown) {
                            setTimeout(function() {
                                $submit.prop("disabled", false);
                            }, 3000);
                            $captcha.captchaImage("refresh", true);
                            $captcha2.captchaImage("refresh", true);

                        }
                    });
                }
            });

            // 表单验证、记住用户名
            $mobloginForm.validate({
                rules: {
                    username: "required",
                    captcha: "required",
                    password: "required"
                },
                submitHandler: function(form) {
                    $.ajax({
                        url: "${base}/member/login",
                        type: "POST",
                        data: $mobloginForm.serialize(),
                        dataType: "json",
                        success: function(data) {
                            [#if redirectUrl?has_content]
                                location.href = "${redirectUrl?js_string}";
                            [#else]
                                if (data.redirectUrl != null) {
                                    location.href = data.redirectUrl;
                                } else {
                                    location.href = "${base}/";
                                }
                            [/#if]
                        },
                        error: function(XMLHttpRequest) {
                            if(XMLHttpRequest.status==422) {
                                m=$mobilenum.attr("value");
                                window.location.href="${base}/member/register?"+m;
                            }                
                        }
                    });
                }
            });
        });
    </script>
</head>
<body>
	[#include "/shop/include/header.ftl" /]
<div class="container login">
    <div class="row">
        <div class="span6">
				[@ad_position id = 6]
					[#noautoesc]
                        ${adPosition.resolveTemplate()}
                    [/#noautoesc]
                [/@ad_position]
        </div>
        <div class="span6">
            <div class="wrap" id="myVue">
                <div class="main">
                    <template>
                        <el-tabs v-model="activeName" @tab-click="handleClick">
                            <el-tab-pane label="会员登陆" name="first">
                                <form id="loginForm" action="${base}/member/login" method="post">
                                    <input name="socialUserId" type="hidden" value="${socialUserId}" />
                                    <input name="uniqueId" type="hidden" value="${uniqueId}" />
                                    <table>
                                        <tr>
                                            <th>
                                            ${message("member.login.username")}:
                                            </th>
                                            <td>
                                                <input type="text" id="username" name="username" class="text" maxlength="200" title="${message("member.login.usernameTitle")}" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <th>
                                            ${message("member.login.password")}:
                                            </th>
                                            <td>
                                                <input type="password" id="password" name="password" class="text" maxlength="200" autocomplete="off" />
                                            </td>
                                        </tr>
								[#if setting.captchaTypes?? && setting.captchaTypes?seq_contains("memberLogin")]
									<tr>
                                        <th>
                                            ${message("common.captcha.name")}:
                                        </th>
                                        <td>
											<span class="fieldSet">
												<input type="text" id="captcha" name="captcha" class="text captcha" maxlength="4" autocomplete="off" />
											</span>
                                        </td>
                                    </tr>
                                [/#if]
                                        <tr>
                                            <th>
                                                &nbsp;
                                            </th>
                                            <td>
                                                <label>
                                                    <input type="checkbox" id="isRememberUsername" name="isRememberUsername" value="true" />${message("member.login.isRememberUsername")}
                                                </label>
                                                <label>
                                                    &nbsp;&nbsp;<a href="${base}/password/forgot?type=member">${message("member.login.forgotPassword")}</a>
                                                </label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th>
                                                &nbsp;
                                            </th>
                                            <td>
										[#if socialUserId?has_content && uniqueId?has_content]
                                            <input type="submit" class="submit" value="${message("member.login.bind")}" />
                                        [#else]
											<input type="submit" class="submit" value="${message("member.login.submit")}" />
                                        [/#if]
                                            </td>
                                        </tr>
								[#if loginPlugins?has_content && !socialUserId?has_content && !uniqueId?has_content]
									<tr class="loginPlugin">
                                        <th>
                                            &nbsp;
                                        </th>
                                        <td>
                                            <ul>
												[#list loginPlugins as loginPlugin]
                                                    <li>
                                                        <a href="${base}/social_user_login?loginPluginId=${loginPlugin.id}"[#if loginPlugin.description??] title="${loginPlugin.description}"[/#if]>
															[#if loginPlugin.logo?has_content]
                                                                <img src="${loginPlugin.logo}" alt="${loginPlugin.loginMethodName}" />
                                                            [#else]
                                                                ${loginPlugin.loginMethodName}
                                                            [/#if]
                                                        </a>
                                                    </li>
                                                [/#list]
                                            </ul>
                                        </td>
                                    </tr>
                                [/#if]
                                        <tr class="register">
                                            <th>
                                                &nbsp;
                                            </th>
                                            <td>
                                                <dl>
                                                    <dt>${message("member.login.noAccount")}</dt>
                                                    <dd>
                                                    ${message("member.login.tips")}
												[#if socialUserId?has_content && uniqueId?has_content]
													<a href="${base}/member/register?socialUserId=${socialUserId}&uniqueId=${uniqueId}">${message("member.login.registerBind")}</a>
                                                [#else]
													<a href="${base}/member/register">${message("member.login.register")}</a>
                                                [/#if]
                                                    </dd>
                                                </dl>
                                            </td>
                                        </tr>
                                    </table>
                                </form>
                            </el-tab-pane>
                            <el-tab-pane label="手机号登陆" name="second">
                                <form id="mobloginForm" action="" method="post">
                                    <input name="socialUserId" type="hidden" value="${socialUserId}" />
                                    <input name="uniqueId" type="hidden" value="${uniqueId}" />
                                    <table>
                                        <tr>
                                            <th>
                                            ${message("member.login.mobile")}:
                                            </th>
                                            <td>
                                                <input type="text" id="mobile" name="username" class="text" maxlength="200" title="${message("member.login.usernameTitle")}" />
                                            </td>
                                        </tr>
                                            [#if setting.captchaTypes?? && setting.captchaTypes?seq_contains("memberLogin")]
                                            <tr>
                                                <th>
                                                    ${message("common.captcha.name")}:
                                                </th>
                                                <td>
                                                    <span class="fieldSet">
                                                        <input type="text" id="captcha2" name="captcha" class="text captcha" maxlength="4" autocomplete="off" />
                                                    </span>
                                                </td>
                                            </tr>
                                            [/#if]
                                        <tr>
                                            <th>
                                            ${message("common.captcha.mname")}:
                                            </th>
                                            <td>
                                                <input type="text" id="mcaptcha" name="password" class="text captcha" maxlength="200" autocomplete="off" />
                                                <input type="button" id="btnSendCode1" class="mob-code" value="发送验证码"/>

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
										[#if socialUserId?has_content && uniqueId?has_content]
                                            <input type="submit" class="submit" value="${message("member.login.bind")}" />
                                        [#else]
											<input type="submit" class="submit" value="${message("member.login.submit")}" />
                                        [/#if]
                                            </td>
                                        </tr>
[#if loginPlugins?has_content && !socialUserId?has_content && !uniqueId?has_content]
									<tr class="loginPlugin">
                                        <th>
                                            &nbsp;
                                        </th>
                                        <td>
                                            <ul>
												[#list loginPlugins as loginPlugin]
                                                    <li>
                                                        <a href="${base}/social_user_login?loginPluginId=${loginPlugin.id}"[#if loginPlugin.description??] title="${loginPlugin.description}"[/#if]>
															[#if loginPlugin.logo?has_content]
                                                                <img src="${loginPlugin.logo}" alt="${loginPlugin.loginMethodName}" />
                                                            [#else]
                                                                ${loginPlugin.loginMethodName}
                                                            [/#if]
                                                        </a>
                                                    </li>
                                                [/#list]
                                            </ul>
                                        </td>
                                    </tr>
[/#if]
                                        <tr class="register">
                                            <th>
                                                &nbsp;
                                            </th>
                                            <td>
                                                <dl>
                                                    <dt>${message("member.login.noAccount")}</dt>
                                                    <dd>
                                                    ${message("member.login.tips")}
												[#if socialUserId?has_content && uniqueId?has_content]
													<a href="${base}/member/register?socialUserId=${socialUserId}&uniqueId=${uniqueId}">${message("member.login.registerBind")}</a>
                                                [#else]
													<a href="${base}/member/register">${message("member.login.register")}</a>
                                                [/#if]
                                                    </dd>
                                                </dl>
                                            </td>
                                        </tr>
                                    </table>
                                </form>
                            </el-tab-pane>

                        </el-tabs>
                    </template>

                </div>
            </div>
        </div>
    </div>
</div>
	[#include "/shop/include/footer.ftl" /]


<script type="text/javascript" src="${base}/resources/member/js/vue.min.js"></script>
<script src="${base}/resources/member/js/element.min.js"></script>
<script type="text/javascript">
    new Vue({
        el: '#myVue',
        data() {
            return {
                activeName: 'first',
                activeName2: 'second',
                tabPosition: 'top',
                editableTabsValue2: '2',
                editableTabs2: [{
                    title: 'Tab 1',
                    name: '1',
                    content: 'Tab 1 content'
                }, {
                    title: 'Tab 2',
                    name: '2',
                    content: 'Tab 2 content'
                }],
                tabIndex: 2
            }
        },
        methods: {
            handleClick(tab, event) {
                console.log(tab, event);
            },
            addTab(targetName) {
                let newTabName = ++this.tabIndex + '';
                this.editableTabs2.push({
                    title: 'New Tab',
                    name: newTabName,
                    content: 'New Tab content'
                });
                this.editableTabsValue2 = newTabName;
            },
            removeTab(targetName) {
                let tabs = this.editableTabs2;
                let activeName = this.editableTabsValue2;
                if(activeName === targetName) {
                    tabs.forEach((tab, index) => {
                        if(tab.name === targetName) {
                        let nextTab = tabs[index + 1] || tabs[index1];
                        if(nextTab) {
                            activeName = nextTab.name;
                        }
                    }
                });
                }

                this.editableTabsValue2 = activeName;
                this.editableTabs2 = tabs.filter(tab => tab.name !== targetName);
            }
        }
    })
</script>
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
            // data: {mobNum: $("#mobile")}, //传入组装的参数
            data:$("#mobloginForm").serialize(),
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
</body>
</html>
