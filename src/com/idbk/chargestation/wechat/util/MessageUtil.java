//package com.idbk.chargestation.wechat.util;
//
//import java.io.IOException;
//import java.io.InputStream;
//import java.util.Date;
//import java.util.HashMap;
//import java.util.List;
//import java.util.Map;
//
//import javax.servlet.http.HttpServletRequest;
//
//import org.dom4j.Document;
//import org.dom4j.DocumentException;
//import org.dom4j.Element;
//import org.dom4j.io.SAXReader;
//
//import com.idbk.chargestation.wechat.json.TextMessage;
//import com.thoughtworks.xstream.XStream;
//
///**
// * 实现消息的格式转换(Map类型和XML的互转)
// * @author gaoqy
// * @date 2018-9-26 上午10:40:41
// */
//public class MessageUtil {
//
//	public static final String MESSAGE_TEXT = "text";
//	public static final String MESSAGE_IMAGE = "image";
//	public static final String MESSAGE_VOICE = "voice";
//	public static final String MESSAGE_VIDEO = "video";
//	public static final String MESSAGE_LOCATION = "location";
//	public static final String MESSAGE_LINK = "link";
//	public static final String MESSAGE_EVENT = "event";
//	public static final String MESSAGE_SUBSCRIBE = "subscribe";
//	public static final String MESSAGE_UNSUBSCRIBE = "unsubscribe";
//	public static final String MESSAGE_CLICK = "CLICK";
//	public static final String MESSAGE_VIEW = "VIEW";
//	public static final String MESSAGE_NEWS = "news";
//	public static final String MESSAGE_MUSIC = "music";
//	public static final String MESSAGE_SCANCODE = "scancode_push";
//	
//	/**
//	 * 将XML转换成Map集合
//	 */
//	@SuppressWarnings("unchecked")
//	public static Map<String, String>xmlToMap(HttpServletRequest request) throws IOException, DocumentException{
//		
//		Map<String, String> map = new HashMap<String, String>();
//		SAXReader reader = new SAXReader();			// 使用dom4j解析xml
//		InputStream ins = request.getInputStream(); // 从request中获取输入流
//		Document doc = reader.read(ins);
//		
//		Element root = doc.getRootElement(); 		// 获取根元素
//		List<Element> list = root.elements();		// 获取所有节点
//		
//		for (Element e : list) {
//			map.put(e.getName(), e.getText()); 
//			System.out.println(e.getName() + "--->" + e.getText());
//		}
//		ins.close();
//		return map;
//	}
//	
//	/**
//	 * 将文本消息对象转换成XML
//	 */
//	public static String textMessageToXML(TextMessage textMessage){
//		
//		XStream xstream = new XStream();			  // 使用XStream将实体类的实例转换成xml格式	
//		xstream.alias("xml", textMessage.getClass()); // 将xml的默认根节点替换成“xml”
//		return xstream.toXML(textMessage);
//		
//	}
//
//	
////	/**
////	 * 音乐消息转化为xml
////	 * @param imageMessage
////	 * @return
////	 */
////	public static String musicMessageToXML(MusicMessage musicMessage){
////		
////		XStream xstream = new XStream();			  // 使用XStream将实体类的实例转换成xml格式	
////		xstream.alias("xml", musicMessage.getClass()); // 将xml的默认根节点替换成“xml”
////		return xstream.toXML(musicMessage);
////		
////	}
//	
//	/**
//	 * 拼接文本消息
//	 * @return
//	 */
//	public static String initText(String fromUserName,String toUserName,String content){
//		
//		TextMessage text = new TextMessage();
//		text.setFromUserName(toUserName); 		// 发送和回复是反向的
//		text.setToUserName(fromUserName);
//		text.setMsgType(MESSAGE_TEXT);
//		text.setCreateTime(new Date().getTime());
//		text.setContent(content);
//		return textMessageToXML(text);
//		
//	}
//	
////	/**
////	 * 组装图文消息
////	 * @param fromUserName
////	 * @param toUserName
////	 * @return
////	 */
////	public static String initNewsMessage(String fromUserName,String toUserName){
////		
////		String message = null;
////		List<News> newslList = new ArrayList<News>();
////		NewsMessage newsMessage = new NewsMessage();
////		News news = new News();
////		news.setTitle("慕课介绍");
////		news.setDescription("三点法第三  第三方三点飞屌丝方法三点飞三点 浮动是飞三点飞三点 发送的飞三点飞三点方法的是 发送的飞三点飞三点方法");
////		news.setPicUrl("http://7xlan5.com1.z0.glb.clouddn.com/images/9-cells.jpg");
////		news.setUrl("http://www.imooc.com");
////		newslList.add(news);
////		newsMessage.setFromUserName(toUserName);
////		newsMessage.setToUserName(fromUserName);
////		newsMessage.setCreateTime(new Date().getTime());
////		newsMessage.setMsgType(MESSAGE_NEWS);
////		newsMessage.setArticles(newslList);
////		newsMessage.setArticleCount(newslList.size());
////		message = newsMessageToXML(newsMessage);
////		
////		return message;
////	}
//	
////	/**
////	 * 组装图片消息
////	 * @param fromUserName
////	 * @param toUserName
////	 * @return
////	 * @throws IOException 
////	 * @throws ClientProtocolException 
////	 */
////	public static String initImageMessage(String fromUserName,String toUserName) throws ClientProtocolException, IOException{
////		
////		String message = null;
////		
////		Image image = new Image();
////		image.setMediaId("hYGDuLUjC8Cv5p3CxMcCrYh-Lh-X6-nkFsGNseYHIK7H6xIfeKimhPoz6wRKvcYC");
////		ImageMessage imageMessage = new ImageMessage();
////		
////		imageMessage.setCreateTime(1444492282);
////		imageMessage.setFromUserName(toUserName);
////		imageMessage.setMsgType(MESSAGE_IMAGE);
////		imageMessage.setImage(image);
////		imageMessage.setToUserName(fromUserName);
////		
////		message = imageMessageToXML(imageMessage);
////		return message;
////	}
//	
//}
