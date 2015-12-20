$(function () {

    var table;

    table = $('.table-sort').DataTable({
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
        "columns": [{
            "width": "10px",
            "className": "text-c",
            "defaultContent": '<input type="checkbox" value="" name="">'
        }, {
            "width": "30px",
            "name": "ETS_TaskId",
            "data": "ETS_TaskId"
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
            "width": "50px",
            "className": "text-c nowrap",
            "defaultContent": '<a class="btn btn-primary radius size-MINI mr-5 user-statistic fz-9" href="javascript:;">详情</a>'
        }],
        "createdRow": function(row, data, dataIndex) {

        	var span;
        	var etsDate;

            row = $(row);

            span = row.find('span.ETS_PaperTemplateDate');
            etsDate = data['ETS_PaperTemplateDate'];
            etsDate = etsDate.jsonDateToDate();
            span.text(etsDate.format('yyyy年MM月dd日'));
        },
        'initComplete': function(settings, json) {

            $('tbody').find('.ETS_AttendeeNumber, .ETS_PaperNumber, .ETS_PassNumber, .ETS_FlunkNumber').each(function(){

                var td;

                td = $(this);
                td.html('<span class="bold">' + td.text() + '</span> <span class="fz-9">人</span>');
            });
        }
    });

    $('.table-sort tbody').on('click', 'a.user-statistic', function() {

        var data, id;

        data = table.row($(this).parents('tr')).data();
        id = data['ETS_PaperTemplateId'];

        ShowPageWithSize('统计详情', '/ExaminationTaskStatistic/ListUser?eptId=' + id, 800, 600);
    });

});