$(function() {

    var dtParams, list;

    dtParams = {
        "processing": true,
        "serverSide": true,
        "ajax": {
            "url": "/Department/ListDataTablesAjax",
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
            "className": "D_Id",
            "name": "D_Id",
            "data": "D_Id"
        }, {
            "name": "D_Name",
            "data": "D_Name"
        }, {
            "name": "D_AddTime",
            "defaultContent": '<span class="D_AddTime"></span>'
        }, {
            "width": "40%",
            "name": "D_Remark",
            "data": 'D_Remark'
        }, {
            "className": "text-c nowrap",
            "defaultContent": '<a class="recycle mr-5 fz-18 hide" href="javascript:void(0);" title="回收"><i class="Hui-iconfont">&#xe631;</i></a>' +
                '<a class="resume mr-5 fz-18 hide" href="javascript:void(0);" title="恢复"><i class="Hui-iconfont">&#xe615;</i></a>' +
                '<a class="edit mr-5 fz-18 hide" href="javascript:void(0);" title="编辑"><i class="Hui-iconfont">&#xe60c;</i></a>' +
                '<a class="delete mr-5 fz-18 hide" href="javascript:void(0);" title="删除"><i class="Hui-iconfont">&#xe6e2;</i></a>' +
                '<a class="btn btn-primary radius size-MINI sort-top mr-5 fz-9 hide" href="javascript:void(0);">置顶</a>' +
                '<a class="btn btn-primary radius size-MINI sort-up mr-5 fz-9 hide" href="javascript:void(0);">上移</a>' +
                '<a class="btn btn-primary radius size-MINI sort-down mr-5 fz-9 hide" href="javascript:void(0);">下移</a>'
        }],
        "createdRow": function(row, data, dataIndex) {

            var span, strDate, date, status;

            row = $(row);

            span = row.find('span.D_AddTime');
            strDate = data['D_AddTime'];
            date = strDate.jsonDateToDate();
            strDate = date.format('yyyy-MM-dd hh:mm:ss');
            span.text(strDate);

            status = data['D_Status'];
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
        },
        "drawCallback": function(settings) {

            var api;
            api = this.api();
            Kyzx.List.resetId(api, 'D_Id');
        }
    };

    list = Kyzx.List.init({
        dtSelector: '.table-sort',
        dtParams: dtParams,
        modelCnName: '部门',
        modelEnName: 'Department',
        modelPrefix: 'D_'
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
        originId = data['D_Id'];

        destTr = originTr.parent().find('tr').first();
        data = list.dataTables.row(destTr).data();
        destId = data['D_Id'];

        $.post('/Department/Sort', {
                originId: originId,
                sortFlag: 1
            }, function(data) {

                var remoteDest, remoteDestId;

                layer.close(layerIndex);

                if (1 == data.status) {

                    /*remoteDest = data.addition[1];
                    remoteDestId = remoteDest['D_Id'];

                    if(destId == remoteDestId){
                        originTr.insertBefore(destTr);
                    }
                    else{
                        originTr.remove();
                    }

                    Kyzx.List.resetId(list.dataTables, 'D_Id');
                    refreshRowBackgroundColor('.table-sort');*/
                    list.dataTables.ajax.reload(null, false);
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
        originId = data['D_Id'];

        destTr = originTr.prev();

        $.post('/Department/Sort', {
                originId: originId,
                sortFlag: 2
            }, function(data) {

                layer.close(layerIndex);

                if (1 == data.status) {

                    /*if(destTr.length == 0){
                        originTr.remove();
                    }
                    else{
                        originTr.insertBefore(destTr);
                    }

                    Kyzx.List.resetId(list.dataTables, 'D_Id');
                    refreshRowBackgroundColor('.table-sort');*/
                    list.dataTables.ajax.reload(null, false);
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
        originId = data['D_Id'];

        destTr = originTr.next();

        $.post('/Department/Sort', {
                originId: originId,
                sortFlag: 3
            }, function(data) {

                layer.close(layerIndex);
                
                if (1 == data.status) {

                    /*if(destTr.length == 0){
                        originTr.remove();
                    }
                    else{
                        originTr.insertAfter(destTr);
                    }

                    Kyzx.List.resetId(list.dataTables, 'D_Id');
                    refreshRowBackgroundColor('.table-sort');*/
                    list.dataTables.ajax.reload(null, false);
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
