@echo "确定执行删除操作吗？"
pause

rd /s /q OnlineLearningSystem\ErrorLogs
rd /s /q OnlineLearningSystem\Content\lib\ueditor\1.4.3\net\upload
md OnlineLearningSystem\Content\lib\ueditor\1.4.3\net\upload
del OnlineLearningSystem\Excels\* /f /s /q
del OnlineLearningSystem\bin\* /f /s /q
del OnlineLearningSystem\obj\* /f /s /q
del TimeTaskTestProject\bin\* /f /s /q
del TimeTaskTestProject\obj\* /f /s /q
del TestResults\* /f /s /q

pause