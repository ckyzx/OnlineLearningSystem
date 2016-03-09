$(function() {

    var dRoleSel;

    dRoleSel = '#D_Roles';

    Kyzx.List.setChecked('.role-table', dRoleSel);

    // 限制复选框只能单选
    var rTable;
    var clickEvent, changeEvent;

    rTable = $('.role-table');

    rTable.find(':checkbox[value=""]').attr('disabled', 'disabled');

    //[IECompatibility]
    if (brower.ieVersion) {

        rTable.find(':checkbox').each(function() {

            var checkbox;

            checkbox = $(this);
            checkbox.after('<input type="radio" name="role" value="' + checkbox.val() + '" />');

            if (checkbox.get(0).checked) {
                checkbox.parent().find(':radio').get(0).checked = true;
            }

            checkbox.remove()
        });

        rTable.on('change', ':radio', function() {

            Kyzx.List.getChecked('.role-table', dRoleSel);

            roles = $(dRoleSel).val();
            Kyzx.List.renderSelectCount(rTable.parent(), JSON.parse(roles).length);
        });
    } else {

        rTable
            .on('click', ':checkbox', function() {
                Kyzx.List.checkboxClickEvent(this);
            })
            .on('change', ':checkbox', function() {

                var roles;

                Kyzx.List.checkboxChangeEvent(this);
                Kyzx.List.getChecked('.role-table', dRoleSel);

                roles = $(dRoleSel).val();
                Kyzx.List.renderSelectCount(rTable.parent(), JSON.parse(roles).length);
            });
    }
    /*----------------------------------------------------------------------*/

    $('form').submit(function(e) {

        if (!confirm('确定提交吗？')) {

            e.preventDefault();
            ifSubmit = false;
        } else {
            ifSubmit = true;
        }
    });
});
