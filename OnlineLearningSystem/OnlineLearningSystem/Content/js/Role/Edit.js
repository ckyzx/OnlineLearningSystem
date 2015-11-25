$(function() {

    var ps, ztree, settings, nodes, setNodeChecked, getNodeId;
    var permissionIds, permissionNames, permissionCategoryIds, permissionCategoryNames;

    ps = $('#Permissions');

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

    nodes = ps.attr('value');
    nodes = $.parseJSON(nodes);

    permissionIds = $('#R_Permissions').val();
    permissionIds = $.parseJSON(permissionIds);
    permissionCategoryIds = $('#R_PermissionCategories').val();
    permissionCategoryIds = $.parseJSON(permissionCategoryIds);

    setNodeChecked = function(nodes) {

        var checkedCount;

        checkedCount = 0;
        for (var i = 0; i < nodes.length; i++) {

            for (var i1 = 0; i1 < permissionIds.length; i1++) {

                for (var i2 = 0; i2 < permissionCategoryIds.length; i2++) {

                    if (permissionCategoryIds[i2] == nodes[i].permissionCategoryId && permissionIds[i1] == nodes[i].permissionId) {

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

    ztree = $.fn.zTree.init(ps, settings, nodes);

    getNodeId = function(nodes) {

        for (var i = 0; i < nodes.length; i++) {

            if (nodes[i].checked) {

                if (nodes[i].permissionNode) {

                    permissionIds.push(nodes[i].permissionId);
                    permissionNames.push(nodes[i].name);
                } else {

                    permissionCategoryIds.push(nodes[i].permissionCategoryId);
                    permissionCategoryNames.push(nodes[i].name);
                }
            }

            if (nodes[i].children != undefined) {

                getNodeId(nodes[i].children);
            }
        }
    };

    $('form').submit(function(e) {

        if(!confirm('确定提交吗？')){
            
            e.preventDefault();
            return;
        }

        permissionIds = [];
        permissionNames = [];
        permissionCategoryIds = [];
        permissionCategoryNames = [];
        nodes = ztree.getNodes();

        getNodeId(nodes);

        $('#R_Permissions').val(JSON.stringify(permissionIds));
        $('#R_PermissionCategories').val(JSON.stringify(permissionCategoryIds));
    });
});
