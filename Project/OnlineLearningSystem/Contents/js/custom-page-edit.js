// 给 DataTables 的数据设置复选状态
function SetDataTablesChecked(tableSelector, valueSelector) {

    var container, table, tableId, settings, dtData, ms, cells, checkbox, id;
    var countSpan, rows, allCheckbox;
    var checked;

    table = $(tableSelector);
    container = table.parent();
    tableId = table.attr('id');
    settings = table.DataTable.settings;

    for (var i = 0; i < settings.length; i++) {

        if (settings[i].sTableId == tableId) {

            dtData = settings[i].aoData;
            break;
        }
    }

    ms = $(valueSelector).val();
    ms = $.parseJSON(ms);

    for (var i = 0; i < dtData.length; i++) {

        cells = dtData[i].anCells;
        checkbox = $(cells[0]).find(':checkbox');
        id = checkbox.val();

        for (var i1 = 0; i1 < ms.length; i1++) {

            if (id == ms[i1]) {

                $(cells[0]).find(':checkbox').get(0).checked = true;
            }
        }
    }

    // 显示已选数据数量
    container.find('.select-data-item').remove();
    countSpan = $('<div class="select-data-item">已选 <span class="select-data-count">' + ms.length + '</span> 条</div>');
    countSpan.prependTo(container);

    // 判断是否复选“全选”框
    rows = table.find('tbody tr');
    allCheckbox = $(':checkbox[value=all]');
    checked = rows.length == rows.find(':checked').length;
    if (checked) {
        allCheckbox.attr('checked', 'checked');
    } else {
        allCheckbox.removeAttr('checked');
    }
}

function SetDataTablesChecked_Old_1(tableSelector, valueSelector, field1) {

    var table, tableId, settings, dtData, ms, anCells, checkbox, id;

    table = $(tableSelector);
    tableId = table.attr('id');
    settings = table.DataTable.settings;

    for (var i = 0; i < settings.length; i++) {

        if (settings[i].sTableId == tableId) {

            dtData = settings[i].aoData;
            break;
        }
    }

    ms = $(valueSelector).val();
    ms = $.parseJSON(ms);

    for (var i = 0; i < dtData.length; i++) {

        cells = dtData[i].anCells;
        checkbox = $(cells[0]).find(':checkbox');
        id = checkbox.val();

        for (var i1 = 0; i1 < ms.length; i1++) {

            if (id == ms[i1][field1]) {

                $(cells[0]).find(':checkbox').get(0).checked = true;
            }
        }
    }
}

// 提交前，获取被选择的操作权限值
function GetDataTablesChecked_Old_1(tableSelector, valueSelector, field1, field2) {

    var table, dtData, ms;

    table = $(tableSelector);
    dtData = table.DataTable.settings[0].aoData;

    ms = [];

    for (var i = 0; i < dtData.length; i++) {

        cells = dtData[i].anCells;
        if ($(cells[0]).find(':checkbox').get(0).checked) {

            m = {};
            m[field1] = 0;
            m[field2] = $(cells[0]).find(':checkbox').val();
            ms.push(m);
        }
    }

    $(valueSelector).val(JSON.stringify(ms));
}

function GetDataTablesChecked(tableSelector, valueSelector, increment) {

    var table, tableId, dtData, ms;

    table = $(tableSelector);
    tableId = table.attr('id');
    settings = table.DataTable.settings;

    for (var i = 0; i < settings.length; i++) {

        if (settings[i].sTableId == tableId) {

            dtData = settings[i].aoData;
            break;
        }
    }

    if (increment) {

        ms = $(valueSelector).val();
        ms = $.parseJSON(ms);
    } else {
        ms = [];
    }

    for (var i = 0; i < dtData.length; i++) {

        cells = dtData[i].anCells;
        if ($(cells[0]).find(':checkbox').get(0).checked) {

            id = $(cells[0]).find(':checkbox').val();
            id = parseInt(id);
            ms.push(id);
        }
    }

    $(valueSelector).val(JSON.stringify(ms));
}

function GetDataTablesAllCheckStatus(tableSelector) {

    var table, dtData, id, checked, unchecked;

    table = $(tableSelector);
    dtData = table.DataTable.settings[0].aoData;

    checked = [];
    unchecked = [];
    for (var i = 0; i < dtData.length; i++) {

        cells = dtData[i].anCells;
        id = $(cells[0]).find(':checkbox').val();

        if ($(cells[0]).find(':checkbox').get(0).checked) {

            checked.push(id);
        } else {

            unchecked.push(id);
        }
    }

    return [checked, unchecked];
}

//[IECompatibility]
function GetDataTablesAllCheckStatus1(tableSelector, checked) {

    var table, dtData, id, checkedAry, uncheckedAry;

    table = $(tableSelector);
    checkboxs = table.find(':checkbox[value!=all]');

    checkedAry = [];
    uncheckedAry = [];
    for (var i = 0; i < checkboxs.length; i++) {

        id = checkboxs[i].value;
        if (checked) {
            checkedAry.push(id);
        } else {
            uncheckedAry.push(id);
        }
    }

    return [checkedAry, uncheckedAry];
}
/*----------------------------------------------------------------------*/

/**
 ** 考试页面与改卷页面相关函数
 **/

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
        q.EPTQ_Content =
            q.EPTQ_Content
            .replace(/^(\\r\\n)+/, '')
            .replace(/(\\r\\n)+$/, '')
            .replace(/\\r\\n/g, '<br />');

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

function getAnswer(answers, eptqId) {

    for (var i = 0; i < answers.length; i++) {

        if (answers[i].EPTQ_Id == eptqId) {
            return answers[i];
        }
    }

    return {};
}

