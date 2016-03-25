$(function() {
    'use strict';

    var ztree, qcZtree;
    var userIds, userNames, departmentIds, departmentNames;
    var et;

    et = OLS.ExaminationTask.init({
        idPrefix: 'ETT_'
    });

    // 初始化提交事件
    olsCustomSubmitHandler = submitHandler;

    function submitHandler(form) {

        var etStartTime, etEndTime;
        var mode, startDate, startTime;

        if (!validateData()) {
            return false;
        }

        etStartTime = $('#ETT_StartTime');
        etEndTime = $('#ETT_EndTime');
        mode = $('#ETT_Mode').val();
        if (0 == mode) {

            etStartTime.val('1970/1/1 00:00:00');
            etEndTime.val('1970/1/1 00:00:00');
        }

        if (!confirm('确定提交吗？')) {
            return false;
        } else {
            $(form).submit();
        }
    }

    function validateData() {

        var valid;
        var etMode;
        var mode;

        $('.custom-validation-error').remove();

        valid = true;

        etMode = $('#ETT_Mode');
        mode = etMode.val();

        // 自动任务
        if (mode == 1) {

            valid = et.validateAutoRatios(valid);
            valid = et.validateStartTime(valid);
            valid = et.validateEndTime(valid);
        } else if (mode == 2) { // 预定任务

            valid = et.validateStartTime(valid);
            valid = et.validateEndTime(valid);
            valid = et.validateContinuedDays(valid);
        }

        return valid;
    }

});
