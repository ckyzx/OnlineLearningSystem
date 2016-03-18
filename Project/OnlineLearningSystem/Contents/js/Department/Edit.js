$(function() {

    var dRoleSel;

    dRoleSel = '#D_Roles';

    Kyzx.List.setChecked('.role-table', dRoleSel);

    // 限制复选框只能单选
    var rTable;
    var clickEvent, changeEvent;

    rTable = $('.role-table');

    rTable.find(':radio[value=""]').attr('disabled', 'disabled');

    rTable.on('change', ':radio', function() {

        Kyzx.List.getChecked('.role-table', dRoleSel);

        roles = $(dRoleSel).val();
        Kyzx.List.renderSelectCount(rTable.parent(), JSON.parse(roles).length);
    });
});
