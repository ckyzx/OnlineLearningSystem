$(function() {

    var epId;
    var questionContainers;
    var swipers;


    QueryString.Initial();
    epId = QueryString.GetValue('epId');

    swipers = {};

    if (undefined == epId) {

        alert('试卷编号有误。');

        location.href = '/Contents/html/layer_close.htm';

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

                alert('ErrorName: ' + e.name + '\r\nMessage: ' + e.message + '\r\nStack: ' + e.stack);
            }

        } else if (0 == data.status) {

            alert(data.message);

            if (data.message == '考试已结束。') {
                layer_close();
            }
        }
    }, 'json');

    // 启动定时任务
    $('body').everyTime('180s', 'saveAnswers', saveAnswers);

    function renderQuestions(questions, answers) {

        var questionAry;

        questionAry = adjustQuestions(questions, answers);

        $('#TypeItemTmpl').tmpl(questionAry).appendTo('#TypeList ul');
        $('#QuestionListTmpl').tmpl(questionAry).appendTo('#QuestionList');

        // 在本地保存考题数据
        initLocalQuestions('#QuestionList', questions, answers);

        /* 5个参数顺序不可打乱，分别是：响应区,隐藏显示的内容,速度,类型,事件 */
        $.Huifold("#TypeList ul .item h4", "#TypeList ul .item .info", "fast", 1, "click");

        // 显示第一个题型
        questionContainers = $('div[id^="Questions_"]');

        $('#TypeList')
            .on('click', 'li.item', function() {

                clickTypeItem(this);
            })
            .on('click', '.info-item a', function() {

                clickTypeSubItem(this);
            });

        $('#TypeList li.item h4').first().click();

        $('.swiper-button-prev-question').on('click', function() {

            prevQuestion(this);
        });

        $('.swiper-button-next-question').on('click', function() {

            nextQuestion(this);
        });

        $('#QuestionList').on('click', 'button.paper-hand-in', function() {

            if (confirm('确定结束考试吗？')) {

                saveLocalAnswers();
                
                submitAnswers(function() {

                    undoPrompt(function() {

                        handIn(function() {
                            location.href = '/Contents/html/parent_reload.htm';
                        });
                    });
                });

            }
        });
    }

    function prevQuestion(btn) {

        var h4, li, prevLi, a, prevA, infoItem;

        btn = $(btn);
        h4 = $('li.item h4.active');
        li = h4.parent();
        a = li.find('a.active');
        infoItem = a.parent();
        prevA = infoItem.prev().find('a');

        if (prevA.length == 0) {

            prevLi = li.prev();

            if (prevLi.length == 0) {

                return;
            } else {

                prevLi.find('h4').click();

                a = prevLi.find('a').last();
                a.click();
            }
        } else {

            prevA.click();
        }
    }

    function nextQuestion(btn) {

        var h4, li, nextLi, a, nextA, infoItem;

        btn = $(btn);
        h4 = $('li.item h4.active');
        li = h4.parent();
        a = li.find('a.active');
        infoItem = a.parent();
        nextA = infoItem.next().find('a');

        if (nextA.length == 0) {

            nextLi = li.next();

            if (nextLi.length == 0) {

                return;
            } else {

                nextLi.find('h4').click();
            }
        } else {

            nextA.click();
        }
    }

    function clickTypeItem(thisElem) {

        var li;
        var i, i1;
        var oldContainer;

        li = $(thisElem);
        i = li.attr('data-item-index');

        // 销毁并隐藏 Swiper
        oldContainer = $('.question-container-active');
        i1 = oldContainer.attr('data-questions-index');

        if (i == i1) {
            return;
        }

        if (swipers[i1] != null) {

            swipers[i1].destroy();
            swipers[i1] = null;
        }
        oldContainer.removeClass('question-container-active').addClass('hide');

        questionContainers.eq(i).addClass('question-container-active').removeClass('hide');
        swipers[i] = initSwiper(questionContainers.eq(i).get(0));

        $('li.item h4.active').removeClass('active');
        li.find('h4').addClass('active');

        li.find('a').first().click();
    }

    function initSwiper(elem) {

        var swiper;

        swiper = new Swiper(elem, {
            mode: 'vertical',
            simulateTouch: false
        });

        return swiper;
    }

    function clickTypeSubItem(thisElem) {

        var a, li, questionContainer;
        var i1, i2;

        a = $(thisElem);
        li = a.parentsUntil('ul').last();

        i1 = li.attr('data-item-index');
        i2 = a.attr('data-question-index');

        questionContainer = $('#Questions_' + i1);
        swipers[i1].swipeTo(i2);

        $('li.item a.active').removeClass('active');
        a.addClass('active');

        // 控制按钮状态
        $('.swiper-button-question').removeClass('disabled');

        if (a.parent().prev().length == 0 && a.parentsUntil('ul').last().prev().length == 0) {
            $('.swiper-button-prev-question').addClass('disabled');
        }

        if (a.parent().next().length == 0 && a.parentsUntil('ul').last().next().length == 0) {
            $('.swiper-button-next-question').addClass('disabled');
        }

        saveAnswers();

        setCurrentQuestionId(questionContainer);
    }

    function setCurrentQuestionId(questionContainer) {

        $('#CurrentQuestionId').val(questionContainer.find('.swiper-slide-active').attr('data-question-id'));
    }

    function saveAnswers() {

        saveLocalAnswers();
        submitAnswers();
    }

    function saveLocalAnswers() {

        var qId;
        var qSlide;

        qId = $('#CurrentQuestionId').val();

        if ('' == qId) {
            return;
        }

        qSlide = $('#Question_' + qId);
        qType = qSlide.attr('data-question-type');

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

        if (answers == '[') {
            return;
        }

        answers = answers.substring(0, answers.length - 2);
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

                    }

                    if ('function' == typeof(successCallback)) {
                        successCallback();
                    }
                    //updateAnswerProgress(questionTypesAry);
                } else if (0 == data.status) {

                    alert(data.message);

                    if (data.message == '考试已结束') {
                        location.href = '/Contents/html/parent_reload.htm';
                    }
                }
            }, 'json')
            .error(function() {

                alert('请求返回错误！');
            });
    }

    function handIn(successCallback) {

        $.post('/ExaminationPaper/HandIn', {
                id: epId
            }, function(data) {

                if (1 == data.status) {

                    if ('function' == typeof(successCallback)) {
                        successCallback();
                    }
                } else if (0 == data.status) {

                    alert(data.message);

                    if (data.message == '考试已结束') {
                        location.href = '/Contents/html/parent_reload.htm';
                    }
                }
            }, 'json')
            .error(function() {

                alert('请求返回错误！');
            });
    }

    function undoPrompt(successCallback) {

        $.post('/ExaminationPaper/GetUndoNumber', {
                id: epId
            }, function(data) {

                var undoNumber;

                if (1 == data.status) {

                    undoNumber = data.data;
                    if (undoNumber != 0) {

                        if (!confirm('还有 ' + undoNumber + ' 条题目未回答，确定要交卷吗？')) {
                            return;
                        }
                    }

                    if ('function' == typeof(successCallback)) {
                        successCallback();
                    }
                } else if (0 == data.status) {

                    alert(data.message);
                }
            }, 'json')
            .error(function() {

                alert('请求返回错误！');
            });
    }
});