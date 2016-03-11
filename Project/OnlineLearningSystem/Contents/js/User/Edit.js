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

    //[IECompatibility]
    if (brower.ieVersion) {

        dTable.find(':checkbox').each(function() {

            var checkbox;

            checkbox = $(this);
            checkbox.after('<input type="radio" name="department" value="' + checkbox.val() + '" />');

            if(checkbox.get(0).checked){
                checkbox.parent().find(':radio').get(0).checked = true;
            }

            checkbox.remove()
        });
        rTable.find(':checkbox').each(function() {

            var checkbox;

            checkbox = $(this);
            checkbox.after('<input type="radio" name="role" value="' + checkbox.val() + '" />');

            if(checkbox.get(0).checked){
                checkbox.parent().find(':radio').get(0).checked = true;
            }

            checkbox.remove()
        });

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
    } else {

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
    }

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
        }else if(action == '/User/Create' && '**********' == ps){

            psInput.val('');
            $('#U_RePassword').val('');
            e.preventDefault();
        }

    });
});
