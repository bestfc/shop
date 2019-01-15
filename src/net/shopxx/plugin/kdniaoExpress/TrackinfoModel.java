package net.shopxx.plugin.kdniaoExpress;

import java.util.List;

public class TrackinfoModel {
    public class Trace{
        private String AcceptTime;
        private String AcceptStation;
        private String Remark;

        public void setAcceptTime(String acceptTime) {
            AcceptTime = acceptTime;
        }

        public void setAcceptStation(String acceptStation) {
            AcceptStation = acceptStation;
        }

        public void setRemark(String remark) {
            Remark = remark;
        }

        public String getAcceptTime() {
            return AcceptTime;
        }

        public String getAcceptStation() {
            return AcceptStation;
        }

        public String getRemark() {
            return Remark;
        }
    }

    private Boolean Success;
    private String Reason;
    private Integer State;
    private List<Trace> Traces;

    public Boolean getSuccess() {
        return Success;
    }

    public void setSuccess(Boolean success) {
        Success = success;
    }

    public String getReason() {
        return Reason;
    }

    public void setReason(String reason) {
        Reason = reason;
    }

    public Integer getState() {
        return State;
    }

    public void setState(Integer state) {
        State = state;
    }

    public List<Trace> getTraces() {
        return Traces;
    }

    public void setTraces(List<Trace> traces) {
        Traces = traces;
    }
}
