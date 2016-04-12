package com.mzskyzx.webunittest.ols;

import static org.junit.Assert.*;

import java.util.concurrent.TimeUnit;

import org.junit.AfterClass;
import org.junit.BeforeClass;
import org.junit.Test;
import org.openqa.selenium.Alert;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.chrome.ChromeDriver;

public class LoginTest {
	
	private static WebDriver wd;

	@BeforeClass
	public static void setUpBeforeClass() throws Exception {
		System.setProperty("webdriver.chrome.driver", "Resources\\chromedriver.exe");
		wd = new ChromeDriver();
		wd.manage().window().maximize();
	}

	@AfterClass
	public static void tearDownAfterClass() throws Exception {
	}

	@Test
	public void test() {
		
		WebElement name, pwd, submit;
		Alert alert = null;
		String expected = null, actual = null;
		
		try {
			
			wd.get("http://localhost:8090/User/Login");
			name = wd.findElement(By.id("UserName"));
			pwd = wd.findElement(By.id("Password"));
			submit = wd.findElement(By.id("Submit"));
			
			name.sendKeys("admin");
			pwd.sendKeys("123456");
			submit.click();
			
			try {
				
				Thread.sleep(3000);
				alert = wd.switchTo().alert();
				actual = alert.getText();
			} catch (Exception e) {
				e.printStackTrace();
			}
			expected = "身份证号或密码有误。";
			assertEquals("Failure.", expected, actual);
			
			alert.accept();
			pwd.clear();
			pwd.sendKeys("kyzx201510");
			submit.click();
			
			try{
				
				wd.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS);
				actual = wd.findElement(By.id("User")).getAttribute("user-name");
			}
			catch (Exception e){
				e.printStackTrace();
			}
			expected = "系统管理员";
			assertEquals("Failure.", expected, actual);
			
			wd.close();
		} catch (Exception ex) {
			System.out.println("Throw exception.");
			ex.printStackTrace();
		}
	}

}
