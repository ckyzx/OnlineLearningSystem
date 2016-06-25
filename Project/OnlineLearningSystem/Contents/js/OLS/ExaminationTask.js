if(undefined == OLS){
    OLS = {};
}

OLS.ExaminationTask = {
    settings: {
        idPrefix: ''
    },
    s: null,
    v: {
        ztree: null,
        qcZtree: null,
        userIds: [],
        userNames: [],
        departmentIds: [],
        departmentNames: []
    },

    init: function(settings) {

        $.extend(this.settings, settings);

        this.s = this.settings;

        // 初始化任务模板事件
        this.initTemplateEvent();

        // 初始化任务类型控件事件
        this.initTypeEvent();

        // 初始化成绩统计方式控件事件
        this.initStatisticTypeEvent();

        // 初始化出题方式控件事件
        this.initModeEvent();

        // 初始化出题方式控件事件
        this.initAutoTypeEvent();

        // 初始化部门/用户选择控件
        this.renderDepartmentsAndUsers();

        // 初始化试题分类选择控件
        this.renderQuestionClassifies();

        // 初始化自动出题比例选择控件
        this.renderAutoRatio();

        // 初始化开始时间、结束时间控件事件
        this.initStartTimeEvent();
        this.initEndTimeEvent();

        // 初始化控件
        this.initControls();

        return this;
    },

    initTemplateEvent: function() {

        var me;

        me = this;

        $('#' + me.s.idPrefix + 'Template').on('change', function() {

            var select, template, departmentIds, userIds;
            var ztree, nodes, autoClassifies;

            select = $(this);
            template = select.val();

            if ('' == template) {
                return;
            }

            template = $.parseJSON(template);

            $('#' + me.s.idPrefix + 'Type').val(template.ETT_Type);
            $('#' + me.s.idPrefix + 'ParticipatingDepartment').val(template.ETT_ParticipatingDepartment);
            $('#' + me.s.idPrefix + 'Attendee').val(template.ETT_Attendee);
            $('#' + me.s.idPrefix + 'StatisticType').val(template.ETT_StatisticType).change();
            $('#' + me.s.idPrefix + 'TotalScore').val(template.ETT_TotalScore);
            $('#' + me.s.idPrefix + 'TotalNumber').val(template.ETT_TotalNumber)
            $('#' + me.s.idPrefix + 'Mode').val(template.ETT_Mode).change();
            $('#' + me.s.idPrefix + 'AutoType').val(template.ETT_AutoType).change();
            $('#AutoOffsetDayContainer .offset-day-num').val(template.ETT_AutoOffsetDay).change();
            $('#' + me.s.idPrefix + 'DifficultyCoefficient').val(template.ETT_DifficultyCoefficient);
            $('#' + me.s.idPrefix + 'AutoClassifies').val(template.ETT_AutoClassifies);
            $('#' + me.s.idPrefix + 'AutoRatio').val(template.ETT_AutoRatio);
            $('#' + me.s.idPrefix + 'StartTime').val(template.ETT_StartTime.toDate().format('yyyy/M/d hh:mm:ss'));
            $('#' + me.s.idPrefix + 'EndTime').val(template.ETT_EndTime.toDate().format('yyyy/M/d hh:mm:ss'));
            $('#' + me.s.idPrefix + 'TimeSpan').val(template.ETT_TimeSpan);

            departmentIds = $.parseJSON(template.ETT_ParticipatingDepartment);
            userIds = $.parseJSON(template.ETT_Attendee);

            // 设置参与人员
            ztree = $.fn.zTree.getZTreeObj('DepartmentsAndUsers');
            nodes = ztree.getNodes();
            me.setDepartmentsAndUsersNodeChecked(ztree, nodes, departmentIds, userIds);

            // 设置自动出题分类
            ztree = $.fn.zTree.getZTreeObj('QuestionClassifies');
            nodes = ztree.getNodes();
            autoClassifies = JSON.parse(template.ETT_AutoClassifies);
            me.setQuestionClassifiesNodeChecked(ztree, nodes, autoClassifies);

            // 设置出题比例
            me.setRatios(template.ETT_AutoRatio);
            me.renderAutoRatio();

            // 设置开始时间、结束时间
            me._setTime('StartTime');
            me._setTime('EndTime');
        });
    },

    initStatisticTypeEvent: function() {

        var me;

        me = this;

        $('#' + me.s.idPrefix + 'StatisticType').on('change', function() {

            var select, etTotalScore, etTotalNumber, tsContainer, anContainer;
            var type;

            select = $(this);
            type = parseInt(select.val());

            etTotalScore = $('#' + me.s.idPrefix + 'TotalScore');
            etTotalNumber = $('#' + me.s.idPrefix + 'TotalNumber');
            tsContainer = etTotalScore.parentsUntil('form').last();
            anContainer = etTotalNumber.parentsUntil('form').last();

            switch (type) {
                case 0:

                    tsContainer.hide();
                    anContainer.hide();

                    break;
                case 1:

                    tsContainer.show();
                    anContainer.hide();

                    break;
                case 2:

                    tsContainer.hide();
                    anContainer.show();

                    break;
                default:
                    break;
            }

        });
        $('#' + me.s.idPrefix + 'StatisticType').change();
    },

    initTypeEvent: function() {

        var me;
        var etType;
        var req, etId;

        me = this;

        // 判断是否隐藏任务类型
        req = Request.init();
        etId = req.getValue('id', 0);

        if(0 != etId){
            me._toggleElementContainer('#' + me.s.idPrefix + 'Type', false);
            return;
        }

        etType = $('#' + me.s.idPrefix + 'Type');

        etType.on('change', function() {

            var etType;
            var type;

            etType = $(this);
            type = parseInt(etType.val());

            switch (type) {
                case 0: // 考试

                    // 显示任务模板
                    me._toggleElementContainer('#' + me.s.idPrefix + 'Template', true);

                    // 设置成绩计算类型
                    $('#' + me.s.idPrefix + 'StatisticType').val(1).change();
                    me._toggleElementContainer('#' + me.s.idPrefix + 'StatisticType', true);

                    // 设置自动类型
                    me._toggleElementContainer('#' + me.s.idPrefix + 'Mode', true);
                    $('#' + me.s.idPrefix + 'Mode').val(0).change();

                    break;
                case 1: // 练习

                    // 隐藏任务模板
                    me._toggleElementContainer('#' + me.s.idPrefix + 'Template', false);

                    // 设置成绩计算类型
                    $('#' + me.s.idPrefix + 'StatisticType').val(2).change();
                    me._toggleElementContainer('#' + me.s.idPrefix + 'StatisticType', false);

                    // 设置自动类型
                    $('#' + me.s.idPrefix + 'Mode').val(2).change();
                    me._toggleElementContainer('#' + me.s.idPrefix + 'Mode', false);
                    me._toggleElementContainer('#' + me.s.idPrefix + 'AutoType', false);

                    // 隐藏试题列表
                    $('#QuestionListSelectContainer').hide();

                    // 显示出题分类
                    me._toggleElementContainer('#' + me.s.idPrefix + 'AutoClassifies', true);

                    // 显示出题比例
                    me._toggleElementContainer('#' + me.s.idPrefix + 'AutoRatio', true);

                    break;
                default:
                    break;
            }
        });

        etType.change();
    },

    initModeEvent: function() {

        var etMode, etAutoType;
        var autoType;
        var me;

        me = this;

        etMode = $('#' + me.s.idPrefix + 'Mode');
        etAutoType = $('#' + me.s.idPrefix + 'AutoType');

        etMode.on('change', function() {

            var etMode, etAutoType;
            var mode;

            etAutoType = $('#' + me.s.idPrefix + 'AutoType');

            etMode = $(this);
            mode = parseInt(etMode.val());

            switch (mode) {
                case 0:

                    etAutoType.find('option[value=0]').get(0).selected = true;
                    etAutoType.change();
                    break;
                case 1:

                    etAutoType.find('option[value=1]').get(0).selected = true;
                    etAutoType.change();
                    break;
                case 2:

                    etAutoType.find('option[value=4]').get(0).selected = true;
                    etAutoType.change();
                    break;
                default:
                    break;
            }
        });

        etAutoType.attr('data-origin-value', etAutoType.val());

        etMode.change();

        etAutoType.val(etAutoType.attr('data-origin-value'));
    },

    _toggleElementContainer: function(selector, show) {

        var container;

        container = $(selector).parentsUntil('form').last();

        if (show) {
            container.show();
        } else if (show === false) {
            container.hide();
        } else {
            container.toggle();
        }
    },

    initStartTimeEvent: function() {

        var me = this;

        me._initDateTimeControl('StartTime');
        me._setTime('StartTime');
    },

    initEndTimeEvent: function() {

        var me = this;

        me._initDateTimeControl('EndTime');
        me._setTime('EndTime');
    },

    _initDateTimeControl: function(controlId) {

        var me = this;

        $('#' + controlId)
            .on('change', 'select', function() {

                var container, hourcombo, mincombo, seccombo;
                var hour, min, sec, datetime;

                container = $(this).parent();
                hourcombo = container.find('select.hourcombo');
                mincombo = container.find('select.mincombo');
                seccombo = container.find('select.seccombo');

                hour = hourcombo.val();
                min = mincombo.val();
                sec = seccombo.val();

                datetime = '1970/1/1 ' + hour + ':' + min + ':' + sec;

                $('#' + me.s.idPrefix + controlId).val(datetime);
            });
    },

    initAutoTypeEvent: function() {

        var me;
        var etAutoType, etAutoOffsetDay;

        me = this;

        etAutoType = $('#' + me.s.idPrefix + 'AutoType');
        etAutoOffsetDay = $('#' + me.s.idPrefix + 'AutoOffsetDay');

        etAutoType.on('change', function() {

            var questionsList, etAutoType, etAutoOffsetDay, etaodContainer, atContainer,
                etContinuedDays, etMode, etStartDateContainer, etQuestions;
            var autoType;

            etAutoType = $('#' + me.s.idPrefix + 'AutoType');
            autoType = parseInt(etAutoType.val());
            atContainer = etAutoType.parentsUntil('form').last();

            etMode = $('#' + me.s.idPrefix + 'Mode');

            questionsList = $('#QuestionListSelectContainer');
            etStartDateContainer = $('#ETStartDateContainer');

            etAutoOffsetDay = $('#' + me.s.idPrefix + 'AutoOffsetDay');
            etaodContainer = etAutoOffsetDay.parentsUntil('form').last();

            etQuestions = $('#' + me.s.idPrefix + 'Questions');

            switch (autoType) {
                case 0:

                    me._hideAutoTaskControls();
                    questionsList.show();
                    etStartDateContainer.remove();

                    etMode.find('option[value=0]').get(0).selected = true;
                    break;
                case 1:

                    questionsList.find(':checkbox').attr('checked', false);
                    etQuestions.val('[]');
                    questionsList.hide();
                    etaodContainer.hide();
                    me._showAutoTaskControls();
                    etStartDateContainer.remove();
                    break;
                case 2:

                    questionsList.find(':checkbox').attr('checked', false);
                    etQuestions.val('[]');
                    questionsList.hide();
                    etaodContainer.show();
                    me._showAutoTaskControls();
                    etStartDateContainer.remove();
                    break;
                case 3:

                    questionsList.find(':checkbox').attr('checked', false);
                    etQuestions.val('[]');
                    questionsList.hide();
                    etaodContainer.show();
                    me._showAutoTaskControls();
                    etStartDateContainer.remove();
                    break;
                case 4:

                    me._hideAutoTaskControls();
                    questionsList.show();
                    me._showDateTimeControls();
                    me._renderStartDateControl();

                    etMode.find('option[value=2]').get(0).selected = true;

                    etContinuedDays = $('#' + me.s.idPrefix + 'ContinuedDays');
                    etContinuedDays.parentsUntil('form').last().show();
                    if (etContinuedDays.val() == 0) {
                        etContinuedDays.val(1);
                    }

                    break;
                default:
                    break;
            }

            me._renderOffsetDayNumberControl(autoType);
        });

        $('#AutoOffsetDayContainer').on('change', 'select.offset-day-num', function() {

            etAutoOffsetDay.val($(this).val());
        });

        etAutoOffsetDay.attr('data-origin-value', etAutoOffsetDay.val());

        etAutoType.change();

        $('#AutoOffsetDayContainer select.offset-day-num')
            .val(etAutoOffsetDay.attr('data-origin-value'))
            .change();
    },

    initControls: function() {

        var me;
        var etTimeSpan, etContinuedDays;

        me = this;

        if (!brower.ieVersion) {

            etTimeSpan = $('#' + me.s.idPrefix + 'TimeSpan');
            etContinuedDays = $('#' + me.s.idPrefix + 'ContinuedDays');

            $('script[src$="jquery.min.js"]').after('<script type="text/javascript" src="/Contents/lib/jquery-ui/jquery-ui.min.js"></script>');
            $('head').prepend('<link href="/Contents/lib/jquery-ui/jquery-ui.min.css" rel="stylesheet" type="text/css" />');

            etTimeSpan.spinner({
                min: 0,
                max: 600,
                step: 10
            });

            etContinuedDays.spinner({
                min: 1,
                max: 30,
                step: 1
            });

            etTimeSpan.parents('div').addClass('custom-spinner');
            etContinuedDays.parents('div').addClass('custom-spinner');
        }
    },

    /* --------------------------------------------------------------------------------- */

    _renderOffsetDayNumberControl: function(autoType) {

        var me;
        var aodContainer, etAutoOffsetDay, container, offsetDayNum;

        me = this;

        aodContainer = $('#AutoOffsetDayContainer');
        etAutoOffsetDay = $('#' + me.s.idPrefix + 'AutoOffsetDay');
        container = etAutoOffsetDay.parentsUntil('form').last();

        switch (autoType) {
            case 2:

                container.show();
                aodContainer.html('');
                aodContainer.append(
                    '<span class="offset-day-item">' +
                    '<span class="offset-day-text">每周星期</span>' +
                    '<span class="select-box">' +
                    '<select class="select offset-day-num">' +
                    '<option value="1">一</option>' +
                    '<option value="2">二</option>' +
                    '<option value="3">三</option>' +
                    '<option value="4">四</option>' +
                    '<option value="5">五</option>' +
                    '<option value="6">六</option>' +
                    '<option value="7">日</option>' +
                    '</select>' +
                    '</span>' +
                    '</span>')

                etAutoOffsetDay.val(1);
                break;
            case 3:

                container.show();
                aodContainer.html('');
                aodContainer.append(
                    '<span class="offset-day-item">' +
                    '<span class="offset-day-text">每月</span>' +
                    '<span class="select-box">' +
                    '<select class="select offset-day-num">' +
                    '</select>' +
                    '</span>' +
                    '<span class="offset-day-text">号</span>' +
                    '</span>')

                offsetDayNum = $('#AutoOffsetDayContainer select.offset-day-num');
                for (var i = 1; i < 32; i++) {
                    offsetDayNum.append('<option value="' + i + '">' + i + '</option>');
                }

                etAutoOffsetDay.val(1);
                break;
            default:

                container.hide();
                aodContainer.html('');
                etAutoOffsetDay.val(0);
                break;
        };
    },

    _renderStartDateControl: function() {

        var me;
        var etStartTime;
        var autoType, startTime, startDate;

        me = this;

        autoType = Number($('#' + me.s.idPrefix + 'AutoType').val());

        if (autoType != 4) {
            return;
        }

        etStartTime = $('#' + me.s.idPrefix + 'StartTime');
        startDate = etStartTime.val();
        startDate = startDate.toDate();
        if (startDate.getFullYear() == 1970) {
            startDate = (new Date()).add('d', 1).format('yyyy-MM-dd');
        } else {
            startDate = startDate.format('yyyy-MM-dd');
        }

        if ($('#ETStartDateContainer').length == 0) {

            $('#' + me.s.idPrefix + 'AutoType').parentsUntil('form').last().after(
                '<div id="ETStartDateContainer" class="row cl">' +
                '   <label class="form-label col-2">' +
                '       考试日期' +
                '   </label>' +
                '   <div class="formControls col-2">' +
                '       <input type="text" id="ETStartDate" value="' + startDate + '" class="input-text Wdate" onfocus="WdatePicker({minDate: \'%y-%M-%d\'});" />' +
                '   </div>' +
                '</div>');
        }
    },

    /* --------------------------------------------------------------------------------- */

    _showAutoTaskControls: function() {

        var me;

        me = this;

        $('#' + me.s.idPrefix + 'AutoType').parentsUntil('form').last().show();
        $('#' + me.s.idPrefix + 'AutoOffsetDay').parentsUntil('form').last().show();
        $('#' + me.s.idPrefix + 'DifficultyCoefficient').parentsUntil('form').last().show();
        $('#' + me.s.idPrefix + 'AutoClassifies').parentsUntil('form').last().show();
        $('#' + me.s.idPrefix + 'AutoRatio').parentsUntil('form').last().show();

        me._showDateTimeControls();
    },

    _showDateTimeControls: function() {

        var me;

        me = this;

        $('#' + me.s.idPrefix + 'StartTime').parentsUntil('form').last().show();
        $('#' + me.s.idPrefix + 'EndTime').parentsUntil('form').last().show();
    },

    _hideAutoTaskControls: function() {

        var me;

        me = this;

        $('#' + me.s.idPrefix + 'AutoType').parentsUntil('form').last().hide();
        $('#' + me.s.idPrefix + 'AutoOffsetDay').parentsUntil('form').last().hide();
        $('#' + me.s.idPrefix + 'DifficultyCoefficient').parentsUntil('form').last().hide();
        $('#' + me.s.idPrefix + 'AutoClassifies').parentsUntil('form').last().hide();
        $('#' + me.s.idPrefix + 'AutoRatio').parentsUntil('form').last().hide();
        $('#' + me.s.idPrefix + 'StartTime').parentsUntil('form').last().hide();
        $('#' + me.s.idPrefix + 'EndTime').parentsUntil('form').last().hide();
        $('#' + me.s.idPrefix + 'ContinuedDays').parentsUntil('form').last().hide();
    },

    _setTime: function(controlId) {

        var me = this;

        $('body').everyTime('3s', 'Set' + controlId, function() {

            var startTimeDiv, hourcombo, mincombo, seccombo;
            var startTime;

            startTimeDiv = $('#' + controlId);
            hourcombo = startTimeDiv.find('select.hourcombo');
            mincombo = startTimeDiv.find('select.mincombo');
            seccombo = startTimeDiv.find('select.seccombo');
            hourcombo.addClass('select');
            mincombo.addClass('select');
            seccombo.addClass('select');

            if (hourcombo.length > 0) {

                startTime = $('#' + me.s.idPrefix + controlId).val();
                startTime = startTime.toDate();

                hourcombo.val(startTime.getHours())
                mincombo.val(startTime.getMinutes());
                seccombo.val(startTime.getSeconds())

                $('body').stopTime('Set' + controlId);
            }
        });
    },

    validateCustomAutoTypeData: function(valid) {

        var etStartDate;
        var startDate;
        var me;

        me = this;

        etStartDate = $('#ETStartDate');
        startDate = etStartDate.val();

        if (startDate == '') {

            me.appendError('ETStartDate', '请选择考试日期', etStartDate);
            valid = false;
        }

        valid = this.validateStartTime(valid);
        valid = this.validateEndTime(valid);

        return valid;
    },

    validateAutoClassifies: function(valid) {

        var me;
        var acRegex;
        var etAutoClassifies;
        var autoClassifies;

        me = this;

        // 出题分类数据验证
        // 数据格式：['分类名1', '分类名2', ...]
        acRegex = /^\[(".+",?\s*)+\]$/g;

        etAutoClassifies = $('#' + me.s.idPrefix + 'AutoClassifies');
        autoClassifies = etAutoClassifies.val();

        if (!acRegex.test(autoClassifies)) {

            me.appendError(me.s.idPrefix + 'AutoClassifies', '请选择出题分类', etAutoClassifies);
            valid = false;
        }

        return valid;
    },

    validateAutoRatios: function(valid) {

        var me;
        var arRegex;
        var etAutoRatio;
        var autoRatio, ratioNumber;

        me = this;

        // 出题比例数据验证
        // 数据格式： [{type: '单选题', percent: 0.2}, {type: '多选题', percent: 0.2}, ...]
        arRegex = /^\[(\{"type"\:\s*".+"\,\s*"percent"\:\s*(0\.)?\d{1,2}},?\s*)+\]$/g;

        etAutoRatio = $('#' + me.s.idPrefix + 'AutoRatio');
        autoRatio = etAutoRatio.val();

        if (!arRegex.test(autoRatio)) {

            me.appendError(me.s.idPrefix + 'AutoRatio', '请输入出题比例', etAutoRatio)
            valid = false;
        }

        // 限制出题比例 >= 50% 与 <= 100%
        ratioNumber = 0;
        autoRatio = JSON.parse(autoRatio);
        for (var i = 0; i < autoRatio.length; i++) {
            ratioNumber += autoRatio[i].percent;
        }

        if (ratioNumber < 0.5 || ratioNumber > 1) {

            me.appendError(me.s.idPrefix + 'AutoRatio', '出题比例必须大于 50% 、小于 100%', etAutoRatio)
            valid = false;
        }

        return valid;
    },

    validateStartTime: function(valid) {

        var stRegex, stRegex1;
        var etStartTime;
        var startTime;
        var me;

        me = this;

        // 开始时间验证
        // 数据格式：2016/1/1 8:00:00
        stRegex = /^\d{4}\/\d{1,2}\/\d{1,2} (([0-9]{1})|(1{1}[0-9]{1})|(2{1}[0-3]{1})):[0-5]{1}[0-9]{0,1}:[0-5]{0,1}[0-9]{1}$/g;
        stRegex1 = /^\d{4}\/\d{1,2}\/\d{1,2} 0{1,2}:0{1,2}:0{1,2}$/g;

        etStartTime = $('#' + me.s.idPrefix + 'StartTime');
        startTime = etStartTime.val();

        if (stRegex1.test(startTime) || !stRegex.test(startTime)) {

            me.appendError(me.s.idPrefix + 'StartTime', '请选择开始时间', etStartTime);
            valid = false;
        }

        return valid;
    },

    validateEndTime: function(valid) {

        var stRegex, stRegex1;
        var etEndTime;
        var endTime;
        var me;

        me = this;

        // 结束时间验证
        // 数据格式：2016/1/1 8:00:00
        stRegex = /^\d{4}\/\d{1,2}\/\d{1,2} (([0-9]{1})|(1{1}[0-9]{1})|(2{1}[0-3]{1})):[0-5]{1}[0-9]{0,1}:[0-5]{0,1}[0-9]{1}$/g;
        stRegex1 = /^\d{4}\/\d{1,2}\/\d{1,2} 0{1,2}:0{1,2}:0{1,2}$/g;

        etEndTime = $('#' + me.s.idPrefix + 'EndTime');
        endTime = etEndTime.val();

        if (stRegex1.test(endTime) || !stRegex.test(endTime)) {

            me.appendError(me.s.idPrefix + 'EndTime', '请选择结束时间', etEndTime);
            valid = false;
        }

        return valid;
    },

    validateContinuedDays: function(valid) {

        var etAutoType, etContinuedDays;
        var autoType, continuedDays;
        var me;

        me = this;

        etAutoType = $('#' + me.s.idPrefix + 'AutoType');
        etContinuedDays = $('#' + me.s.idPrefix + 'ContinuedDays');

        autoType = Number(etAutoType.val());
        continuedDays = Number(etContinuedDays.val());

        if (!isNaN(autoType) && autoType == 4) {

            if (isNaN(continuedDays) || continuedDays == 0) {

                me.appendError(me.s.idPrefix + 'ContinuedDays', '请输入 1 至 30 之间的天数', etContinuedDays);
                valid = false;
            } else if (continuedDays > 30) {

                me.appendError(me.s.idPrefix + 'ContinuedDays', '请输入 1 至 30 之间的天数', etContinuedDays);
                valid = false;
            } else {
                etContinuedDays.val(continuedDays);
            }
        }

        return valid;
    },

    validateQuestions: function(valid) {
        'use strict';

        var me;
        var mode;
        var questions, qAry, statisticType, totalNumber, totalScore;
        var qsRegex;
        var sdiContainer;

        me = this;

        mode = Number($('#' + me.s.idPrefix + 'Mode').val());
        statisticType = Number($('#' + me.s.idPrefix + 'StatisticType').val());
        totalNumber = Number($('#' + me.s.idPrefix + 'TotalNumber').val());
        totalScore = Number($('#' + me.s.idPrefix + 'TotalScore').val());

        sdiContainer = $('.select-data-item');

        // 试题选择数据验证
        // 数据格式：[1, 2, ...]
        questions = $('#' + me.s.idPrefix + 'Questions').val();
        qsRegex = /^\[((\d+)|("{1}\d+"{1}),?\s*)+\]$/g;
        if (1 != mode && !qsRegex.test(questions)) {

            me.appendErrorAfter('Questions', '请选择试题', sdiContainer);
            return false;
        }

        qAry = JSON.parse(questions);
        if (1 != mode && qAry.length == 0) {

            me.appendErrorAfter('Questions', '请选择试题', sdiContainer);
            return false;
        }

        // 检查“已选试题数量”与“出题数量”是否一致
        if (1 != mode && qAry.length != 0 && statisticType == 2 && qAry.length != totalNumber) {

            me.appendErrorAfter('Questions', '已选试题数量与出题数量不一致', sdiContainer);
            return false;
        }

        // 限制选题数量
        if (1 != mode && qAry.length != 0 && statisticType == 1 && (totalScore * 0.1 > qAry.length || qAry.length > totalScore)) {

            me.appendErrorAfter('Questions', '选题总数不合理。选题数量最低应占总分的 10% ，最高不超过出题总分。', sdiContainer);
            return false;
        }

        return valid;
    },

    validateTotal: function(valid) {

        var me;
        var etTotalScore, etStatisticType, etTotalNumber;
        var totalScore, statisticType, totalNumber;

        me = this;

        etStatisticType = $('#' + me.s.idPrefix + 'StatisticType');
        statisticType = Number(etStatisticType.val());

        etTotalScore = $('#' + me.s.idPrefix + 'TotalScore');
        totalScore = parseInt(etTotalScore.val());

        etTotalNumber = $('#' + me.s.idPrefix + 'TotalNumber');
        totalNumber = parseInt(etTotalNumber.val());

        if (1 == statisticType && totalScore % 10 != 0) {

            me.appendError('TotalScore', '出题总分必须为 10 的倍数', etTotalScore);
            valid = false;
        } else if (2 == statisticType && totalNumber % 10 != 0) {

            me.appendError('TotalScore', '出题总数必须为 10 的倍数', etTotalNumber);
            valid = false;
        }

        return valid;
    },

    appendError: function(idValue, tip, jqElem) {

        var me = this;

        me._appendError(idValue, tip, jqElem.parents('div.row'));
    },

    _appendError: function(idValue, tip, container) {

        container.find('.custom-validation-error').remove();

        $('<div class="custom-validation-error col-offset-2" style="clear:both;">' +
            '<div class="cl"></div>' +
            '<span class="field-validation-error">' +
            '<span htmlfor="' + idValue + '" generated="true" class="">' + tip + '</span>' +
            '</span>' +
            '<div>').appendTo(container);
    },

    appendErrorBefore: function(idValue, tip, jqElem) {

        jqElem.parents('div.row').find('.custom-validation-error').remove();

        jqElem.before($('<div class="custom-validation-error">' +
            '<div class="cl"></div>' +
            '<span class="field-validation-error">' +
            '<span htmlfor="' + idValue + '" generated="true" class="">' + tip + '</span>' +
            '</span>' +
            '<div>'));
    },

    appendErrorAfter: function(idValue, tip, jqElem) {

        jqElem.parents('div.row').find('.custom-validation-error').remove();

        jqElem.after($('<div class="custom-validation-error">' +
            '<div class="cl"></div>' +
            '<span class="field-validation-error">' +
            '<span htmlfor="' + idValue + '" generated="true" class="">' + tip + '</span>' +
            '</span>' +
            '<div>'));
    },

    /* --------------------------------------------------------------------------------- */

    renderDepartmentsAndUsers: function() {

        var me;
        var dus, settings, nodes;

        me = this;

        settings = {
            check: {
                enable: true
            },
            data: {
                simpleData: {
                    enable: true
                }
            }
        };

        dus = $('#DepartmentsAndUsers');
        nodes = dus.attr('data-value');
        nodes = $.parseJSON(nodes);
        nodes = [{
            name: '全部',
            departmentId: 0,
            open: true,
            children: nodes
        }];

        me.v.userIds = $('#' + me.s.idPrefix + 'Attendee').val();
        me.v.userIds = $.parseJSON(me.v.userIds);
        me.v.departmentIds = $('#' + me.s.idPrefix + 'ParticipatingDepartment').val();
        me.v.departmentIds = $.parseJSON(me.v.departmentIds);

        me.v.ztree = $.fn.zTree.init(dus, settings, nodes);
        nodes = me.v.ztree.getNodes();
        me.setDepartmentsAndUsersNodeChecked(me.v.ztree, nodes, me.v.departmentIds, me.v.userIds);

        dus.find('.chk').attr('tabIndex', 1);
        dus.on('blur', '.chk', function() {
            me.setAttendees();
        });
    },

    getDepartmentsAndUsersNodeChecked: function(nodes) {

        var me;

        me = this;

        for (var i = 0; i < nodes.length; i++) {

            if (nodes[i].checked) {

                if (nodes[i].userNode) {

                    me.v.userIds.push(nodes[i].userId);
                    me.v.userNames.push(nodes[i].name);
                } else {

                    me.v.departmentIds.push(nodes[i].departmentId);
                    me.v.departmentNames.push(nodes[i].name);
                }
            }

            if (nodes[i].children != undefined) {

                me.getDepartmentsAndUsersNodeChecked(nodes[i].children);
            }
        }
    },

    setDepartmentsAndUsersNodeChecked: function(ztree, nodes, departmentIds, userIds) {

        var checkedCount, checked;
        var depNode, userNode, now;
        var me;

        me = this;

        checkedCount = 0;
        now = undefined == now ? (new Date()).format('yyyy-MM-dd hh:mm:ss.S') : now;
        /*for (var i = 0; i < nodes.length; i++) {

            for (var i1 = 0; i1 < userIds.length; i1++) {

                for (var i2 = 0; i2 < departmentIds.length; i2++) {

                    if (departmentIds[i2] == nodes[i].departmentId && userIds[i1] == nodes[i].userId) {

                        ztree.checkNode(nodes[i], true, true);
                        nodes[i].now = now;
                        checkedCount += 1;
                    } else if (nodes[i].now != now) {

                        ztree.checkNode(nodes[i], false, true);
                    }
                }
            }

            if (nodes[i].children != undefined) {

                checked = me.setDepartmentsAndUsersNodeChecked(ztree, nodes[i].children, departmentIds, userIds);
                if (checked) {
                    ztree.checkNode(nodes[i], true, true);
                }
            }
        }*/
        for (var i1 = 0; i1 < userIds.length; i1++) {

            for (var i2 = 0; i2 < departmentIds.length; i2++) {

                depNode = ztree.getNodeByParam('departmentId', departmentIds[i2]);
                userNode = ztree.getNodeByParam('userId', userIds[i1], depNode);

                if (depNode != null && userNode != null) {

                    ztree.checkNode(userNode, true, true);
                    userNode.now = now;
                    checkedCount += 1;
                } else if (userNode != null && userNode.now != now) {
                    ztree.checkNode(nodes[i], false, true);
                }
            }
        }

        /*// 是否复选父节点
        if (nodes.length == checkedCount) {
            return true;
        }

        return false;*/
    },

    setAttendees: function() {

        var me;
        var nodes;

        me = this;

        // 设置参与部门/用户
        me.v.userIds = [];
        me.v.userNames = [];
        me.v.departmentIds = [];
        me.v.departmentNames = [];
        nodes = me.v.ztree.getNodes();

        me.getDepartmentsAndUsersNodeChecked(nodes);

        $('#' + me.s.idPrefix + 'ParticipatingDepartment').val(JSON.stringify(me.v.departmentIds));
        $('#' + me.s.idPrefix + 'Attendee').val(JSON.stringify(me.v.userIds));
    },

    /* --------------------------------------------------------------------------------- */

    renderQuestionClassifies: function() {

        var me;
        var settings, qcs, nodes, autoClassifies;

        me = this;

        settings = {
            check: {
                enable: true
            },
            data: {
                simpleData: {
                    enable: true
                }
            }
        };

        qcs = $('#QuestionClassifies');
        nodes = qcs.attr('data-value');
        nodes = JSON.parse(nodes);
        nodes = [{
            name: '全部',
            questionClassifyId: 0,
            open: true,
            children: nodes
        }];

        me.v.qcZtree = $.fn.zTree.init(qcs, settings, nodes);
        nodes = me.v.qcZtree.getNodes();
        autoClassifies = $('#' + me.s.idPrefix + 'AutoClassifies').val();
        autoClassifies = JSON.parse(autoClassifies);
        me.setQuestionClassifiesNodeChecked(me.v.qcZtree, nodes, autoClassifies);

        qcs.find('.chk').attr('tabIndex', 1);
        qcs.on('blur', '.chk', function() {
            me.setClassifies();
        });
    },

    getQuestionClassifiesNodeChecked: function(nodes, autoClassifies) {

        var n;
        var me;

        me = this;

        autoClassifies = undefined == autoClassifies ? [] : autoClassifies;
        for (var i = 0; i < nodes.length; i++) {

            n = nodes[i];

            if (n.checked) {

                if (n.name && '全部' != n.name) {

                    autoClassifies.push(n.name);
                }
            }

            if (n.children != undefined) {

                autoClassifies = me.getQuestionClassifiesNodeChecked(n.children, autoClassifies);
            }
        }

        return autoClassifies;
    },

    setQuestionClassifiesNodeChecked: function(ztree, nodes, autoClassifies, now) {

        var checkedCount, checked;
        var now;
        var me;

        me = this;

        checkedCount = 0;
        now = undefined == now ? (new Date()).format('yyyy-MM-dd hh:mm:ss.S') : now;
        for (var i = 0; i < nodes.length; i++) {
            for (var i1 = 0; i1 < autoClassifies.length; i1++) {

                if (nodes[i].name == autoClassifies[i1]) {

                    ztree.checkNode(nodes[i], true, true);
                    nodes[i].now = now;
                    checkedCount += 1;
                } else if (nodes[i].now != now) {

                    ztree.checkNode(nodes[i], false, true);
                }
            }

            if (nodes[i].children != undefined) {

                checked = me.setQuestionClassifiesNodeChecked(ztree, nodes[i].children, autoClassifies, now);
                if (checked) {
                    ztree.checkNode(nodes[i], true, true);
                }
            }
        }

        // 是否复选父节点
        if (nodes.length == checkedCount) {
            return true;
        }

        return false;
    },

    setClassifies: function() {

        var me;
        var nodes, autoClassifies;

        me = this;

        // 设置自动出题分类
        nodes = me.v.qcZtree.getNodes();
        autoClassifies = me.getQuestionClassifiesNodeChecked(nodes);
        // 数据格式：['分类名1', '分类名2', ...]
        $('#' + me.s.idPrefix + 'AutoClassifies').val(JSON.stringify(autoClassifies));
    },

    /* --------------------------------------------------------------------------------- */

    renderAutoRatio: function() {

        var rs, r, p;
        var etAutoRatio, container;
        var me;

        me = this;

        etAutoRatio = $('#' + me.s.idPrefix + 'AutoRatio');
        rs = etAutoRatio.val();
        if (undefined == rs || '[]' == rs) {
            rs = me.getOriginRatios();
            etAutoRatio.val(JSON.stringify(rs));
        } else {
            rs = JSON.parse(rs);
        }

        container = $('#RatioContainer');
        container.children().remove();

        for (var i = 0; i < rs.length; i++) {

            r = rs[i];
            p = r.percent * 100;

            $('<span class="ratio-item">' +
                '<span class="ratio-type">' + r.type + '</span>' +
                '<input type="text" class="input-text ratio-percent" value="' + p + '" data-origin-val="' + p + '" />%' +
                '</span>').appendTo(container);

        }

        container.on('change', 'input.ratio-percent', function() {

            var input;
            var ratio;

            input = $(this);
            ratio = input.val();

            if ('' == ratio || isNaN(ratio) || /[-.+]+/.test(ratio)) {

                alert('请输入整数。');
                ratio = input.attr('data-origin-val');
            }

            ratio = parseInt(ratio);
            input.val(ratio);

            input.attr('data-origin-val', ratio);

            me.setRatios();
        });
    },

    getOriginRatios: function() {

        return [{
            type: '单选题',
            percent: 0.2
        }, {
            type: '多选题',
            percent: 0.2
        }, {
            type: '判断题',
            percent: 0.2
        }, {
            type: '公文改错题',
            percent: 0.1
        }, {
            type: '计算题',
            percent: 0.1
        }, {
            type: '案例分析题',
            percent: 0.1
        }, {
            type: '问答题',
            percent: 0.1
        }];
    },

    getRatios: function() {

        var ratios;

        ratios = [];
        $('#RatioContainer').find('.ratio-item').each(function() {

            var item;
            var type, percent;

            item = $(this);
            type = item.find('.ratio-type').text();
            percent = item.find('input.ratio-percent').val();
            percent = parseInt(percent) / 100;

            ratios.push({
                type: type,
                percent: percent
            });
        });

        return ratios;
    },

    setRatios: function(ratios) {

            var me;

            me = this;

            if (ratios == undefined) {
                ratios = JSON.stringify(me.getRatios());
            } else if (typeof(ratios) == 'object') {
                ratios = JSON.stringify(ratios);
            }

            // 设置自动出题比例
            $('#' + me.s.idPrefix + 'AutoRatio').val(ratios);
        }
        /* --------------------------------------------------------------------------------- */
};
