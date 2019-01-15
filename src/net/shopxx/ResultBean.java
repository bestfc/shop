package net.shopxx;

import java.io.Serializable;

public class ResultBean implements Serializable {
    private static final long serialVersionUID = 1553528004123260834L;
    protected String msg;
    protected int code;
    protected Object data;

    public ResultBean(){}

    public ResultBean(String msg) {
        this.msg = msg;
    }

    public ResultBean(String msg, int code) {
        this.msg = msg;
        this.code = code;
    }

    public ResultBean(String msg, int code, Object data) {
        this.msg = msg;
        this.code = code;
        this.data = data;
    }

    public String getMsg() {
        return msg;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }

    public int getCode() {
        return code;
    }

    public void setCode(int code) {
        this.code = code;
    }

    public Object getData() {
        return data;
    }

    public void setData(Object data) {
        this.data = data;
    }

    public static ResultBean OK(){
        return new ResultBean("操作成功",50000);
    }
    public static ResultBean OK(String msg){
        return new ResultBean(msg,50000);
    }
    public static ResultBean OK(Object object){
        return new ResultBean("操作成功",50000,object);
    }
    public static ResultBean Error(){
        return new ResultBean("操作失败",40000);
    }
    public static ResultBean Error(String msg){
        return new ResultBean(msg,40000);
    }
    public static ResultBean Error(String msg, int code){
        return new ResultBean(msg,code);
    }
}
