$(function() {

    'use strict';

    var eptId;

    QueryString.Initial();
    eptId = QueryString.GetValue('id');

    renderPaper(eptId);

    initButtonEvent();
    /*----------------------------------------------------------------------*/

    function renderPaper(eptId) {

        $.post('/ExaminationPaperTemplate/GetQuestionsForUser', {
                id: eptId
            }, function(data) {

                var paperContainer;
                var questions, answers, paperData;
                var epId, uId;

                paperContainer = $('#PaperContainer');
                paperContainer.html('');

                if (1 == data.status) {

                    data.data = JSON.parse(data.data);
                    questions = data.data[0];
                    answers = data.data[1];
                    epId = data.data[2];

                    paperData = adjustQuestions(questions, answers);
                    paperData = {
                        epId: epId,
                        uId: uId,
                        types: paperData
                    };

                    paperContainer.addClass('bg-f')
                    $('#PaperTmpl').tmpl(paperData).appendTo(paperContainer);

                    // 在本地保存考题数据
                    initLocalQuestions('#PaperContainer', questions, answers);

                    // 清除未选评分项
                    $('span.grade i[class!=active]').hide();

                } else {

                    paperContainer
                        .removeClass('bg-f')
                        .html('<div class="prompt">' + data.message.replace(/。/g, '') + '</div>');
                }
            }, 'json')
            .error(function() {

                alert('请求返回错误！');
            });
    }

    function initButtonEvent(){

        $('#ExaminationPaperGradeContainer').on('click', '#Close', function(){
            layer_close();
        });
    }
    /*----------------------------------------------------------------------*/
});
