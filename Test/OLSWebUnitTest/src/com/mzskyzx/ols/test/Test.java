package com.mzskyzx.ols.test;

public class Test {
	public static void main(String[] args){
		String s1, s2;
		
		s1 = "身份证号或密码有误。";
		s2 = "身份证号或密码有误。";
		if(s1 == s2){
			System.out.println("Success.");
		}else{
			System.out.println("Failure.");
		}
		if(s1.equals(s2)){
			System.out.println("Success.");
		}else{
			System.out.println("Failure.");
		}
	}
}
