$(function() {

    'use strict';

    var status, qcId;
    var params;
    var recycleBin;
    var jqTable, dataTables;
    var list;

    Request.init();
    status = Request.getValue('status', 1);
    qcId = Request.getValue('qcId', 0);

    params = {
        "processing": true,
        "serverSide": true,
        "ajax": {
            "url": "/Question/ListDataTablesAjax",
            "type": "POST"
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
            "className": "QC_Name",
            "defaultContent": '<span class="QC_Name"></span>'
        }, {
            "name": "Q_Content",
            "className": "Q_Content",
            "defaultContent": '<span class="Q_Content"></span>'
        }, {
            "width": "50px",
            "name": "Q_DifficultyCoefficient",
            "defaultContent": '<span class="select-box size-MINI"><select class="dif-coe select"></select></span>'
        }, {
            "width": "40px",
            "className": "text-r",
            "name": "Q_Score",
            "defaultContent": '<span class="size-MINI"><input type="text" class="score input-text" /></span>'
        }, {
            "className": "text-c nowrap",
            "defaultContent": '<a class="recycle mr-5 fz-18 hide" href="javascript:void(0);" title="回收"><i class="Hui-iconfont">&#xe631;</i></a>' +
                '<a class="resume mr-5 fz-18 hide" href="javascript:void(0);" title="恢复"><i class="Hui-iconfont">&#xe615;</i></a>' +
                '<a class="edit mr-5 fz-18 hide" href="javascript:void(0);" title="编辑"><i class="Hui-iconfont">&#xe60c;</i></a>' +
                '<a class="delete mr-5 fz-18 hide" href="javascript:void(0);" title="删除"><i class="Hui-iconfont">&#xe6e2;</i></a>'
        }],
        "createdRow": function(row, data, dataIndex) {

            var span, select, input, th;
            var qcName, qContent, optionalAnswer, modelAnswer, status, coefficient, score;

            row = $(row);

            optionalAnswer = data['Q_OptionalAnswer'];
            if ('{}' == optionalAnswer) {
                row.addClass('question-has-error');
            }

            modelAnswer = data['Q_ModelAnswer'];
            if ('[]' == modelAnswer && !row.hasClass('question-has-error')) {
                row.addClass('question-has-error');
            }

            qcName = data['QC_Name'];
            Kyzx.List.columnContentEllipsis(jqTable, row, '.QC_Name', qcName);

            /*th = jqTable.find('th.Q_Content');
            span = row.find('span.Q_Content');
            qContent = qContent.replace(/^(\\r\\n)+/g, '').replace(/(\\r\\n)+$/g, '').replace(/\\r\\n/g, '[换行]').replace(/\s+/g, '');
            span.addClass('ellipsis').width(th.width()).html(qContent).attr('title', qContent);*/
            qContent = data['Q_Content'];
            Kyzx.List.columnContentEllipsis(jqTable, row, '.Q_Content', qContent);

            status = data['Q_Status'];
            switch (status) {
                case 1:
                    row.find('a.recycle').removeClass('hide');
                    row.find('a.edit').removeClass('hide');
                    break;
                case 2:
                    row.find('a.resume').removeClass('hide');
                    row.find('a.delete').removeClass('hide');
                    break;
                case 3:
                    break;
                case 4:
                    row.find('a.edit').removeClass('hide');
                    break;
                default:
                    break;
            }

            coefficient = data['Q_DifficultyCoefficient'];
            select = row.find('select.dif-coe');
            select.html(options);
            select.val(coefficient);

            score = data['Q_Score'];
            input = row.find('input.score');
            input.val(score);

        }
    };

    // 显示“试题缓存导入面板”
    if (4 == status) {

        $('#QuestionImportPanel').removeClass('hide');

        params.ajax.data = {
            status: status,
            qcId: qcId
        };
    } else {

        $('#FunctionPanel').removeClass('hide');

        // 添加回收站
        recycleBin = $('<a id="RecycleBin" class="btn btn-success radius r mr-5" style="line-height:1.6em;margin-top:3px" href="javascript:void(0);">回收站</a>');
        $('nav.breadcrumb').append(recycleBin);
        recycleBin.attr('data-status', status);
        recycleBin.on('click', function() {

            var status;

            status = recycleBin.attr('data-status');

            if (1 == status) {

                status = 2;
                recycleBin.text('返回列表');
                recycleBin.removeClass('btn-success');
                recycleBin.addClass('btn-primary');
            } else if (2 == status) {

                status = 1;
                recycleBin.text('回收站');
                recycleBin.removeClass('btn-primary');
                recycleBin.addClass('btn-success');
            }

            recycleBin.attr('data-status', status);
            dataTables.ajax.reload(null, false);
        });

        params.ajax.data = function(originData) {

            return $.extend({}, originData, {
                status: recycleBin.attr('data-status'),
                qcId: qcId
            });
        }
    }

    jqTable = $('.question-table');
    dataTables = $('.question-table').DataTable(params);

    list = Kyzx.List.init({
        modelCnName: '试题',
        modelEnName: 'Question',
        modelPrefix: 'Q_'
    });
    list.jqTable = jqTable;
    list.dataTables = dataTables;
    list._initListEvent();

    $('#CreateBtn').on('click', function() {
        ShowPage('添加试题', '/Question/Create');
    });

    $('#DocxUploadBtn').on('click', function() {
        ShowPage('导入试题', '/Question/DocxUploadAndImport');
    });

    $('#CacheClearBtn').on('click', function() {

        var layerIndex;

        layerIndex = layer.load(0, {
            shade: [0.3, '#FFF']
        });

        $.post('/Question/CacheClear', {}, function(data) {

                layer.close(layerIndex);

                if (1 == data.status) {

                    alert('缓存清除成功。');
                    location.href = '/Question/List';
                } else if (0 == data.status) {

                    alert(data.message);
                }
            }, 'json')
            .error(function() {

                layer.close(layerIndex);
                alert('请求返回错误！');
            });
    });

    $('#CacheImportBtn').on('click', function() {

        var layerIndex;

        layerIndex = layer.load(0, {
            shade: [0.3, '#FFF']
        });

        $.post('/Question/CacheImport', {}, function(data) {

                var message, href;

                layer.close(layerIndex);

                if (1 == data.status) {

                    message = '缓存导入成功。';
                    href = '/Question/List?qcId=' + qcId;

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

                layer.close(layerIndex);
                alert('请求返回错误！');
            });
    });


    // 初始化难度系数设置框
    var options;

    options = '';
    for (var p in DifficultyCoefficient) {
        options += '<option value="' + p + '">' + DifficultyCoefficient[p] + '</option>';
    }

    $('.question-table tbody').on('change', 'select.dif-coe', function() {

        var select, tr, data, id, coefficient;

        select = $(this);
        tr = select.parents('tr');
        data = dataTables.row(tr).data();
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

    // 初始化分数设置框
    $('.question-table tbody').on('change', 'input.score', function() {

        var input, tr;
        var data, id, score;

        input = $(this);
        tr = input.parents('tr');
        data = dataTables.row(tr).data();
        id = data['Q_Id'];

        score = input.val();

        $.post('/Question/SetScore', {
                id: id,
                score: score
            }, function(data) {

                if (0 == data.status) {

                    alert(data.message);
                }
            }, 'json')
            .error(function() {

                alert('请求返回错误！');
            });
    });


    // 初始化分类列表
    var ul;
    var settings, nodes, n;
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

        if (n.questionClassifyId == qcId) {

            n.checked = true;
        }

        n.click = 'location.href = \'/Question/List?status=' + status + '&qcId=' + n.questionClassifyId + '\';';
    };

    // 添加根节点“全部”
    nodes = [{
        name: '全部',
        questionClassifyId: 0,
        open: true,
        click: 'location.href = \'/Question/List?status=' + status + '&qcId=0\';',
        children: nodes
    }];

    if (0 == qcId) {

        nodes[0].checked = true;
    }

    ztree = $.fn.zTree.init(ul, settings, nodes);

});
