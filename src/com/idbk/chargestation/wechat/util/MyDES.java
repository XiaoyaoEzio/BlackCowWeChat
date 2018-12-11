package com.idbk.chargestation.wechat.util;

import java.security.MessageDigest;
import java.security.SecureRandom;
import javax.crypto.Cipher;
import javax.crypto.SecretKey;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.DESKeySpec;

/**
 * 用于请求短信验证码，防止被攻击
 * @author gqy
 *
 */
public class MyDES {
	
	private final static String DES = "DES";
    
	public final static String KEY = "EANAzDr0eLDVwiv5dBM535xpsPQ8Ny6-";
	
	public static void main(String[] args) throws Exception {
        String key = "1234564879798787878797989"; //密钥
        String para = "mobile="+"15200001111"+"&timeStamp="+"14465545464";//请求参数以及排序
        String data = MD5Encrypt(para.getBytes("UTF-8"));
        System.out.println("MD5值：" + data);
        System.out.println("sign值："+encrypt(data, key));
        // System.err.println(decrypt(encrypt(data, key), key));
    }
    
    /**
     * Description DES加密
     * 
     * @param data
     *            MD5编码
     * @param key
     *            密钥
     * @return
     * @throws Exception
     */
    public static String encrypt(String data, String key) throws Exception {
        // 获取双字节数据
        StringBuilder db = new StringBuilder();
        for (int i = 1; i < data.length(); i = i + 2) {
            db.append(data.charAt(i));
        }
        String dbString = db.toString();
        // 生成一个可信任的随机数源
        SecureRandom random = new SecureRandom();
        // 从原始密钥数据创建DESKeySpec对象
        DESKeySpec dks = new DESKeySpec(key.getBytes("UTF-8"));
        // 创建一个密钥工厂，然后用它把DESKeySpec转换成SecretKey对象
        SecretKeyFactory keyFactory = SecretKeyFactory.getInstance(DES);
        SecretKey securekey = keyFactory.generateSecret(dks);
        // Cipher对象实际完成加密操作
        Cipher cipher = Cipher.getInstance(DES);
        // 用密钥初始化Cipher对象
        cipher.init(Cipher.ENCRYPT_MODE, securekey, random);
        // 加密结果
        byte[] bt = cipher.doFinal(dbString.getBytes("UTF-8"));
        // 将字节转换为16进制字符串
        String result = byte2Hex(bt);
        return result;
    }
    /**
     * 将字节数组转换为十六进制字符串
     * 
     * @param b
     * @return
     */
    public static String byte2Hex(byte[] b) {
        String hs = "";
        String stmp = "";
        for (int n = 0; n < b.length; n++) {
            stmp = (java.lang.Integer.toHexString(b[n] & 0XFF));
            if (stmp.length() == 1) {
                hs = hs + "0" + stmp;
            } else {
                hs = hs + stmp;
            }
        }
        return hs.toUpperCase();
    }
    /**
     * MD5加密
     * 
     * @param bytes
     * @return  String  加密后的字节转16进制字符串
     */
    public final static String MD5Encrypt(byte[] bytes) {
        byte[] result = null;
        try {
            MessageDigest md5 = MessageDigest.getInstance("MD5");
            result = md5.digest(bytes);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return byte2Hex(result);
    }
}
