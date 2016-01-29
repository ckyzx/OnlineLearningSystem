$(function(){

	var ldContentInput, ueContent;

	ldContentInput = $('#LearningDataContent');

	$('#LD_Content').html(ldContentInput.val());
	ueContent = UE.getEditor('LD_Content');

});