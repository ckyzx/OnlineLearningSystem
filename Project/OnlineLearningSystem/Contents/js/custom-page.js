function refreshRowBackgroundColor(tableSelector) {

    var table, trs;

    table = $(tableSelector);
    trs = table.find('tbody tr');

    trs.removeClass('odd');
    trs.removeClass('even');
    table.find('tbody tr:odd').addClass('even');
    table.find('tbody tr:even').addClass('odd');
}

function rowResponse() {

    $('.table-sort')
        .on('mouseenter', 'tbody tr', function() {
            $(this).addClass('hover');
        })
        .on('mouseleave', 'tbody tr', function() {
            $(this).removeClass('hover');
        });
    /*$('.table-sort')
        .on('mouseenter', 'tbody tr', function() {
            var tr, table;
            tr = $(this);
            table = tr.parentsUntil('table');
            table.find('tr').removeClass('hover');
            tr.addClass('hover');
        })*/;
}
