$(function () {

    var table, dtParams;
    var request, uId;

    request = Request.init();
    uId = request.getValue('uId', 0);

    dtParams = {
        "processing": true,
        "serverSide": true,
        "ajax": {
            "url": "/UserScore/ListDetailDataTablesAjax?uId=" + uId,
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
            "name": "USD_PaperTemplateId",
            "data": "USD_PaperTemplateId"
        }, {
            "name": "USD_TaskName",
            "data": "USD_TaskName"
        }, {
            "name": "USD_TaskStatisticType",
            "defaultContent": '<span class="USD_TaskStatisticType"></span>'
        }, {
            "name": "USD_StartTime",
            "defaultContent": '<span class="USD_StartTime"></span>'
        }, {
            "name": "USD_Score",
            "defaultContent": '<span class="USD_Score"></span>'
        }, {
            "name": "USD_State",
            "defaultContent": '<span class="USD_State"></span>'
        }],
        "createdRow": function(row, data, dataIndex) {

            var span;
            var startDate, statisticType, score, state;

            row = $(row);

            span = row.find('span.USD_StartTime');
            startDate = data['USD_StartTime'];
            startDate = startDate.jsonDateToDate();
            span.text(startDate.format('yyyy年MM月dd日 hh时mm分'));

            span = row.find('span.USD_TaskStatisticType');
            statisticType = data['USD_TaskStatisticType'];
            span.text(StatisticType[statisticType]);

            span = row.find('span.USD_State');
            state = data['USD_State'];
            span.text(UserScoreState[state]);

            span = row.find('span.USD_Score');
            score = data['USD_Score'];
            if(score == -1){
                score = '...'
            }else if(statisticType == 1){
                score = '<span class="bold">' + score + '</span> <span class="fz-9">分</span>';
            }else if(statisticType == 2){
                score = '<span class="bold">' + score + '</span> <span class="fz-9">%</span>';
            }else{
                score = '...';
            }
            span.html(score);
        },
        'rowCallback':function(row, data, index){

        },
        'initComplete': function(settings, json) {

        }
    };

    table = $('.table-sort').DataTable(dtParams);

    $('#ExportBtn').click(function(){

        location.href = '/UserScore/DetailExportToExcel?uId=' + uId;
    });

    $(window).resize(function() {

        table.destroy();
        table = $('.table-sort').DataTable(dtParams);
    });

});