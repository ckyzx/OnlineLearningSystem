$(function() {

    var table;

    table = $('.table-sort').DataTable({
        "sorting": [
            [1, "asc"]
        ],
        "columnDefs": [{
            "orderable": false,
            "targets": [0]
        }]
    });
});
