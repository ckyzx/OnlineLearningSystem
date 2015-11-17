$(function() {

    var table, etId, type, ptStatus;

    QueryString.Initial();
    etId = QueryString.GetValue('etId');
    type = QueryString.GetValue('type');
    ptStatus = QueryString.GetValue('ptStatus');

    table = $('.table-sort').DataTable({
        "processing": true,
        "serverSide": true,
        "ajax": {
            "url": "/ExaminationPaperTemplate/ListDataTablesAjaxStudent?type=" + type + "&ptStatus=" + ptStatus,
            "type": "POST"
        },
        "stateSave": false,
        "lengthChange": false,
        "pageLength": 15,
        "sorting": [
            [1, "asc"]
        ],
        "columnDefs": [{
            "orderable": false,
            "targets": [0, 3, 4, 5, 6]
        }],
        "columns": [{
            "width": "10px",
            "className": "text-c",
            "defaultContent": '<input type="checkbox" value="" name="">'
        }, {
            "width": "30px",
            "name": "EPT_Id",
            "data": "EPT_Id"
        }, {
            "name": "EPT_StartTime",
            "defaultContent": '<span class="EPT_StartTime"></span>'
        }, {
            "name": "EPT_TimeSpan",
            "data": "EPT_TimeSpan"
        }, {
            "name": "EPT_AddTime",
            "defaultContent": '<span class="EPT_AddTime"></span>'
        }, {
            "width": "40%",
            "name": "EPT_Remark",
            "data": 'EPT_Remark'
        }, {
            "width": "180px",
            "className": "text-c",
            "defaultContent": 
                '<a style="text-decoration: none" class="recycle fz-14" href="javascript:;" title="进入考试">进入考试</a>' +
                '<a style="text-decoration: none" class="recycle ml-5 fz-18 hide" href="javascript:;" title="回收"><i class="Hui-iconfont">&#xe631;</i></a>' +
                '<a style="text-decoration: none" class="resume ml-5 fz-18 hide" href="javascript:;" title="恢复"><i class="Hui-iconfont">&#xe615;</i></a>' +
                '<a style="text-decoration: none" class="edit ml-5 fz-18 hide" href="javascript:;" title="编辑"><i class="Hui-iconfont">&#xe60c;</i></a>' +
                '<a style="text-decoration: none" class="delete ml-5 fz-18 hide" href="javascript:;" title="删除"><i class="Hui-iconfont">&#xe6e2;</i></a>'
        }],
        "createdRow": function(row, data, dataIndex) {

            var span, strDate, date, status;

            row = $(row);

            span = row.find('span.EPT_AddTime');
            strDate = data['EPT_AddTime'];
            date = strDate.jsonDateToDate();
            strDate = date.format('yyyy-MM-dd hh:mm:ss');
            span.text(strDate);

            span = row.find('span.EPT_StartTime');
            strDate = data['EPT_StartTime'];
            date = strDate.jsonDateToDate();
            strDate = date.format('yyyy-MM-dd hh:mm:ss');
            span.text(strDate);

            status = data['EPT_Status'];
            switch (status) {
                case 1:
                    row.find('a.recycle').show();
                    row.find('a.edit').show();
                    row.find('a.delete').show();
                    break;
                case 2:
                    row.find('a.resume').show();
                    row.find('a.delete').show();
                    break;
                case 3:
                    break;
                default:
                    break;
            }
        }
    });

    $('.table-sort tbody').on('click', 'a.edit', function() {

        var data, id;

        data = table.row($(this).parents('tr')).data();
        id = data['EPT_Id'];

        ShowPage('修改试卷模板', '/ExaminationPaperTemplate/Edit?id=' + id);
    });

    $('.table-sort tbody').on('click', 'a.recycle', function() {

        var tr, data, id;

        tr = $(this).parents('tr');
        data = table.row(tr).data();
        id = data['EPT_Id'];

        $.post('/ExaminationPaperTemplate/Recycle', {
                id: id
            }, function(data) {

                if (1 == data.status) {

                    tr.fadeOut(function() {

                        tr.remove();
                    });
                } else if (0 == data.status) {

                    alert(data.message);
                }
            }, 'json')
            .error(function() {

                alert('请求返回错误！');
            });
    });

    $('.table-sort tbody').on('click', 'a.resume', function() {

        var tr, data, id;

        tr = $(this).parents('tr');
        data = table.row(tr).data();
        id = data['EPT_Id'];

        $.post('/ExaminationPaperTemplate/Resume', {
                id: id
            }, function(data) {

                if (1 == data.status) {

                    tr.fadeOut(function() {

                        tr.remove();
                    });
                } else if (0 == data.status) {

                    alert(data.message);
                }
            }, 'json')
            .error(function() {

                alert('请求返回错误！');
            });
    });

    $('.table-sort tbody').on('click', 'a.resume', function() {

        var tr, data, id;

        tr = $(this).parents('tr');
        data = table.row(tr).data();
        id = data['EPT_Id'];

        $.post('/ExaminationPaperTemplate/Resume', {
                id: id
            }, function(data) {

                if (1 == data.status) {

                    tr.fadeOut(function() {

                        tr.remove();
                    });
                } else if (0 == data.status) {

                    alert(data.message);
                }
            }, 'json')
            .error(function() {

                alert('请求返回错误！');
            });
    });

    $('.table-sort tbody').on('click', 'a.delete', function() {

        var tr, data, id;

        tr = $(this).parents('tr');
        data = table.row(tr).data();
        id = data['EPT_Id'];

        $.post('/ExaminationPaperTemplate/Delete', {
                id: id
            }, function(data) {

                if (1 == data.status) {

                    tr.fadeOut(function() {

                        tr.remove();
                    });
                } else if (0 == data.status) {

                    alert(data.message);
                }
            }, 'json')
            .error(function() {

                alert('请求返回错误！');
            });
    });

    $('.table-sort tbody').on('click', 'a.edit', function() {

        var data, id;

        data = table.row($(this).parents('tr')).data();
        id = data['EPT_Id'];

        ShowPage('进入考试', '/ExaminationPaperTemplate/Paper?id=' + id);
    });

});
