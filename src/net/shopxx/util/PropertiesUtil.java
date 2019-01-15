package net.shopxx.util;

import org.slf4j.LoggerFactory;
import org.springframework.util.ResourceUtils;

import java.io.*;
import java.util.Properties;

public class PropertiesUtil {
    private static org.slf4j.Logger logger = LoggerFactory.getLogger(PropertiesUtil.class);

    private String path;

    public String getPath() {
        return path;
    }

    public void setPath(String path) {
        this.path = path;
    }

    private boolean bInit = false;

    private Properties properties;

    public void Init(){
        logger.info("loadding properties...");
        File file = null;
        properties=new Properties();
        if(path == null) {
            logger.error("Properties Not Found!!! please check file or Spring's configuration");
        }
        InputStream in = null;
        try {
            file = ResourceUtils.getFile(path);
            in = new BufferedInputStream(new FileInputStream(file));

        } catch (FileNotFoundException e) {
            in = PropertiesUtil.class.getClassLoader().getResourceAsStream(path);
        }
        if(in != null) {
            try {
                properties.load(new InputStreamReader(in,"UTF-8"));
            } catch (IOException e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
            }
            bInit = true;
        }
    }

    public String getValue(String key){
        if(!bInit){
            Init();
        }
        if(properties != null){
            return properties.getProperty(key);
        }
        return null;
    }
}
