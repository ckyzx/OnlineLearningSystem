$(function() {

    var eptId;
    var container, eptIdInput, uIdInput, epIdInput;

    QueryString.Initial();
    eptId = QueryString.GetValue('eptId');

    eptIdInput = $('<input type="hidden" id="EPT_Id" />').val(eptId);
    uIdInput = $('<input type="hidden" id="U_Id" />').val(0);
    epIdInput = $('<input type="hidden" id="EP_Id" />').val(0);

    container = $('#ExaminationPaperGradeContainer');
    container.append(eptIdInput);
    container.append(uIdInput);
    container.append(epIdInput);

    renderUserList();

    initButtonEvent();
    /*----------------------------------------------------------------------*/

    function renderUserList() {

        _loadUserList();

        _clickUserItem();
    }

    function _loadUserList() {

        $.post('/ExaminationPaperTemplate/GetUsers', {
                    id: eptId
                },
                function(data) {

                    if (1 == data.status) {

                        data.data = JSON.parse(data.data);
                        $('#UserItemTmpl').tmpl(data.data).appendTo('#UserList ul');

                        $('#UserList li h4').first().click();
                    } else {

                        alert(data.message);
                    }
                }, 'json')
            .error(function() {

                alert('请求返回错误！');
            });
    }

    function _clickUserItem() {

        var list, h4s;

        list = $('#UserList');

        list.on('click', 'li h4', function() {

            var h4, li, uIdInput;
            var uId, currentUId;

            h4 = $(this);
            li = h4.parent();
            uIdInput = $('#U_Id');

            uId = li.attr('data-user-id');
            currentUId = uIdInput.val();

            if (uId == currentUId) {
                return;
            }

            __gradeEvent();

            $('#U_Id').val(uId);

            list.find('li h4.active').removeClass('active');
            h4.addClass('active');

            __renderPaper();
        });
    }
    /*--------------------------------------------------*/

    function __gradeEvent() {

        var paperContainer, epIdInput, uIdInput, gradeJsonInput;
        var epId, uId, grades;

        epIdInput = $('#EP_Id');
        uIdInput = $('#U_Id');

        epId = epIdInput.val();
        uId = uIdInput.val();

        paperContainer = $('#Paper_' + epId);
        gradeJsonInput = $('#GradeJson_' + epId);

        grades = [];
        paperContainer.find('.question').each(function() {

            var eptqId, grade;

            eptqId = $(this).attr('data-eptq-id');
            grade = $('input[name=question_radios_' + eptqId + '_grade]:checked').val();
            grade = undefined == grade ? 0 : grade;
            grade = {
                EPTQ_Id: eptqId,
                EP_Id: epId,
                EPQ_Exactness: grade
            };

            grades.push(grade);
        });

        if (grades.length == 0) {
            return;
        }

        grades = JSON.stringify(grades);

        $.post('/ExaminationPaperTemplate/Grade', {
                gradeJson: grades
            }, function(data) {

                var userList, h4, scoreSpan;
                var eps;

                if (1 == data.status) {

                    userList = $('#UserList');
                    userList.find('li[data-user-id=' + uId + '] h4').addClass('done');

                    // 呈现分数
                    eps = JSON.parse(data.data);
                    for (var i = 0; i < eps.length; i++) {

                        ep = eps[i];

                        h4 = userList.find('li[data-user-id=' + ep.EP_UserId + '] h4');
                        scoreSpan = h4.find('span.score');
                        if (scoreSpan.length == 0) {
                            h4.append('<span class="score">' + ep.EP_Score + '</span>');
                        }else{
                            scoreSpan.text(ep.EP_Score);
                        }
                    };

                    layer.msg('评分提交成功', {offset: '100px'});
                } else if (0 == data.status) {

                    gradeJsonInput.val(grades);
                    alert(data.message);
                }
            }, 'json')
            .error(function() {

                gradeJsonInput.val(grades);
                alert('请求返回错误！');
            });
    }

    function __renderPaper() {

        var eptId, epId, uId;

        eptId = $('#EPT_Id').val();
        epId = $('#EP_Id').val();
        uId = $('#U_Id').val();

        $.post('/ExaminationPaperTemplate/GetQuestions', {
                id: eptId,
                uId: uId
            }, function(data) {

                var paperContainer, epIdInput, uIdInput, gradeJsonInput;
                var questions, answers, paperData;

                paperContainer = $('#PaperContainer');
                epIdInput = $('#EP_Id');
                uIdInput = $('#U_Id');

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

                    $('#PaperTmpl').tmpl(paperData).appendTo(paperContainer);

                    // 在本地保存考题数据
                    initLocalQuestions('#PaperContainer', questions, answers);

                    epIdInput.val(epId);

                    gradeJsonInput = $('#GradeJson_' + epId);
                    if (gradeJsonInput.length == 0) {
                        gradeJsonInput = $('<input type="hidden" id="GradeJson_' + epId + '" />').val('[]');
                        $('#ExaminationPaperGradeContainer').append(gradeJsonInput);
                    }

                    ___changeButtonStatus();

                } else {

                    epIdInput.val(0);
                    uIdInput.val(0);

                    paperContainer.html('<div class="prompt">' + data.message.replace(/。/g, '') + '</div>');
                }
            }, 'json')
            .error(function() {

                alert('请求返回错误！');
            });
    }

    function ___changeButtonStatus() {

        var li;

        li = $('#UserList li h4.active').parent();

        $('button').removeClass('disabled');

        if (li.prev().length == 0) {
            $('#PrevPaper').addClass('disabled');
        }

        if (li.next().length == 0) {
            $('#NextPaper').addClass('disabled');
        }
    }
    /*--------------------------------------------------*/

    function initButtonEvent() {

        container.on('click', '#PrevPaper', _prevPaper);

        container.on('click', '#NextPaper', _nextPaper);

        container.on('click', '#Grade', __gradeEvent);

        container.on('click', '#GradeFinish', _gradeFinish);
    }

    function _prevPaper(elem) {

        var btn, h4, li, prevLi;

        btn = $(elem);
        h4 = $('#UserList li h4.active');
        li = h4.parent();
        prevLi = li.prev();

        if (prevLi.length == 0) {
            return;
        }

        prevLi.find('h4').click();
    }

    function _nextPaper(elem) {

        var btn, h4, li, nextLi;

        btn = $(elem);
        h4 = $('#UserList li h4.active');
        li = h4.parent();
        nextLi = li.next();

        if (nextLi.length == 0) {
            return;
        }

        nextLi.find('h4').click();
    }

    function _gradeFinish() {}
});
