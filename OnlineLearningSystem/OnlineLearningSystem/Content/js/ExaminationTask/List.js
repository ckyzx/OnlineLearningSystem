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
            "width": "50px",
            "className": "text-l nowrap",
            "defaultContent": '<a class="btn btn-primary radius size-MINI mr-5 start-task fz-9" href="javascript:;" title="开始">开始</a>' +
                '<a class="btn btn-primary radius size-MINI mr-5 stop-task fz-9" href="javascript:;" title="结束">结束</a>' +
                '<a class="btn btn-primary radius size-MINI mr-5 paper-template fz-9" href="javascript:;" title="试题">试题</a>' +
                '<a class="recycle mr-5 fz-18 hide" href="javascript:;" title="回收"><i class="Hui-iconfont">&#xe631;</i></a>' +
                '<a class="resume mr-5 fz-18 hide" href="javascript:;" title="恢复"><i class="Hui-iconfont">&#xe615;</i></a>' +
                '<a class="edit mr-5 fz-18 hide" href="javascript:;" title="编辑"><i class="Hui-iconfont">&#xe60c;</i></a>' +
                '<a class="delete mr-5 fz-18 hide" href="javascript:;" title="删除"><i class="Hui-iconfont">&#xe6e2;</i></a>'
        }],
        "createdRow": function(row, data, dataIndex) {

            var span, timeSpan, startTask, stopTask;
            var strDate, date, autoType, status, enabled;

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

            enabled = data['ET_Enabled'];
            startTask = row.find('a.start-task');
            stopTask = row.find('a.stop-task');

            switch (autoType) {
                case 0:

                    // 手动任务呈现按钮“开始/结束”
                    if(0 == enabled){
                        startTask.attr('title', '开始').text('开始').show();
                    }else if(1 == enabled){
                        stopTask.attr('title', '结束').text('结束').show();
                    }else if(2 == enabled){
                        // 不呈现按钮
                    }
                    break;
                default:

                    // 自动任务呈现按钮“开启/关闭”
                    if(1 == enabled){
                        stopTask.attr('title', '关闭').text('关闭').show();
                    }else{
                        startTask.attr('title', '开启').text('开启').show();
                    }

                    row.find('a.paper-template').show();
                    break;
            }

            // 呈现按钮
            status = data['ET_Status'];
            switch (status) {
                case 1:
                    row.find('a.recycle').show();
                    row.find('a.edit').show();
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
                        refreshRowBackgroundColor('.table-sort');
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
                        refreshRowBackgroundColor('.table-sort');
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
                        refreshRowBackgroundColor('.table-sort');
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

        var tr;
        var data, id, autoType;

        tr = $(this).parents('tr');
        data = table.row(tr).data();
        id = data['ET_Id'];
        autoType = data['ET_AutoType'];

        $.post('/ExaminationTask/StartTask', {
                id: id
            }, function(data) {

                var stopTask;

                if (1 == data.status) {

                    tr.find('a.start-task').hide();
                    stopTask = tr.find('a.stop-task');

                    if(0 == autoType){
                        stopTask.attr('title', '结束').text('结束');
                    }else{
                        stopTask.attr('title', '关闭').text('关闭');
                    }
                    stopTask.show();

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

        var tr;
        var data, id, autoType;

        tr = $(this).parents('tr');
        data = table.row(tr).data();
        id = data['ET_Id'];
        autoType = data['ET_AutoType'];

        $.post('/ExaminationTask/StopTask', {
                id: id
            }, function(data) {

                var startTask;

                if (1 == data.status) {

                    tr.find('a.stop-task').hide();

                    // 自动任务切换按钮
                    if(0 != autoType){

                        startTask = tr.find('a.start-task');
                        startTask.attr('title', '开启').text('开启');
                        startTask.show();
                    }

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
