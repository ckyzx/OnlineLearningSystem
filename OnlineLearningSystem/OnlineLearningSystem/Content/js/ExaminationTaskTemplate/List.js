$(function() {

    var dtParams;
    var dataTables;

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
            "data": 'ETT_Remark'
        }, {
            "width": "80px",
            "className": "text-c",
            "defaultContent": '<a style="text-decoration: none" class="recycle fz-18 hide" href="javascript:void(0);" title="回收"><i class="Hui-iconfont">&#xe631;</i></a>' +
                '<a style="text-decoration: none" class="resume ml-5 fz-18 hide" href="javascript:void(0);" title="恢复"><i class="Hui-iconfont">&#xe615;</i></a>' +
                '<a style="text-decoration: none" class="edit ml-5 fz-18 hide" href="javascript:void(0);" title="编辑"><i class="Hui-iconfont">&#xe60c;</i></a>' +
                '<a style="text-decoration: none" class="delete ml-5 fz-18 hide" href="javascript:void(0);" title="删除"><i class="Hui-iconfont">&#xe6e2;</i></a>'
        }],
        "createdRow": function(row, data, dataIndex) {

            var span, strDate, date, timeSpan, autoType, status;

            row = $(row);

            span = row.find('span.ETT_StartTime');
            strDate = data['ETT_StartTime'];
            date = strDate.jsonDateToDate();
            strDate = date.format('hh时 mm分');
            span.text(strDate);

            span = row.find('span.ETT_TimeSpan');
            timeSpan = data['ETT_TimeSpan'];
            span.text(timeSpan + '分钟');

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
        }
    };

    dataTables = initList('.table-sort', dtParams, '考试任务模板', 'ExaminationTaskTemplate', 'ETT_');

});