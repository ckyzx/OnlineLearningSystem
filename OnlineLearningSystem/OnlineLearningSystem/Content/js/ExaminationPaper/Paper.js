$(function() {

    var epId;
    var swipers;

    QueryString.Initial();
    epId = QueryString.GetValue('epId');

    swipers = {};

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

        var ary;
        var obj;
        var i1, i2;
        var questionContainers;

        ary = [];
        i1 = 0;
        i2 = 1;

        for (var i = 0; i < questions.length; i++) {

            q = questions[i];
            q.EPTQ_Content = q.EPTQ_Content.replace(/\\r\\n/g, '<br />');

            a = getAnswer(answers, q.EPTQ_Id);

            if (undefined != a) {
                for (var k in a) {
                    q[k] = a[k];
                }
            }

            obj = duplicateType(ary, q.EPTQ_Type);
            if (undefined == obj) {

                obj = {
                    i: i1,
                    type: q.EPTQ_Type,
                    questions: []
                };
                ary.push(obj);

                i1 += 1;
                i2 = 1;
            }

            q.i = i2;
            obj.questions.push(q);

            i2 += 1;
        }

        $('#TypeItemTmpl').tmpl(ary).appendTo('#TypeList ul');
        $('#QuestionListTmpl').tmpl(ary).appendTo('#QuestionList');

        /* 5个参数顺序不可打乱，分别是：响应区,隐藏显示的内容,速度,类型,事件 */
        $.Huifold("#TypeList ul .item h4", "#TypeList ul .item .info", "fast", 1, "click");

        questionContainers = $('div[id^="Questions_"]');
        questionContainers.eq(0).addClass('question-container-active').show();
        swipers[0] = initSwiper(questionContainers.eq(0).get(0));

        $('#TypeList')
            .on('click', '.info-item a', function() {

                var a, li;
                var i1, i2;

                a = $(this);
                li = a.parentsUntil('ul').last();

                i1 = li.attr('index');
                i2 = a.attr('index');

                $('#Questions_' + i1).find('.bullet-' + i2).click();
            })
            .on('click', 'li.item', function() {

                var li;
                var i, i1;
                var oldContainer;

                li = $(this);
                i = li.attr('index');

                // 销毁并隐藏
                oldContainer = $('.question-container-active');
                i1 = oldContainer.attr('index');

                if(i == i1){
                    return;
                }

                if(swipers[i1] != null){

                    swipers[i1].destroy();
                    swipers[i1] = null;
                }
                oldContainer.removeClass('question-container-active').hide();

                questionContainers.eq(i).addClass('question-container-active').show();
                swipers[i] = initSwiper(questionContainers.eq(i).get(0));
            });
    }

    function initSwiper(ele) {

        var swiper;

        swiper = new Swiper(ele, {
            direction: 'vertical',
            pagination: '.swiper-pagination',
            paginationClickable: true,
            paginationBulletRender: function(index, className) {
                return '<span class="' + className + ' bullet-' + (index + 1) + '">' + (index + 1) + '</span>';
            },
            prevButton: '.swiper-button-prev-question',
            nextButton: '.swiper-button-next-question'
        });

        return swiper;
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
