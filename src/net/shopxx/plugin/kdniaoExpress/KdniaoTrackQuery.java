package net.shopxx.plugin.kdniaoExpress;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import net.shopxx.entity.*;
import net.shopxx.plugin.ExpressPlugin;
import net.shopxx.service.PluginConfigService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

import javax.inject.Inject;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.security.MessageDigest;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * 快递鸟 快递查询插件
 *
 * @author young
 * @version 1.0
 */
@Component("kdniaoTrackQuery")
public class KdniaoTrackQuery extends ExpressPlugin{
    Logger logger= LoggerFactory.getLogger(KdniaoTrackQuery.class);

    @Inject
    private PluginConfigService pluginConfigService;

    public String getName() {
        return "快递鸟查快递";
    }

    public String getVersion() {
        return "1.0";
    }

    public String getAuthor() {
        return "*";
    }

    public String getSiteUrl() {
        return "#";
    }

    public String getInstallUrl() {
        return "kdniao/install";
    }

    public String getUninstallUrl() {
        return "kdniao/uninstall";
    }

    public String getSettingUrl() {
        return "kdniao/setting";
    }

    private String getEBusinessID(){ return getAttribute("EBusinessID"); }

    private String getAppKey(){ return getAttribute("AppKey"); }


    /**
     * Json方式 查询订单物流轨迹
     * @throws Exception
     */
    public TrackinfoModel getOrderTracesByJson(String expCode, String expNo) throws Exception{
        //请求url
       // String reqURL="http://api.kdniao.cc/Ebusiness/EbusinessOrderHandle.aspx";
        //测试请求url
        String reqURL="http://sandboxapi.kdniao.cc:8080/kdniaosandbox/gateway/exterfaceInvoke.json";

        String requestData= "{'OrderCode':'','ShipperCode':'" + expCode + "','LogisticCode':'" + expNo + "'}";
        Map<String, String> params = new HashMap<String, String>();
        params.put("RequestData", urlEncoder(requestData, "UTF-8"));
        params.put("EBusinessID", getEBusinessID());
        params.put("RequestType", "1002");
        String dataSign=encrypt(requestData, getAppKey(), "UTF-8");
        params.put("DataSign", urlEncoder(dataSign, "UTF-8"));
        params.put("DataType", "2");

        String result=sendPost(reqURL, params);
        //根据公司业务处理返回的信息......
        TrackinfoModel info = JSON.parseObject(result,TrackinfoModel.class);
        if(info.getTraces() != null){
            Collections.sort(info.getTraces(), new Comparator<TrackinfoModel.Trace>() {
                @Override
                public int compare(TrackinfoModel.Trace o1, TrackinfoModel.Trace o2) {
                    returno1.getAcceptTime().compareTo(o2.getAcceptTime());
                }
            });
        }
        return info;
    }

