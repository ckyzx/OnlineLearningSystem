$(function() {

    var epId;
    var questionContainers;
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

                alert('ErrorName: ' + e.name + '\r\nMessage: ' + e.message + '\r\nStack: ' + e.stack);
            }

        } else if (0 == data.status) {

            alert(data.message);
        }
    }, 'json');

    // 启动定时任务
    $('body').everyTime('180s', 'saveAnswers', saveAnswers);

    function renderQuestions(questions, answers) {

        var ary;

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

            if (confirm('确定要结束考试吗？')) {

                saveLocalAnswers();
                submitAnswers(function() {
                    layer_close();
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
                    questions: [],
                };
                ary.push(obj);

                i1 += 1;
            }

            q.i = obj.total;
            obj.total = obj.total + 1;
            obj.questions.push(q);

            if (q.hasAnswer) {
                obj.done += 1;
            }

        }

        return ary;
    }

    function duplicateType(ary, type) {

        for (var i = 0; i < ary.length; i++) {

            if (ary[i].type == type) {

                return ary[i];
            }
        }

        return undefined;
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

            alert('ErrorName: ' + e.name + '\r\nMessage: ' + e.message + '\r\nStack: ' + e.stack + '\r\nEPTQ_Id: ' + q.EPTQ_Id);
        }

        return q;
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
        oldContainer.removeClass('question-container-active').hide();

        questionContainers.eq(i).addClass('question-container-active').show();
        swipers[i] = initSwiper(questionContainers.eq(i).get(0));

        $('li.item h4.active').removeClass('active');
        li.find('h4').addClass('active');

        li.find('a').first().click();
    }

    function initSwiper(elem) {

        var swiper;

        swiper = new Swiper(elem, {
            mode: 'vertical'
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

        if(a.parent().prev().length == 0 && a.parentsUntil('ul').last().prev().length == 0){
            $('.swiper-button-prev-question').addClass('disabled');
        }

        if(a.parent().next().length == 0 && a.parentsUntil('ul').last().next().length == 0){
            $('.swiper-button-next-question').addClass('disabled');
        }

        saveAnswers();

        setCurrentQuestionId(questionContainer);
    }

    function setCurrentQuestionId(questionContainer) {

        $('#CurrentQuestionId').val(questionContainer.find('.swiper-slide-active').attr('data-question-id'));
    }

    function getAnswer(answers, eptqId) {

        for (var i = 0; i < answers.length; i++) {

            if (answers[i].EPTQ_Id == eptqId) {
                return answers[i];
            }
        }

        return {};
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

});
