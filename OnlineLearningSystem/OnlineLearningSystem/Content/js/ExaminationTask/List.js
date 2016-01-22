$(function() {

    var dtParams;

    dtParams = {
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
            "className": "text-c nowrap",
            "defaultContent": '<a class="btn btn-primary radius size-MINI mr-5 start-task fz-9 hide" href="javascript:void(0);">开始</a>' +
                '<a class="btn btn-primary radius size-MINI mr-5 stop-task fz-9 hide" href="javascript:void(0);">结束</a>' +
                '<a class="btn btn-primary radius size-MINI mr-5 paper-template fz-9 hide" href="javascript:void(0);" title="试题">试题</a>' +
                '<a class="recycle mr-5 fz-18 hide" href="javascript:void(0);" title="回收"><i class="Hui-iconfont">&#xe631;</i></a>' +
                '<a class="resume mr-5 fz-18 hide" href="javascript:void(0);" title="恢复"><i class="Hui-iconfont">&#xe615;</i></a>' +
                '<a class="edit mr-5 fz-18 hide" href="javascript:void(0);" title="编辑"><i class="Hui-iconfont">&#xe60c;</i></a>' +
                '<a class="delete mr-5 fz-18 hide" href="javascript:void(0);" title="删除"><i class="Hui-iconfont">&#xe6e2;</i></a>'
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

            status = data['ET_Status'];

            if(1 == status){

                // 呈现任务控制按钮
                switch (autoType) {
                    case 0:

                        // 手动任务呈现按钮“开始/结束”
                        if(0 == enabled){
                            startTask.text('开始').removeClass('hide');
                        }else if(1 == enabled){
                            stopTask.text('结束').removeClass('hide');
                        }else if(2 == enabled){
                            // 不呈现按钮
                        }
                        break;
                    default:

                        // 自动任务呈现按钮“开启/关闭”
                        if(1 == enabled){
                            stopTask.text('关闭').removeClass('hide');
                        }else{
                            startTask.text('开启').removeClass('hide');
                        }

                        break;
                }

                // 呈现“试卷模板/试题”按钮
                row.find('a.paper-template').removeClass('hide');
            }

            // “未开始/未结束”的任务才显示常规按钮
            if(0 == enabled || (2 == enabled && autoType != 0)){

                // 呈现常规按钮
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
        }
    };

    list = Kyzx.List.init({
        dtSelector: '.table-sort',
        dtParams: dtParams,
        modelCnName: '考试任务',
        modelEnName: 'ExaminationTask',
        modelPrefix: 'ET_'
    });
    list.initList();

    $('.table-sort tbody').on('click', 'a.paper-template', function() {

        var tr, data, id;

        tr = $(this).parents('tr');
        data = list.dataTables.row(tr).data();
        id = data['ET_Id'];

        location.href = '/ExaminationPaperTemplate/List?etId=' + id;
    });

    $('.table-sort tbody').on('click', 'a.start-task', function() {

        var tr;
        var data, id, autoType;

        if(!confirm('确认开始考试任务吗？'))
        {
            return;
        }

        tr = $(this).parents('tr');
        data = list.dataTables.row(tr).data();
        id = data['ET_Id'];
        autoType = data['ET_AutoType'];

        $.post('/ExaminationTask/StartTask', {
                id: id
            }, function(data) {

                var stopTask;

                if (1 == data.status) {

                    tr.find('a.start-task').addClass('hide');
                    stopTask = tr.find('a.stop-task');

                    if(0 == autoType){
                        stopTask.text('结束');
                    }else{
                        stopTask.text('关闭');
                    }
                    stopTask.removeClass('hide');

                    // 隐藏常规控制按钮
                    tr.find('a.edit, a.recycle, a.resume, a.delete').addClass('hide');

                    layer.msg('操作成功', {offset: '100px'});
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

        if(!confirm('确认关闭考试任务吗？'))
        {
            return;
        }

        tr = $(this).parents('tr');
        data = list.dataTables.row(tr).data();
        id = data['ET_Id'];
        autoType = data['ET_AutoType'];

        $.post('/ExaminationTask/StopTask', {
                id: id
            }, function(data) {

                var startTask;

                if (1 == data.status) {

                    tr.find('a.stop-task').addClass('hide');


                    // 自动任务切换按钮
                    if(0 != autoType){

                        startTask = tr.find('a.start-task');
                        startTask.text('开启');
                        startTask.removeClass('hide');
                        // 显示常规控制按钮
                        tr.find('a.edit, a.recycle').removeClass('hide');
                    }

                    layer.msg('操作成功', {offset: '100px'});
                } else if (0 == data.status) {

                    alert(data.message);
                }
            }, 'json')
            .error(function() {

                alert('请求返回错误！');
            });
    });

});
