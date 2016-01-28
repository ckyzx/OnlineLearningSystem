$(function() {

    var dRoleSel;

    dRoleSel = '#D_Roles';

    Kyzx.List.setChecked('.role-table', dRoleSel);

    // 限制复选框只能单选
    var rTable;
    var clickEvent, changeEvent;

    rTable = $('.role-table');

    rTable.find(':checkbox[value=""]').attr('disabled', 'disabled');

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
	/*----------------------------------------------------------------------*/

    $('form').submit(function(e) {

        if(!confirm('确定提交吗？')){
            
            e.preventDefault();
            return;
        }
    });
});
