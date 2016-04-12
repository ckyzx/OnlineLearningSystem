package com.mzskyzx.webunittest.ols;

import org.junit.runner.RunWith;
import org.junit.runners.Suite;

@RunWith(Suite.class)
@Suite.SuiteClasses({
	LoginTest.class,
	ManualTaskTest.class,
	AutoTaskDayTest.class,
	AutoTaskWeekTest.class,
	AutoTaskMonthTest.class,
	CustomTaskTest.class
})
public class TestSuiteWithCreateTask {

}