function initLocalQuestions(selector, qs, as) {

    var qList, qsdInput, asdInput, tmpInput;

    qList = $(selector);

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
            setModelAnswer(q, a.EPQ_Exactness);
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
            tmpAnswer = tmpAnswer == '' ? '[]' : tmpAnswer;
            tmpAnswer = JSON.parse(tmpAnswer);
            tmpAnswer = tmpAnswer.length == 1 ? tmpAnswer[0] : '';

            tmpRadio = $('input[name="question_radios_' + eptqId + '"][value="' + tmpAnswer + '"]');
            if (tmpRadio.length == 1) {
                tmpRadio.get(0).checked = true;
            }

            break;
        case '多选题':

            tmpAnswer = answerContent;
            tmpAnswer = tmpAnswer == '' ? '[]' : tmpAnswer;
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

            answerContent =
                answerContent
                .replace(/^(\\r\\n)+/, '')
                .replace(/(\\r\\n)+$/, '')
                .replace(/\\r\\n/g, '\n');;
            $('textarea[name="question_textarea_' + eptqId + '"]').val(answerContent);

            break;
    }
    
    /*// 试题已回答，且 [标准答案] 不为空，则显示 [标准答案模块]
    if (answerContent != '[]' && answerContent != '') {
        _showModelAnswerModule();
    }*/

}

function _showModelAnswerModule() {

    var qContainer, span, textarea;
    var qId, aData, answer;

    qId = $('#CurrentQuestionId').val();

    qContainer = $('.question-container-active');
    qContainer = qContainer.find('#Question_' + qId);

    span = qContainer.find('span[data-id=ModelAnswerContainer_' + qId + ']');
    textarea = qContainer.find('textarea[name=question_textarea_' + qId + '_model_answer]');

    // 获取已提交的答案
    aData = $('#AnswerData_' + qId).val();
    aData = JSON.parse(aData);
    answer = aData.EPQ_Answer;

    // 判断是否显示 [标准答案模块]
    // - 如果 [标准答案] 内容不为空，则显示
    if (answer != '[]' 
        && answer != '' 
        && (span.text() != '' 
            || (textarea.length != 0 && textarea.val() != ''))) {

        qContainer.find('div.question-grade').removeClass('hide');
        _setCheckboxAndRadioStatus(qContainer);
    }
}

// 设置选择题、判断题的选项 [正确与否] 的状态
function _setCheckboxAndRadioStatus(questionContainer) {

    var answerControl, modelAnswer;

    answerControl = questionContainer.find('span.model-answer');
    modelAnswer = answerControl.text();

    questionContainer.find(':checkbox, :radio').each(function() {

        var control1, parent;

        control1 = $(this);
        parent = control1.parent();

        if (control1.is(':checked')) {

            if (modelAnswer.indexOf(control1.val()) == -1) {
                parent.css('color', 'red');
            } else {
                parent.css('color', 'green');
            }
        } else {
            parent.css('color', '');
        }
    });
}

function setModelAnswer(eptq, exactness) {

    var qType, eptqId, modelAnswer, exactness;
    var exactnessRadio;

    if (null == eptq.EPTQ_ModelAnswer) {
        return;
    }

    qType = eptq.EPTQ_Type;
    eptqId = eptq.EPTQ_Id;
    modelAnswer = eptq.EPTQ_ModelAnswer;

    //$('div[data-id=ModelAnswer_' + eptqId + ']').removeClass('hide');

    // 设置评分
    exactnessRadio = $('input[name="question_radios_' + eptqId + '_grade"][value="' + exactness + '"]');

    // - 有评分控件，则设置
    if (exactnessRadio.length != 0) {
        exactnessRadio.get(0).checked = true;
        $('span[data-name="question_radios_' + eptqId + '_grade"][data-value="' + exactness + '"] i.Hui-iconfont').addClass('active');
    }

    switch (qType) {
        case '单选题':

            tmpAnswer = modelAnswer;
            tmpAnswer = JSON.parse(tmpAnswer);
            tmpAnswer = tmpAnswer.length == 1 ? tmpAnswer[0] : '';

            /*tmpRadio = $('input[name="question_radios_' + eptqId + '_model_answer"][value="' + tmpAnswer + '"]');
            if (tmpRadio.length == 1) {
                tmpRadio.get(0).checked = true;
            }*/

            $('span[data-id=ModelAnswerContainer_' + eptqId + ']').text(tmpAnswer);

            break;
        case '多选题':

            /*tmpAnswer = modelAnswer;
            tmpAnswer = JSON.parse(tmpAnswer);

            for (var i = 0; i < tmpAnswer.length; i++) {

                tmpAnswer1 = tmpAnswer[i];

                tmpCheckbox = $('input[name="question_checkboxs_' + eptqId + '_model_answer"][value="' + tmpAnswer1 + '"]');
                if (tmpCheckbox.length == 1) {
                    tmpCheckbox.get(0).checked = true;
                }
            }*/

            $('span[data-id=ModelAnswerContainer_' + eptqId + ']').text(modelAnswer.replace(/[\[\]",]*/g, ''));

            break;
        case '判断题':

            /*tmpRadio = $('input[name="question_radios_' + eptqId + '_model_answer"][value="' + modelAnswer + '"]');
            if (tmpRadio.length == 1) {
                tmpRadio.get(0).checked = true;
            }*/

            $('span[data-id=ModelAnswerContainer_' + eptqId + ']').text(modelAnswer);

            break;
        default:

            modelAnswer =
                modelAnswer
                .replace(/^(\\r\\n)+/, '')
                .replace(/(\\r\\n)+$/, '')
                .replace(/\\r\\n/g, '\n');
            $('textarea[name="question_textarea_' + eptqId + '_model_answer"]').val(modelAnswer);

            break;
    }
}
/*----------------------------------------------------------------------*/
