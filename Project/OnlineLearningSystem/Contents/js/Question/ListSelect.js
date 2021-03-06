$(function() {

    'use strict';

    var tableSelector, valueSelector;

    tableSelector = '.question-table';
    valueSelector = $(tableSelector).attr('value-selector');

    // 取消试题复选时，清除试题数据
    $('.question-table').on('change', ':checkbox', function() {

        var checkbox, id, hidden, questions, checkStatus, checked;
        var countSpan;

        checkbox = $(this);
        id = checkbox.val();

        hidden = $(valueSelector);
        questions = hidden.val();

        if ('all' == id) {

            checkStatus = GetDataTablesAllCheckStatus1(tableSelector, $(':checkbox[value=all]').get(0).checked);

            // 去除复选项
            for (var i = 0; i < checkStatus[1].length; i++) {

                questions =
                    questions
                    .replace('"' + checkStatus[1][i] + '"', '')
                    .replace('[,', '[')
                    .replace(',]', ']')
                    .replace(',,', ',');
            }

            // 添加复选项
            checked = [];
            for (var i = 0; i < checkStatus[0].length; i++) {

                if (questions.indexOf('"' + checkStatus[0][i] + '"') == -1) {

                    checked.push(checkStatus[0][i]);
                }
            }
            questions = $.parseJSON(questions);
            questions = questions.concat(checked);
            questions = JSON.stringify(questions);
        } else if (checkbox.get(0).checked && questions.indexOf('"' + id + '"') == -1) {

            questions = $.parseJSON(questions);
            questions.push(id);
            questions = JSON.stringify(questions);
        } else if (!checkbox.get(0).checked) {

            questions =
                questions
                .replace('"' + id + '"', '')
                .replace('[,', '[')
                .replace(',]', ']')
                .replace(',,', ',');
        }

        // 显示已选数据数量
        Kyzx.List.renderSelectCount($(tableSelector).parent(), JSON.parse(questions).length);

        hidden.val(questions);
    });

    initQuestionSelectTable();

});

function initQuestionSelectTable() {

    'use strict';

    var params;
    var jqTable, dataTableObj;
    var valueSelector;

    params = {
        "processing": true,
        "serverSide": true,
        "ajax": {
            "url": "/Question/ListDataTablesAjax",
            "type": "POST"
        },
        "stateSave": false,
        "pageLength": 10,
        "ordering": false,
        "columns": [{
            "width": "10px",
            "className": "text-c",
            "defaultContent": '<input type="checkbox" />'
        }, {
            "width": "30px",
            "name": "Q_Id",
            "className": "Q_Id",
            "data": "Q_Id"
        }, {
            "width": "100px",
            "name": "Q_Type",
            "defaultContent": '<span class="Q_Type"></span>'
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
            "data": 'Q_DifficultyCoefficient'
        }, {
            "width": "30px",
            "className": "text-r",
            "name": "Q_Score",
            "data": "Q_Score"
        }],
        "createdRow": function(row, data, dataIndex) {

            var checkbox, id;
            var span, th;
            var qType, qcName, qContent;

            row = $(row);

            checkbox = row.find(':checkbox');
            id = data['Q_Id'];
            checkbox.val(id);

            th = jqTable.find('th.Q_Type');
            span = row.find('span.Q_Type');
            qType = data['Q_Type'];
            span.addClass('ellipsis').width(th.width()).text(qType);

            th = jqTable.find('th.QC_Name');
            span = row.find('span.QC_Name');
            qcName = data['QC_Name'];
            span.addClass('ellipsis').width(th.width()).text(qcName);

            th = jqTable.find('th.Q_Content');
            span = row.find('span.Q_Content');
            qContent = data['Q_Content'];
            qContent = qContent.replace(/^(\\r\\n)+/g, '').replace(/(\\r\\n)+$/g, '').replace(/\\r\\n/g, '[换行]').replace(/\s+/g,'');
            span.addClass('ellipsis').width(th.width()).html(qContent).attr('title', qContent);
        },
        /*"footerCallback": function(settings, json) {

            SetDataTablesChecked('.question-table', valueSelector);
        },*/
        'initComplete': function(settings, json) {

            SetDataTablesChecked('.question-table', valueSelector);
        },
        'drawCallback': function(settings){

            SetDataTablesChecked('.question-table', valueSelector);
            Kyzx.List.resetId(this.api(), 'Q_Id');
        }
    };

    jqTable = $('.question-table');
    valueSelector = jqTable.attr('value-selector');

    dataTableObj = jqTable.DataTable(params);

    initQuestionClassifyTree(dataTableObj);
}

function initQuestionClassifyTree(dataTableObj){

    var ul, inputSelected;
    var settings, nodes, n, qcId;
    var ztree;

    inputSelected = $('.question-classify-list-container input[data-value=QuestionClassifySelected]');
    qcId = inputSelected.val();
    qcId = qcId == undefined ? 0 : qcId;

    /*dataTableObj.settings().ajax.data = function(originData){
        return $.extend({}, originData, {qcId: inputSelected.val()});
    };*/

    settings = {
        check: {
            enable: false
        },
        data: {
            simpleData: {
                enable: true
            }
        },
        view: {
            fontCss: function(treeId, treeNode) {
                if (treeNode.ifChecked) {
                    return { background: '#4185E0', color: '#FFF', 'border-radius': '2px' }
                }
            }
        },
        callback: {
            onClick: function(event, treeId, treeNode, clickFlag){

                var qcId, nodes, n;

                qcId = treeNode.questionClassifyId;
                dataTableObj.ajax.url('/Question/ListDataTablesAjax?qcId=' + qcId).load(null, true);

                nodes = $.fn.zTree.getZTreeObj(treeId).getNodes();
                if(qcId == 0){
                    nodes[0].ifChecked = true;
                }else{
                    nodes[0].ifChecked = false;
                }

                for (var i = 0; i < nodes[0].children.length; i++) {
                    n = nodes[0].children[i];
                    if (n.questionClassifyId == qcId) {
                        n.ifChecked = true;
                    }else{
                        n.ifChecked = false;
                    }
                };

                $.fn.zTree.destroy(treeId)
                ztree = $.fn.zTree.init(ul, settings, nodes);
            }
        }
    };

    ul = $('.question-classify-list-container ul');
    ul.attr('id', 'ZTree_' + (new Date()).getTime());
    nodes = ul.attr('data-value');
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

    if(0 == qcId){
        nodes[0].ifChecked = true;
    }

    ztree = $.fn.zTree.init(ul, settings, nodes);
}
