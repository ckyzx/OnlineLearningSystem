$(function () {

    var table;

    table = $('.role-table');

    if(undefined == table.attr('id')){
        table.attr('id', 'RoleTable');
    }

    table = table.DataTable({
        "ordering": false,
        "columns": [{
            "width": "10px"
        }, {
            "width": "30px"
        }, null, null, {
            "width": "40%"
        }]
    });
});
