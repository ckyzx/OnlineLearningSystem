$(function() {

    var table;
    var status, qcId;

    QueryString.Initial();
    status = QueryString.GetValue('status');
    status = undefined == status ? 1 : status;
    qcId = QueryString.GetValue('qcId');
    qcId = undefined == qcId ? 0 : qcId;


    // 显示“试题缓存导入面板”
    if (4 == status) {

        $('#QuestionImportPanel').show();
    } else {

        $('#FunctionPanel').show();
    }

    table = $('.question-table').DataTable({
        "processing": true,
        "serverSide": true,
        "ajax": {
            "url": "/Question/ListDataTablesAjax",
            "type": "POST",
            "data": {
                status: status,
                qcId: qcId
            }
        },
        "stateSave": false,
        "lengthChange": false,
        "pageLength": 15,
        "ordering": false, 
        "columns": [{
            "width": "10px",
            "className": "text-c",
            "defaultContent": '<input type="checkbox" />'
        }, {
            "width": "30px",
            "name": "Q_Id",
            "data": "Q_Id"
        }, {
            "width": "100px",
            "name": "Q_Type",
            "data": "Q_Type"
        }, {
            "width": "150px",
            "name": "QC_Name",
            "data": "QC_Name"
        }, {
            "name": "Q_Content",
            "defaultContent": '<span class="Q_Content"></span>'
        }, {
            "width": "50px",
            "name": "Q_DifficultyCoefficient",
            "defaultContent": '<span class="select-box size-MINI"><select class="dif-coe select"></select></span>'
        }, {
            "width": "30px",
            "className": "text-r",
            "name": "Q_Score",
            "data": "Q_Score"
        }, {
            "width": "80px",
            "className": "text-c",
            "defaultContent": '<a style="text-decoration: none" class="recycle fz-18 hide" href="javascript:;" title="回收"><i class="Hui-iconfont">&#xe631;</i></a>' +
                '<a style="text-decoration: none" class="resume ml-5 fz-18 hide" href="javascript:;" title="恢复"><i class="Hui-iconfont">&#xe615;</i></a>' +
                '<a style="text-decoration: none" class="edit ml-5 fz-18 hide" href="javascript:;" title="编辑"><i class="Hui-iconfont">&#xe60c;</i></a>' +
                '<a style="text-decoration: none" class="delete ml-5 fz-18 hide" href="javascript:;" title="删除"><i class="Hui-iconfont">&#xe6e2;</i></a>'
        }],
        "createdRow": function(row, data, dataIndex) {

            var span, strDate, date, content, optionalAnswer, modelAnswer, status, coefficient, select;

            row = $(row);

            optionalAnswer = data['Q_OptionalAnswer'];
            if ('{}' == optionalAnswer) {
                row.addClass('question-has-error');
            }

            modelAnswer = data['Q_ModelAnswer'];
            if ('[]' == modelAnswer && !row.hasClass('question-has-error')) {
                row.addClass('question-has-error');
            }

            span = row.find('span.Q_Content');
            content = data['Q_Content'];
            content = content.replace(/\\r\\n/g, '<br />').trim();
            //span.css({'overflow':'hidden','white-space':'nowrap','text-overflow':'ellipsis'});
            span.html(content);

            status = data['Q_Status'];
            switch (status) {
                case 1:
                    row.find('a.recycle').show();
                    row.find('a.edit').show();
                    row.find('a.delete').show();
                    break;
                case 2:
                    row.find('a.resume').show();
                    row.find('a.delete').show();
                    break;
                case 3:
                    break;
                case 4:
                    row.find('a.edit').show();
                    break;
                default:
                    break;
            }

            coefficient = data['Q_DifficultyCoefficient'];
            select = row.find('select.dif-coe');
            select.html(options);
            select.val(coefficient);

        }
    });

    $('.table-sort tbody').on('click', 'a.edit', function() {

        var data, id;

        data = table.row($(this).parents('tr')).data();
        id = data['Q_Id'];

        ShowPage('编辑试题', '/Question/Edit?id=' + id);
    });

    $('.table-sort tbody').on('click', 'a.recycle', function() {

        var tr, data, id;

        tr = $(this).parents('tr');
        data = table.row(tr).data();
        id = data['Q_Id'];

        $.post('/Question/Recycle', {
                id: id
            }, function(data) {

                if (1 == data.status) {

                    tr.fadeOut(function() {

                        tr.remove();
                    });
                } else if (0 == data.status) {

                    alert(data.message);
                }
            }, 'json')
            .error(function() {

                alert('请求返回错误！');
            });
    });

    $('.table-sort tbody').on('click', 'a.resume', function() {

        var tr, data, id;

        tr = $(this).parents('tr');
        data = table.row(tr).data();
        id = data['Q_Id'];

        $.post('/Question/Resume', {
                id: id
            }, function(data) {

                if (1 == data.status) {

                    tr.fadeOut(function() {

                        tr.remove();
                    });
                } else if (0 == data.status) {

                    alert(data.message);
                }
            }, 'json')
            .error(function() {

                alert('请求返回错误！');
            });
    });

    $('.table-sort tbody').on('click', 'a.resume', function() {

        var tr, data, id;

        tr = $(this).parents('tr');
        data = table.row(tr).data();
        id = data['Q_Id'];

        $.post('/Question/Resume', {
                id: id
            }, function(data) {

                if (1 == data.status) {

                    tr.fadeOut(function() {

                        tr.remove();
                    });
                } else if (0 == data.status) {

                    alert(data.message);
                }
            }, 'json')
            .error(function() {

                alert('请求返回错误！');
            });
    });

    $('.table-sort tbody').on('click', 'a.delete', function() {

        var tr, data, id;

        tr = $(this).parents('tr');
        data = table.row(tr).data();
        id = data['Q_Id'];

        $.post('/Question/Delete', {
                id: id
            }, function(data) {

                if (1 == data.status) {

                    tr.fadeOut(function() {

                        tr.remove();
                    });
                } else if (0 == data.status) {

                    alert(data.message);
                }
            }, 'json')
            .error(function() {

                alert('请求返回错误！');
            });
    });

    $('#CreateBtn').on('click', function() {
        ShowPage('添加试题', '/Question/Create');
    });

    $('#DocxUploadBtn').on('click', function() {
        //ShowPageWithSize('导入试题', '/Question/DocxUploadAndImport', 800, 300);
        ShowPage('导入试题', '/Question/DocxUploadAndImport');
    });

    $('#CacheClearBtn').on('click', function() {

        $.post('/Question/CacheClear', {}, function(data) {

                if (1 == data.status) {

                    alert('缓存清除成功。');
                    location.href = '/Question/List';
                } else if (0 == data.status) {

                    alert(data.message);
                }
            }, 'json')
            .error(function() {

                alert('请求返回错误！');
            });
    });

    $('#CacheImportBtn').on('click', function() {

        $.post('/Question/CacheImport', {}, function(data) {

                var message, href;

                if (1 == data.status) {

                    message = '缓存导入成功。';
                    href = '/Question/List?qcId' + qcId;

                    if ('' != data.message) {

                        message += '但含有以下问题：\r\n';
                        message += '    ' + data.message + '\r\n';
                        message += '    请手工检查试题缓存列表。';

                        href += '&status=' + status;
                    }

                    alert(message);
                    location.href = href;
                } else if (0 == data.status) {

                    alert(data.message);
                }
            }, 'json')
            .error(function() {

                alert('请求返回错误！');
            });
    });

    // 初始化难度系数设置框
    var options;

    options = '';

    for (var p in difficultyCoefficient) {
        options += '<option value="' + p + '">' + difficultyCoefficient[p] + '</option>';
    }

    $('.table-sort tbody').on('change', 'select.dif-coe', function() {

        var select, tr, data, id, coefficient;

        select = $(this);
        tr = select.parents('tr');
        data = table.row(tr).data();
        id = data['Q_Id'];

        coefficient = select.val();

        $.post('/Question/SetDifficultyCoefficient', {
                id: id,
                coefficient: coefficient
            }, function(data) {

                if (0 == data.status) {

                    alert(data.message);
                }
            }, 'json')
            .error(function() {

                alert('请求返回错误！');
            });
    });

    var ul;
    var settings, nodes;
    var ztree;

    settings = {
        check: {
            enable: true
        },
        data: {
            simpleData: {
                enable: true
            }
        }
    };

    ul = $('.question-classify-list-container ul');
    nodes = ul.attr('data-value');
    nodes = $.parseJSON(nodes);

    for (var i = 0; i < nodes.length; i++) {

        n = nodes[i];

        if(n.questionClassifyId == qcId){

            n.checked = true;
        }

        n.click = 'location.href = \'/Question/List?status='+status+'&qcId='+n.questionClassifyId+'\';';
    };

    // 添加根节点“全部”
    nodes = [{
        name: '全部', 
        questionClassifyId: 0, 
        open: true, 
        click: 'location.href = \'/Question/List?status='+status+'&qcId=0\';',
        children: nodes
    }];

    if(0 == qcId){

        nodes[0].checked = true;
    }

    ztree = $.fn.zTree.init(ul, settings, nodes);

});

var difficultyCoefficient;

difficultyCoefficient = {
    0: 0,
    1: 1,
    2: 2,
    3: 3,
    4: 4,
    5: 5,
    6: 6,
    7: 7,
    8: 8,
    9: 9
};
