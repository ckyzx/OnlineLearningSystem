$(function() {
    'use strict';

    var ztree, qcZtree;
    var userIds, userNames, departmentIds, departmentNames;
    var et;

    et = OLS.ExaminationTask.init({
        idPrefix: 'ETT_'
    });

    // 初始化成绩统计方式控件事件
    initStatisticTypeEvent();

    // 初始化出题方式控件事件
    initModeEvent();

    // 初始化出题方式控件事件
    initAutoTypeEvent();

    // 初始化部门/用户选择控件
    renderDepartmentsAndUsers();

    // 初始化试题分类选择控件
    renderQuestionClassifies();

    // 初始化自动出题比例选择控件
    renderAutoRatio();

    // 初始化开始时间、结束时间控件事件
    initStartTimeEvent();
    initEndTimeEvent();

    // 初始化提交事件
    //initSubmitEvent();
    olsCustomSubmitHandler = submitHandler;

    function initStatisticTypeEvent() {

        $('#ETT_StatisticType').on('change', function() {

            var select, etTotalScore, etTotalNumber, tsContainer, anContainer;
            var type;

            select = $(this);
            type = parseInt(select.val());

            etTotalScore = $('#ETT_TotalScore');
            etTotalNumber = $('#ETT_TotalNumber');
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
        $('#ETT_StatisticType').change();
    }

    function initModeEvent() {

        var etMode, etAutoType;
        var autoType;

        etMode = $('#ETT_Mode');
        etAutoType = $('#ETT_AutoType');

        etMode.on('change', function() {

            var etMode, etAutoType;
            var mode;

            etAutoType = $('#ETT_AutoType');

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
    }

    function initAutoTypeEvent() {

        var etAutoType, etAutoOffsetDay, etMode;

        etAutoType = $('#ETT_AutoType');
        etAutoOffsetDay = $('#ETT_AutoOffsetDay');

        etAutoType.on('change', function() {

            var qList, etAutoType, etAutoOffsetDay, offsetDayNum, aodContainer,
                etaodContainer, atContainer, etContinuedDays;
            var autoType;
            var hideFunc, showFunc, onfocus;

            etAutoType = $('#ETT_AutoType');
            atContainer = etAutoType.parentsUntil('form').last()
            etAutoOffsetDay = $('#ETT_AutoOffsetDay');

            qList = $('#QuestionListSelectContainer');
            autoType = parseInt(etAutoType.val());

            aodContainer = $('#AutoOffsetDayContainer');
            etaodContainer = etAutoOffsetDay.parentsUntil('form').last();

            hideFunc = function() {

                $('#ETT_AutoType').parentsUntil('form').last().hide();
                $('#ETT_AutoOffsetDay').parentsUntil('form').last().hide();
                $('#ETT_DifficultyCoefficient').parentsUntil('form').last().hide();
                $('#ETT_AutoClassifies').parentsUntil('form').last().hide();
                $('#ETT_AutoRatio').parentsUntil('form').last().hide();
                $('#ETT_StartTime').parentsUntil('form').last().hide();
                $('#ETT_EndTime').parentsUntil('form').last().hide();
                $('#ETT_ContinuedDays').parentsUntil('form').last().hide();
            };

            showFunc = function() {

                $('#ETT_AutoType').parentsUntil('form').last().show();
                $('#ETT_AutoOffsetDay').parentsUntil('form').last().show();
                $('#ETT_DifficultyCoefficient').parentsUntil('form').last().show();
                $('#ETT_AutoClassifies').parentsUntil('form').last().show();
                $('#ETT_AutoRatio').parentsUntil('form').last().show();
                $('#ETT_StartTime').parentsUntil('form').last().show();
                $('#ETT_EndTime').parentsUntil('form').last().show();
            };

            switch (autoType) {
                case 0:

                    qList.show();

                    etMode = $('#ETT_Mode');
                    etMode.find('option[value=0]').get(0).selected = true;

                    hideFunc();
                    break;
                case 1:

                    qList.hide();
                    showFunc();
                    etaodContainer.hide();

                    etAutoOffsetDay.val(0);
                    aodContainer.html('');
                    break;
                case 2:

                    qList.hide();
                    showFunc();
                    etaodContainer.show();

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

                    qList.hide();
                    showFunc();
                    etaodContainer.show();

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
                case 4:

                    qList.show();

                    etMode = $('#ETT_Mode');
                    etMode.find('option[value=2]').get(0).selected = true;

                    hideFunc();

                    $('#ETT_StartTime').parentsUntil('form').last().show();
                    $('#ETT_EndTime').parentsUntil('form').last().show();

                    etContinuedDays = $('#ETT_ContinuedDays');
                    if(etContinuedDays.val() == 0){
                        etContinuedDays.val(1);
                    }
                    etContinuedDays.parentsUntil('form').last().show();
                    break;
                default:
                    break;
            }
        });

        $('#AutoOffsetDayContainer').on('change', 'select.offset-day-num', function() {

            etAutoOffsetDay.val($(this).val());
        });

        etAutoOffsetDay.attr('data-origin-value', etAutoOffsetDay.val());

        etAutoType.change();

        $('#AutoOffsetDayContainer select.offset-day-num')
            .val(etAutoOffsetDay.attr('data-origin-value'))
            .change();
    }

    function renderDepartmentsAndUsers() {

        var dus, settings, nodes;

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

        userIds = $('#ETT_Attendee').val();
        userIds = $.parseJSON(userIds);
        departmentIds = $('#ETT_ParticipatingDepartment').val();
        departmentIds = $.parseJSON(departmentIds);

        ztree = $.fn.zTree.init(dus, settings, nodes);
        nodes = ztree.getNodes();
        setDepartmentsAndUsersNodeChecked(ztree, nodes, departmentIds, userIds);
    }

    function setDepartmentsAndUsersNodeChecked(ztree, nodes, departmentIds, userIds) {

        var checkedCount, checked;
        var now;

        checkedCount = 0;
        now = undefined == now ? (new Date()).format('yyyy-MM-dd hh:mm:ss.S') : now;
        for (var i = 0; i < nodes.length; i++) {

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

                checked = setDepartmentsAndUsersNodeChecked(ztree, nodes[i].children, departmentIds, userIds);
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
    }

    function getDepartmentsAndUsersNodeChecked(nodes) {

        for (var i = 0; i < nodes.length; i++) {

            if (nodes[i].checked) {

                if (nodes[i].userNode) {

                    userIds.push(nodes[i].userId);
                    userNames.push(nodes[i].name);
                } else {

                    departmentIds.push(nodes[i].departmentId);
                    departmentNames.push(nodes[i].name);
                }
            }

            if (nodes[i].children != undefined) {

                getDepartmentsAndUsersNodeChecked(nodes[i].children);
            }
        }
    }

    function renderQuestionClassifies() {

        var settings, qcs, nodes, autoClassifies;

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

        qcZtree = $.fn.zTree.init(qcs, settings, nodes);
        nodes = qcZtree.getNodes();
        autoClassifies = $('#ETT_AutoClassifies').val();
        autoClassifies = JSON.parse(autoClassifies);
        setQuestionClassifiesNodeChecked(qcZtree, nodes, autoClassifies);
    }

    function setQuestionClassifiesNodeChecked(ztree, nodes, autoClassifies, now) {

        var checkedCount, checked;
        var now;

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

                checked = setQuestionClassifiesNodeChecked(ztree, nodes[i].children, autoClassifies, now);
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
    }

    function getQuestionClassifiesNodeChecked(nodes, autoClassifies) {

        var n;

        autoClassifies = undefined == autoClassifies ? [] : autoClassifies;
        for (var i = 0; i < nodes.length; i++) {

            n = nodes[i];

            if (n.checked) {

                if (n.name && '全部' != n.name) {

                    autoClassifies.push(n.name);
                }
            }

            if (n.children != undefined) {

                autoClassifies = getQuestionClassifiesNodeChecked(n.children, autoClassifies);
            }
        }

        return autoClassifies;
    }

    function renderAutoRatio() {

        var rs, r, p;
        var container;

        rs = $('#ETT_AutoRatio').val();
        rs = undefined == rs || '[]' == rs ? getOriginRatios() : JSON.parse(rs);

        container = $('#RatioContainer');

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
        });
    }

    function getOriginRatios() {

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
    }

    function getRatios() {

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
    }

    function initStartTimeEvent() {

        $('#StartTime')
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

                $('#ETT_StartTime').val(datetime);
            });

        // 设置时间
        $('body').everyTime('1s', 'SetStartTime', function() {

            var startTimeDiv, hourcombo, mincombo, seccombo;
            var startTime;

            startTimeDiv = $('#StartTime');
            hourcombo = startTimeDiv.find('select.hourcombo');
            mincombo = startTimeDiv.find('select.mincombo');
            seccombo = startTimeDiv.find('select.seccombo');
            hourcombo.addClass('select');
            mincombo.addClass('select');
            seccombo.addClass('select');

            if (hourcombo.length > 0) {

                startTime = $('#ETT_StartTime').val();
                startTime = startTime.toDate();

                hourcombo.val(startTime.getHours())
                mincombo.val(startTime.getMinutes());
                seccombo.val(startTime.getSeconds())

                $('body').stopTime('SetStartTime');
            }
        });
    }

    function initEndTimeEvent() {

        $('#EndTime')
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

                $('#ETT_EndTime').val(datetime);
            });

        // 设置时间
        $('body').everyTime('1s', 'SetEndTime', function() {

            var startTimeDiv, hourcombo, mincombo, seccombo;
            var startTime;

            startTimeDiv = $('#EndTime');
            hourcombo = startTimeDiv.find('select.hourcombo');
            mincombo = startTimeDiv.find('select.mincombo');
            seccombo = startTimeDiv.find('select.seccombo');
            hourcombo.addClass('select');
            mincombo.addClass('select');
            seccombo.addClass('select');

            if (hourcombo.length > 0) {

                startTime = $('#ETT_EndTime').val();
                startTime = startTime.toDate();

                hourcombo.val(startTime.getHours())
                mincombo.val(startTime.getMinutes());
                seccombo.val(startTime.getSeconds())

                $('body').stopTime('SetEndTime');
            }
        });
    }

    function initSubmitEvent() {

        $('form').submit(function(e) {
            submitHandler(e);
        });
    }

    function submitHandler(form) {

        var nodes, autoClassifies;
        var etStartTime, etEndTime;
        var mode, startDate, startTime;

        // 设置参与部门/用户
        userIds = [];
        userNames = [];
        departmentIds = [];
        departmentNames = [];
        nodes = ztree.getNodes();

        getDepartmentsAndUsersNodeChecked(nodes);

        $('#ETT_ParticipatingDepartment').val(JSON.stringify(departmentIds));
        $('#ETT_Attendee').val(JSON.stringify(userIds));

        // 设置自动出题分类
        nodes = qcZtree.getNodes();
        autoClassifies = getQuestionClassifiesNodeChecked(nodes);
        // 数据格式：['分类名1', '分类名2', ...]
        $('#ETT_AutoClassifies').val(JSON.stringify(autoClassifies));

        // 设置自动出题比例
        $('#ETT_AutoRatio').val(JSON.stringify(getRatios()));

        if (!validateData()) {
            //e.preventDefault();
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
            //e.preventDefault();
            return false;
        } else {
            $(form).submit();
        }
    }

    function validateData() {

        var valid;
        var errorSpan, etMode, container, etAutoClassifies, etAutoRatio,
            etQuestions, sdiContainer, etTotalScore,
            etStatisticType, etTotalNumber, etTimeSpan;
        var mode, autoClassifies, autoRatio, questions, qAry,
            totalScore, ratioNumber, statisticType,
            totalNumber, timeSpan;
        var acRegex, arRegex, qsRegex;

        valid = true;

        $('.custom-validation-error').remove();

        etMode = $('#ETT_Mode');
        mode = etMode.val();

        etTotalScore = $('#ETT_TotalScore');
        totalScore = parseInt(etTotalScore.val());

        // 自动任务
        if (mode == 1) {

            // 出题分类数据验证
            // 数据格式：['分类名1', '分类名2', ...]
            acRegex = /^\[(".+",?\s*)+\]$/g;

            etAutoClassifies = $('#ETT_AutoClassifies');
            container = etAutoClassifies.parent();
            autoClassifies = etAutoClassifies.val();

            if (!acRegex.test(autoClassifies)) {

                $('<div class="custom-validation-error">' +
                    '<div class="cl"></div>' +
                    '<span class="field-validation-error">' +
                    '<span htmlfor="ETT_AutoClassifies" generated="true" class="">请选择出题分类</span>' +
                    '</span>' +
                    '<div>').appendTo(container);

                valid = false;
            }

            // 出题比例数据验证
            // 数据格式： [{type: '单选题', percent: 0.2}, {type: '多选题', percent: 0.2}, ...]
            arRegex = /^\[(\{"type"\:\s*".+"\,\s*"percent"\:\s*(0\.)?\d{1,2}},?\s*)+\]$/g;

            etAutoRatio = $('#ETT_AutoRatio');
            container = etAutoRatio.parent();
            autoRatio = etAutoRatio.val();

            if (!arRegex.test(autoRatio)) {

                $('<div class="custom-validation-error">' +
                    '<div class="cl"></div>' +
                    '<span class="field-validation-error">' +
                    '<span htmlfor="ETT_AutoRatio" generated="true" class="">请输入出题比例</span>' +
                    '</span>' +
                    '<div>').appendTo(container);

                valid = false;
            }

            // 限制出题比例 >= 50% 与 <= 100%
            ratioNumber = 0;
            autoRatio = JSON.parse(autoRatio);
            for (var i = 0; i < autoRatio.length; i++) {
                ratioNumber += autoRatio[i].percent;
            }

            if (ratioNumber < 0.5 || ratioNumber > 1) {

                $('<div class="custom-validation-error">' +
                    '<div class="cl"></div>' +
                    '<span class="field-validation-error">' +
                    '<span htmlfor="ETT_AutoRatio" generated="true" class="">出题比例必须大于 50% 、小于 100%</span>' +
                    '</span>' +
                    '<div>').appendTo(container);

                valid = false;
            }

            valid = validateStartTime(valid);
            valid = validateEndTime(valid);
        } else if (mode == 2) {

            valid = et.validateStartTime(valid);
            valid = et.validateEndTime(valid);
            valid = et.validateContinuedDays(valid);
        }

        return valid;
    }

});
