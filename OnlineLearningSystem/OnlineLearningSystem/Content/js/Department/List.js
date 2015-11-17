$(function() {

    var table;

    table = $('.table-sort').DataTable({
        "processing": true,
        "serverSide": true,
        "ajax": {
            "url": "/Department/ListDataTablesAjax",
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
            "targets": [0, 4, 5]
        }],
        "columns": [{
            "width": "10px",
            "className": "text-c",
            "defaultContent": '<input type="checkbox" value="" name="">'
        }, {
            "width": "30px",
            "name": "D_Id",
            "data": "D_Id"
        }, {
            "name": "D_Name",
            "data": "D_Name"
        }, {
            "name": "D_AddTime",
            "defaultContent": '<span class="D_AddTime"></span>'
        }, {
            "width": "40%",
            "name": "D_Remark",
            "data": 'D_Remark'
        }, {
            "width": "80px",
            "className": "text-c",
            "defaultContent": '<a style="text-decoration: none" class="recycle fz-18 hide" href="javascript:;" title="回收"><i class="Hui-iconfont">&#xe631;</i></a>' +
                '<a style="text-decoration: none" class="resume ml-5 fz-18 hide" href="javascript:;" title="恢复"><i class="Hui-iconfont">&#xe615;</i></a>' +
                '<a style="text-decoration: none" class="edit ml-5 fz-18 hide" href="javascript:;" title="编辑"><i class="Hui-iconfont">&#xe60c;</i></a>' +
                '<a style="text-decoration: none" class="delete ml-5 fz-18 hide" href="javascript:;" title="删除"><i class="Hui-iconfont">&#xe6e2;</i></a>'
        }],
        "createdRow": function(row, data, dataIndex) {

            var span, strDate, date, status;

            row = $(row);

            span = row.find('span.D_AddTime');
            strDate = data['D_AddTime'];
            date = strDate.jsonDateToDate();
            strDate = date.format('yyyy-MM-dd hh:mm:ss');
            span.text(strDate);

            status = data['D_Status'];
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
        id = data['D_Id'];

        ShowPage('修改部门', '/Department/Edit?id=' + id);
    });

    $('.table-sort tbody').on('click', 'a.recycle', function() {

        var tr, data, id;

        tr = $(this).parents('tr');
        data = table.row(tr).data();
        id = data['D_Id'];

        $.post('/Department/Recycle', {
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
        id = data['D_Id'];

        $.post('/Department/Resume', {
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
        id = data['D_Id'];

        $.post('/Department/Resume', {
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
        id = data['D_Id'];

        $.post('/Department/Delete', {
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

    $('#CreateBtn').on('click', function() {
        ShowPage('添加部门', '/Department/Create');
    });

});
