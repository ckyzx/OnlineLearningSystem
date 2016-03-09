$(function() {

    var jqTable, dtParams, list;

    jqTable = $('.table-sort');

    dtParams = {
        "processing": true,
        "serverSide": true,
        "ajax": {
            "url": "/ExaminationTaskTemplate/ListDataTablesAjax",
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
            "name": "ETT_Id",
            "data": "ETT_Id"
        }, {
            "name": "ETT_Name",
            "data": "ETT_Name"
        }, {
            "name": "ETT_StartTime",
            "defaultContent": '<span class="ETT_StartTime"></span>'
        }, {
            "name": "ETT_TimeSpan",
            "defaultContent": '<span class="ETT_TimeSpan"></span>'
        }, {
            "name": "ETT_AutoType",
            "defaultContent": '<span class="ETT_AutoType"></span>'
        }, {
            "width": "40%",
            "name": "ETT_Remark",
            "className": 'ETT_Remark',
            "defaultContent": '<span class="ETT_Remark"></span>'
        }, {
            "className": "text-c nowrap",
            "defaultContent": '<a style="text-decoration: none" class="recycle fz-18 hide" href="javascript:void(0);" title="回收"><i class="Hui-iconfont">&#xe631;</i></a>' +
                '<a style="text-decoration: none" class="resume ml-5 fz-18 hide" href="javascript:void(0);" title="恢复"><i class="Hui-iconfont">&#xe615;</i></a>' +
                '<a style="text-decoration: none" class="edit ml-5 fz-18 hide" href="javascript:void(0);" title="编辑"><i class="Hui-iconfont">&#xe60c;</i></a>' +
                '<a style="text-decoration: none" class="delete ml-5 fz-18 hide" href="javascript:void(0);" title="删除"><i class="Hui-iconfont">&#xe6e2;</i></a>'
        }],
        "createdRow": function(row, data, dataIndex) {

            var span, strDate, date, timeSpan, autoType, status, remark;

            row = $(row);

            // 设置考试时间
            span = row.find('span.ETT_StartTime');
            strDate = data['ETT_StartTime'];
            date = strDate.jsonDateToDate();
            if (date.getHours() == 0 && date.getMinutes() == 0 && date.getSeconds() == 0) {

                span.text('[手动开始]');
            } else {

                strDate = date.format('hh时 mm分');
                strDate += ' - ' + data['ETT_EndTime'].jsonDateToDate().format('hh时 mm分');
                span.text(strDate);
            }

            // 设置考试时长
            span = row.find('span.ETT_TimeSpan');
            timeSpan = data['ETT_TimeSpan'];
            if (0 == timeSpan) {
                span.text('[无限制]');
            } else {
                span.text(timeSpan + '分钟');
            }

            // 设置类型
            span = row.find('span.ETT_AutoType');
            autoType = data['ETT_AutoType'];
            span.text(AutoType[autoType]);

            status = data['ETT_Status'];
            switch (status) {
                case 1:
                    row.find('a.recycle').removeClass('hide');
                    row.find('a.edit').removeClass('hide');
                    break;
                case 2:
                    row.find('a.resume').removeClass('hide');
                    row.find('a.delete').removeClass('hide');
                    break;
                case 3:
                    break;
                default:
                    break;
            }

            remark = data['ETT_Remark'];
            remark = remark == null ? '' : remark;
            Kyzx.List.columnContentEllipsis(jqTable, row, '.ETT_Remark', remark);
        },
        "drawCallback": function(settings) {

            if ($('th.ETT_Remark').width() != 40) {

                Kyzx.List.columnContentEllipsisAgain(jqTable, '.ETT_Remark');
            }
        },
        "initComplete": function() {

            Kyzx.List.columnContentEllipsisAgain(jqTable, '.ETT_Remark');
        }
    };

    list = Kyzx.List.init({
        dtSelector: '.table-sort',
        dtParams: dtParams,
        modelCnName: '考试任务模板',
        modelEnName: 'ExaminationTaskTemplate',
        modelPrefix: 'ETT_'
    });
    list.initList();

});