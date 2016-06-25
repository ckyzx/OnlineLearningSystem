$(function() {

    var jqTable, dtParams;

    $('body').append('<input type="hidden" id="ET_Mode" value="-1" />')

    jqTable = $('.table-sort');

    dtParams = {
        "processing": true,
        "serverSide": true,
        "ajax": {
            "url": "/ExaminationTask/ListDataTablesAjaxByUser?status=1&type=1&enabled=1",
            "type": "POST"
        },
        "stateSave": false,
        "lengthChange": false,
        "pageLength": 15,
        "ordering": false,
        "columns": [{
            "width": "10px",
            "className": "text-c",
            "defaultContent": '<input type="checkbox" value="" name="">'
        }, {
            "width": "30px",
            "name": "ET_Id",
            "data": "ET_Id"
        }, {
            "name": "ET_Name",
            "data": "ET_Name"
        }, {
            "name": "ET_Type",
            "defaultContent": '<span class="ET_Type"></span>'
        }, {
            "name": "ET_StartTime",
            "defaultContent": '<span class="ET_StartTime"></span>'
        }, {
            "name": "ET_TimeSpan",
            "defaultContent": '<span class="ET_TimeSpan"></span>'
        }, {
            "name": "ET_AutoType",
            "defaultContent": '<span class="ET_AutoType"></span>'
        }, {
            "width": "250px",
            "name": "ET_Remark",
            "className": "ET_Remark",
            "defaultContent": '<span class="ET_Remark"></span>'
        }, {
            "className": "text-c nowrap",
            "defaultContent": '<a class="btn btn-primary radius size-MINI mr-5 enter-exercise fz-9" href="javascript:void(0);">进入练习</a>'
        }],
        "createdRow": function(row, data, dataIndex) {

            var span, timeSpan, startTask, stopTask;
            var strDate, startTime, autoType, status, enabled,
                remark, mode, errorMessage, etType;

            row = $(row);

            autoType = data['ET_AutoType'];
            mode = data['ET_Mode'];

            // 设置任务类型
            etType = data['ET_Type'];
            row.find('span.ET_Type').text(ExaminationTaskType[etType]);

            // 设置考试时间
            span = row.find('span.ET_StartTime');
            startTime = data['ET_StartTime'];
            startTime = startTime.jsonDateToDate();
            if (mode == 0) { // 手动

                span.text('[手动开始]');
            } else if (mode == 2) { // 预定

                span.text(startTime.format('yyyy年MM月dd日hh时mm分'));
            } else { // 自动

                strDate = startTime.format('hh时mm分');
                strDate += ' - ' + data['ET_EndTime'].jsonDateToDate().format('hh时mm分');
                span.text(strDate);
            }

            // 设置考试时长
            span = row.find('span.ET_TimeSpan');
            timeSpan = data['ET_TimeSpan'];
            if (0 == timeSpan) {
                span.text('[无限制]');
            } else {
                span.text(timeSpan + '分钟');
            }

            // 设置类型
            span = row.find('span.ET_AutoType');
            span.text(AutoType[autoType]);
            if (autoType == 2) { // 每周
                span.text(span.text() + Week[data['ET_AutoOffsetDay']]);
            } else if (autoType == 3) { // 每月
                span.text(span.text() + data['ET_AutoOffsetDay'] + '号');
            }

            remark = data['ET_Remark'];
            remark = remark == null ? '' : remark;
            Kyzx.List.columnContentEllipsis(jqTable, row, '.ET_Remark', remark);

        },
        "drawCallback": function(settings) {

            if ($('th.ET_Remark').width() != 40) {

                Kyzx.List.columnContentEllipsisAgain(jqTable, '.ET_Remark');
            }
        },
        "initComplete": function() {

            Kyzx.List.columnContentEllipsisAgain(jqTable, '.ET_Remark');
        }
    };

    list = Kyzx.List.init({
        hasCreateBtn: false,
        hasRecycleBin: false,
        hasControlBtn: false,
        dtSelector: '.table-sort',
        dtParams: dtParams,
        modelCnName: '考试任务',
        modelEnName: 'ExaminationTask',
        modelPrefix: 'ET_'
    });
    list.initList();

    $('.table-sort tbody').on('click', 'a.enter-exercise', function() {

        var tr, data, etType;

        tr = $(this).parents('tr');
        data = list.dataTables.row(tr).data();

        etType = data['ET_Type'];

        layer.confirm('是否开始练习？', {
            title: '',
            btn: ['是', '否']
        }, function() {
            layer.closeAll();
            var id = data['ET_Id'];
            location.href = '/ExaminationPaperTemplate/EnterExercise?etId=' + id;
        });
    });

});
