package net.shopxx.exception;

import org.slf4j.Logger;

public class BusinessException extends Exception {
    private static final long serialVersionUID = 1L;
    protected int code = 0;

    public int getCode() {
        return this.code;
    }

    public void setCode(int code) {
        this.code = code;
    }

    public BusinessException() {super(); }

    public BusinessException(String message) {
        this(ErrorCode.SERVER_INTERNAL_ERROR,message);
    }

    public BusinessException(BasicErrorDesc desc) {
        super(desc.getName());
        this.code = desc.getCode();
    }
    public BusinessException(BasicErrorDesc desc,String message) {
        super(message);
        this.code = desc.getCode();
    }

    public BusinessException(BasicErrorDesc desc, Logger logger, Exception e) {
        super(desc.getName());
        this.code = desc.getCode();
        LogException(desc, logger, e);
    }

    public static void LogException(BasicErrorDesc desc, Logger logger, Exception e) {
        StringBuffer sb = new StringBuffer();
        sb.append("BusinessException:");
        sb.append(desc.getName());
        sb.append("code:");
        sb.append(desc.getCode());
        sb.append("===>error info:" + e);
        logger.error(sb.toString());
    }
}
