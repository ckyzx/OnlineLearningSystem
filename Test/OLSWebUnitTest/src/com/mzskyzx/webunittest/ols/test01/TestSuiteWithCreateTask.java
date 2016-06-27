package com.mzskyzx.webunittest.ols.test01;

import org.junit.runner.RunWith;
import org.junit.runners.Suite;

@RunWith(Suite.class)
@Suite.SuiteClasses({
	T01LoginTest.class,
	T02ManualTaskTest.class,
	T03AutoTaskDayTest.class,
	T04AutoTaskWeekTest.class,
	T05AutoTaskMonthTest.class,
	T06CustomTaskTest.class
})
public class TestSuiteWithCreateTask {

}
