$(function() {

    SetDataTablesChecked('.role-table', '#D_Roles');

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
            Kyzx.List.checkboxChangeEvent(this);
        });
	/*----------------------------------------------------------------------*/

    $('form').submit(function(e) {

        if(!confirm('确定提交吗？')){
            
            e.preventDefault();
            return;
        }

        GetDataTablesChecked('.role-table', '#D_Roles');
    });
});
