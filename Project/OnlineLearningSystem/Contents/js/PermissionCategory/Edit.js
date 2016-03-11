$(function() {

    // 给 DataTables 的数据设置复选状态
    var table, dtData, inputPermissions, aps, anCells, controllerName, actionName;

    table = $('.table-sort');
    dtData = table.DataTable.settings[0].aoData;

    // 初始化已选项目
    permissions = $('#PC_Permissions').val();
    aps = $.parseJSON(permissions);

    for (var i = 0; i < dtData.length; i++) {

        cells = dtData[i].anCells;
        controllerName = $(cells[1]).text().trim();
        actionName = $(cells[2]).text().trim();

        for (var i1 = 0; i1 < aps.length; i1++) {

            ap = aps[i1];
            if (controllerName == ap.ControllerName && actionName == ap.ActionName) {

                $(cells[0]).find(':checkbox').get(0).checked = true;
            }
        }
    }

    Kyzx.List.renderSelectCount(table.parent(), aps.length);

    // 初始化选择事件
    table
        .on('click', ':checkbox', function() {
            Kyzx.List.checkboxMutipleClickEvent(this);
        })
        .on('change', ':checkbox', function() {

            var dtData, actionPermissions;

            Kyzx.List.checkboxMutipleChangeEvent(this);

            dtData = table.DataTable.settings[0].aoData;

            actionPermissions = [];

            for (var i = 0; i < dtData.length; i++) {

                cells = dtData[i].anCells;
                if ($(cells[0]).find(':checkbox').get(0).checked) {

                    actionPermissions.push({
                        'ControllerName': $(cells[1]).text().trim(),
                        'ActionName': $(cells[2]).text().trim(),
                        'Description': $(cells[3]).text().trim()
                    });
                }
            }

            $('#PC_Permissions').val(JSON.stringify(actionPermissions));

            Kyzx.List.renderSelectCount(table.parent(), actionPermissions.length);
        });
});
