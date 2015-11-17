$(function () {

    var table;

    table = $('.role-table').DataTable({
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
