$(function() {
    'use strict';

    var ztree, qcZtree;
    var userIds, userNames, departmentIds, departmentNames;

    // 初始化任务模板事件
    initTemplateEvent();

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

    // 初始化开始时间控件事件
    initStartTimeEvent();

    // 初始化提交事件
    initSubmitEvent();

    function initTemplateEvent() {

        $('#ET_Template').on('change', function() {

            var select, template, departmentIds, userIds;
            var ztree, nodes, autoClassifies;

            select = $(this);
            template = select.val();

            if ('' == template) {
                return;
            }

            template = $.parseJSON(template);

            $('#ET_Type').val(template.ETT_Type);
            $('#ET_ParticipatingDepartment').val(template.ETT_ParticipatingDepartment);
            $('#ET_Attendee').val(template.ETT_Attendee);
            $('#ET_StatisticType').val(template.ETT_StatisticType).change();
            $('#ET_TotalScore').val(template.ETT_TotalScore);
            $('#ET_TotalNumber').val(template.ETT_TotalNumber)
            $('#ET_Mode').val(template.ETT_Mode).change();
            $('#ET_AutoType').val(template.ETT_AutoType).change();
            //$('#ET_AutoOffsetDay').val(template.ETT_AutoOffsetDay);
            $('#AutoOffsetDayContainer .offset-day-num').val(template.ETT_AutoOffsetDay).change();
            $('#ET_DifficultyCoefficient').val(template.ETT_DifficultyCoefficient);
            $('#ET_AutoClassifies').val(template.ETT_AutoClassifies);
            $('#ET_AutoRatio').val(template.ETT_AutoRatio);
            $('#ET_StartTime').val(template.ETT_StartTime.toDate().format('yyyy/M/d hh:mm:ss'));
            $('#ET_EndTime').val(template.ETT_EndTime);
            $('#ET_TimeSpan').val(template.ETT_TimeSpan);

            departmentIds = $.parseJSON(template.ETT_ParticipatingDepartment);
            userIds = $.parseJSON(template.ETT_Attendee);

            // 设置参与人员
            ztree = $.fn.zTree.getZTreeObj('DepartmentsAndUsers');
            nodes = ztree.getNodes();
            setDepartmentsAndUsersNodeChecked(ztree, nodes, departmentIds, userIds);

            // 设置自动出题分类
            ztree = $.fn.zTree.getZTreeObj('QuestionClassifies');
            nodes = ztree.getNodes();
            autoClassifies = JSON.parse(template.ETT_AutoClassifies);
            setQuestionClassifiesNodeChecked(ztree, nodes, autoClassifies);

            // 设置出题比例
            setAutoRatio($('#RatioContainer'), JSON.parse(template.ETT_AutoRatio));

            // 设置开始时间
            setStartTime();
        });
    }

    function initStatisticTypeEvent() {

        $('#ET_StatisticType').on('change', function() {

            var select, etTotalScore, etTotalNumber, tsContainer, anContainer;
            var type;

            select = $(this);
            type = parseInt(select.val());

            etTotalScore = $('#ET_TotalScore');
            etTotalNumber = $('#ET_TotalNumber');
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
        $('#ET_StatisticType').change();
    }

    function initModeEvent() {

        var etMode, etAutoType;
        var autoType;

        etMode = $('#ET_Mode');
        etAutoType = $('#ET_AutoType');

        etMode.on('change', function() {

            var modeSelect, tmpSelect;
            var mode;

            modeSelect = $(this);
            mode = parseInt(modeSelect.val());

            tmpSelect = $('#ET_AutoType');

            switch (mode) {
                case 0:

                    tmpSelect.parentsUntil('form').last().hide();
                    tmpSelect.find('option[selected]').attr('selected', false);
                    tmpSelect.find('option[value=0]').attr('selected', true);
                    $('#ET_AutoOffsetDay').parentsUntil('form').last().hide();
                    $('#ET_DifficultyCoefficient').parentsUntil('form').last().hide();
                    $('#ET_AutoClassifies').parentsUntil('form').last().hide();
                    $('#ET_AutoRatio').parentsUntil('form').last().hide();
                    $('#ET_StartTime').parentsUntil('form').last().hide();
                    break;
                case 1:

                    tmpSelect.parentsUntil('form').last().show();
                    tmpSelect.find('option[selected]').attr('selected', false);
                    tmpSelect.find('option[value=1]').attr('selected', true);
                    tmpSelect.change();
                    $('#ET_AutoOffsetDay').parentsUntil('form').last().hide();
                    $('#ET_DifficultyCoefficient').parentsUntil('form').last().show();
                    $('#ET_AutoClassifies').parentsUntil('form').last().show();
                    $('#ET_AutoRatio').parentsUntil('form').last().show();
                    $('#ET_StartTime').parentsUntil('form').last().show();
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

        var etAutoType, etAutoOffsetDay;

        etAutoType = $('#ET_AutoType');
        etAutoOffsetDay = $('#ET_AutoOffsetDay');

        etAutoType.on('change', function() {

            var qList, etAutoType, etAutoOffsetDay, offsetDayNum, aodContainer, etaodContainer;
            var autoType;

            qList = $('#QuestionListSelectContainer');
            etAutoType = $('#ET_AutoType');
            autoType = parseInt(etAutoType.val());

            aodContainer = $('#AutoOffsetDayContainer');
            etAutoOffsetDay = $('#ET_AutoOffsetDay');
            etaodContainer = etAutoOffsetDay.parentsUntil('form').last();

            switch (autoType) {
                case 0:

                    qList.show();
                    renderQuestionList();

                    etAutoOffsetDay = $('#ET_Mode');
                    etAutoOffsetDay.find('option[value=0]').attr('selected', true);
                    etAutoOffsetDay.change();
                    break;
                case 1:

                    qList.hide();
                    etaodContainer.hide();

                    etAutoOffsetDay.val(0);
                    aodContainer.html('');
                    break;
                case 2:

                    qList.hide();
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

    function renderQuestionList() {

        var table;

        table = $('.question-table').DataTable();
        table.destroy();
        initQuestionSelectTable();
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

        userIds = $('#ET_Attendee').val();
        userIds = $.parseJSON(userIds);
        departmentIds = $('#ET_ParticipatingDepartment').val();
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
                    }else if(nodes[i].now != now){

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
        autoClassifies = $('#ET_AutoClassifies').val();
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
                }else if(nodes[i].now != now){

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

        var rs;
        var container;

        rs = $('#ET_AutoRatio').val();
        rs = undefined == rs || '[]' == rs ? getOriginRatios() : JSON.parse(rs);

        container = $('#RatioContainer');

        setAutoRatio(container, rs);

        container.on('change', 'input.ratio-percent', function() {

            var input;
            var ratio;

            input = $(this);
            ratio = input.val();

            if (isNaN(ratio)) {

                alert('请输入整数。');
                ratio = input.attr('data-origin-val');
            }

            ratio = parseInt(ratio);
            input.val(ratio);
        });
    }

    function setAutoRatio(ratioContainer, rs) {

        var r, p;

        ratioContainer.html('');
        for (var i = 0; i < rs.length; i++) {

            r = rs[i];
            p = r.percent * 100;

            $('<div class="ratio-item">' +
                '<span class="ratio-type">' + r.type + '</span>' +
                '<input type="text" class="input-text ratio-percent" value="' + p + '" data-origin-val="' + p + '" />%' +
                '</div>').appendTo(ratioContainer);

        }
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

                $('#ET_StartTime').val(datetime);
            });

        // 设置时间
        setStartTime();
    }

    function setStartTime() {

        $('body').everyTime('3s', 'SetHour', function() {

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

                startTime = $('#ET_StartTime').val();
                startTime = startTime.toDate();

                hourcombo.val(startTime.getHours())
                mincombo.val(startTime.getMinutes());
                seccombo.val(startTime.getSeconds())

                $('body').stopTime('SetHour');
            }
        });
    }

    function initSubmitEvent() {

        $('form').submit(function(e) {

            var nodes, autoClassifies;

            // 设置参与部门/用户
            userIds = [];
            userNames = [];
            departmentIds = [];
            departmentNames = [];
            nodes = ztree.getNodes();

            getDepartmentsAndUsersNodeChecked(nodes);

            $('#ET_ParticipatingDepartment').val(JSON.stringify(departmentIds));
            $('#ET_Attendee').val(JSON.stringify(userIds));

            // 设置自动出题分类
            nodes = qcZtree.getNodes();
            autoClassifies = getQuestionClassifiesNodeChecked(nodes);
            $('#ET_AutoClassifies').val(JSON.stringify(autoClassifies)); // 数据格式：['分类名1', '分类名2', ...]

            // 设置自动出题比例
            $('#ET_AutoRatio').val(JSON.stringify(getRatios()));

            if (!validateData()) {

                e.preventDefault();
                return;
            }

            if (!confirm('确定提交吗？')) {
                e.preventDefault();
            }

        });
    }

    function validateData() {

        var errorSpan, etAutoType, container, etAutoClassifies, etAutoRatio,
            etQuestions, sdiContainer, etStartTime, etTotalScore, etStatisticType, etTotalNumber;
        var autoType, autoClassifies, autoRatio, questions, qAry, startTime, totalScore, ratioNumber, statisticType, totalNumber;
        var acRegex, arRegex, qsRegex, stRegex, stRegex1;
        var valid;

        $('.custom-validation-error').remove();

        etAutoType = $('#ET_AutoType');
        autoType = etAutoType.val();

        valid = true;

        etTotalScore = $('#ET_TotalScore');
        totalScore = parseInt(etTotalScore.val());

        // 自动任务
        if (0 != autoType) {

            // 出题分类数据验证
            // 数据格式：['分类名1', '分类名2', ...]
            acRegex = /^\[(".+",?\s*)+\]$/g;

            etAutoClassifies = $('#ET_AutoClassifies');
            container = etAutoClassifies.parent();
            autoClassifies = etAutoClassifies.val();

            if (!acRegex.test(autoClassifies)) {

                $('<div class="custom-validation-error">' +
                    '<div class="cl"></div>' +
                    '<span class="field-validation-error">' +
                    '<span htmlfor="ET_AutoClassifies" generated="true" class="">请选择出题分类</span>' +
                    '</span>' +
                    '<div>').appendTo(container);

                valid = false;
            }

            // 出题比例数据验证
            // 数据格式： [{type: '单选题', percent: 0.2}, {type: '多选题', percent: 0.2}, ...]
            arRegex = /^\[(\{"type"\:\s*".+"\,\s*"percent"\:\s*(0\.)?\d{1,2}},?\s*)+\]$/g;

            etAutoRatio = $('#ET_AutoRatio');
            container = etAutoRatio.parent();
            autoRatio = etAutoRatio.val();

            if (!arRegex.test(autoRatio)) {

                $('<div class="custom-validation-error">' +
                    '<div class="cl"></div>' +
                    '<span class="field-validation-error">' +
                    '<span htmlfor="ET_AutoRatio" generated="true" class="">请输入出题比例</span>' +
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

            if (ratioNumber < 0.5 ||ratioNumber > 1) {

                $('<div class="custom-validation-error">' +
                    '<div class="cl"></div>' +
                    '<span class="field-validation-error">' +
                    '<span htmlfor="ET_AutoRatio" generated="true" class="">出题比例必须大于50%、小于100%</span>' +
                    '</span>' +
                    '<div>').appendTo(container);

                valid = false;
            }

            // 开始时间验证
            // 数据格式：1970/1/1 8:00:00
            stRegex = /^1970\/1\/1 (([0-9]{1})|(1{1}[0-9]{1})|(2{1}[0-3]{1})):[0-5]{1}[0-9]{0,1}:[0-5]{0,1}[0-9]{1}$/g;
            stRegex1 = /^1970\/1\/1 0{1,2}:0{1,2}:0{1,2}$/g;

            etStartTime = $('#ET_StartTime');
            container = etStartTime.parent();
            startTime = etStartTime.val();

            if (stRegex1.test(startTime) || !stRegex.test(startTime)) {

                $('<div class="custom-validation-error">' +
                    '<div class="cl"></div>' +
                    '<span class="field-validation-error">' +
                    '<span htmlfor="ET_StartTime" generated="true" class="">请选择开始时间</span>' +
                    '</span>' +
                    '<div>').appendTo(container);

                valid = false;
            }
        }

        // 手动任务
        etQuestions = $('#ETT_Questions');
        if (0 == autoType && etQuestions.length != 0) {

            // 试题选择数据验证
            // 数据格式：[1, 2, ...]
            qsRegex = /^\[((\d+)|("{1}\d+"{1}),?\s*)+\]$/g;


            sdiContainer = $('.select-data-item');
            questions = etQuestions.val();
            qAry = JSON.parse(questions);

            if (!qsRegex.test(questions)) {

                $('<div class="custom-validation-error">' +
                    '<div class="cl"></div>' +
                    '<span class="field-validation-error">' +
                    '<span htmlfor="ETT_Questions" generated="true" class="">请选择试题</span>' +
                    '</span>' +
                    '<div>').appendTo(sdiContainer);

                valid = false;
            } else {

                // 检查“已选试题数量”与“出题数量”是否一致
                if ($('#ETT_StatisticType').val() == 2 && qAry.length != $('#ETT_TotalNumber').val()) {

                    $('<div class="custom-validation-error">' +
                        '<div class="cl"></div>' +
                        '<span class="field-validation-error">' +
                        '<span htmlfor="ETT_Questions" generated="true" class="">已选试题数量与出题数量不一致</span>' +
                        '</span>' +
                        '<div>').appendTo(sdiContainer);

                    valid = false;
                }
            }

            // 限制选题数量
            if (qAry.length < totalScore / 10 || qAry.length > totalScore) {

                $('<div class="custom-validation-error">' +
                    '<div class="cl"></div>' +
                    '<span class="field-validation-error">' +
                    '<span htmlfor="ETT_TotalScore" generated="true" class="">已选试题数量与出题分数不合理</span>' +
                    '</span>' +
                    '<div>').appendTo(sdiContainer);

                valid = false;
            }
        }

        // 限制出题总分/出题总数为 10 的倍数
        etStatisticType = $('#ET_StatisticType');
        etTotalNumber = $('#ET_TotalNumber');

        statisticType = etStatisticType.val();
        totalNumber = parseInt(etTotalNumber.val());

        if (1 == statisticType && totalScore % 10 != 0) {

            $('<div class="custom-validation-error">' +
                '<div class="cl"></div>' +
                '<span class="field-validation-error">' +
                '<span htmlfor="ET_TotalScore" generated="true" class="">出题总分必须为10的倍数</span>' +
                '</span>' +
                '<div>').appendTo(etTotalScore.parent());

            valid = false;
        } else if (2 == statisticType && totalNumber % 10 != 0) {

            $('<div class="custom-validation-error">' +
                '<div class="cl"></div>' +
                '<span class="field-validation-error">' +
                '<span htmlfor="ET_TotalNumber" generated="true" class="">出题总数必须为10的倍数</span>' +
                '</span>' +
                '<div>').appendTo(etTotalNumber.parent());

            valid = false;
        }

        return valid;
    }
});
