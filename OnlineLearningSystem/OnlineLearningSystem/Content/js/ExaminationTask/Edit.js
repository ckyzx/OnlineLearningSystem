$(function() {

    var dus, ztree, settings, nodes, setNodeChecked, getNodeId;
    var userIds, userNames, departmentIds, departmentNames;

    dus = $('#DepartmentsAndUsers');

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

    nodes = dus.attr('value');
    nodes = $.parseJSON(nodes);

    userIds = $('#ET_Attendee').val();
    userIds = $.parseJSON(userIds);
    departmentIds = $('#ET_ParticipatingDepartment').val();
    departmentIds = $.parseJSON(departmentIds);

    setNodeChecked = function(ztree, nodes, departmentIds, userIds) {

        var checkedCount;

        checkedCount = 0;
        for (var i = 0; i < nodes.length; i++) {

            for (var i1 = 0; i1 < userIds.length; i1++) {

                for (var i2 = 0; i2 < departmentIds.length; i2++) {

                    if (departmentIds[i2] == nodes[i].departmentId && userIds[i1] == nodes[i].userId) {

                        //nodes[i].checked = true;
                        ztree.checkNode(nodes[i], true, true);
                        checkedCount += 1;
                    } else {

                        ztree.checkNode(nodes[i], false, true);
                    }
                }
            }

            if (nodes[i].children != undefined) {

                //nodes[i].checked = setNodeChecked(ztree, nodes[i].children, departmentIds, userIds);
                checked = setNodeChecked(ztree, nodes[i].children, departmentIds, userIds);
                ztree.checkNode(nodes[i], checked, true);
            }
        }

        if (nodes.length == checkedCount) {
            return true;
        }

        return false;
    };

    ztree = $.fn.zTree.init(dus, settings, nodes);

    nodes = ztree.getNodes();
    setNodeChecked(ztree, nodes, departmentIds, userIds);

    getNodeId = function(nodes) {

        for (var i = 0; i < nodes.length; i++) {

            if (nodes[i].checked) {

                if (nodes[i].userNode) {

                    userIds.push(nodes[i].userId);
                    userNames.push(nodes[i].name);
                } else {

                    departmentIds.push(nodes[i].departmentId);
                    departmentNames.push(nodes[i].name);
                }
            }

            if (nodes[i].children != undefined) {

                getNodeId(nodes[i].children);
            }
        }
    };

    $('form').submit(function() {

        userIds = [];
        userNames = [];
        departmentIds = [];
        departmentNames = [];
        nodes = ztree.getNodes();

        getNodeId(nodes);

        $('#ET_ParticipatingDepartment').val(JSON.stringify(departmentIds));
        $('#ET_Attendee').val(JSON.stringify(userIds));
    });

    $('#ET_Template').on('change', function() {

        var select, template, departmentIds, userIds;
        var ztree;

        select = $(this);
        template = select.val();
        template = $.parseJSON(template);

        $('#ET_Type').val(template.ETT_Type);
        $('#ET_Mode').val(template.ETT_Mode);
        $('#ET_DifficultyCoefficient').val(template.ETT_DifficultyCoefficient);
        $('#ET_ParticipatingDepartment').val(template.ETT_ParticipatingDepartment);
        $('#ET_Attendee').val(template.ETT_Attendee);
        $('#ET_AutoType').val(template.ETT_AutoType);
        $('#ET_StartTime').val(template.ETT_StartTime);
        $('#ET_EndTime').val(template.ETT_EndTime);
        $('#ET_TimeSpan').val(template.ETT_TimeSpan);

        departmentIds = $.parseJSON(template.ETT_ParticipatingDepartment);
        userIds = $.parseJSON(template.ETT_Attendee);

        // 设置节点选中
        ztree = $.fn.zTree.getZTreeObj("DepartmentsAndUsers");
        nodes = ztree.getNodes();
        setNodeChecked(ztree, nodes, departmentIds, userIds);
    });

    $('#ET_AutoType').on('change', function() {

        var container;
        var table;

        container = $('#QuestionListSelectContainer');

        table = $('.question-table').DataTable();
        table.destroy();

        if ($(this).val() != 0) {

            container.show();

            initQuestionSelectTable();

        }else{
            container.hide();
        }
    });

    $('#ET_AutoType').change();
});

var AutoType;

AutoType = {
    0: '手动',
    1: '每日',
    2: '每周',
    3: '每月'
};
