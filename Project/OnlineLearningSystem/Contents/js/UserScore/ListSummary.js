﻿$(function() {

    var table, dtParams;
    var getDepartmentId;

    dtParams = {
        "processing": true,
        "serverSide": true,
        "ajax": {
            "url": "/UserScore/ListSummaryDataTablesAjax",
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
            "name": "USS_UserId",
            "data": "USS_UserId"
        }, {
            "name": "USS_UserName",
            "data": "USS_UserName"
        }, {
            "name": "USS_DepartmentName",
            "data": "USS_DepartmentName"
        }, {
            "name": "USS_DutyName",
            "data": "USS_DutyName"
        }, {
            "name": "USS_TotalNumber",
            "data": "USS_TotalNumber",
            "className": "text-r USS_TotalNumber"
        }, {
            "name": "USS_DoneNumber",
            "data": "USS_DoneNumber",
            "className": "text-r USS_DoneNumber"
        }, {
            "name": "USS_UndoNumber",
            "data": "USS_UndoNumber",
            "className": "text-r USS_UndoNumber"
        }, {
            "name": "USS_PassNumber",
            "data": "USS_PassNumber",
            "className": "text-r USS_PassNumber"
        }, {
            "name": "USS_DoneRatio",
            "data": "USS_DoneRatio",
            "className": "text-r USS_DoneRatio"
        }, {
            "name": "USS_PassRatio",
            "data": "USS_PassRatio",
            "className": "text-r USS_PassRatio"
        }, {
            "className": "text-c nowrap",
            "defaultContent": '<a class="btn btn-primary radius size-MINI mr-5 detail fz-9" href="javascript:void(0);">详情</a>'
        }],
        "createdRow": function(row, data, dataIndex) {

            row = $(row);

            row.find('.USS_TotalNumber, .USS_DoneNumber, .USS_UndoNumber, .USS_PassNumber').each(function() {

                var td;

                td = $(this);
                td.html('<span class="bold">' + td.text() + '</span> <span class="fz-9">次</span>');
            });

            row.find('.USS_PassRatio, .USS_DoneRatio').each(function() {

                var td;

                td = $(this);
                td.html('<span class="bold">' + td.text() + '</span> <span class="fz-9">%</span>');
            });
        },
        'rowCallback': function(row, data, index) {

        },
        'initComplete': function(settings, json) {

        }
    };

    table = $('.table-sort').DataTable(dtParams);

    $('.table-sort tbody').on('click', 'a.detail', function() {

        var data, id;

        data = table.row($(this).parents('tr')).data();
        id = data['USS_UserId'];

        Kyzx.Utility.redirect('成绩详情', '/UserScore/ListDetail?uId=' + id);
    });

    getDepartmentId = function(){

        var dId;

        dId = $('#Department').val();
        dId = dId == '' ? 0 : dId;

        return dId;
    };

    $('#SearchBtn').click(function() {

        table.ajax.url('/UserScore/ListSummaryDataTablesAjax?dId=' + getDepartmentId()).load();
    });

    $('#ExportBtn').click(function() {

        $('#SearchBtn').click();

        layer.confirm('是否导出成绩报表？', {
            title: '',
            btn: ['是', '否']
        }, function() {

            location.href = '/UserScore/SummaryExportToExcel?dId=' + getDepartmentId();
            layer.closeAll();
        }, function() {

        })
    });

    /*$(window).resize(function() {

        table.destroy();
        dtParams.ajax.url = '/UserScore/ListSummaryDataTablesAjax?dId=' + getDepartmentId();
        table = $('.table-sort').DataTable(dtParams);
    });*/

});
