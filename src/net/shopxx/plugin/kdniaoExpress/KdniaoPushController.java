package net.shopxx.plugin.kdniaoExpress;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import net.shopxx.entity.ShippingTraces;
import net.shopxx.service.ShippingTracesService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.Mapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Date;
import java.util.Map;

/**
 * Controller接受快递鸟订阅推送
 *
 * @author young
 * @version 2.0
 */
@Controller("kdniaoPushController")
@RequestMapping("/express/kdniao")
public class KdniaoPushController {

    @Autowired
    private KdniaoTrackQuery kdniaoTrackQuery;
    @Autowired
    private ShippingTracesService shippingTracesService;

    @PostMapping("/subscibe-push")
    public void getSubscibePush(HttpServletRequest request, HttpServletResponse response) {
        String reason="";
        try{
            String requestData = request.getParameter("RequestData");
            JSONObject jsonObject = JSONObject.parseObject(requestData);
            JSONArray jsonArray = jsonObject.getJSONArray("Data");
            for(Object obj:jsonArray){
                JSONObject data = JSONObject.parseObject(obj.toString());
               // String traces="{\"Traces\":"+data.getJSONArray("Traces").toString()+"}";
                String traces=data.getJSONArray("Traces").toString();
                String deliveryCorpCode=data.getString("ShipperCode");
                String trackingNo=data.getString("LogisticCode");
                ShippingTraces shippingTraces=shippingTracesService.findByCode(deliveryCorpCode,trackingNo);
                shippingTraces.setTraces(traces);
                shippingTraces.setLastModifiedDate(new Date());
                shippingTracesService.update(shippingTraces);

            }
        }catch (Exception e){
            reason=e.getMessage()+e.toString();
        }finally {
            kdniaoTrackQuery.orderTracesSubReturn(reason,response);
        }
    }
}
