$(function() {

    showContentAndAnswer();

    // 编辑单选题/多选题的备选答案
    $('#QuestionContentAndAnswer')
        .on('click', 'a#ModifyAnswerBtn', function() {

            var taValue;

            qOptionalAnswer = $('#Q_OptionalAnswer').val();
            qOptionalAnswer = qOptionalAnswer == '' ? []: JSON.parse(qOptionalAnswer);
            qModelAnswer = $('#Q_ModelAnswer').val();
            qModelAnswer = qModelAnswer == '' ? [] : JSON.parse(qModelAnswer);
            taValue = '';
            for (var p in qOptionalAnswer) {
                taValue += (whetherAnswerCheck(qModelAnswer, p) ? '√' : '') + p + '.' + qOptionalAnswer[p] + '\n';
            };
            taValue = taValue != '' ? taValue.substring(0, taValue.length - 1) : taValue;

            layer.confirm(
                '', {
                    title: '编辑答案',
                    area: ['500px', '360px'],
                    content: 
                        '请一行输入一条备选答案，√ 开头表示选中。'+
                        '<a id="SampleTip" href="javascript:void(0);" style="color:orange;" onclick="layer.tips(\'√A.备选答案a<br />B.备选答案b<br />C.备选答案c<br />……\', \'#SampleTip\');">示例</a><br />' +
                        '<textarea id="ModifyAnswer" class="textarea" cols="20" rows="2" style="height:200px;">' + taValue + '</textarea>'
                },
                function(index) {

                    var answer;
                    var checked, qOptionalAnswer, qModelAnswer, qType;

                    answer = $('#ModifyAnswer').val();
                    answer = answer.split('\n');
                    qOptionalAnswer = {};
                    qModelAnswer = [];
                    for (var i = 0; i < answer.length; i++) {

                        a = answer[i];
                        if (a.substring(0, 1) == '√') {
                            checked = true;
                            a = a.substring(1);
                        } else {
                            checked = false;
                        }

                        if (a.indexOf('.') == -1) {
                            alert('格式有误。');
                            return;
                        }

                        a = a.split('.');
                        key = a[0].trim();
                        text = a[1].trim();
                        qOptionalAnswer[key] = text;

                        if (checked) {
                            qModelAnswer.push(key);
                        }
                    }

                    qType = $('#Q_Type').val();
                    generateSelectItems(qType, qOptionalAnswer, qModelAnswer);
                    changeContentAndAnswer();

                    layer.close(index);
                },
                function(index) {
                    $('#ModifyAnswer').val('');
                }
            );
        })
        .on('click', ':checkbox', function() {

            changeContentAndAnswer();
        })
        .on('click', ':radio', function() {

            changeContentAndAnswer();
        });

    $('select#Q_Type').on('change', function() {

        showContentAndAnswer();
    });

    // 提交前修改数据
    $('form').submit(function(e) {

        if(confirm('确定提交吗？')){
            
            changeContentAndAnswer();
        }else{

            e.preventDefault();
        }
    });

    function whetherAnswerCheck(qModelAnswer, currentAnswer) {

        for (var i = 0; i < qModelAnswer.length; i++) {
            if (qModelAnswer[i] == currentAnswer)
                return true;
        }

        return false;
    }

    function generateSelectItems(qType, qOptionalAnswer, qModelAnswer) {

        var controlHtml;

        controlHtml = '';
        if (qType == '单选题') {

            for (var p in qOptionalAnswer) {

                controlHtml += '<span class="mr-10"><input type="radio" name="Answer" value="' + p + '" text="' + qOptionalAnswer[p] + '" class="mr-5" ' + (whetherAnswerCheck(qModelAnswer, p) ? 'checked="checked"' : '') + ' />' + p + '.' + qOptionalAnswer[p] + '</span>';
            }
        } else if (qType == '多选题') {

            for (var p in qOptionalAnswer) {

                controlHtml += '<span class="mr-10"><input type="checkbox" name="Answer" value="' + p + '" text="' + qOptionalAnswer[p] + '" class="mr-5" ' + (whetherAnswerCheck(qModelAnswer, p) ? 'checked="checked"' : '') + ' />' + p + '.' + qOptionalAnswer[p] + '</span>';
            }
        }
        controlHtml += '<span class="mr-30"><a id="ModifyAnswerBtn" href="javascript:void();" style="color:#06c;">修改</a></span>';

        $('#SelectItemContainer').html(controlHtml);
    }

    function changeContentAndAnswer() {

        var qType, modelAnswers, answer;

        modelAnswers = [];

        qType = $('#Q_Type').val();
        switch (qType) {
            case '单选题':

                answer = $('input[name="Answer"]:checked').val();
                modelAnswers.push(answer);
                modelAnswers = modelAnswers.length > 0 ? JSON.stringify(modelAnswers) : '';

                $('#Q_Content').val($('[name="Content"]').val());
                $('#Q_OptionalAnswer').val(getOptionalAnswer());
                $('#Q_ModelAnswer').val(modelAnswers);

                break;
            case '多选题':

                $('input[name="Answer"]:checked').each(function() {

                    answer = $(this).val();
                    modelAnswers.push(answer);
                });
                modelAnswers = modelAnswers.length > 0 ? JSON.stringify(modelAnswers) : '';

                $('#Q_Content').val($('[name="Content"]').val());
                $('#Q_OptionalAnswer').val(getOptionalAnswer());
                $('#Q_ModelAnswer').val(modelAnswers);

                break;
            case '判断题':

                answer = $('input[name="Answer"]:checked').val();
                answer = undefined == answer ? '' : answer;

                $('#Q_Content').val($('[name="Content"]').val());
                $('#Q_OptionalAnswer').val(getOptionalAnswer());
                $('#Q_ModelAnswer').val(answer);

                break;
            case '公文改错题':
            case '计算题':
            case '案例分析题':
            case '问答题':
            default:

                $('#Q_Content').val($('[name="Content"]').val());
                $('#Q_ModelAnswer').val($('[name="Answer"]').val());

                break;
        }
    }

    function getOptionalAnswer(json) {

        var container;
        var qType, selector;
        var qOptionalAnswer;

        container = $('#SelectItemContainer');
        qType = $('#Q_Type').val();

        if ('单选题' == qType) {
            selector = ':radio';
        } else if ('多选题' == qType) {
            selector = ':checkbox';
        } else {
            return {};
        }

        qOptionalAnswer = {};
        container.find(selector).each(function() {

            var input;
            var key, text;

            input = $(this);
            key = input.val().trim();
            text = input.attr('text').trim();
            qOptionalAnswer[key] = text;
        });

        return json ? qOptionalAnswer : JSON.stringify(qOptionalAnswer);
    }

    function showContentAndAnswer() {

        var container;
        var templateHtml, controlHtml, validationMessageHtml, html;
        var tmpHtml1;
        var qType, qContent, qOptionalAnswer, qModelAnswer;

        container = $('#QuestionContentAndAnswer');
        container.html('');

        templateHtml =
            '<div class="row cl">' +
            '    <label class="form-label col-2">' +
            '        {Name}' +
            '    </label>' +
            '    <div class="formControls {ColClass}">' +
            '        {Control}' +
            '        {ValidationMessage}' +
            '    </div>' +
            '</div>';

        qType = $('#Q_Type').val();
        qContent = $('#Q_Content').val();
        qOptionalAnswer = $('#Q_OptionalAnswer').val();
        qModelAnswer = $('#Q_ModelAnswer').val();

        switch (qType) {
            case '单选题':

                tmpHtml1 = templateHtml;
                controlHtml = '<textarea id="Content" name="Content" class="textarea" cols="20" rows="2">' + qContent + '</textarea>';
                validationMessageHtml = '<span class="field-validation-valid" data-valmsg-for="Q_Content" data-valmsg-replace="true"></span>';

                tmpHtml1 = tmpHtml1.replace('{Name}', '内容');
                tmpHtml1 = tmpHtml1.replace('{ColClass}', 'col-4');
                tmpHtml1 = tmpHtml1.replace('{Control}', controlHtml);
                html = tmpHtml1.replace('{ValidationMessage}', validationMessageHtml);

                tmpHtml1 = templateHtml;

                qOptionalAnswer = qOptionalAnswer == '' ? [] : $.parseJSON(qOptionalAnswer);
                qModelAnswer = qModelAnswer == '' ? [] : $.parseJSON(qModelAnswer);
                controlHtml = '<div id="SelectItemContainer">';
                for (var p in qOptionalAnswer) {

                    controlHtml += '<span class="mr-10"><input type="radio" name="Answer" value="' + p + '" text="' + qOptionalAnswer[p] + '" class="mr-5" ' + (whetherAnswerCheck(qModelAnswer, p) ? 'checked="checked"' : '') + ' />' + p + '.' + qOptionalAnswer[p] + '</span>';
                }
                controlHtml += '<span class="mr-30"><a id="ModifyAnswerBtn" href="javascript:void();" style="color:#06c;">修改</a></span>';
                controlHtml += '</div>';

                validationMessageHtml = '<span class="field-validation-valid" data-valmsg-for="Q_OptionalAnswer" data-valmsg-replace="true"></span>';
                validationMessageHtml += '<span class="field-validation-valid" data-valmsg-for="Q_ModelAnswer" data-valmsg-replace="true"></span>';

                tmpHtml1 = tmpHtml1.replace('{Name}', '答案');
                tmpHtml1 = tmpHtml1.replace('{ColClass}', 'col-10');
                tmpHtml1 = tmpHtml1.replace('{Control}', controlHtml);
                html += tmpHtml1.replace('{ValidationMessage}', validationMessageHtml);

                container.html(html);

                break;
            case '多选题':

                tmpHtml1 = templateHtml;
                controlHtml = '<textarea id="Content" name="Content" class="textarea" cols="20" rows="2">' + qContent + '</textarea>';
                validationMessageHtml = '<span class="field-validation-valid" data-valmsg-for="Q_Content" data-valmsg-replace="true"></span>';

                tmpHtml1 = tmpHtml1.replace('{Name}', '内容');
                tmpHtml1 = tmpHtml1.replace('{ColClass}', 'col-4');
                tmpHtml1 = tmpHtml1.replace('{Control}', controlHtml);
                html = tmpHtml1.replace('{ValidationMessage}', validationMessageHtml);

                tmpHtml1 = templateHtml;

                qOptionalAnswer = qOptionalAnswer == '' ? [] : $.parseJSON(qOptionalAnswer);
                qModelAnswer = qModelAnswer == '' ? [] : $.parseJSON(qModelAnswer);
                controlHtml = '<div id="SelectItemContainer">';
                for (var p in qOptionalAnswer) {

                    controlHtml += '<span class="mr-10"><input type="checkbox" name="Answer" value="' + p + '" text="' + qOptionalAnswer[p] + '" class="mr-5" ' + (whetherAnswerCheck(qModelAnswer, p) ? 'checked="checked"' : '') + ' />' + p + '.' + qOptionalAnswer[p] + '</span>';
                }
                controlHtml += '<span class="mr-30"><a id="ModifyAnswerBtn" href="javascript:void();" style="color:#06c;">修改</a></span>';
                controlHtml += '</div>';

                validationMessageHtml = '<span class="field-validation-valid" data-valmsg-for="Q_OptionalAnswer" data-valmsg-replace="true"></span>';
                validationMessageHtml += '<span class="field-validation-valid" data-valmsg-for="Q_ModelAnswer" data-valmsg-replace="true"></span>';

                tmpHtml1 = tmpHtml1.replace('{Name}', '答案');
                tmpHtml1 = tmpHtml1.replace('{ColClass}', 'col-10');
                tmpHtml1 = tmpHtml1.replace('{Control}', controlHtml);
                html += tmpHtml1.replace('{ValidationMessage}', validationMessageHtml);

                container.html(html);

                break;
            case '判断题':

                tmpHtml1 = templateHtml;
                controlHtml = '<textarea id="Content" name="Content" class="textarea" cols="20" rows="2">' + qContent + '</textarea>';
                validationMessageHtml = '<span class="field-validation-valid" data-valmsg-for="Q_Content" data-valmsg-replace="true"></span>';

                tmpHtml1 = tmpHtml1.replace('{Name}', '内容');
                tmpHtml1 = tmpHtml1.replace('{ColClass}', 'col-4');
                tmpHtml1 = tmpHtml1.replace('{Control}', controlHtml);
                html = tmpHtml1.replace('{ValidationMessage}', validationMessageHtml);

                tmpHtml1 = templateHtml;
                controlHtml =
                    '<span class="mr-10">' +
                    '<input type="radio" name="Answer" value="√" class="mr-5" ' + ('√' == qModelAnswer ? 'checked="checked"' : '') + ' />√' +
                    '</span>' +
                    '<span class="mr-10">' +
                    '<input type="radio" name="Answer" value="×" class="mr-5" ' + ('×' == qModelAnswer ? 'checked="checked"' : '') + ' />×' +
                    '</span>';
                validationMessageHtml = '<br /><span class="field-validation-valid" data-valmsg-for="Q_OptionalAnswer" data-valmsg-replace="true"></span>';
                validationMessageHtml += '<span class="field-validation-valid" data-valmsg-for="Q_ModelAnswer" data-valmsg-replace="true"></span>';

                tmpHtml1 = tmpHtml1.replace('{Name}', '答案');
                tmpHtml1 = tmpHtml1.replace('{ColClass}', 'col-10');
                tmpHtml1 = tmpHtml1.replace('{Control}', controlHtml);
                html += tmpHtml1.replace('{ValidationMessage}', validationMessageHtml);

                container.html(html);

                break;
            case '公文改错题':
            case '计算题':
            case '案例分析题':
            case '问答题':

                tmpHtml1 = templateHtml;
                qContent = qContent.replace(/\\r\\n/g, '<br />');
                controlHtml = '<script id="UEditorContent" name="Content" type="text/plain" style="width:100%;height:400px;">' + qContent + '</script>';
                validationMessageHtml = '<span class="field-validation-valid" data-valmsg-for="Q_Content" data-valmsg-replace="true"></span>';

                tmpHtml1 = tmpHtml1.replace('{Name}', '内容');
                tmpHtml1 = tmpHtml1.replace('{ColClass}', 'col-10');
                tmpHtml1 = tmpHtml1.replace('{Control}', controlHtml);
                html = tmpHtml1.replace('{ValidationMessage}', validationMessageHtml);

                tmpHtml1 = templateHtml;
                qModelAnswer = qModelAnswer.replace(/\\r\\n/g, '<br />');
                controlHtml = '<script id="UEditorAnswer" name="Answer" type="text/plain" style="width:100%;height:400px;">' + qModelAnswer + '</script>';
                validationMessageHtml = '<span class="field-validation-valid" data-valmsg-for="Q_ModelAnswer" data-valmsg-replace="true"></span>';

                tmpHtml1 = tmpHtml1.replace('{Name}', '答案');
                tmpHtml1 = tmpHtml1.replace('{ColClass}', 'col-10');
                tmpHtml1 = tmpHtml1.replace('{Control}', controlHtml);
                html += tmpHtml1.replace('{ValidationMessage}', validationMessageHtml);

                container.html(html);
                ueContent = UE.getEditor('UEditorContent');
                ueAnswer = UE.getEditor('UEditorAnswer');

                break;
            default:
                break;
        }
    }
});
