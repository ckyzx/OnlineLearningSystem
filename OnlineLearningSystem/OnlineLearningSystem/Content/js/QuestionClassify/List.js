$(function() {

    var dtParams, list, dataTables;

    dtParams = {
        "processing": true,
        "serverSide": true,
        "ajax": {
            "url": "/QuestionClassify/ListDataTablesAjax",
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
            "name": "QC_Id",
            "data": "QC_Id"
        }, {
            "name": "QC_Name",
            "data": "QC_Name"
        }, {
            "name": "QC_AddTime",
            "defaultContent": '<span class="QC_AddTime"></span>'
        }, {
            "width": "40%",
            "name": "QC_Remark",
            "data": 'QC_Remark'
        }, {
            "width": "80px",
            "className": "text-c",
            "defaultContent": '<a style="text-decoration: none" class="recycle fz-18 hide" href="javascript:void(0);" title="回收"><i class="Hui-iconfont">&#xe631;</i></a>' +
                '<a style="text-decoration: none" class="resume ml-5 fz-18 hide" href="javascript:void(0);" title="恢复"><i class="Hui-iconfont">&#xe615;</i></a>' +
                '<a style="text-decoration: none" class="edit ml-5 fz-18 hide" href="javascript:void(0);" title="编辑"><i class="Hui-iconfont">&#xe60c;</i></a>' +
                '<a style="text-decoration: none" class="delete ml-5 fz-18 hide" href="javascript:void(0);" title="删除"><i class="Hui-iconfont">&#xe6e2;</i></a>'
        }],
        "createdRow": function(row, data, dataIndex) {

            var span, strDate, date, status;

            row = $(row);

            span = row.find('span.QC_AddTime');
            strDate = data['QC_AddTime'];
            date = strDate.jsonDateToDate();
            strDate = date.format('yyyy-MM-dd hh:mm:ss');
            span.text(strDate);

            status = data['QC_Status'];
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

    list = Kyzx.List.init({
        dtSelector: '.table-sort',
        dtParams: dtParams,
        modelCnName: '试题分类',
        modelEnName: 'QuestionClassify',
        modelPrefix: 'QC_'
    });
    dataTables = list.initList();

});