    /**
     * Json方式  物流信息订阅
     * @throws Exception
     */
    public Boolean orderTracesSubByJson(OrderShipping orderShipping, Area area){
        //请求url
        String requrl="http://api.kdniao.cc/api/dist";
        //沙箱请求url
        //String requrl="http://sandboxapi.kdniao.cc:8080/kdniaosandbox/gateway/exterfaceInvoke.json";

        double cost=0;
        if(orderShipping.getFreight()!=null && orderShipping.getFreight().doubleValue()>0){
            cost=orderShipping.getFreight().doubleValue();
        }
        List<OrderShippingItem> shippingItems=orderShipping.getOrderShippingItems();
        StringBuffer goods=new StringBuffer();
        for(OrderShippingItem item:shippingItems){
            if(!goods.toString().equals("")){
                goods.append(",");
            }
            goods.append("{'GoodsName':'"+item.getName()+"','Goodsquantity': "+item.getQuantity()+",'GoodsWeight': 0 }" );
        }
        Store store=orderShipping.getOrder().getStore();
        String expAreaName =area.getName();
        String cityName=area.getParent().getName();
        String provinceName=area.getParent().getParent()==null ? cityName : area.getParent().getParent().getFullName();
        String requestData="{'OrderCode': ''," +
                "'ShipperCode':'"+orderShipping.getDeliveryCorpCode()+"'," +
                "'LogisticCode':'"+orderShipping.getTrackingNo()+"'," +
                "'PayType':2," +        //0现付、1到付、2月结、3顺丰第三方支付
                "'ExpType':1," +
                "'CustomerName':'',"+
                "'CustomerPwd':''," +
                "'MonthCode':''," +
                "'IsNotice':1," +       //0通知，1不通知
                "'Cost': "+cost+"," +   //快递费
                "'OtherCost': 0," +      //其他费用
                "'Sender':" +           //发件人信息
                "{" +
                "'Company':'"+store.getName()+"','Name':'"+store.getName()+"','Mobile':'"+store.getMobile()+"','ProvinceName':'浙江省','CityName':'杭州市','ExpAreaName':'余杭区','Address':'龙潭路2号'}," +
                "'Receiver':" +         //收件人信息
                "{" +
                "'Company':'"+orderShipping.getConsignee()+"','Name':'"+orderShipping.getConsignee()+"','Mobile':'"+orderShipping.getPhone()+"','ProvinceName':'"+provinceName+"','CityName':'"+cityName+"','ExpAreaName':'"+expAreaName+"','Address':'"+orderShipping.getAddress()+"','PostCode':'"+orderShipping.getZipCode()+"'}," +
                "'Commodity':" +        //商品信息
                "[" +
                goods.toString()+
               // "{'GoodsName':' ','Goodsquantity': ,'GoodsWeight': }" +
                "]," +
                "'Weight': "+ orderShipping.getOrder().getWeight()+"," +
                "'Quantity': "+orderShipping.getOrderShippingItems().size()+"," +
                "'Volume': 0," +
                "'Remark':' '}";

        Map<String, String> params = new HashMap<>();
        try {
            params.put("RequestData", urlEncoder(requestData, "UTF-8"));
            params.put("EBusinessID", getEBusinessID());
            params.put("RequestType", "1008");
            String dataSign=encrypt(requestData, getAppKey(), "UTF-8");
            params.put("DataSign", urlEncoder(dataSign, "UTF-8"));
            params.put("DataType", "2");
        } catch (Exception e) {
            e.printStackTrace();
        }

        String result=sendPost(requrl, params);

        JSONObject jsonObject=JSONObject.parseObject(result);
        if(jsonObject.getBoolean("Success")){
            return true;
        }else {
            logger.error("》》》"+orderShipping.getDeliveryCorp()+orderShipping.getTrackingNo()+"订阅失败《《《");
            logger.error("》》》原因："+jsonObject.getString("Reason")+"《《《");
            return false;
        }
    }
    /**
     * Json方式  物流订阅信息推送返回
     * @throws Exception
     */
    public Map orderTracesSubReturn(Boolean success,String reason){
        LinkedHashMap<String,Object> map=new LinkedHashMap<>();
        SimpleDateFormat dateFormat=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        map.put("EBusinessID",getEBusinessID());
        map.put("UpdateTime",dateFormat.format(new Date()));
        map.put("Success",success);
        map.put("Reason",reason==null ? "":reason);
        return map;
    }
    public void orderTracesSubReturn(String reason,HttpServletResponse response){
        SimpleDateFormat dateFormat=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        String responseResult = "{\"EBusinessID\": \"%s\",\" UpdateTime\": \"%s\",\" Success\": %s,\" Reason\":\"%s\"}";
        String writeResult = "";
        if(reason.equals("")){
            writeResult = String.format(responseResult,getEBusinessID(),dateFormat.format(new Date()), "true", "");
        }else{
            writeResult  = String.format(responseResult,getEBusinessID(),dateFormat.format(new Date()), "false", reason);
        }
        try {
            response.getWriter().write(writeResult);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    //#####以下内容为工具函数
    /**
     * MD5加密
     * @param str 内容
     * @param charset 编码方式
     * @throws Exception
     */
    @SuppressWarnings("unused")
    private String MD5(String str, String charset) throws Exception {
        MessageDigest md = MessageDigest.getInstance("MD5");
        md.update(str.getBytes(charset));
        byte[] result = md.digest();
        StringBuffer sb = new StringBuffer(32);
        for (int i = 0; i < result.length; i++) {
            int val = result[i] & 0xff;
            if (val <= 0xf) {
                sb.append("0");
            }
            sb.append(Integer.toHexString(val));
        }
        return sb.toString().toLowerCase();
    }

    /**
     * base64编码
     * @param str 内容
     * @param charset 编码方式
     * @throws UnsupportedEncodingException
     */
    private String base64(String str, String charset) throws UnsupportedEncodingException {
        String encoded = base64Encode(str.getBytes(charset));
        return encoded;
    }

    @SuppressWarnings("unused")
    private String urlEncoder(String str, String charset) throws UnsupportedEncodingException{
        String result = URLEncoder.encode(str, charset);
        return result;
    }

    /**
     * 电商Sign签名生成
     * @param content 内容
     * @param keyValue Appkey
     * @param charset 编码方式
     * @throws UnsupportedEncodingException ,Exception
     * @return DataSign签名
     */
    @SuppressWarnings("unused")
    private String encrypt (String content, String keyValue, String charset) throws UnsupportedEncodingException, Exception
    {
        if (keyValue != null)
        {
            return base64(MD5(content + keyValue, charset), charset);
        }
        return base64(MD5(content, charset), charset);
    }

    /**
     * 向指定 URL 发送POST方法的请求
     * @param url 发送请求的 URL
     * @param params 请求的参数集合
     * @return 远程资源的响应结果
     */
    @SuppressWarnings("unused")
    private String sendPost(String url, Map<String, String> params) {
        OutputStreamWriter out = null;
        BufferedReader in = null;
        StringBuilder result = new StringBuilder();
        try {
            URL realUrl = new URL(url);
            HttpURLConnection conn =(HttpURLConnection) realUrl.openConnection();
            // 发送POST请求必须设置如下两行
            conn.setDoOutput(true);
            conn.setDoInput(true);
            // POST方法
            conn.setRequestMethod("POST");
            // 设置通用的请求属性
            conn.setRequestProperty("accept", "*/*");
            conn.setRequestProperty("connection", "Keep-Alive");
            conn.setRequestProperty("user-agent",
                    "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1;SV1)");
            conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
            conn.connect();
            // 获取URLConnection对象对应的输出流
            out = new OutputStreamWriter(conn.getOutputStream(), "UTF-8");
            // 发送请求参数
            if (params != null) {
                StringBuilder param = new StringBuilder();
                for (Map.Entry<String, String> entry : params.entrySet()) {
                    if(param.length()>0){
                        param.append("&");
                    }
                    param.append(entry.getKey());
                    param.append("=");
                    param.append(entry.getValue());
                    //System.out.println(entry.getKey()+":"+entry.getValue());
                }
                //System.out.println("param:"+param.toString());
                out.write(param.toString());
            }
            // flush输出流的缓冲
            out.flush();
            // 定义BufferedReader输入流来读取URL的响应
            in = new BufferedReader(
                    new InputStreamReader(conn.getInputStream(), "UTF-8"));
            String line;
            while ((line = in.readLine()) != null) {
                result.append(line);
            }
        } catch (Exception e) {
            logger.error(e.getMessage());
            e.printStackTrace();
        }
        //使用finally块来关闭输出流、输入流
        finally{
            try{
                if(out!=null){
                    out.close();
                }
                if(in!=null){
                    in.close();
                }
            }
            catch(IOException ex){
                ex.printStackTrace();
            }
        }
        return result.toString();
    }
    private static char[] base64EncodeChars = new char[] {
            'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H',
            'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P',
            'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X',
            'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f',
            'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n',
            'o', 'p', 'q', 'r', 's', 't', 'u', 'v',
            'w', 'x', 'y', 'z', '0', '1', '2', '3',
            '4', '5', '6', '7', '8', '9', '+', '/' };
    public static String base64Encode(byte[] data) {
        StringBuffer sb = new StringBuffer();
        int len = data.length;
        int i = 0;
        int b1, b2, b3;
        while (i < len) {
            b1 = data[i++] & 0xff;
            if (i == len)
            {
                sb.append(base64EncodeChars[b1 >>> 2]);
                sb.append(base64EncodeChars[(b1 & 0x3) << 4]);
                sb.append("==");
                break;
            }
            b2 = data[i++] & 0xff;
            if (i == len)
            {
                sb.append(base64EncodeChars[b1 >>> 2]);
                sb.append(base64EncodeChars[((b1 & 0x03) << 4) | ((b2 & 0xf0) >>> 4)]);
                sb.append(base64EncodeChars[(b2 & 0x0f) << 2]);
                sb.append("=");
                break;
            }
            b3 = data[i++] & 0xff;
            sb.append(base64EncodeChars[b1 >>> 2]);
            sb.append(base64EncodeChars[((b1 & 0x03) << 4) | ((b2 & 0xf0) >>> 4)]);
            sb.append(base64EncodeChars[((b2 & 0x0f) << 2) | ((b3 & 0xc0) >>> 6)]);
            sb.append(base64EncodeChars[b3 & 0x3f]);
        }
        return sb.toString();
    }


}
