$(function() {

    'use strict';

    var req, fileName;

    $('#replace').on('click', function() {

        var qt = QT.init();
        qt.format($('#txt'), patterns);
    });

    req = Request.init();
    fileName = req.getValue('file');

    $.get('../' + fileName, function(data) {

        var txt;

        txt = data;
        txt = encodeURIComponent(txt).replace(/%0A/g, '<n>\n').replace(/%0D/g, '<r>');
        txt = decodeURIComponent(txt) + '<r><n>';
        $('#txt').val(txt);
    });
});

