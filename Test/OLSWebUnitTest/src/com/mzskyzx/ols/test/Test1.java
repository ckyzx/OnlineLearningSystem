package com.mzskyzx.ols.test;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;

import com.mzskyzx.webunittest.WebUnitTest;

public class Test1 {

	public static void main(String[] args){
		
		WebDriver wd;
		WebElement we;
		
		new WebUnitTest();
		wd = WebUnitTest.getWd();
		wd.get("http://localhost:8084/selenium-test/test1.html");
		// √
		//we = wd.findElement(By.xpath("//div[@id='container']/div[.//span[@class='inner']]"));
		//System.out.println(we.getAttribute("class"));
		// √
		//we = wd.findElement(By.xpath("//span[@class='sub-inner']"));
		//System.out.println(we.getText());
		// ×
		//we = wd.findElement(By.xpath("//div[@id='container']/div[.//span[@class='inner']]/span[@class='sub-inner']"));
		//System.out.println(we.getText());
		// ×
		we = wd.findElement(By.xpath("//div[@id='container']/div[.//span[@class='inner']]"));
		System.out.println(we.getAttribute("class"));
		we = we.findElement(By.xpath("//span[@class='inner']"));
		System.out.println(we.getText());
	}
}
