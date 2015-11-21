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
        var questionContainers;

        ary = adjustQuestions(questions, answers);

        $('#TypeItemTmpl').tmpl(ary).appendTo('#TypeList ul');
        $('#QuestionListTmpl').tmpl(ary).appendTo('#QuestionList');

        // 在本地保存考题数据
        saveLocalQuestions(questions, answers);

        /* 5个参数顺序不可打乱，分别是：响应区,隐藏显示的内容,速度,类型,事件 */
        $.Huifold("#TypeList ul .item h4", "#TypeList ul .item .info", "fast", 1, "click");

        // 显示第一个题型
        questionContainers = $('div[id^="Questions_"]');

        $('#TypeList')
            .on('click', 'li.item', function() {

                var li;
                var i, i1;
                var oldContainer;

                li = $(this);
                i = li.attr('index');

                // 销毁并隐藏 Swiper
                oldContainer = $('.question-container-active');
                i1 = oldContainer.attr('index');

                if (i == i1) {
                    return;
                }

                if (swipers[i1] != null) {

                    swipers[i1].destroy();
                    swipers[i1] = null;
                }
                oldContainer.removeClass('question-container-active').hide();

                questionContainers.eq(i).addClass('question-container-active').show();
                swipers[i] = initSwiper(questionContainers.eq(i).get(0));

                $('li.item h4.active').removeClass('active');
                li.find('h4').addClass('active');

                li.find('a').first().click();
            })
            .on('click', '.info-item a', function() {

                var a, li;
                var i1, i2;

                a = $(this);
                li = a.parentsUntil('ul').last();

                i1 = li.attr('index');
                i2 = a.attr('index');

                $('#Questions_' + i1).find('.bullet-' + i2).click();

                $('li.item a.active').removeClass('active');
                a.addClass('active');
            });

        $('#TypeList li.item h4').first().click();
        // ---------------------------------------

        $('#QuestionList')
            // 提交考题数据
            .on('mousedown', 'button.swiper-button-question', function() {

                var btn, liActive, qSlide, adInput;
                var liIndex;
                var qId, qType, qAnswer;
                var answer;

                btn = $(this);
                liActive = $('h4.active').parent();
                liIndex = liActive.attr('index');

                qSlide = $('#Questions_' + liIndex + ' .swiper-slide-active');
                qId = qSlide.attr('q-id');
                qType = qSlide.attr('q-type');

                // 获取原答题数据
                adInput = $('#AnswerData_' + qId);
                answer = adInput.val();
                answer = answer == '' ? {} : JSON.parse(answer);

                switch (qType) {
                    case '单选题':

                        qAnswer = $('#Question_radios_' + qId + ':checked').val();
                        qAnswer = undefined == qAnswer ? [] : [qAnswer];

                        answer.EP_Id = epId;
                        answer.EPTQ_Id = qId;
                        answer.EPQ_Answer = JSON.stringify(qAnswer);

                        adInput.val(JSON.stringify(answer));

                        break;
                    case '多选题':
                        break;
                    case '判断题':
                        break;
                    default:
                        break;
                }

                // 切换至下一题型
                if(btn.hasClass('swiper-button-disabled')){
                    switchNextQuestionType(btn);
                }

            });
    }

    function switchNextQuestionType(btn) {

        var btn, li;
        var direction;

        btn = $(btn);

        direction = btn.hasClass('swiper-button-prev-question') ? 'prev' : 'next';
        if ('prev' == direction) {

            li = $('#TypeList li.item h4.active').parent().prev();
        } else if ('next' == direction) {

            li = $('#TypeList li.item h4.active').parent().next();
        }

        if (li.length == 1) {

            li.find('h4').click();

            if ('prev' == direction) {

                li.find('a').last().click();
            }
        }
    }

    function saveLocalQuestions(qs, as) {

        var qList, qsdInput, asdInput, tmpInput;

        qList = $('#QuestionList');

        qsdInput = $('<input type="hidden" id="QuestionsData" />');
        asdInput = $('<input type="hidden" id="AnswersData" />')

        qsdInput.val(JSON.stringify(qs));
        asdInput.val(JSON.stringify(as));

        qList.append(qsdInput);
        qList.append(asdInput);

        for (var i = 0; i < qs.length; i++) {

            q = qs[i];
            qId = q.EPTQ_Id;

            tmpInput = $('<input type="hidden" id="QuestionData_' + qId + '" />');
            tmpInput.val(JSON.stringify(q));
            $('#Question_' + qId).append(tmpInput);

            a = getAnswer(as, qId);
            tmpInput = $('<input type="hidden" id="AnswerData_' + qId + '" />');
            tmpInput.val(JSON.stringify(a));
            $('#Question_' + qId).append(tmpInput);
        }
    }

    function adjustQuestions(qs, as) {

        var ary;
        var obj;
        var i1, i2;

        ary = [];
        i1 = 0;
        i2 = 1;

        for (var i = 0; i < qs.length; i++) {

            q = qs[i];

            // 将数据格式化
            q = formatQuestion(q);

            a = getAnswer(as, q.EPTQ_Id);

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

        return ary;
    }

    function formatQuestion(q) {

        q.EPTQ_Content = q.EPTQ_Content.replace(/\\r\\n/g, '<br />');

        if (q.EPTQ_Type == '单选题' || q.EPTQ_Type == '多选题') {

            tmpObj = JSON.parse(q.EPTQ_OptionalAnswer);
            tmpAry = [];
            for (var p in tmpObj) {

                tmpAry.push({
                    qId: q.EPTQ_Id,
                    key: p,
                    text: tmpObj[p]
                });
            }
            q.EPTQ_OptionalAnswer = tmpAry;
        }

        return q;
    }

    function initSwiper(ele) {

        var swiper;
        var liIndex;

        liIndex = $(ele).attr('index');

        swiper = new Swiper(ele, {
            direction: 'vertical',
            pagination: '.swiper-pagination',
            paginationClickable: true,
            paginationBulletRender: function(index, className) {

                var i;

                i = index + 1;

                return '<span class="' + className + ' bullet-' + i + '" li-index="' + liIndex + '" a-index="' + i + '">' + i + '</span>';
            },
            prevButton: '.swiper-button-prev-question',
            nextButton: '.swiper-button-next-question',
            onSlideChangeEnd: function(swiper) {

                var bullet;
                var liIndex, aIndex;

                bullet = $(ele).find('.swiper-pagination-bullet-active');
                liIndex = bullet.attr('li-index');
                aIndex = bullet.attr('a-index');

                $('#Item_' + liIndex).find('a.active').removeClass('active');
                $('#Item_' + liIndex).find('a[index="' + aIndex + '"]').addClass('active');
            }
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
