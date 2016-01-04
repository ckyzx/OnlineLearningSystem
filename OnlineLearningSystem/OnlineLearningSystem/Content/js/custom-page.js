function refreshRowBackgroundColor(tableSelector) {

    var table, trs;

    table = $(tableSelector);
    trs = table.find('tbody tr');

    trs.removeClass('odd');
    trs.removeClass('even');
    table.find('tbody tr:odd').addClass('even');
    table.find('tbody tr:even').addClass('odd');
}

Kyzx.List = {
    self: null,
    settings: {
        hasCreateBtn: true,
        hasRecycleBin: true,
        hasTree: false,
        dtSelector: null,
        dtParams: {},
        modelCnName: null,
        modelEnName: null,
        modelPrefix: null,
        treeIdName: null,
        treeIdDefaultValue: null
    },
    request: null,
    jqTable: null,
    dataTables: null,

    init: function(settings) {

        self = this;

        $.extend(self.settings, settings);

        self.request = Request.init();

        if (null != self.settings.treeIdName) {

            self.settings.dtParams.ajax.url += '?' + self.settings.treeIdName + '=' + self.request.getValue(self.settings.treeIdName, self.settings.treeIdDefaultValue);
        }

        if (undefined == self.settings.dtParams.initComplete) {

            self.settings.dtParams.initComplete = self._adjustElem;
        }

        return self;
    },

    initList: function() {

        self._addCreateBtn();
        self._addRecycleBtn();
        self._addTree();

        self.jqTable = $(self.settings.dtSelector);
        self.dataTables = self.jqTable.DataTable(self.settings.dtParams);

        self._initListEvent();

        return self.dataTables;
    },

    _addCreateBtn: function() {

        var funcBtnContainer, createBtn;

        if (self.settings.hasCreateBtn) {

            funcBtnContainer = $('<div class="function-btn-container cl pd-5 bg-1 bk-gray"><span class="l"></span></div>');
            createBtn = $('<a id="CreateBtn" class="btn btn-primary radius" href="javascript:void(0);"><i class="Hui-iconfont">&#xe600;</i> 添加</a>');
            funcBtnContainer.find('span.l').append(createBtn);
            $('div.list-body').prepend(funcBtnContainer);

            createBtn.on('click', function() {
                ShowPage('添加' + self.settings.modelCnName, '/' + self.settings.modelEnName + '/Create');
            });
        }
    },

    _addRecycleBtn: function() {

        var recycleBin, status;

        if (self.settings.hasRecycleBin) {

            status = self.request.getValue('status', 1);

            recycleBin = $('<a id="RecycleBin" class="btn btn-success radius r mr-5" style="line-height:1.6em;margin-top:3px" href="javascript:void(0);">回收站</a>');
            $('nav.breadcrumb').append(recycleBin);

            recycleBin.attr('data-status', status);

            self.settings.dtParams.ajax.data = function(originData) {

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
                self.dataTables.ajax.reload(null, false);
            });
        }
    },

    _addTree: function() {

        var status, nodeId;
        var ul;
        var settings, nodes, n;
        var ztree;

        if (self.settings.hasTree) {

            status = self.request.getValue('status', 1);
            nodeId = self.request.getValue(self.settings.treeIdName, 0);

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

            ul = $('.tree-container ul');
            nodes = ul.attr('data-ztree-json');
            nodes = $.parseJSON(nodes);

            for (var i = 0; i < nodes.length; i++) {

                n = nodes[i];

                if (n[self.settings.treeIdName] == nodeId) {

                    n.checked = true;
                }

                n.click = 'location.href = \'/' + self.settings.modelEnName + '/List?status=' + status + '&' + self.settings.treeIdName + '=' + n[self.settings.treeIdName] + '\';';
            };

            // 添加根节点“全部”
            nodes = [{
                name: '全部',
                open: true,
                click: 'location.href = \'/' + self.settings.modelEnName + '/List?status=' + status + '&' + self.settings.treeIdName + '=0\';',
                children: nodes
            }];
            nodes[0][self.settings.treeIdName] = 0;

            if (0 == nodeId) {

                nodes[0].checked = true;
            }

            ztree = $.fn.zTree.init(ul, settings, nodes);

        }
    },

    _initListEvent: function() {

        self.jqTable.on('click', 'tbody a.edit', function() {

            var data, id;

            data = self.dataTables.row($(this).parents('tr')).data();
            id = data[self.settings.modelPrefix + 'Id'];

            ShowPage('修改' + self.settings.modelCnName, '/' + self.settings.modelEnName + '/Edit?id=' + id);
        });

        self.jqTable.on('click', 'tbody a.recycle', function() {

            var tr, data, id;

            tr = $(this).parents('tr');
            data = self.dataTables.row(tr).data();
            id = data[self.settings.modelPrefix + 'Id'];

            $.post('/' + self.settings.modelEnName + '/Recycle', {
                    id: id
                }, function(data) {

                    if (1 == data.status) {

                        tr.fadeOut(function() {

                            tr.remove();
                            self.__refreshRowBackgroundColor();
                        });
                    } else if (0 == data.status) {

                        alert(data.message);
                    }
                }, 'json')
                .error(function() {

                    alert('请求返回错误！');
                });
        });

        self.jqTable.on('click', 'tbody a.resume', function() {

            var tr, data, id;

            tr = $(this).parents('tr');
            data = self.dataTables.row(tr).data();
            id = data[self.settings.modelPrefix + 'Id'];

            $.post('/' + self.settings.modelEnName + '/Resume', {
                    id: id
                }, function(data) {

                    if (1 == data.status) {

                        tr.fadeOut(function() {

                            tr.remove();
                            self.__refreshRowBackgroundColor();
                        });
                    } else if (0 == data.status) {

                        alert(data.message);
                    }
                }, 'json')
                .error(function() {

                    alert('请求返回错误！');
                });
        });

        self.jqTable.on('click', 'tbody a.delete', function() {

            var tr, data, id;

            tr = $(this).parents('tr');
            data = self.dataTables.row(tr).data();
            id = data[self.settings.modelPrefix + 'Id'];

            $.post('/' + self.settings.modelEnName + '/Delete', {
                    id: id
                }, function(data) {

                    if (1 == data.status) {

                        tr.fadeOut(function() {

                            tr.remove();
                            self.__refreshRowBackgroundColor();
                        });
                    } else if (0 == data.status) {

                        alert(data.message);
                    }
                }, 'json')
                .error(function() {

                    alert('请求返回错误！');
                });
        });
    },

    __refreshRowBackgroundColor: function() {

        var trs;

        trs = self.jqTable.find('tbody tr');

        trs.removeClass('odd');
        trs.removeClass('even');
        self.jqTable.find('tbody tr:odd').addClass('even');
        self.jqTable.find('tbody tr:even').addClass('odd');
    },

    _adjustElem: function() {

        var h;

        if (self.settings.hasTree) {

            h = Kyzx.Common.getElemHeight('.list-container');
            $('.tree-container').height(h);
        }
    }
}
