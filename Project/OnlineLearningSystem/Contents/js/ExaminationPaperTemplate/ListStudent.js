$(function() {

    var table, params, etId, type, ptStatus;

    QueryString.Initial();
    etId = QueryString.GetValue('etId');
    type = QueryString.GetValue('type');
    ptStatus = QueryString.GetValue('ptStatus');

    params = {
        "processing": true,
        "serverSide": true,
        "ajax": {
            "url": "/ExaminationPaperTemplate/ListDataTablesAjaxStudent?type=" + type + "&ptStatus=" + ptStatus,
            "type": "POST"
        },
        "stateSave": false,
        "lengthChange": false,
        "pageLength": 15,
        "ordering": false,
        "createdRow": function(row, data, dataIndex) {

            var span, addTime, startTime, status, type, epScore, epStatus;

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

            type = data['ET_Type'];
            status = data['EPT_PaperTemplateStatus'];
            epScore = data['EP_Score'];
            epStatus = data['EP_PaperStatus'];
            switch (status) {
                case 0:
                    break;
                case 1:

                    a = row.find('a.enter-exam');
                    if (1 == type) {
                        a.text('进入练习').attr('title', '进入练习');
                        a.text('查看练习').attr('title', '查看练习');
                    }
                    a.removeClass('hide');

                    if (epScore == '[未参与]' || epStatus == 1) {

                        row.find('a.enter-exam').removeClass('hide');
                        row.find('a.view-exam').addClass('hide');
                    } else {

                        row.find('a.enter-exam').addClass('hide');
                        row.find('a.view-exam').removeClass('hide');
                    }
                    break;
                case 2:

                    a = row.find('a.view-exam');
                    if (1 == type) {
                        a.text('进入练习').attr('title', '进入练习');
                        a.text('查看练习').attr('title', '查看练习');
                    }
                    a.removeClass('hide');

                    if(epScore == '[未参与]'){

                        row.find('a.enter-exam').addClass('hide');
                        row.find('a.view-exam').addClass('hide');
                    }else if (epStatus == 1) {

                        row.find('a.enter-exam').removeClass('hide');
                        row.find('a.view-exam').addClass('hide');
                    }else{

                        row.find('a.enter-exam').addClass('hide');
                        row.find('a.view-exam').removeClass('hide');
                    }
                    break;
                default:
                    break;
            }

        }
    };

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
        "data": "ET_Name"
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
    }];

    if (2 == ptStatus) {

        params.columns.push({
            "className": "text-r",
            "name": "EP_Score",
            "data": 'EP_Score'
        });

        $('.table-sort thead th.EPT_Remark').after('<th class="text-r">成绩</th>');
    }

    params.columns.push({
        "width": "100px",
        "className": "text-c",
        "defaultContent": '<a class="btn btn-primary radius size-MINI enter-exam fz-9 hide" href="javascript:void(0);">进入考试</a>' +
            '<a class="btn btn-primary radius size-MINI view-exam fz-9 hide" href="javascript:void(0);">查看试卷</a>'
    });

    table = $('.table-sort').DataTable(params);

    $('.table-sort tbody').on('click', 'a.enter-exam', function() {

        var data, id;

        data = table.row($(this).parents('tr')).data();
        id = data['EPT_Id'];

        ShowPage('试卷', '/ExaminationPaperTemplate/Paper?id=' + id);
    });

    $('.table-sort tbody').on('click', 'a.view-exam', function() {

        var data, id;

        data = table.row($(this).parents('tr')).data();
        id = data['EPT_Id'];

        ShowPage('试卷', '/ExaminationPaperTemplate/PaperView?id=' + id);
    });

});
