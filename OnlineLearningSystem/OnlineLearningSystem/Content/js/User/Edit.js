$(function() {

    SetDataTablesChecked('.department-table', '#U_Departments');
    SetDataTablesChecked('.role-table', '#U_Roles');

    $('form').submit(function(e) {

        var psInput;
        var ps;

        if(!confirm('确定提交吗？')){
            
            e.preventDefault();
            return;
        }

        GetDataTablesChecked('.department-table', '#U_Departments');
        GetDataTablesChecked('.role-table', '#U_Roles');

        psInput = $('#U_Password');
        ps = psInput.val();

        if ('' == ps) {

            ps = '**********';
            psInput.val(ps);
            $('#U_RePassword').val(ps);
        }
    });
});
