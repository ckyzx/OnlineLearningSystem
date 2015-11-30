$(function() {

    var table;

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
            "targets": [0, 1, 2, 3, 4, 5, 6]
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
            date = strDate.jsonDateToDate();
            strDate = date.format('yyyy-MM-dd hh:mm:ss');

            span.text(strDate);

            span = row.find('span.Q_Content');
            content = data['Q_Content'];
            content = content.replace(/\\r\\n/g, '<br />');

            span.html(content);
        }
    });

});