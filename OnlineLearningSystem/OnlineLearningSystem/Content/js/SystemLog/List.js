$(function() {

    var dtParams, list;

    dtParams = {
        "processing": true,
        "serverSide": true,
        "ajax": {
            "url": "/SystemLog/ListDataTablesAjax",
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
            "name": "SL_Id",
            "data": "SL_Id"
        }, {
            "name": "SL_Name",
            "data": "SL_Name"
        }, {
            "name": "SL_Type",
            "defaultContent": '<span class="SL_Type"></span>'
        }, {
            "name": "SL_AddTime",
            "defaultContent": '<span class="SL_AddTime"></span>'
        }, {
            "width": "40%",
            "name": "SL_Content",
            "defaultContent": '<span class="SL_Content"></span>'
        }, {
            "width": "20%",
            "name": "SL_Remark",
            "data": 'SL_Remark'
        }, {
            "className": "text-c nowrap",
            "defaultContent": ''/*'<a class="recycle mr-5 fz-18 hide" href="javascript:void(0);" title="回收"><i class="Hui-iconfont">&#xe631;</i></a>' +
                '<a class="resume mr-5 fz-18 hide" href="javascript:void(0);" title="恢复"><i class="Hui-iconfont">&#xe615;</i></a>' +
                '<a class="edit mr-5 fz-18 hide" href="javascript:void(0);" title="编辑"><i class="Hui-iconfont">&#xe60c;</i></a>' +
                '<a class="delete mr-5 fz-18 hide" href="javascript:void(0);" title="删除"><i class="Hui-iconfont">&#xe6e2;</i></a>'*/
        }],
        "createdRow": function(row, data, dataIndex) {

            var span;
            var strDate, date, status, type;

            row = $(row);

            span = row.find('span.SL_AddTime');
            strDate = data['SL_AddTime'];
            date = strDate.jsonDateToDate();
            strDate = date.format('yyyy-MM-dd hh:mm:ss');
            span.text(strDate);

            status = data['SL_Status'];
            switch (status) {
                case 1:
                    row.find('a.recycle').removeClass('hide');
                    row.find('a.edit').removeClass('hide');

                    row.find('a.sort-top').removeClass('hide');
                    row.find('a.sort-up').removeClass('hide');
                    row.find('a.sort-down').removeClass('hide');
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

            type = data['SL_Type'];
            row.find('span.SL_Type').text(SystemLogType[type]);

            Kyzx.List.columnContentEllipsis($('.table-sort'), row, '.SL_Content', data['SL_Content']);
        }
    };

    list = Kyzx.List.init({
        dtSelector: '.table-sort',
        hasCreateBtn: false,
        hasRecycleBin: false,
        dtParams: dtParams,
        modelCnName: '系统日志',
        modelEnName: 'SystemLog',
        modelPrefix: 'SL_'
    });
    list.initList();
});