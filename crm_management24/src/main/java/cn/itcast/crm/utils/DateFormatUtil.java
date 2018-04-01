package cn.itcast.crm.utils;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

import org.codehaus.groovy.syntax.TokenMismatchException;

public class DateFormatUtil {
	private static DateFormat df = new SimpleDateFormat("yyyy-MM-dd");

	// 将日期转成字符串
	public static String changeDateToString(Date date) {
		return df.format(date);
	}

	// 获得你输入的那天计算所输入偏差后的的那一天
	public static Date getDateWithOffsetDay(Date date, int day) {
		Calendar c = Calendar.getInstance();
		c.setTime(date);
		// 通过日历类获取第二天的日期
		c.add(Calendar.DAY_OF_MONTH, day);
		return c.getTime();
	}

	// 将字符串转成日期
	public static Date changeStringToDate(String date) throws ParseException {
		return df.parse(date);
	}

	// 将两个日期变成年月日的字符串形式,然后进行比较是否相等的方法
	public static boolean compareDateByString(Date d1, Date d2) {
		String StrD1 = changeDateToString(d1);
		String StrD2 = changeDateToString(d2);
		if (StrD1.equals(StrD2)) {
			return true;
		}
		return false;
	}

	// 测试工具类
	public static void main(String[] args) throws ParseException {
		Date date1 = changeStringToDate("2018-3-30");
		Date tomorrow = getDateWithOffsetDay(date1, 1);
		System.out.println(compareDateByString(tomorrow,new Date()));
		
		/*
		 * Date tomorrow = DateFormatUtil.getDateWithOffsetDay(date1, 1); Date
		 * nowdate = new Date(); System.out.println(tomorrow.equals(nowdate));
		 */
	}
}
