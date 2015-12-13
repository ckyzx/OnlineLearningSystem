$(function() {

    'use strict';

    var tableSelector, valueSelector;

    tableSelector = '.question-table';
    valueSelector = $(tableSelector).attr('value-selector');

    // 取消试题复选时，清除试题数据
    $('.question-table').on('change', ':checkbox', function() {

        var checkbox, id, hidden, questions, checkStatus, checked;
        var countSpan;

        checkbox = $(this);
        id = checkbox.val();

        hidden = $(valueSelector);
        questions = hidden.val();

        if ('all' == id) {

            checkStatus = GetDataTablesAllCheckStatus1(tableSelector, $(':checkbox[value=all]').get(0).checked);

            // 去除复选项
            for (var i = 0; i < checkStatus[1].length; i++) {

                questions =
                    questions
                    .replace('"' + checkStatus[1][i] + '"', '')
                    .replace('[,', '[')
                    .replace(',]', ']')
                    .replace(',,', ',');
            }

            // 添加复选项
            checked = [];
            for (var i = 0; i < checkStatus[0].length; i++) {

                if (questions.indexOf('"' + checkStatus[0][i] + '"') == -1) {

                    checked.push(checkStatus[0][i]);
                }
            }
            questions = $.parseJSON(questions);
            questions = questions.concat(checked);
            questions = JSON.stringify(questions);
        } else if (checkbox.get(0).checked && questions.indexOf('"' + id + '"') == -1) {

            questions = $.parseJSON(questions);
            questions.push(id);
            questions = JSON.stringify(questions);
        } else if (!checkbox.get(0).checked) {

            questions =
                questions
                .replace('"' + id + '"', '')
                .replace('[,', '[')
                .replace(',]', ']')
                .replace(',,', ',');
        }

        // 显示已选数据数量
        $('.select-data-item').remove();
        countSpan = $('<div class="select-data-item mb-10">已选 <span class="select-data-count">' + JSON.parse(questions).length + '</span> 条</div>');
        countSpan.prependTo($(tableSelector).parent());

        hidden.val(questions);
    });

    initQuestionSelectTable();

});

function initQuestionSelectTable() {

    'use strict';

    var jqTable, table;
    var valueSelector;

    jqTable = $('.question-table');
    valueSelector = jqTable.attr('value-selector');

    table = jqTable.DataTable({
        "processing": true,
        "serverSide": true,
        "ajax": {
            "url": "/Question/ListDataTablesAjax",
            "type": "POST"
        },
        "stateSave": false,
        "pageLength": 10,
        "ordering": false,
        "columns": [{
            "width": "10px",
            "className": "text-c",
            "defaultContent": '<input type="checkbox" />'
        }, {
            "width": "30px",
            "name": "Q_Id",
            "data": "Q_Id"
        }, {
            "width": "100px",
            "name": "Q_Type",
            "defaultContent": '<span class="Q_Type"></span>'
        }, {
            "width": "150px",
            "name": "QC_Name",
            "className": "QC_Name",
            "defaultContent": '<span class="QC_Name"></span>'
        }, {
            "name": "Q_Content",
            "className": "Q_Content",
            "defaultContent": '<span class="Q_Content"></span>'
        }, {
            "width": "50px",
            "name": "Q_DifficultyCoefficient",
            "data": 'Q_DifficultyCoefficient'
        }, {
            "width": "30px",
            "className": "text-r",
            "name": "Q_Score",
            "data": "Q_Score"
        }],
        "createdRow": function(row, data, dataIndex) {

            var checkbox, id;
            var span, th;
            var qType, qcName, qContent;

            row = $(row);

            checkbox = row.find(':checkbox');
            id = data['Q_Id'];
            checkbox.val(id);

            th = jqTable.find('th.Q_Type');
            span = row.find('span.Q_Type');
            qType = data['Q_Type'];
            span.addClass('ellipsis').width(th.width()).text(qType);

            th = jqTable.find('th.QC_Name');
            span = row.find('span.QC_Name');
            qcName = data['QC_Name'];
            span.addClass('ellipsis').width(th.width()).text(qcName);

            th = jqTable.find('th.Q_Content');
            span = row.find('span.Q_Content');
            qContent = data['Q_Content'];
            qContent = qContent.replace(/^(\\r\\n)+/g, '').replace(/(\\r\\n)+$/g, '').replace(/\\r\\n/g, '[换行]').replace(/\s+/g,'');
            span.addClass('ellipsis').width(th.width()).html(qContent).attr('title', qContent);
        },
        /*"footerCallback": function(settings, json) {

            SetDataTablesChecked('.question-table', valueSelector);
        },*/
        'initComplete': function(settings, json) {

            SetDataTablesChecked('.question-table', valueSelector);
        }
    });
}
