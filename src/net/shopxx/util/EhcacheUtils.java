package net.shopxx.util;

import net.sf.ehcache.Cache;
import net.sf.ehcache.CacheManager;
import net.sf.ehcache.Element;


public class EhcacheUtils {

    // 1. 创建缓存管理器
    CacheManager cacheManager = CacheManager.create("src/ehcache.xml");
    // 2. 获取缓存对象
    Cache cache = cacheManager.getCache("captcha");


    public  String setCache(String mobNum,int smscap) {
        // 3. 创建元素
        Element element = new Element(mobNum, smscap);
        // 4. 将元素添加到缓存
        cache.put(element);
        return null;
    }

    public  Object getCache(String mobNum) {
        Element value = cache.get(mobNum);
        return value.getObjectValue();
    }



    public static void main(String[] args) throws InterruptedException {
        EhcacheUtils ehcacheUtils=new EhcacheUtils();
        ehcacheUtils.setCache("17805056119",1234567);
        for (int i=0;i<100;i++){
            Thread.sleep(2000,0);
            System.out.println(ehcacheUtils.getCache("17805056119"));
        }


}


}
