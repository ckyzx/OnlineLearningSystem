package com.mzskyzx.webunittest.ols;

import static org.junit.Assert.*;

import org.junit.AfterClass;
import org.junit.BeforeClass;

public class Test extends OLSTest {

	@BeforeClass
	public static void setUpBeforeClass() throws Exception {
	}

	@AfterClass
	public static void tearDownAfterClass() throws Exception {
	}

	@org.junit.Test
	public void test() {
		login();
		login();
	}

}
