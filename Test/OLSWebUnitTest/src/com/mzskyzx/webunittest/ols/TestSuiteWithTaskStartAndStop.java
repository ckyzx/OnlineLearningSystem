package com.mzskyzx.webunittest.ols;

import org.junit.runner.RunWith;
import org.junit.runners.Suite;

@RunWith(Suite.class)
@Suite.SuiteClasses({
	ManualTaskTest.class,
	AutoTaskDayTest.class,
	AutoTaskWeekTest.class,
	AutoTaskMonthTest.class,
	CustomTaskTest.class,
	TaskStartAndStopTest.class
})
public class TestSuiteWithTaskStartAndStop {

}
