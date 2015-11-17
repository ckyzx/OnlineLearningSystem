$(function() {

    var table;

    table = $('.question-table').DataTable({
        "processing": true,
        "serverSide": true,
        "ajax": {
            "url": "/Question/ListDataTablesAjax",
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
            "targets": [0, 5, 6, 7]
        }],
        "columns": [{
            "width": "10px",
            "className": "text-c",
            "defaultContent": '<input type="checkbox" value="" name="">'
        }, {
            "width": "30px",
            "name": "Q_Id",
            "data": "Q_Id"
        }, {
            "name": "Q_Type",
            "data": "Q_Type"
        }, {
            "name": "QC_Name",
            "data": "QC_Name"
        }, {
            "name": "Q_AddTime",
            "defaultContent": '<span class="Q_AddTime"></span>'
        }, {
            "width": "40%",
            "name": "Q_Content",
            "defaultContent": '<span class="Q_Content"></span>'
        }, {
            "width": "50px",
            "name": "Q_DifficultyCoefficient",
            "defaultContent": '<span class="select-box size-MINI"><select class="dif-coe select"></select></span>'
        }, {
            "width": "80px",
            "className": "text-c",
            "defaultContent": '<a style="text-decoration: none" class="recycle fz-18 hide" href="javascript:;" title="回收"><i class="Hui-iconfont">&#xe631;</i></a>' +
                '<a style="text-decoration: none" class="resume ml-5 fz-18 hide" href="javascript:;" title="恢复"><i class="Hui-iconfont">&#xe615;</i></a>' +
                '<a style="text-decoration: none" class="edit ml-5 fz-18 hide" href="javascript:;" title="编辑"><i class="Hui-iconfont">&#xe60c;</i></a>' +
                '<a style="text-decoration: none" class="delete ml-5 fz-18 hide" href="javascript:;" title="删除"><i class="Hui-iconfont">&#xe6e2;</i></a>'
        }],
        "createdRow": function(row, data, dataIndex) {

            var span, strDate, date, content, status, coefficient, select;

            row = $(row);

            span = row.find('span.Q_AddTime');
            strDate = data['Q_AddTime'];
            date = strDate.jsonDateToDate();
            strDate = date.format('yyyy-MM-dd hh:mm:ss');

            span.text(strDate);

            span = row.find('span.Q_Content');
            content = data['Q_Content'];
            content = content.replace(/\\r\\n/g, '<br />');

            span.html(content);

            status = data['Q_Status'];
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

            coefficient = data['Q_DifficultyCoefficient'];
            select = row.find('select.dif-coe');
            select.html(options);
            select.val(coefficient);

        }
    });

    $('.table-sort tbody').on('click', 'a.edit', function() {

        var data, id;

        data = table.row($(this).parents('tr')).data();
        id = data['Q_Id'];

        ShowPage('编辑试题', '/Question/Edit?id=' + id);
    });

    $('.table-sort tbody').on('click', 'a.recycle', function() {

        var tr, data, id;

        tr = $(this).parents('tr');
        data = table.row(tr).data();
        id = data['Q_Id'];

        $.post('/Question/Recycle', {
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
        id = data['Q_Id'];

        $.post('/Question/Resume', {
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
        id = data['Q_Id'];

        $.post('/Question/Resume', {
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
        id = data['Q_Id'];

        $.post('/Question/Delete', {
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
        ShowPage('添加试题', '/Question/Create');
    });

    $('#DocxUploadBtn').on('click', function() {
        ShowPageWithSize('导入试题', '/Question/DocxUploadAndImport', 800, 300);
    });

    // 初始化难度系数设置框
    var options;

    options = '';

    for (var p in difficultyCoefficient) {
        options += '<option value="' + p + '">' + difficultyCoefficient[p] + '</option>';
    }

    $('.table-sort tbody').on('change', 'select.dif-coe', function() {

        var select, tr, data, id, coefficient;

        select = $(this);
        tr = select.parents('tr');
        data = table.row(tr).data();
        id = data['Q_Id'];

        coefficient = select.val();

        $.post('/Question/SetDifficultyCoefficient', {
                id: id,
                coefficient: coefficient
            }, function(data) {

                if (0 == data.status) {

                    alert(data.message);
                }
            }, 'json')
            .error(function() {

                alert('请求返回错误！');
            });
    });
});

var difficultyCoefficient;

difficultyCoefficient = {
    0: 0,
    1: 1,
    2: 2,
    3: 3,
    4: 4,
    5: 5,
    6: 6,
    7: 7,
    8: 8,
    9: 9
};
