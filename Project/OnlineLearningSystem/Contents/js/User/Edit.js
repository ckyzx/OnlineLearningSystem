$(function() {

    var dTableSel, rTableSel, uDepartmentsSel, uRolesSel;

    dTableSel = '.department-table';
    rTableSel = '.role-table';

    uDepartmentsSel = '#U_Departments';
    uRolesSel = '#U_Roles';

    Kyzx.List.setChecked(dTableSel, uDepartmentsSel);
    Kyzx.List.setChecked(rTableSel, uRolesSel);

    // 限制复选框只能单选
    var dTable, rTable;
    var clickEvent, changeEvent;

    dTable = $(dTableSel);
    rTable = $(rTableSel);

    dTable.find(':radio[value=""]').attr('disabled', 'disabled');
    rTable.find(':radio[value=""]').attr('disabled', 'disabled');

    dTable.on('change', ':radio', function() {

        Kyzx.List.getChecked(dTableSel, uDepartmentsSel);

        deps = $(uDepartmentsSel).val();
        Kyzx.List.renderSelectCount(dTable.parent(), JSON.parse(deps).length);
    });

    rTable.on('change', ':radio', function() {

        Kyzx.List.getChecked(rTableSel, uRolesSel);

        roles = $(uRolesSel).val();
        Kyzx.List.renderSelectCount(rTable.parent(), JSON.parse(roles).length);
    });

    $('form').submit(function(e) {

        var form, psInput;
        var ps, action;

        if (!confirm('确定提交吗？')) {

            e.preventDefault();
            return;
        }

        form = $(this);
        action = form.attr('action');
        psInput = $('#U_Password');
        ps = psInput.val();

        if (action == '/User/Edit' && '' == ps) {

            ps = '**********';
            psInput.val(ps);
            $('#U_RePassword').val(ps);
        } else if (action == '/User/Create' && '**********' == ps) {

            psInput.val('');
            $('#U_RePassword').val('');
            e.preventDefault();
        }

    });
});
