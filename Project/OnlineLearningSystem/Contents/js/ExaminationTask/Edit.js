$(function() {
    'use strict';

    var ztree, qcZtree;
    var userIds, userNames, departmentIds, departmentNames;
    var et;

    et = OLS.ExaminationTask.init({
        idPrefix: 'ET_'
    });

    // 初始化提交事件
    olsCustomSubmitHandler = submitHandler;

    function submitHandler(form) {

        var etStartTime, etEndTime;
        var mode, startDate, endDate, startTime, continuedDays, endTime;

        if (!validateData()) {
            return false;
        }

        etStartTime = $('#ET_StartTime');
        etEndTime = $('#ET_EndTime');
        mode = $('#ET_Mode').val();
        if (0 == mode) { // 手动

            etStartTime.val('1970/1/1 00:00:00');
            etEndTime.val('1970/1/1 00:00:00');
        } else if (2 == mode) { // 预定

            // 设置开始日期
            startDate = $('#ETStartDate').val();
            startDate = startDate.toDate();
            startTime = $('#ET_StartTime').val();
            startTime = startTime.toDate();
            etStartTime.val(
                startDate.getFullYear() + '/' + (startDate.getMonth() + 1) + '/' + startDate.getDate() + ' ' +
                startTime.getHours() + ':' + startTime.getMinutes() + ':' + startTime.getSeconds());


            endTime = $('#ET_EndTime').val();
            endTime = endTime.toDate();
            continuedDays = $('#ET_ContinuedDays').val();
            continuedDays = continuedDays > 1 ? (continuedDays - 1) : 0;
            endDate = startDate.add('d', continuedDays);
            etEndTime.val(
                startDate.getFullYear() + '/' + (startDate.getMonth() + 1) + '/' + startDate.getDate() + ' ' +
                endTime.getHours() + ':' + endTime.getMinutes() + ':' + endTime.getSeconds());
        }

        if (!confirm('确定提交吗？')) {
            return false;
        } else {
            $(form).submit();
        }
    }

    function validateData() {

        var valid;
        var type, mode;

        $('.custom-validation-error').remove();

        valid = true;

        type = Number($('#ET_Type').val());
        mode = Number($('#ET_Mode').val());

        // 练习
        if(type == 1){
            valid= et.validateAutoClassifies(valid);
            valid = et.validateAutoRatios(valid);
            valid = et.validateCustomAutoTypeData(valid);
            valid = et.validateContinuedDays(valid);
        // 考试
        }else{

            // 手动任务
            if(0 == mode){
                valid = et.validateQuestions(valid);
            }

            // 自动任务
            if (1 == mode) {
                valid= et.validateAutoClassifies(valid);
                valid = et.validateAutoRatios(valid);
                valid = et.validateStartTime(valid);
                valid = et.validateEndTime(valid);
            }

            // 预定任务
            if (2 == mode) {
                valid = et.validateQuestions(valid);
                valid = et.validateCustomAutoTypeData(valid);
                valid = et.validateContinuedDays(valid);
            }
        }
        
        valid = et.validateTotal(valid);

        return valid;
    }

});
