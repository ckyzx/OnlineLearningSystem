$(function() {

    var table;
    var eptId;

    QueryString.Initial();
    eptId = QueryString.GetValue('eptId');

    table = $('.table-sort').DataTable({
        "processing": true,
        "serverSide": true,
        "ajax": {
            "url": "/ExaminationTaskStatistic/ListUserDataTablesAjax",
            "type": "POST",
            "data": {
                eptId: eptId
            }
        },
        "stateSave": false,
        "lengthChange": false,
        "pageLength": 12,
        "ordering": false,
        "columns": [{
            "width": "10px",
            "className": "text-c",
            "defaultContent": '<input type="checkbox" value="" name="">'
        }, {
            "name": "ETUS_DepartmentName",
            "data": 'ETUS_DepartmentName'
        }, {
            "name": "ETUS_UserName",
            "data": 'ETUS_UserName'
        }, {
            "name": "ETUS_DutyName",
            "data": 'ETUS_DutyName'
        }, {
            "width": "50px",
            "className": "text-r",
            "name": "ETUS_Score",
            "defaultContent": '<span class="ETUS_Score"></span>'
        }, {
            "width": "50px",
            "className": "text-c",
            "defaultContent": '<span class="ETUS_State"></span>'
        }],
        "createdRow": function(row, data, dataIndex) {

            var span;
            var etusDate, etusTaskStatisticType, etusScore, etusState;

            row = $(row);

            // 呈现成绩
            span = row.find('span.ETUS_Score');
            etusTaskStatisticType = data['ETUS_TaskStatisticType'];
            etusScore = data['ETUS_Score'];
            if(-1 != etusScore){

                if(1 == etusTaskStatisticType){
                    span.html('<span class="bold">' + etusScore + '</span> 分');
                }else if(2 == etusTaskStatisticType){
                    span.html('<span class="bold">' + etusScore + '</span> %');
                }
            }

            // 呈现状态
            span = row.find('span.ETUS_State');
            etusState = data['ETUS_State'];
            switch (etusState) {
                case 1:
                    span.text('未考试');
                    break;
                case 2:
                    span.text('合格');
                    break;
                case 3:
                    span.text('未合格');
                    break;
                case 4:
                    span.text('未打分');
                    break;
                default:
                    span.text('[未设置]');
                    break;
            }
        }
    });

});
