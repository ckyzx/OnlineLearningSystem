$(function() {

    var eptId;
    var paperGrade;

    QueryString.Initial();
    eptId = QueryString.GetValue('eptId');

    paperGrade = OLS.PaperGrade.init(eptId);
    paperGrade.renderUserList();
    paperGrade.initButtonEvent();
    paperGrade.initEvent();
});
