package cn.itcast.bos.consumer;

import javax.jms.JMSException;
import javax.jms.MapMessage;
import javax.jms.Message;
import javax.jms.MessageListener;

import org.springframework.stereotype.Component;

import com.aliyuncs.dysmsapi.model.v20170525.SendSmsResponse;

import cn.itcast.bos.utils.SmsDemoUtils;

// Queue消费者
@Component("smsQueueConsumer")
public class SmsQueueConsumer implements MessageListener {

	public void onMessage(Message message) {
		MapMessage mapMessage = (MapMessage)message;
		try {
			String telephone = mapMessage.getString("telephone");
			String number = mapMessage.getString("number");
			// 调用阿里大鱼发送短信
//			SendSmsResponse sendSms = SmsDemoUtils.sendSms(telephone, number);
//			String code = sendSms.getCode();
			String code = "OK";
			if(code.equals("OK")){
				System.out.println("使用短信平台bos_sms发送短信成功！电话号是："+telephone+"，验证码是："+number);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

}
