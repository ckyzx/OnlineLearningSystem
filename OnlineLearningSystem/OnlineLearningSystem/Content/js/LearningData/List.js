$(function() {

    var dtParams, list;

    dtParams = {
        "processing": true,
        "serverSide": true,
        "ajax": {
            "url": "/LearningData/ListDataTablesAjax",
            "type": "POST"
        },
        "stateSave": false,
        "lengthChange": false,
        "pageLength": 15,
        "ordering": false,
        "columns": [{
            "width": "10px",
            "className": "text-c",
            "defaultContent": '<input type="checkbox" value="" name="">'
        }, {
            "width": "30px",
            "name": "LD_Id",
            "data": "LD_Id"
        }, {
            "name": "LD_Title",
            "data": "LD_Title"
        }, {
            "name": "LD_AddTime",
            "defaultContent": '<span class="LD_AddTime"></span>'
        }, {
            "width": "40%",
            "name": "LD_Remark",
            "data": 'LD_Remark'
        }, {
            "className": "text-c nowrap",
            "defaultContent": 
                '<a class="view mr-5 fz-16" href="javascript:void(0);" title="查看"><i class="Hui-iconfont">&#xe626;</i></a>' +
                '<a class="recycle mr-5 fz-18 hide" href="javascript:void(0);" title="回收"><i class="Hui-iconfont">&#xe631;</i></a>' +
                '<a class="resume mr-5 fz-18 hide" href="javascript:void(0);" title="恢复"><i class="Hui-iconfont">&#xe615;</i></a>' +
                '<a class="edit mr-5 fz-18 hide" href="javascript:void(0);" title="编辑"><i class="Hui-iconfont">&#xe60c;</i></a>' +
                '<a class="delete mr-5 fz-18 hide" href="javascript:void(0);" title="删除"><i class="Hui-iconfont">&#xe6e2;</i></a>' +
                '<a class="btn btn-primary radius size-MINI sort-top mr-5 fz-9 hide" href="javascript:void(0);">置顶</a>' +
                '<a class="btn btn-primary radius size-MINI sort-up mr-5 fz-9 hide" href="javascript:void(0);">上移</a>' +
                '<a class="btn btn-primary radius size-MINI sort-down mr-5 fz-9 hide" href="javascript:void(0);">下移</a>'
        }],
        "createdRow": function(row, data, dataIndex) {

            var span;
            var strDate, date, status;

            row = $(row);

            span = row.find('span.LD_AddTime');
            strDate = data['LD_AddTime'];
            date = strDate.jsonDateToDate();
            strDate = date.format('yyyy-MM-dd hh:mm:ss');
            span.text(strDate);

            status = data['LD_Status'];
            switch (status) {
                case 1:
                    row.find('a.recycle').removeClass('hide');
                    row.find('a.edit').removeClass('hide');

                    row.find('a.sort-top').removeClass('hide');
                    row.find('a.sort-up').removeClass('hide');
                    row.find('a.sort-down').removeClass('hide');
                    break;
                case 2:
                    row.find('a.resume').removeClass('hide');
                    row.find('a.delete').removeClass('hide');
                    break;
                case 3:
                    break;
                default:
                    break;
            }
        }
    };

    list = Kyzx.List.init({
        hasTree: true,
        dtSelector: '.table-sort',
        dtParams: dtParams,
        modelCnName: '资料',
        modelEnName: 'LearningData',
        modelPrefix: 'LD_',
        treeIdName: 'ldcId',
        treeIdDefaultValue: 0
    });
    list.initList();

    $('.table-sort tbody').on('click', 'a.sort-top', function() {

        var originTr, destTr;
        var data, originId, destId;
        var layerIndex;

        layerIndex = layer.load(0, {
            shade: [0.3, '#FFF']
        });

        originTr = $(this).parents('tr');
        data = list.dataTables.row(originTr).data();
        originId = data['LD_Id'];

        destTr = originTr.parent().find('tr').first();
        data = list.dataTables.row(destTr).data();
        destId = data['LD_Id'];

        $.post('/LearningData/Sort', {
                originId: originId,
                sortFlag: 1
            }, function(data) {

                var remoteDest, remoteDestId;

                layer.close(layerIndex);

                if (1 == data.status) {

                    remoteDest = data.addition[1];
                    remoteDestId = remoteDest['LD_Id'];

                    if (destId == remoteDestId) {
                        originTr.insertBefore(destTr);
                    } else {
                        originTr.remove();
                    }

                    refreshRowBackgroundColor('.table-sort');
                } else if (0 == data.status) {

                    alert(data.message);
                }

            }, 'json')
            .error(function() {

                layer.close(layerIndex);
                alert('请求返回错误！');
            });
    });

    $('.table-sort tbody').on('click', 'a.sort-up', function() {

        var originTr, destTr;
        var data, originId, destId;
        var layerIndex;

        layerIndex = layer.load(0, {
            shade: [0.3, '#FFF']
        });

        originTr = $(this).parents('tr');
        data = list.dataTables.row(originTr).data();
        originId = data['LD_Id'];

        destTr = originTr.prev();

        $.post('/LearningData/Sort', {
                originId: originId,
                sortFlag: 2
            }, function(data) {

                layer.close(layerIndex);

                if (1 == data.status) {

                    if (destTr.length == 0) {
                        originTr.remove();
                    } else {
                        originTr.insertBefore(destTr);
                    }

                    refreshRowBackgroundColor('.table-sort');
                } else if (0 == data.status) {

                    alert(data.message);
                }

            }, 'json')
            .error(function() {

                layer.close(layerIndex);
                alert('请求返回错误！');
            });
    });

    $('.table-sort tbody').on('click', 'a.sort-down', function() {

        var originTr, destTr;
        var data, originId, destId;
        var layerIndex;

        layerIndex = layer.load(0, {
            shade: [0.3, '#FFF']
        });

        originTr = $(this).parents('tr');
        data = list.dataTables.row(originTr).data();
        originId = data['LD_Id'];

        destTr = originTr.next();

        $.post('/LearningData/Sort', {
                originId: originId,
                sortFlag: 3
            }, function(data) {

                layer.close(layerIndex);

                if (1 == data.status) {

                    if (destTr.length == 0) {
                        originTr.remove();
                    } else {
                        originTr.insertAfter(destTr);
                    }

                    refreshRowBackgroundColor('.table-sort');
                } else if (0 == data.status) {

                    alert(data.message);
                }

            }, 'json')
            .error(function() {

                layer.close(layerIndex);
                alert('请求返回错误！');
            });
    });

});
