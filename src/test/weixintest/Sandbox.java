package test.weixintest;

import com.fasterxml.jackson.core.type.TypeReference;
import net.shopxx.util.WebUtils;
import net.shopxx.util.XmlUtils;
import org.apache.commons.beanutils.ConvertUtils;
import org.apache.commons.codec.digest.DigestUtils;
import org.apache.commons.lang.ArrayUtils;
import org.apache.commons.lang.RandomStringUtils;
import org.apache.commons.lang.StringUtils;

import java.util.*;

public class Sandbox {
    public static String MCH_ID="1440873102";
    public static String API_KEY="gqgr34act30axia6lkpv63xd2jligfim";

    //获取沙箱apikey
    public String getsandboxkey(){
        Map<String, Object> parameterMap = new HashMap<>();
        parameterMap.put("mch_id",MCH_ID);
        parameterMap.put("nonce_str", DigestUtils.md5Hex(UUID.randomUUID() + RandomStringUtils.randomAlphabetic(30)));
        parameterMap.put("sign", generateSign(parameterMap));
        String result = WebUtils.post("https://api.mch.weixin.qq.com/sandboxnew/pay/getsignkey", XmlUtils.toXml(parameterMap));
        Map<String, String> resultMap = XmlUtils.toObject(result, new TypeReference<Map<String, String>>() {});
        if(resultMap.get("return_code").equals("SUCCESS")){
            return resultMap.get("sandbox_signkey");
        }else{
            System.out.println(resultMap.get("return_msg"));
            return null;
        }
    }
    private String generateSign(Map<String, ?> parameterMap) {
        return StringUtils.upperCase(DigestUtils.md5Hex(joinKeyValue(new TreeMap<>(parameterMap), null, "&key=" + API_KEY, "&", true)));
    }
    private String joinKeyValue(Map<String, Object> map, String prefix, String suffix, String separator, boolean ignoreEmptyValue, String... ignoreKeys) {
        List<String> list = new ArrayList<>();
        if (map != null) {
            for (Map.Entry<String, Object> entry : map.entrySet()) {
                String key = entry.getKey();
                String value = ConvertUtils.convert(entry.getValue());
                if (StringUtils.isNotEmpty(key) && !ArrayUtils.contains(ignoreKeys, key) && (!ignoreEmptyValue || StringUtils.isNotEmpty(value))) {
                    list.add(key + "=" + (value != null ? value : ""));
                }
            }
        }
        return (prefix != null ? prefix : "") + StringUtils.join(list, separator) + (suffix != null ? suffix : "");
    }

    public static void main(String[] args) {
        Sandbox sandbox=new Sandbox();
        String key=sandbox.getsandboxkey();
        if(key!=null){
            System.out.println("================成功，复制下面字符串，到系统管理后台配置即可==================");
            System.out.println(key);
        }else{
            System.out.println("出错了！");
        }
    }
}
