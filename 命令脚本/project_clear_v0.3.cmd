@echo "确定执行删除操作吗？"
pause

rd /s /q OnlineLearningSystem\ErrorLogs
rd /s /q OnlineLearningSystem\Content\lib\ueditor\1.4.3\net\upload\file
del TestResults\* /f /s /q

pause