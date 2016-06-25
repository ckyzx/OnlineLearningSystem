$(function() {

	var req;
    var eptId, epId, uId;
    var paperGrade;

    req = Request.init();
    eptId = req.getValue('eptId');
    epId = req.getValue('epId');
    uId = req.getValue('uId');

    paperGrade = OLS.PaperGrade.init(eptId, epId, uId);
    paperGrade.renderPaper();
    paperGrade.initButtonEvent();
    paperGrade.initEvent();
});
