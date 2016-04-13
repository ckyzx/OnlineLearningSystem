package com.mzskyzx.webunittest;

import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.concurrent.TimeUnit;

import org.openqa.selenium.By;
import org.openqa.selenium.NoSuchElementException;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.edge.EdgeDriver;
import org.openqa.selenium.ie.InternetExplorerDriver;

public class WebUnitTest {

	protected static WebDriver wd;
	protected Date now;
	protected Calendar calendar;

	public WebUnitTest() {
		// init("chrome");
	}

	public WebUnitTest(String driver) {
		init(driver);
	}

	public WebUnitTest(String driver, String url) {
		init(driver);
		wd.get(url);
	}

	protected void init(String driver) {
		init(driver, true, 10);
	}

	protected void init(String driver, Boolean ifMax, int loadWait) {

		now = new Date();
		calendar = Calendar.getInstance();

		if (driver == "ie") {
			System.setProperty("webdriver.ie.driver", "Resources\\IEDriverServer.exe");
			wd = new InternetExplorerDriver();
		} else if (driver == "edge") {
			System.setProperty("webdriver.edge.driver", "Resources\\MicrosoftWebDriver.exe");
			wd = new EdgeDriver();
		} else {
			System.setProperty("webdriver.chrome.driver", "Resources\\chromedriver.exe");
			wd = new ChromeDriver();
		}
		if(ifMax){
			wd.manage().window().maximize();
		}
		wd.manage().timeouts().implicitlyWait(loadWait, TimeUnit.SECONDS);
	}

	public static WebDriver getWd() {
		return wd;
	}

	public static void setWd(WebDriver wd) {
		WebUnitTest.wd = wd;
	}

	public Date getNow() {
		return now;
	}

	public void setNow(Date now) {
		this.now = now;
	}

	public WebElement $(String selector) {

		int poundIndex;
		String tag, id;
		WebElement we = null;

		try {

			if (selector.indexOf("#") != -1) {

				poundIndex = selector.indexOf("#");
				if (poundIndex == 0) {
					tag = "*";
				} else {
					tag = selector.substring(0, poundIndex);
				}
				id = selector.substring(poundIndex + 1);
				we = $x("//" + tag + "[@id='" + id + "']");
			}
		} catch (NoSuchElementException e) {
		}
		return we;
	}

	public List<WebElement> $xs(String xpath) {
		try {
			return wd.findElements(By.xpath(xpath));
		} catch (NoSuchElementException e) {
		}
		return null;
	}

	public WebElement $x(String xpath) {
		try {
			return wd.findElement(By.xpath(xpath));
		} catch (NoSuchElementException e) {
		}
		return null;
	}

	public WebElementx $wex(String selector) {
		if (selector.indexOf("//") == 0) {
			return new WebElementx($x(selector));
		} else {
			return new WebElementx($(selector));
		}
	}

	public void close() {
		wd.close();
	}
}
