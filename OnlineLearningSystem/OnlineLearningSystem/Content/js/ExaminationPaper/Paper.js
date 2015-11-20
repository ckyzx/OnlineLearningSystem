$(function() {

    var epId;

    QueryString.Initial();
    epId = QueryString.GetValue('epId');

    if (undefined == epId) {

        alert('试卷编号有误。');

        location.href = '/Content/html/layer_close.htm';

        return;
    }

    $.post('/ExaminationPaper/GetQuestions', {
        epId: epId
    }, function(data) {

        if (1 == data.status) {

            var ary, questions, answers;

            ary = JSON.parse(data.data);
            questions = ary[0];
            answers = ary[1];

            renderQuestions(questions, answers);

        } else if (0 == data.status) {

            alert(data.message);
        }
    }, 'json');

    function renderQuestions(questions, answers) {

        var ary, obj;

        ary = [];

        for (var i = 0; i < questions.length; i++) {

            q = questions[i];
            a = getAnswer(answers, q.EPTQ_Id);

            if (undefined != a) {
                for (var k in a) {
                    q[k] = a[k];
                }
            }

            obj = duplicateType(ary, q.EPTQ_Type);
            if (undefined == obj) {

                ary.push({
                    type: q.EPTQ_Type,
                    questions: []
                });
            } else {

                obj.questions.push(q);
            }
        }

        $('#QuestionTmpl').tmpl(ary).appendTo('#QuestionContainer .swiper-wrapper');


        var swiper = new Swiper('.swiper-container', {
            scrollbar: '.swiper-scrollbar',
            scrollbarHide: true,
            slidesPerView: 'auto',
            centeredSlides: true,
            spaceBetween: 10,
            grabCursor: true,
            direction: 'vertical'
        });

    }

    function getAnswer(answers, eptqId) {

        for (var i = 0; i < answers.length; i++) {

            if (answers.EPTQ_Id == eptqId) {
                return answers[i];
            }
        }

        return undefined;
    }

    function duplicateType(ary, type) {

        for (var i = 0; i < ary.length; i++) {

            if (ary[i].type == type) {

                return ary[i];
            }
        }

        return undefined;
    }
});
