$(function () {

    var table;

    table = $('.department-table');

    if(undefined == table.attr('id')){
        table.attr('id', 'DepartmentTable');
    }

    table = table.DataTable({
        "ordering": false,
        "columnDefs": [{
            "orderable": false,
            "targets": [0, 4]
        }],
        "columns": [{
            "width": "10px"
        }, {
            "className": "D_Id",
            "width": "30px"
        }, {
            "className": "nowrap"
        }, {
            "className": "nowrap"
        }, {
            "width": "40%"
        }],
        "drawCallback": function(settings) {

            var api;
            api = this.api();
            Kyzx.List.setId(api, 'D_Id');
        }
    });
});
