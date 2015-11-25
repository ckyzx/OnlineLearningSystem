$(function() {

    SetDataTablesChecked('.role-table', '#D_Roles');

    $('form').submit(function(e) {

        if(!confirm('确定提交吗？')){
            
            e.preventDefault();
            return;
        }

        GetDataTablesChecked('.role-table', '#D_Roles');
    });
});
