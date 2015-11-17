// 给 DataTables 的数据设置复选状态
function SetDataTablesChecked(tableSelector, valueSelector) {

    var table, tableId, settings, dtData, ms, anCells, checkbox, id;

    table = $(tableSelector);
    tableId = table.attr('id');
    settings = table.DataTable.settings;

    for (var i = 0; i < settings.length; i++) {

        if (settings[i].sTableId == tableId) {

            dtData = settings[i].aoData;
            break;
        }
    }

    ms = $(valueSelector).val();
    ms = $.parseJSON(ms);

    for (var i = 0; i < dtData.length; i++) {

        cells = dtData[i].anCells;
        checkbox = $(cells[0]).find(':checkbox');
        id = checkbox.val();

        for (var i1 = 0; i1 < ms.length; i1++) {

            if (id == ms[i1]) {

                $(cells[0]).find(':checkbox').get(0).checked = true;
            }
        }
    }
}

function SetDataTablesChecked_Old_1(tableSelector, valueSelector, field1) {

    var table, tableId, settings, dtData, ms, anCells, checkbox, id;

    table = $(tableSelector);
    tableId = table.attr('id');
    settings = table.DataTable.settings;

    for (var i = 0; i < settings.length; i++) {

        if (settings[i].sTableId == tableId) {

            dtData = settings[i].aoData;
            break;
        }
    }

    ms = $(valueSelector).val();
    ms = $.parseJSON(ms);

    for (var i = 0; i < dtData.length; i++) {

        cells = dtData[i].anCells;
        checkbox = $(cells[0]).find(':checkbox');
        id = checkbox.val();

        for (var i1 = 0; i1 < ms.length; i1++) {

            if (id == ms[i1][field1]) {

                $(cells[0]).find(':checkbox').get(0).checked = true;
            }
        }
    }
}

// 提交前，获取被选择的操作权限值
function GetDataTablesChecked_Old_1(tableSelector, valueSelector, field1, field2) {

    var table, dtData, ms;

    table = $(tableSelector);
    dtData = table.DataTable.settings[0].aoData;

    ms = [];

    for (var i = 0; i < dtData.length; i++) {

        cells = dtData[i].anCells;
        if ($(cells[0]).find(':checkbox').get(0).checked) {

            m = {};
            m[field1] = 0;
            m[field2] = $(cells[0]).find(':checkbox').val();
            ms.push(m);
        }
    }

    $(valueSelector).val(JSON.stringify(ms));
}

function GetDataTablesChecked(tableSelector, valueSelector, increment) {

    var table, tableId, dtData, ms;

    table = $(tableSelector);
    tableId = table.attr('id');
    settings = table.DataTable.settings;

    for (var i = 0; i < settings.length; i++) {

        if (settings[i].sTableId == tableId) {

            dtData = settings[i].aoData;
            break;
        }
    }
    
    if (increment) {

        ms = $(valueSelector).val();
        ms = $.parseJSON(ms);
    } else {
        ms = [];
    }

    for (var i = 0; i < dtData.length; i++) {

        cells = dtData[i].anCells;
        if ($(cells[0]).find(':checkbox').get(0).checked) {

            id = $(cells[0]).find(':checkbox').val();
            id = parseInt(id);
            ms.push(id);
        }
    }

    $(valueSelector).val(JSON.stringify(ms));
}

function GetDataTablesAllCheckStatus(tableSelector) {

    var table, dtData, id, checked, unchecked;

    table = $(tableSelector);
    dtData = table.DataTable.settings[0].aoData;

    checked = [];
    unchecked = [];
    for (var i = 0; i < dtData.length; i++) {

        cells = dtData[i].anCells;
        id = $(cells[0]).find(':checkbox').val();

        if ($(cells[0]).find(':checkbox').get(0).checked) {

            checked.push(id);
        } else {

            unchecked.push(id);
        }
    }

    return [checked, unchecked];
}