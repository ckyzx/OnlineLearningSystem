$(function() {

    SetDataTablesChecked('.role-table', '#D_Roles');

    $('form').submit(function() {

        GetDataTablesChecked('.role-table', '#D_Roles');
    });
});
