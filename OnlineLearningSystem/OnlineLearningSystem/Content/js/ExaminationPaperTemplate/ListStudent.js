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
            "targets": [0, 2, 3, 4, 5, 6]
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
            "defaultContent": '<span class="EPT_TimeSpan"></span>'
        }, {
            "name": "EPT_AddTime",
            "defaultContent": '<span class="EPT_AddTime"></span>'
        }, {
            "width": "40%",
            "name": "EPT_Remark",
            "data": 'EPT_Remark'
        }, {
            "width": "100px",
            "className": "text-c",
            "defaultContent": '<a style="display:none;text-decoration: none;" class="btn btn-primary radius size-MINI enter-exam fz-10" href="javascript:;" title="进入考试">进入考试</a>'
        }],
        "createdRow": function(row, data, dataIndex) {

            var span, addTime, startTime, status, type;

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

            /*status = data['EPT_Status'];
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
            }*/

            type = data['ET_Type'];
            status = data['EPT_PaperTemplateStatus'];
            switch (status) {
                case 0:
                    break;
                case 1:

                    a = row.find('a.enter-exam');
                    if(1 == type){
                        a.text('进入练习').attr('title', '进入练习');
                    }
                    a.show();
                    break;
                case 2:
                default:
                    break;
            }
        }
    });

    /*$('.table-sort tbody').on('click', 'a.edit', function() {

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
    });*/

    $('.table-sort tbody').on('click', 'a.enter-exam', function() {

        var data, id;

        data = table.row($(this).parents('tr')).data();
        id = data['EPT_Id'];

        ShowPage('试卷', '/ExaminationPaperTemplate/Paper?id=' + id);
    });

});