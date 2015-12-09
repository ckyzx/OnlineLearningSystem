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
            "className": "text-l",
            "defaultContent": '<a style="display:none;text-decoration:none;" class="btn btn-primary radius size-MINI start-task fz-9" href="javascript:;" title="开始">开始</a>' +
                '<a style="display:none;text-decoration:none;" class="btn btn-primary radius size-MINI stop-task fz-9" href="javascript:;" title="结束">结束</a>' +
                '<a style="display:none;text-decoration:none;" class="btn btn-primary radius size-MINI ml-5 paper-template fz-9" href="javascript:;" title="试卷">试卷</a>' +
                '<a style="text-decoration:none;" class="recycle ml-5 fz-18 hide" href="javascript:;" title="回收"><i class="Hui-iconfont">&#xe631;</i></a>' +
                '<a style="text-decoration:none;" class="resume ml-5 fz-18 hide" href="javascript:;" title="恢复"><i class="Hui-iconfont">&#xe615;</i></a>' +
                '<a style="text-decoration:none;" class="edit ml-5 fz-18 hide" href="javascript:;" title="编辑"><i class="Hui-iconfont">&#xe60c;</i></a>' +
                '<a style="text-decoration:none;" class="delete ml-5 fz-18 hide" href="javascript:;" title="删除"><i class="Hui-iconfont">&#xe6e2;</i></a>'
        }],
        "createdRow": function(row, data, dataIndex) {

            var span, strDate, date, timeSpan, autoType, status;

            row = $(row);

            // 设置开始时间
            span = row.find('span.ET_StartTime');
            strDate = data['ET_StartTime'];
            date = strDate.jsonDateToDate();
            if (date.getHours() == 0 && date.getMinutes() == 0 && date.getSeconds() == 0) {
                span.text('[手动开始]');
            } else {
                strDate = date.format('hh时 mm分');
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
            autoType = data['ET_AutoType'];
            span.text(AutoType[autoType]);
            switch (autoType) {
                case 0:
                    break;
                default:
                    row.find('a.paper-template').show();
                    break;
            }

            // 呈现按钮
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

            status = data['EPT_PaperTemplateStatus']
            switch (status) {
                case 0:
                    row.find('a.start-task').show();
                    break;
                case 1:
                    row.find('a.stop-task').show();
                    break;
                case 2:
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

    $('.table-sort tbody').on('click', 'a.start-task', function() {

        var tr, data, id;

        tr = $(this).parents('tr');
        data = table.row(tr).data();
        id = data['ET_Id'];

        $.post('/ExaminationTask/StartTask', {
                id: id
            }, function(data) {

                var btn, td;

                if (1 == data.status) {

                    tr.find('a.start-task').hide();
                    tr.find('a.stop-task').show();

                    alert('操作成功。');
                } else if (0 == data.status) {

                    alert(data.message);
                }
            }, 'json')
            .error(function() {

                alert('请求返回错误！');
            });
    });

    $('.table-sort tbody').on('click', 'a.stop-task', function() {

        var tr, data, id;

        tr = $(this).parents('tr');
        data = table.row(tr).data();
        id = data['ET_Id'];

        $.post('/ExaminationTask/StopTask', {
                id: id
            }, function(data) {

                if (1 == data.status) {

                    tr.find('a.stop-task').hide();
                    
                    alert('操作成功。');
                } else if (0 == data.status) {

                    alert(data.message);
                }
            }, 'json')
            .error(function() {

                alert('请求返回错误！');
            });
    });

    $('#CreateBtn').on('click', function() {
        ShowPage('添加任务', '/ExaminationTask/Create');
    });

});
