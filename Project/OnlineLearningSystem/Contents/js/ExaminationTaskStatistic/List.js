$(function() {

    var dtParams, table;
    var getRequestString;

    dtParams = {
        "processing": true,
        "serverSide": true,
        "ajax": {
            "url": "/ExaminationTaskStatistic/ListDataTablesAjax",
            "type": "POST"
        },
        "stateSave": false,
        "lengthChange": false,
        "pageLength": 15,
        "ordering": false,
        "searching": false,
        "columns": [{
            "width": "10px",
            "className": "text-c",
            "defaultContent": '<input type="checkbox" value="" name="">'
        }, {
            "width": "30px",
            "name": "ETS_PaperTemplateId",
            "data": "ETS_PaperTemplateId"
        }, {
            "name": "ETS_TaskName",
            "data": "ETS_TaskName"
        }, {
            "name": "ETS_PaperTemplateDate",
            "defaultContent": '<span class="ETS_PaperTemplateDate"></span>'
        }, {
            "className": "text-r ETS_AttendeeNumber",
            "name": "ETS_AttendeeNumber",
            "data": 'ETS_AttendeeNumber'
        }, {
            "className": "text-r ETS_PaperNumber",
            "name": "ETS_PaperNumber",
            "data": 'ETS_PaperNumber'
        }, {
            "className": "text-r ETS_PassNumber",
            "name": "ETS_PassNumber",
            "data": 'ETS_PassNumber'
        }, {
            "className": "text-r ETS_FlunkNumber",
            "name": "ETS_FlunkNumber",
            "data": 'ETS_FlunkNumber'
        }, {
            "className": "text-c nowrap",
            "defaultContent": '<a class="btn btn-primary radius size-MINI mr-5 user-statistic fz-9" href="javascript:void(0);">详情</a>'
        }],
        "createdRow": function(row, data, dataIndex) {

            var span;
            var etsDate;

            row = $(row);

            span = row.find('span.ETS_PaperTemplateDate');
            etsDate = data['ETS_PaperTemplateDate'];
            etsDate = etsDate.jsonDateToDate();
            span.text(etsDate.format('yyyy年MM月dd日'));

            row.find('.ETS_AttendeeNumber, .ETS_PaperNumber, .ETS_PassNumber, .ETS_FlunkNumber').each(function() {

                var td;

                td = $(this);
                td.html('<span class="bold">' + td.text() + '</span> <span class="fz-9">人</span>');
            });
        },
        'initComplete': function(settings, json) {

        }
    };
    table = $('.table-sort').DataTable(dtParams);

    $('.table-sort tbody').on('click', 'a.user-statistic', function() {

        var data, id;

        data = table.row($(this).parents('tr')).data();
        id = data['ETS_PaperTemplateId'];

        ShowPageWithSize('统计详情', '/ExaminationTaskStatistic/ListUser?eptId=' + id, 800, 600);
    });

    getRequestString = function() {

        var taskName, beginTime, endTime;
        var requestString;

        taskName = $('#TaskName').val();
        beginTime = $('#BeginTime').val();
        endTime = $('#EndTime').val();

        if(taskName == '' && beginTime == '' && endTime == ''){

            layer.confirm('请输入搜索条件。', {
                    title: '',
                    btn: ['确定']
                },
                function() {
                    layer.closeAll();
                });

            return '';
        }

        if ((beginTime == '' && endTime != '') || (beginTime != '' && endTime == '')) {

            layer.confirm('请同时选择“开始时间”与“结束时间”。', {
                    title: '',
                    btn: ['确定']
                },
                function() {
                    layer.closeAll();
                });

            return '';
        }

        requestString = '';

        if (taskName != '')
            requestString += '&taskName=' + taskName;

        if (beginTime != '')
            requestString += '&beginTime=' + beginTime;

        if (endTime != '')
            requestString += '&endTime=' + endTime;

        return requestString == '' ? '' : '?' + requestString;
    }

    $('#SearchBtn').click(function() {

        var requestString;

        requestString = getRequestString();
        if (requestString == '') {
            return;
        } else {
            table.ajax.url('/ExaminationTaskStatistic/ListDataTablesAjax' + requestString).load();
        }
    });

    $('#ExportBtn').click(function() {

        $('#SearchBtn').click();

        layer.confirm('是否导出统计报表？', {
            title: '',
            btn: ['是', '否']
        }, function() {
            location.href = '/ExaminationTaskStatistic/TaskExportToExcel' + getRequestString();
            layer.closeAll();
        }, function() {

        })
    });

    /*$(window).resize(function() {

        table.destroy();
        table = $('.table-sort').DataTable(dtParams);
    });
*/
});
