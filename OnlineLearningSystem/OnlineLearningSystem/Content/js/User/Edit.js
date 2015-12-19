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

    clickEvent = function(elem) {

        var checkbox;

        checkbox = $(elem);
        checkbox.parentsUntil('div').last().find(':checkbox').removeAttr('checked');
        checkbox.attr('data-checked', 1).blur().focus();
    };
    changeEvent = function(elem) {

        var checkbox;

        checkbox = $(elem);
        if (1 == checkbox.attr('data-checked')) {

            checkbox.removeAttr('data-checked');
            checkbox.get(0).checked = true;
        }
    };

    dTable
        .on('click', ':checkbox', function() {
            clickEvent(this);
        })
        .on('change', ':checkbox', function() {
            changeEvent(this);
        });
    rTable
        .on('click', ':checkbox', function() {
            clickEvent(this);
        })
        .on('change', ':checkbox', function() {
            changeEvent(this);
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
