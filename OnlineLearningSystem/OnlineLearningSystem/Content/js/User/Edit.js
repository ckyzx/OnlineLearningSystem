$(function() {

    SetDataTablesChecked('.department-table', '#U_Departments');
    SetDataTablesChecked('.role-table', '#U_Roles');

    $('form').submit(function() {
        GetDataTablesChecked('.department-table', '#U_Departments');
        GetDataTablesChecked('.role-table', '#U_Roles');
    });
});
