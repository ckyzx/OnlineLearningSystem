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

            try {
                renderQuestions(questions, answers);
            } catch (e) {
                alert(e.name + '\\r\\n' + e.message + '\\r\\n' + e.stack);
            }

        } else if (0 == data.status) {

            alert(data.message);
        }
    }, 'json');

    // 启动定时任务
    $('body').everyTime('180s', 'saveAnswers', saveAnswers);

    function renderQuestions(questions, answers) {

        var ary;
        var questionContainers;

        ary = adjustQuestions(questions, answers);

        $('#TypeItemTmpl').tmpl(ary).appendTo('#TypeList ul');
        $('#QuestionListTmpl').tmpl(ary).appendTo('#QuestionList');

        // 在本地保存考题数据
        initLocalQuestions(questions, answers);

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

                var a, li, questionContainer;
                var i1, i2;

                a = $(this);
                li = a.parentsUntil('ul').last();

                i1 = li.attr('index');
                i2 = a.attr('index');

                questionContainer = $('#Questions_' + i1);
                questionContainer.find('.bullet-' + i2).click();

                $('li.item a.active').removeClass('active');
                a.addClass('active');

                setCurrentQuestionId(questionContainer);
            });

        $('#TypeList li.item h4').first().click();
        // ---------------------------------------

        $('#QuestionList')
            // 提交考题数据
            .on('mousedown', 'button.swiper-button-question', function() {

                var btn;

                btn = $(this);

                //saveLocalAnswers(btn);
                //submitAnswers();

                // 切换至下一题型
                if (btn.hasClass('swiper-button-disabled')) {
                    switchNextQuestionType(btn);
                }
            })
            .on('click', 'button.paper-hand-in', function() {

                if (confirm('确定要结束考试吗？')) {

                    saveLocalAnswers1();
                    submitAnswers(function() {
                        layer_close();
                    });

                }
            });
    }

    function saveLocalAnswers(switchBtn) {

        var liActive, qSlide, adInput;
        var liIndex;
        var qId, qType, qAnswer;
        var answer;

        liActive = $('h4.active').parent();
        liIndex = liActive.attr('index');

        qSlide = $('#Questions_' + liIndex + ' .swiper-slide-active');
        qId = qSlide.attr('q-id');
        qType = qSlide.attr('q-type');

        // 获取原答题数据
        adInput = $('#AnswerData_' + qId);
        answer = adInput.val();
        answer = answer == '' ? {} : JSON.parse(answer);

        answer.submitStatus = false;
        answer.EP_Id = epId;
        answer.EPTQ_Id = qId;

        switch (qType) {
            case '单选题':

                qAnswer = $('input[name="question_radios_' + qId + '"]:checked').val();
                qAnswer = undefined == qAnswer ? [] : [qAnswer];

                answer.EPQ_Answer = JSON.stringify(qAnswer);

                break;
            case '多选题':

                qAnswer = [];
                $('input[name="question_checkboxs_' + qId + '"]:checked').each(function() {

                    qAnswer.push($(this).val());
                });

                answer.EPQ_Answer = JSON.stringify(qAnswer);

                break;
            case '判断题':

                qAnswer = $('input[name="question_radios_' + qId + '"]:checked').val();
                qAnswer = undefined == qAnswer ? '' : qAnswer;

                answer.EPQ_Answer = qAnswer;

                break;
            default:

                qAnswer = $('textarea[name="question_textarea_' + qId + '"]').val();

                answer.EPQ_Answer = qAnswer;

                break;
        }

        adInput.val(JSON.stringify(answer));
    }

    function saveLocalAnswers1() {

        var qId;
        var qSlide;

        qId = $('#CurrentQuestionId').val();

        qSlide = $('#Question_' + qId);
        qId = qSlide.attr('q-id');
        qType = qSlide.attr('q-type');

        // 获取原答题数据
        adInput = $('#AnswerData_' + qId);
        answer = adInput.val();
        answer = answer == '' ? {} : JSON.parse(answer);

        answer.submitStatus = false;
        answer.EP_Id = epId;
        answer.EPTQ_Id = qId;

        switch (qType) {
            case '单选题':

                qAnswer = $('input[name="question_radios_' + qId + '"]:checked').val();
                qAnswer = undefined == qAnswer ? [] : [qAnswer];

                answer.EPQ_Answer = JSON.stringify(qAnswer);

                break;
            case '多选题':

                qAnswer = [];
                $('input[name="question_checkboxs_' + qId + '"]:checked').each(function() {

                    qAnswer.push($(this).val());
                });

                answer.EPQ_Answer = JSON.stringify(qAnswer);

                break;
            case '判断题':

                qAnswer = $('input[name="question_radios_' + qId + '"]:checked').val();
                qAnswer = undefined == qAnswer ? '' : qAnswer;

                answer.EPQ_Answer = qAnswer;

                break;
            default:

                qAnswer = $('textarea[name="question_textarea_' + qId + '"]').val();

                answer.EPQ_Answer = qAnswer;

                break;
        }

        adInput.val(JSON.stringify(answer));
    }

    function submitAnswers(successCallback) {

        var answers;

        answers = '[';

        $('input[id^="AnswerData_"]').each(function() {

            tmpAnswer = $(this).val();

            if ('' == tmpAnswer) {
                return;
            }

            tmpAnswer1 = JSON.parse(tmpAnswer);

            if (false === tmpAnswer1.submitStatus) {
                answers += tmpAnswer + ', ';
            }
        });

        answers = answers.substring(0, answers.length - 2)
        answers += ']';

        $.post('/ExaminationPaper/SubmitAnswers', {
                answersJson: answers
            }, function(data) {

                if (1 == data.status) {

                    // 提交成功，将本地答案的 submitStatus 设置为 true 。
                    answers = JSON.parse(answers);

                    for (var i = 0; i < answers.length; i++) {

                        a = answers[i];

                        a.submitStatus = true;

                        $('#AnswerData_' + a.EPTQ_Id).val(JSON.stringify(a));

                        if ('function' == typeof(successCallback)) {
                            successCallback();
                        }
                    }

                    //updateAnswerProgress(questionTypesAry);
                } else if (0 == data.status) {

                    alert(data.message);
                }
            }, 'json')
            .error(function() {

                alert('请求返回错误！');
            });
    }

    function updateAnswerProgress(questionTypesAry) {

        //TODO: 刷新答题进度
    }

    function saveAnswers() {

        saveLocalAnswers1();
        submitAnswers();
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

    function initLocalQuestions(qs, as) {

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

            // 设置考题答案
            if (undefined != a.EPQ_Id) {
                setAnswer(q.EPTQ_Type, a);
            }
        }

        // 添加记录当前考题编号的控件
        qList.append($('<input type="hidden" id="CurrentQuestionId" />'));
    }

    function setAnswer(qType, answer) {

        var eptqId, answerContent;

        eptqId = answer.EPTQ_Id;
        answerContent = answer.EPQ_Answer;

        switch (qType) {
            case '单选题':

                tmpAnswer = answerContent;
                tmpAnswer = JSON.parse(tmpAnswer);
                tmpAnswer = tmpAnswer.length == 1 ? tmpAnswer[0] : '';

                tmpRadio = $('input[name="question_radios_' + eptqId + '"][value="' + tmpAnswer + '"]');
                if (tmpRadio.length == 1) {
                    tmpRadio.get(0).checked = true;
                }

                break;
            case '多选题':

                tmpAnswer = answerContent;
                tmpAnswer = JSON.parse(tmpAnswer);

                for (var i = 0; i < tmpAnswer.length; i++) {

                    tmpAnswer1 = tmpAnswer[i];

                    tmpCheckbox = $('input[name="question_checkboxs_' + eptqId + '"][value="' + tmpAnswer1 + '"]');
                    if (tmpCheckbox.length == 1) {
                        tmpCheckbox.get(0).checked = true;
                    }
                }

                break;

            case '判断题':

                tmpRadio = $('input[name="question_radios_' + eptqId + '"][value="' + answerContent + '"]');
                if (tmpRadio.length == 1) {
                    tmpRadio.get(0).checked = true;
                }

                break;
            default:

                $('textarea[name="question_textarea_' + eptqId + '"]').val(answerContent);

                break;
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

            if (undefined != a.EPQ_Id) {

                q.hasAnswer = true;

                for (var k in a) {
                    q[k] = a[k];
                }
            }

            obj = duplicateType(ary, q.EPTQ_Type);
            if (undefined == obj) {

                obj = {
                    i: i1,
                    type: q.EPTQ_Type,
                    total: 0,
                    done: 0,
                    questions: []
                };
                ary.push(obj);

                i1 += 1;
                i2 = 1;
            }

            q.i = i2;
            obj.questions.push(q);
            obj.total = i2;

            if (q.hasAnswer) {
                obj.done += 1;
            }

            i2 += 1;
        }

        return ary;
    }

    function formatQuestion(q) {

        try {
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
        } catch (e) {
            //alert(e.name + '\\r\\n' + e.message + '\\r\\n' + e.stack);
            alert(q.EPTQ_Id);
        }

        return q;
    }

    function initSwiper(questionContainer) {

        var swiper;
        var liIndex;

        liIndex = $(questionContainer).attr('index');

        swiper = new Swiper(questionContainer, {
            direction: 'vertical',
            pagination: '.swiper-pagination',
            paginationClickable: true,
            prevButton: '.swiper-button-prev-question',
            nextButton: '.swiper-button-next-question',
            paginationBulletRender: function(index, className) {

                var i;

                i = index + 1;

                return '<span class="' + className + ' bullet-' + i + '" li-index="' + liIndex + '" a-index="' + i + '">' + i + '</span>';
            },
            onSlideChangeStart: function(swiper) {

                saveLocalAnswers1();
                submitAnswers();
            },
            onSlideChangeEnd: function(swiper) {

                activeQuestion($(questionContainer));
            },
            onDestroy: function(swiper) {

                saveLocalAnswers1();
                submitAnswers();
            }
        });

        return swiper;
    }

    function activeQuestion(questionContainer) {

        var container, bullet;
        var liIndex, aIndex;

        bullet = questionContainer.find('.swiper-pagination-bullet-active');
        liIndex = bullet.attr('li-index');
        aIndex = bullet.attr('a-index');

        $('#Item_' + liIndex).find('a.active').removeClass('active');
        $('#Item_' + liIndex).find('a[index="' + aIndex + '"]').addClass('active');

        setCurrentQuestionId(questionContainer);
    }

    function setCurrentQuestionId(questionContainer) {

        $('#CurrentQuestionId').val(questionContainer.find('.swiper-slide-active').attr('q-id'));
    }

    function getAnswer(answers, eptqId) {

        for (var i = 0; i < answers.length; i++) {

            if (answers[i].EPTQ_Id == eptqId) {
                return answers[i];
            }
        }

        return {};
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
