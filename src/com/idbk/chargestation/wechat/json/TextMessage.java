package com.idbk.chargestation.wechat.json;
/**
 * 按照微信的接入文档编写的微信文本消息实体
 * @author gaoqy
 * @date 2015-5-22 下午12:04:26
 */
public class TextMessage extends BaseMessage{

	
	private String Content;
	private String MsgId;
	
	public TextMessage() {
		
	}
	
	public String getContent() {
		return Content;
	}
	public void setContent(String content) {
		Content = content;
	}
	public String getMsgId() {
		return MsgId;
	}
	public void setMsgId(String msgId) {
		MsgId = msgId;
	}
}
