$(function() {

    SetDataTablesChecked('.department-table', '#U_Departments');
    SetDataTablesChecked('.role-table', '#U_Roles');

    // 限制复选框只能单选
    var dTable, rTable;
    var clickEvent, changeEvent;

    dTable = $('.department-table');
    rTable = $('.role-table');

    dTable.find(':checkbox[value=""]').attr('disabled', 'disabled');
    rTable.find(':checkbox[value=""]').attr('disabled', 'disabled');

    dTable
        .on('click', ':checkbox', function() {
            Kyzx.List.checkboxClickEvent(this);
        })
        .on('change', ':checkbox', function() {
            Kyzx.List.checkboxChangeEvent(this);
        });
    rTable
        .on('click', ':checkbox', function() {
            Kyzx.List.checkboxClickEvent(this);
        })
        .on('change', ':checkbox', function() {
            Kyzx.List.checkboxChangeEvent(this);
        });

    $('form').submit(function(e) {

        var psInput;
        var ps;

        if (!confirm('确定提交吗？')) {

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
