package com.mzskyzx.webunittest;

import org.openqa.selenium.WebElement;

public class WebElementx {

	private WebElement we;
	
	public WebElementx(WebElement we){
		this.we = we;
	}
	
	public String val(){
		return we.getAttribute("value");
	}
	
	public void val(String value){
		we.clear();
		we.sendKeys(value);
	}

	public void val(int value){
		we.clear();
		we.sendKeys(String.valueOf(value));
	}
	
	public String text(){
		return we.getText();
	}
	
	public void click(){
		we.click();
	}
	
	public WebElement get(){
		return we;
	}
}
