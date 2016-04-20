$(function() {

    'use strict';

    var eptId, epId;

    QueryString.Initial();
    eptId = QueryString.GetValue('eptId');
    epId = QueryString.GetValue('epId');

    renderPaper(eptId, epId);

    initButtonEvent();
});
