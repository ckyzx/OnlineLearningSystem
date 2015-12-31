function refreshRowBackgroundColor(tableSelector) {

    var table, trs;

    table = $(tableSelector);
    trs = table.find('tbody tr');

    trs.removeClass('odd');
    trs.removeClass('even');
    table.find('tbody tr:odd').addClass('even');
    table.find('tbody tr:even').addClass('odd');
}

function initList(dtSelector, dtParams, modelCnName, modelEnName, modelPrefix, noCreateBtn, noRecycleBin) {

    var jqTable, recycleBin, funcBtnContainer, createBtn;
    var dataTables;
    var status;

    QueryString.Initial();

    if (!noCreateBtn) {

    	funcBtnContainer = $('<div class="function-btn-container cl pd-5 bg-1 bk-gray"><span class="l"></span></div>');
    	createBtn = $('<a id="CreateBtn" class="btn btn-primary radius" href="javascript:;"><i class="Hui-iconfont">&#xe600;</i> 添加</a>');
    	funcBtnContainer.find('span.l').append(createBtn);
    	$('div.list-body').prepend(funcBtnContainer);

        createBtn.on('click', function() {
            ShowPage('添加' + modelCnName, '/' + modelEnName + '/Create');
        });
    }

    if (!noRecycleBin) {

        status = QueryString.GetValue('status');
        status = undefined == status || 'undefined' == status || '' == status ? 1 : status;

        recycleBin = $('<a id="RecycleBin" class="btn btn-success radius r mr-5" style="line-height:1.6em;margin-top:3px" href="javascript:;">回收站</a>');
        $('nav.breadcrumb').append(recycleBin);

        recycleBin.attr('data-status', status);

        dtParams.ajax.data = function(originData) {

            return $.extend({}, originData, {
                "status": recycleBin.attr('data-status')
            });
        };

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
    }

	jqTable = $(dtSelector);
    dataTables = jqTable.DataTable(dtParams);

    _initListEvent(jqTable, dataTables, modelCnName, modelEnName, modelPrefix);

    return dataTables;
}

function _initListEvent(jqTable, dataTables, modelCnName, modelEnName, modelPrefix) {

    jqTable.on('click', 'tbody a.edit', function() {

        var data, id;

        data = dataTables.row($(this).parents('tr')).data();
        id = data[modelPrefix + 'Id'];

        ShowPage('修改' + modelCnName, '/' + modelEnName + '/Edit?id=' + id);
    });

    jqTable.on('click', 'tbody a.recycle', function() {

        var tr, data, id;

        tr = $(this).parents('tr');
        data = dataTables.row(tr).data();
        id = data[modelPrefix + 'Id'];

        $.post('/' + modelEnName + '/Recycle', {
                id: id
            }, function(data) {

                if (1 == data.status) {

                    tr.fadeOut(function() {

                        tr.remove();
                        refreshRowBackgroundColor(jqTable);
                    });
                } else if (0 == data.status) {

                    alert(data.message);
                }
            }, 'json')
            .error(function() {

                alert('请求返回错误！');
            });
    });

    jqTable.on('click', 'tbody a.resume', function() {

        var tr, data, id;

        tr = $(this).parents('tr');
        data = dataTables.row(tr).data();
        id = data[modelPrefix + 'Id'];

        $.post('/' + modelEnName + '/Resume', {
                id: id
            }, function(data) {

                if (1 == data.status) {

                    tr.fadeOut(function() {

                        tr.remove();
                        refreshRowBackgroundColor(jqTable);
                    });
                } else if (0 == data.status) {

                    alert(data.message);
                }
            }, 'json')
            .error(function() {

                alert('请求返回错误！');
            });
    });

    jqTable.on('click', 'tbody a.delete', function() {

        var tr, data, id;

        tr = $(this).parents('tr');
        data = dataTables.row(tr).data();
        id = data[modelPrefix + 'Id'];

        $.post('/' + modelEnName + '/Delete', {
                id: id
            }, function(data) {

                if (1 == data.status) {

                    tr.fadeOut(function() {

                        tr.remove();
                        refreshRowBackgroundColor(jqTable);
                    });
                } else if (0 == data.status) {

                    alert(data.message);
                }
            }, 'json')
            .error(function() {

                alert('请求返回错误！');
            });
    });
}
