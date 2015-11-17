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

    userIds = $('#ETT_Attendee').val();
    userIds = $.parseJSON(userIds);
    departmentIds = $('#ETT_ParticipatingDepartment').val();
    departmentIds = $.parseJSON(departmentIds);

    setNodeChecked = function(nodes) {

        var checkedCount;

        checkedCount = 0;
        for (var i = 0; i < nodes.length; i++) {

            for (var i1 = 0; i1 < userIds.length; i1++) {

                for (var i2 = 0; i2 < departmentIds.length; i2++) {

                    if (departmentIds[i2] == nodes[i].departmentId && userIds[i1] == nodes[i].userId) {

                        nodes[i].checked = true;
                        checkedCount += 1;
                    }
                }
            }

            if (nodes[i].children != undefined) {

                nodes[i].checked = setNodeChecked(nodes[i].children);
            }
        }

        if (nodes.length == checkedCount) {
            return true;
        }
    };

    setNodeChecked(nodes);

    ztree = $.fn.zTree.init(dus, settings, nodes);

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

        $('#ETT_ParticipatingDepartment').val(JSON.stringify(departmentIds));
        $('#ETT_Attendee').val(JSON.stringify(userIds));
    });
});
