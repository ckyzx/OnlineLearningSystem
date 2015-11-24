$(function() {

    var table;

    table = $('.table-sort').DataTable({
        "processing": true,
        "serverSide": true,
        "ajax": {
            "url": "/ExaminationTask/ListDataTablesAjax",
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
            "targets": [0, 4, 5, 6, 7]
        }],
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
            "name": "ET_StartTime",
            "defaultContent": '<span class="ET_StartTime"></span>'
        }, {
            "name": "ET_TimeSpan",
            "defaultContent": '<span class="ET_TimeSpan"></span>'
        }, {
            "name": "ET_AutoType",
            "defaultContent": '<span class="ET_AutoType"></span>'
        }, {
            "width": "40%",
            "name": "ET_Remark",
            "data": 'ET_Remark'
        }, {
            "width": "180px",
            "className": "text-c",
            "defaultContent": '<a style="text-decoration: none" class="btn btn-primary radius size-MINI paper-template fz-10" href="javascript:;" title="试卷模板">试卷模板</a>' +
                '<a style="text-decoration: none" class="recycle ml-5 fz-18 hide" href="javascript:;" title="回收"><i class="Hui-iconfont">&#xe631;</i></a>' +
                '<a style="text-decoration: none" class="resume ml-5 fz-18 hide" href="javascript:;" title="恢复"><i class="Hui-iconfont">&#xe615;</i></a>' +
                '<a style="text-decoration: none" class="edit ml-5 fz-18 hide" href="javascript:;" title="编辑"><i class="Hui-iconfont">&#xe60c;</i></a>' +
                '<a style="text-decoration: none" class="delete ml-5 fz-18 hide" href="javascript:;" title="删除"><i class="Hui-iconfont">&#xe6e2;</i></a>'
        }],
        "createdRow": function(row, data, dataIndex) {

            var span, strDate, date, timeSpan, autoType, status;

            row = $(row);

            span = row.find('span.ET_StartTime');
            strDate = data['ET_StartTime'];
            date = strDate.jsonDateToDate();
            strDate = date.format('hh时 mm分');
            span.text(strDate);

            span = row.find('span.ET_TimeSpan');
            timeSpan = data['ET_TimeSpan'];
            span.text(timeSpan + '分钟');

            span = row.find('span.ET_AutoType');
            autoType = data['ET_AutoType'];
            span.text(AutoType[autoType]);

            status = data['ET_Status'];
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
        id = data['ET_Id'];

        ShowPage('修改任务', '/ExaminationTask/Edit?id=' + id);
    });

    $('.table-sort tbody').on('click', 'a.recycle', function() {

        var tr, data, id;

        tr = $(this).parents('tr');
        data = table.row(tr).data();
        id = data['ET_Id'];

        $.post('/ExaminationTask/Recycle', {
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
        id = data['ET_Id'];

        $.post('/ExaminationTask/Resume', {
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
        id = data['ET_Id'];

        $.post('/ExaminationTask/Resume', {
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
        id = data['ET_Id'];

        $.post('/ExaminationTask/Delete', {
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

    $('.table-sort tbody').on('click', 'a.paper-template', function() {

        var tr, data, id;

        tr = $(this).parents('tr');
        data = table.row(tr).data();
        id = data['ET_Id'];

        location.href = '/ExaminationPaperTemplate/List?etId=' + id;
    });

    $('#CreateBtn').on('click', function() {
        ShowPage('添加任务', '/ExaminationTask/Create');
    });

});
