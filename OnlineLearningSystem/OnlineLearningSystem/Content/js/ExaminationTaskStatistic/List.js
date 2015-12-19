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
            "name": "ETS_Date",
            "defaultContent": '<span class="ETS_Date"></span>'
        }, {
        	"className": "text-r",
            "name": "ETS_AttendeeNumber",
            "data": 'ETS_AttendeeNumber'
        }, {
        	"className": "text-r",
            "name": "ETS_PaperNumber",
            "data": 'ETS_PaperNumber'
        }, {
        	"className": "text-r",
            "name": "ETS_PassNumber",
            "data": 'ETS_PassNumber'
        }, {
        	"className": "text-r",
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

            span = row.find('span.ETS_Date');
            etsDate = data['ETS_Date'];
            etsDate = etsDate.jsonDateToDate();
            span.text(etsDate.format('yyyy年MM月dd日'));
        }
    });

});