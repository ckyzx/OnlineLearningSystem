@echo "确定执行删除操作吗？"
pause

rd /s /q OnlineLearningSystem\App_Data
rd /s /q OnlineLearningSystem\aspnet_client
rd /s /q OnlineLearningSystem\Controllers
rd /s /q OnlineLearningSystem\Models
rd /s /q OnlineLearningSystem\obj
rd /s /q OnlineLearningSystem\Properties
rd /s /q OnlineLearningSystem\Utilities
rd /s /q OnlineLearningSystem\ViewModels
rd /s /q OnlineLearningSystem\ErrorLogs
rd /s /q OnlineLearningSystem\Content\lib\ueditor\1.4.3\net\upload\file
del OnlineLearningSystem.csproj /f /s /q
del OnlineLearningSystem.csproj.user /f /s /q
del Web.Debug.config /f /s /q
del Web.Release.config /f /s /q
del Global.asax.cs /f /s /q
del packages.config /f /s /q

pause