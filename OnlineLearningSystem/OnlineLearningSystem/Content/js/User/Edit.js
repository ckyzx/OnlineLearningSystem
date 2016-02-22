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

    dTable.find(':checkbox[value=""]').attr('disabled', 'disabled');
    rTable.find(':checkbox[value=""]').attr('disabled', 'disabled');

    dTable
        .on('click', ':checkbox', function() {
            Kyzx.List.checkboxClickEvent(this);
        })
        .on('change', ':checkbox', function() {

            var deps;

            Kyzx.List.checkboxChangeEvent(this);
            Kyzx.List.getChecked(dTableSel, uDepartmentsSel);

            deps = $(uDepartmentsSel).val();
            Kyzx.List.renderSelectCount(dTable.parent(), JSON.parse(deps).length);
        });
    rTable
        .on('click', ':checkbox', function() {
            Kyzx.List.checkboxClickEvent(this);
        })
        .on('change', ':checkbox', function() {

            var roles;

            Kyzx.List.checkboxChangeEvent(this);
            Kyzx.List.getChecked(rTableSel, uRolesSel);

            roles = $(uRolesSel).val();
            Kyzx.List.renderSelectCount(rTable.parent(), JSON.parse(roles).length);
        });

    $('form').submit(function(e) {

        var psInput;
        var ps;

        if (!confirm('确定提交吗？')) {

            e.preventDefault();
            ifSubmit = false;
            return;
        }


        psInput = $('#U_Password');
        ps = psInput.val();

        if ('' == ps) {

            ps = '**********';
            psInput.val(ps);
            $('#U_RePassword').val(ps);
        }

        ifSubmit = true;
    });
});
