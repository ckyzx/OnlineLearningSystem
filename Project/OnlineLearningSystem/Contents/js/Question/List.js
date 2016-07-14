$(function() {

    'use strict';

    var status, qcId;
    var params;
    var qcIdInput, recycleBin;
    var jqTable, dataTables;
    var list;
    var addTree, reloadTreeData;

    addTree = function() {

        var ul;
        var settings, nodes, n;
        var ztree;

        settings = {
            check: {
                enable: false
            },
            data: {
                simpleData: {
                    enable: true
                }
            },
            callback: {
                onClick: function(event, treeId, treeNode) {
                    $('a[id!=' + treeNode.tId + '_a]').removeClass('curSelectedNode');
                    $('#QCId').val(treeNode['questionClassifyId']);
                    list.dataTables.ajax.reload(null, true);
                }
            }
        };

        ul = $('.question-classify-list-container ul');
        ul.attr('id', 'ZTree_' + (new Date()).getTime());
        nodes = ul.attr('data-ztree-json');
        nodes = $.parseJSON(nodes);

        for (var i = 0; i < nodes.length; i++) {

            n = nodes[i];

            if (n.questionClassifyId == qcId) {

                n.ifChecked = true;
            }
        };

        // 添加根节点“全部”
        nodes = [{
            name: '全部',
            questionClassifyId: 0,
            open: true,
            children: nodes
        }];

        if (0 == qcId) {
            nodes[0].ifChecked = true;
        }

        ztree = $.fn.zTree.init(ul, settings, nodes);
        Kyzx.List._setZTreeCheck(ztree);
    };
    reloadTreeData = function(url, status) {

        $.post(url, { status: status }, function(data) {

            var ul;

            if (data.status == 1) {
                $('ul.ztree').attr('data-ztree-json', data.data);
                addTree();
            } else if (data.status == 0) {
                alert(data.message);
            }

        }, 'json');
    };

    Request.init();
    status = Request.getValue('status', 1);
    qcId = Request.getValue('qcId', 0);

    qcIdInput = $('<input type="hidden" id="QCId" value="' + qcId + '" />');
    $('nav.breadcrumb').append(qcIdInput);

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
            "className": 'Q_Id',
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
            if (('[]' == modelAnswer || 'O' == modelAnswer ) && !row.hasClass('question-has-error')) {
                row.addClass('question-has-error');
            }

            qcName = data['QC_Name'];
            Kyzx.List.columnContentEllipsis(jqTable, row, '.QC_Name', qcName);

            /*th = jqTable.find('th.Q_Content');
            span = row.find('span.Q_Content');
            qContent = qContent.replace(/^(\\r\\n)+/g, '').replace(/(\\r\\n)+$/g, '').replace(/\\r\\n/g, '[换行]').replace(/\s+/g, '');
            span.addClass('ellipsis').width(th.width()).html(qContent).attr('title', qContent);*/
            qContent = data['Q_Content'];
            qContent = qContent
                .replace(/^(\\r\\n)+/g, '')
                .replace(/(\\r\\n)+$/g, '')
                .replace(/\\r\\n/g, '[换行]')
                .replace(/\s+/g, '')
                .replace(/\<\/*\w+\>/g, '');
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

            // 添加复选框的值为试题编号
            row.find(':checkbox').val(data['Q_Id']);

        },
        "drawCallback": function() {

            var api;
            api = this.api();
            Kyzx.List.resetId(api, 'Q_Id');
        }
    };

    // 显示“试题缓存导入面板”
    if (4 == status) {

        $('#QuestionImportPanel').removeClass('hide');

        /*params.ajax.data = {
            status: status,
            qcId: qcId
        };*/
        params.ajax.data = function(originData){

            return $.extend({}, originData, {
                status: status,
                qcId: qcIdInput.attr('value')
            });
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
            qcIdInput.attr('value', 0);
            dataTables.ajax.reload(null, true);

            reloadTreeData('/QuestionClassify/GetZTreeResJson', status);
            Kyzx.List._showControlBtn(status);

        });

        params.ajax.data = function(originData) {

            return $.extend({}, originData, {
                status: recycleBin.attr('data-status'),
                qcId: qcIdInput.attr('value')
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

        var url;

        url = '/Question/Create';
        if (qcId != 0) {
            url += '?qcId=' + qcId;
        }

        Kyzx.Utility.redirect('添加试题', url);
    });

    $('#DocxUploadBtn').on('click', function() {
        Kyzx.Utility.redirect('导入试题', '/Question/DocxUploadAndImport');
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
    addTree();

    // 添加控制按钮
    Kyzx.List._addBatchControlBtn();
    Kyzx.List._showControlBtn(status)

    /*$('body').append('<button id="reload" style="position:absolute;">刷新</button>');
    $('#reload').on('click',function(){
        $('.question-table').dataTable().api().ajax.reload(null, false);    
    });*/
});
