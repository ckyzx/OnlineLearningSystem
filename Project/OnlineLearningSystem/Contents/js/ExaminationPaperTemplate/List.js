$(function() {

    var table, etId, etType;
    var parmas;

    QueryString.Initial();
    etId = QueryString.GetValue('etId');
    etType = QueryString.GetValue('etType');

    params = {
        "processing": true,
        "serverSide": true,
        "ajax": {
            "url": "/ExaminationPaperTemplate/ListDataTablesAjax?etId=" + etId,
            "type": "POST"
        },
        "stateSave": false,
        "lengthChange": false,
        "pageLength": 15,
        "ordering": false
    };

    if (etType == 1) {

        $('.table-sort thead tr').html(
            '<th class="text-c"><input type="checkbox" name="" value="" /></th>' +
            '<th>ID</th>' +
            '<th>名称</th>' +
            '<th>用户</th>' +
            '<th>开始时间</th>' +
            '<th>时长</th>' +
            '<th>添加时间</th>' +
            '<th class="ESPT_PaperTemplateRemark">备注</th>' +
            '<th>成绩</th>' +
            '<th class="text-c">操作</th>');

        params.columns = [{
            "width": "10px",
            "className": "text-c",
            "defaultContent": '<input type="checkbox" value="" name="">'
        }, {
            "width": "30px",
            "name": "ESPT_PaperTemplateId",
            "data": "ESPT_PaperTemplateId"
        }, {
            "name": "ESPT_TaskName",
            "data": "ESPT_TaskName"
        }, {
            "name": "ESPT_UserName",
            "data": "ESPT_UserName"
        }, {
            "name": "ESPT_PaperTemplateStartTime",
            "defaultContent": '<span class="ESPT_PaperTemplateStartTime"></span>'
        }, {
            "className": "nowrap",
            "name": "ESPT_PaperTemplateTimeSpan",
            "defaultContent": '<span class="ESPT_PaperTemplateTimeSpan"></span>'
        }, {
            "name": "ESPT_PaperTemplateAddTime",
            "defaultContent": '<span class="ESPT_PaperTemplateAddTime"></span>'
        }, {
            "width": "40%",
            "name": "ESPT_PaperTemplateRemark",
            "data": 'ESPT_PaperTemplateRemark'
        }, {
            "name": "ESPT_PaperScore",
            "data": "ESPT_PaperScore"
        }, {
            "className": "text-c nowrap",
            "defaultContent": '<a class="btn btn-primary radius size-MINI terminate mr-5 fz-9 hide" href="javascript:void(0);">终止</a>' +
                '<a class="btn btn-primary radius size-MINI paper-grade fz-9 hide" href="javascript:void(0);">评改试卷</a>'
        }];

        params.createdRow = function(row, data, dataIndex) {

            var span, addTime, startTime;
            var paperScore, pageType;

            row = $(row);

            span = row.find('span.ESPT_PaperTemplateAddTime');
            addTime = data['ESPT_PaperTemplateAddTime'];
            addTime = addTime.jsonDateToDate();
            span.text(addTime.format('yyyy-MM-dd hh:mm:ss'));

            // 设置开始时间
            span = row.find('span.ESPT_PaperTemplateStartTime');
            startTime = data['ESPT_PaperTemplateStartTime'];
            startTime = startTime.jsonDateToDate();
            if (startTime.getHours() == 0 && startTime.getMinutes() == 0 && startTime.getSeconds() == 0) {
                span.text(addTime.format('yyyy年MM月dd日 hh时mm分'));
            } else {
                span.text(startTime.format('yyyy年MM月dd日 hh时 mm分'));
            }

            // 设置考试时长
            span = row.find('span.ESPT_PaperTemplateTimeSpan');
            timeSpan = data['ESPT_PaperTemplateTimeSpan'];
            if (0 == timeSpan) {
                span.text('[无限制]');
            } else {
                span.text(timeSpan + '分钟');
            }

            paperScore = data['ESPT_PaperScore'];
            pageType = data['ESPT_PageType']

            status = data['ESPT_Status'];
            ptStatus = data['ESPT_PaperTemplateStatus'];

            // 是否显示“终止”按钮
            if (1 == status && 1 == ptStatus) {
                row.find('a.terminate').removeClass('hide');

            // 是否显示“评改试卷”按钮
            }else if(1 == status && 2 == ptStatus && pageType == 2 && paperScore != '[未参与]' && paperScore != '[未预期]'){
                row.find('a.paper-grade').removeClass('hide');
            }
        };
    } else {

        $('.table-sort thead tr').html(
            '<th class="text-c"><input type="checkbox" name="" value="" /></th>' +
            '<th>ID</th>' +
            '<th>名称</th>' +
            '<th>开始时间</th>' +
            '<th>时长</th>' +
            '<th>添加时间</th>' +
            '<th class="ESPT_PaperTemplateRemark">备注</th>' +
            '<th class="text-c">操作</th>');

        params.columns = [{
            "width": "10px",
            "className": "text-c",
            "defaultContent": '<input type="checkbox" value="" name="">'
        }, {
            "width": "30px",
            "name": "EPT_Id",
            "data": "EPT_Id"
        }, {
            "name": "ET_Name",
            "data": 'ET_Name'
        }, {
            "name": "EPT_StartTime",
            "defaultContent": '<span class="EPT_StartTime"></span>'
        }, {
            "name": "EPT_TimeSpan",
            "defaultContent": '<span class="EPT_TimeSpan"></span>'
        }, {
            "name": "EPT_AddTime",
            "defaultContent": '<span class="EPT_AddTime"></span>'
        }, {
            "width": "40%",
            "name": "EPT_Remark",
            "data": 'EPT_Remark'
        }, {
            "className": "text-c nowrap",
            "defaultContent": '<a class="btn btn-primary radius size-MINI terminate mr-5 fz-9 hide" href="javascript:void(0);">终止</a>' +
                '<a class="btn btn-primary radius size-MINI list-grade mr-5 fz-9 hide" href="javascript:void(0);">试卷</a>'
        }];

        params.createdRow = function(row, data, dataIndex) {

            var span, strDate, date, status, ptStatus;

            row = $(row);

            span = row.find('span.EPT_AddTime');
            addTime = data['EPT_AddTime'];
            addTime = addTime.jsonDateToDate();
            span.text(addTime.format('yyyy-MM-dd hh:mm:ss'));

            // 设置开始时间
            span = row.find('span.EPT_StartTime');
            startTime = data['EPT_StartTime'];
            startTime = startTime.jsonDateToDate();
            if (startTime.getHours() == 0 && startTime.getMinutes() == 0 && startTime.getSeconds() == 0) {
                span.text(addTime.format('yyyy年MM月dd日 hh时mm分'));
            } else {
                span.text(startTime.format('yyyy年MM月dd日 hh时 mm分'));
            }

            // 设置考试时长
            span = row.find('span.EPT_TimeSpan');
            timeSpan = data['EPT_TimeSpan'];
            if (0 == timeSpan) {
                span.text('[无限制]');
            } else {
                span.text(timeSpan + '分钟');
            }

            status = data['EPT_Status'];
            ptStatus = data['EPT_PaperTemplateStatus'];
            switch (status) {
                case 1:

                    if (1 == ptStatus) {
                        row.find('a.terminate').removeClass('hide');
                    } else if (2 == ptStatus) {
                        row.find('a.list-grade').removeClass('hide');
                    }
                    break;
                case 2:
                    break;
                case 3:
                    break;
                default:
                    break;
            }
        };
    }

    table = $('.table-sort').DataTable(params);

    $('.table-sort tbody').on('click', 'a.paper-grade', function() {

        var data, eptId, epId, uId;

        data = table.row($(this).parents('tr')).data();
        eptId = data['ESPT_PaperTemplateId'];
        epId = data['ESPT_PaperId'];
        uId = data['ESPT_UserId'];
        Kyzx.Utility.redirect('试卷', '/ExaminationPaperTemplate/PaperGrade?eptId=' + eptId + '&epId=' + epId + '&uId=' + uId);
    });

    $('.table-sort tbody').on('click', 'a.list-grade', function() {

        var data, id;

        data = table.row($(this).parents('tr')).data();
        id = data['EPT_Id'];

        Kyzx.Utility.redirect('试卷', '/ExaminationPaperTemplate/ListGrade?eptId=' + id);
    });

    $('.table-sort tbody').on('click', 'a.terminate', function() {

        var tr, data, id;

        if (!confirm('确定终止考试吗？')) {
            return;
        }

        tr = $(this).parents('tr');
        data = table.row(tr).data();
        id = data['EPT_Id'];

        $.post('/ExaminationPaperTemplate/Terminate', {
                id: id
            }, function(data) {

                if (1 == data.status) {

                    tr.find('a.terminate').addClass('hide');
                    tr.find('a.list-grade').removeClass('hide');

                    layer.msg('操作成功', { offset: '100px' });
                } else if (0 == data.status) {

                    alert(data.message);
                }
            }, 'json')
            .error(function() {

                alert('请求返回错误！');
            });
    });

    $('#GotoTaskListBtn').on('click', function() {
        location.href = '/ExaminationTask/List';
    });

});
