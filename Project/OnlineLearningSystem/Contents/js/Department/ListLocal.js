$(function () {

    var table;

    table = $('.department-table');

    if(undefined == table.attr('id')){
        table.attr('id', 'DepartmentTable');
    }

    table = table.DataTable({
        "sorting": [
            [1, "asc"]
        ],
        "columnDefs": [{
            "orderable": false,
            "targets": [0, 4]
        }],
        "columns": [{
            "width": "10px"
        }, {
            "width": "30px"
        }, null, null, {
            "width": "40%"
        }]
    });
});
