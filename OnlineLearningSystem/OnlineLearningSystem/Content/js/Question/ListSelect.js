$(function() {

    var valueSelector;

    valueSelector = $('.question-table').attr('value-selector');

    // 取消试题复选时，清除试题数据
    $('.question-table').on('change', ':checkbox', function() {

        var checkbox, id, hidden, questions, checkStatus, checked;

        checkbox = $(this);
        id = checkbox.val();

        hidden = $(valueSelector);
        questions = hidden.val();

        if ('all' == id) {

            checkStatus = GetDataTablesAllCheckStatus('.question-table');

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

        hidden.val(questions);
    });

    initQuestionSelectTable();

});

function initQuestionSelectTable() {

    var table;
    var valueSelector;

    valueSelector = $('.question-table').attr('value-selector');

    table = $('.question-table').DataTable({
        "processing": true,
        "serverSide": true,
        "ajax": {
            "url": "/Question/ListDataTablesAjax",
            "type": "POST"
        },
        "stateSave": false,
        "pageLength": 10,
        "sorting": [
            [1, "asc"]
        ],
        "columnDefs": [{
            "orderable": false,
            "targets": [0, 5, 6]
        }],
        "columns": [{
            "width": "10px",
            "className": "text-c",
            "defaultContent": '<input type="checkbox" />'
        }, {
            "width": "30px",
            "name": "Q_Id",
            "data": "Q_Id"
        }, {
            "name": "Q_Type",
            "data": "Q_Type"
        }, {
            "name": "QC_Name",
            "data": "QC_Name"
        }, {
            "name": "Q_AddTime",
            "defaultContent": '<span class="Q_AddTime"></span>'
        }, {
            "width": "40%",
            "name": "Q_Content",
            "defaultContent": '<span class="Q_Content"></span>'
        }, {
            "width": "50px",
            "name": "Q_DifficultyCoefficient",
            "data": 'Q_DifficultyCoefficient'
        }],
        "createdRow": function(row, data, dataIndex) {

            var checkbox, id;
            var span, strDate, date;
            var content;

            row = $(row);

            checkbox = row.find(':checkbox');
            id = data['Q_Id'];
            checkbox.val(id);

            span = row.find('span.Q_AddTime');
            strDate = data['Q_AddTime'];
            date = strDate.jsonDateToDate(strDate);
            strDate = date.format('yyyy-MM-dd hh:mm:ss');

            span.text(strDate);

            span = row.find('span.Q_Content');
            content = data['Q_Content'];
            content = content.replace(/\\r\\n/g, '<br />');

            span.html(content);

        },
        "footerCallback": function(settings, json) {

            SetDataTablesChecked('.question-table', valueSelector);
        }
    });
}
