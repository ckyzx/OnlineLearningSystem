$(function() {

    var dTableSel, rTableSel;

    dTableSel = '.department-table';
    rTableSel = '.role-table';

    Kyzx.List.setChecked(dTableSel, '#U_Departments');
    Kyzx.List.setChecked(rTableSel, '#U_Roles');

    // 限制复选框只能单选
    var dTable, rTable;
    var clickEvent, changeEvent;

    dTable = $(dTableSel);
    rTable = $(rTableSel);

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

        Kyzx.List.getChecked(dTableSel, '#U_Departments');
        Kyzx.List.getChecked(rTableSel, '#U_Roles');

        psInput = $('#U_Password');
        ps = psInput.val();

        if ('' == ps) {

            ps = '**********';
            psInput.val(ps);
            $('#U_RePassword').val(ps);
        }
    });
});
