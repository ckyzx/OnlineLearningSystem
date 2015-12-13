function refreshRowBackgroundColor(tableSelector) {

    var table, trs;

    table = $(tableSelector);
    trs = table.find('tbody tr');

    trs.removeClass('odd');
    trs.removeClass('even');
    table.find('tbody tr:odd').addClass('odd');
    table.find('tbody tr:even').addClass('even');
}
