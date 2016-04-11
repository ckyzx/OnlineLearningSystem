$(function() {

    var table, etId;

    QueryString.Initial();
    etId = QueryString.GetValue('etId');

    table = $('.table-sort').DataTable({
        "processing": true,
        "serverSide": true,
        "ajax": {
            "url": "/ExaminationPaperTemplate/ListDataTablesAjax?etId=" + etId,
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
            "defaultContent": 
                '<a class="btn btn-primary radius size-MINI terminate mr-5 fz-9 hide" href="javascript:void(0);">终止</a>' +
                '<a class="btn btn-primary radius size-MINI list-grade mr-5 fz-9 hide" href="javascript:void(0);">试卷</a>' +
                '<!--a class="recycle mr-5 fz-18 hide" href="javascript:void(0);" title="回收"><i class="Hui-iconfont">&#xe631;</i></a>' +
                '<a class="resume mr-5 fz-18 hide" href="javascript:void(0);" title="恢复"><i class="Hui-iconfont">&#xe615;</i></a>' +
                '<a class="edit mr-5 fz-18 hide" href="javascript:void(0);" title="编辑"><i class="Hui-iconfont">&#xe60c;</i></a>' +
                '<a class="delete mr-5 fz-18 hide" href="javascript:void(0);" title="删除"><i class="Hui-iconfont">&#xe6e2;</i></a-->'
        }],
        "createdRow": function(row, data, dataIndex) {

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

                    /*row.find('a.recycle').removeClass('hide');
                    row.find('a.edit').removeClass('hide');*/

                    if(1 == ptStatus){
                        row.find('a.terminate').removeClass('hide');
                    }else {
                        row.find('a.list-grade').removeClass('hide');
                    }
                    break;
                case 2:
                    /*row.find('a.resume').removeClass('hide');
                    row.find('a.delete').removeClass('hide');*/
                    break;
                case 3:
                    break;
                default:
                    break;
            }
        }
    });

    $('.table-sort tbody').on('click', 'a.list-grade', function() {

        var data, id;

        data = table.row($(this).parents('tr')).data();
        id = data['EPT_Id'];

        Kyzx.Utility.redirect('试卷', '/ExaminationPaperTemplate/ListGrade?eptId=' + id);
    });

    $('.table-sort tbody').on('click', 'a.terminate', function() {

        var tr, data, id;

        if(!confirm('确定终止考试吗？')){
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

                    layer.msg('操作成功', {offset: '100px'});
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
