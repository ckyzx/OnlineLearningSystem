var Kyzx = {};
var OLS = {};

/* 在模态框中显示页面 */
function ShowPage(title, url) {
    var index = layer.open({
        type: 2,
        title: title,
        content: url,
        // 初始化为小区域，可避免展现错位的控件
        //area: ['180px', '36px']
        area: ['800px', '600px'],
        shade: 0
    });
    layer.full(index);
}

function ShowPageWithSize(title, url, w, h) {

    if (w == undefined)
        w = 800;

    if (h == undefined) {
        h = 600;
    }

    layer.open({
        type: 2,
        area: [w + 'px', h + 'px'],
        fix: false, //不固定
        shade: 0.4,
        title: title,
        content: url,
        shade: 0
    });
}

Kyzx.Common = {
    getElemHeight: function(elem) {

        var h;

        elem = $(elem);
        h = elem.height() + parseInt(elem.css('margin-top')) + parseInt(elem.css('margin-bottom')) + parseInt(elem.css('padding-top')) + parseInt(elem.css('padding-bottom'));

        return h;
    }
};

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
        treeIdDefaultValue: null,
        additionRequestParams: null
    },
    request: null,
    jqTable: null,
    dataTables: null,

    init: function(settings) {

        var self;

        self = this;
        this.self = self;

        $.extend(self.settings, settings);

        self.request = Request.init();

        if (null != self.settings.treeIdName) {

            self.settings.dtParams.ajax.url += '?' + self.settings.treeIdName + '=' + self.request.getValue(self.settings.treeIdName, self.settings.treeIdDefaultValue);
        }

        if (undefined == self.settings.dtParams.initComplete) {

            self.settings.dtParams.initComplete = function() {
                self._adjustElem(self.settings.hasTree);
            };
        }

        return self;
    },

    initList: function() {

        var self;

        self = this.self;

        self._addCreateBtn();
        self._addRecycleBtn();
        self._addTree();

        self.jqTable = $(self.settings.dtSelector);
        self.dataTables = self.jqTable.DataTable(self.settings.dtParams);

        self._initListEvent();

        if (!brower.ieVersion) {
            $(window).resize(function() {

                self.dataTables.destroy();
                self.dataTables = self.jqTable.DataTable(self.settings.dtParams);
            });
        }

        return self.dataTables;
    },

    _addCreateBtn: function() {

        var funcBtnContainer, createBtn;
        var self;

        self = this.self;

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
        var self;
        var params;
        var setParams;

        params = {};

        setParams = function(params) {

            var additionParams;

            additionParams = self.settings.additionRequestParams;
            if (null != additionParams) {

                for (var i = 0; i < additionParams.length; i++) {
                    params[additionParams[i]['name']] = $(additionParams[i]['input']).val();
                }
            }
        }

        self = this.self;

        if (self.settings.hasRecycleBin) {

            status = self.request.getValue('status', 1);

            recycleBin = $('<a id="RecycleBin" class="btn btn-success radius r mr-5" style="line-height:1.6em;margin-top:3px" href="javascript:void(0);">回收站</a>');
            $('nav.breadcrumb').append(recycleBin);

            recycleBin.attr('data-status', status);

            self.settings.dtParams.ajax.data = function(originData) {

                params['status'] = recycleBin.attr('data-status');
                setParams(params);

                return $.extend({}, originData, params);
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
        } else {

            self.settings.dtParams.ajax.data = function(originData) {

                setParams(params);
                return $.extend({}, originData, params);
            };

        }
    },

    _addTree: function() {

        var status, nodeId;
        var ul;
        var settings, nodes, n;
        var ztree;
        var self;

        self = this.self;

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

        var self;

        self = this.self;

        self.jqTable.on('click', 'tbody a.view', function() {

            var data, id;

            data = self.dataTables.row($(this).parents('tr')).data();
            id = data[self.settings.modelPrefix + 'Id'];

            ShowPage('查看' + self.settings.modelCnName, '/' + self.settings.modelEnName + '/View?id=' + id);
        });

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
        var self;

        self = this.self;

        trs = self.jqTable.find('tbody tr');

        trs.removeClass('odd');
        trs.removeClass('even');
        self.jqTable.find('tbody tr:odd').addClass('even');
        self.jqTable.find('tbody tr:even').addClass('odd');
    },

    _adjustElem: function(hasTree) {

        var bodyH, h;

        if (hasTree) {

            bodyH = Kyzx.Common.getElemHeight('body');
            h = Kyzx.Common.getElemHeight('.list-container');
            h = bodyH > h ? bodyH : h;
            $('.tree-container').height(h);
        }
    },

    checkboxClickEvent: function(elem) {

        var checkbox;

        checkbox = $(elem);
        //checkbox.parentsUntil('div').last().find(':checkbox').removeAttr('checked');
        this.clearChecked(checkbox.parents('table'));
        checkbox.attr('data-checked', 1).blur().focus();
    },

    checkboxChangeEvent: function(elem) {

        var checkbox;

        checkbox = $(elem);
        if (1 == checkbox.attr('data-checked')) {
            checkbox.get(0).checked = true;
        }

        checkbox.removeAttr('data-checked');
    },

    checkboxMutipleClickEvent: function(elem) {

        var checkbox;

        checkbox = $(elem);
        checkbox.attr('data-checked', 1).blur().focus();
    },

    checkboxMutipleChangeEvent: function(elem) {

        var checkbox;

        checkbox = $(elem);
        checkbox.removeAttr('data-checked');
        checkbox = checkbox.get(0);
        if (checkbox.checked) {
            checkbox = false;
        } else {
            checkbox = true;
        }
    },

    setChecked: function(tableSelector, valueSelector) {

        var container, table, tableId, settings, dtData, ms, cells, checkbox, id;
        var countSpan, rows, allCheckbox;
        var checked;

        table = $(tableSelector);
        container = table.parent();
        tableId = table.attr('id');
        settings = table.DataTable.settings;

        for (var i = 0; i < settings.length; i++) {

            if (settings[i].sTableId == tableId) {

                dtData = settings[i].aoData;
                break;
            }
        }

        ms = $(valueSelector).val();
        ms = $.parseJSON(ms);

        for (var i = 0; i < dtData.length; i++) {

            cells = dtData[i].anCells;
            checkbox = $(cells[0]).find(':checkbox');
            id = checkbox.val();

            for (var i1 = 0; i1 < ms.length; i1++) {

                if (id == ms[i1]) {

                    $(cells[0]).find(':checkbox').get(0).checked = true;
                }
            }
        }

        // 显示已选数据数量
        container.find('.select-data-item').remove();
        countSpan = $('<div class="select-data-item">已选 <span class="select-data-count">' + ms.length + '</span> 条</div>');
        countSpan.prependTo(container);

        // 判断是否复选“全选”框
        rows = table.find('tbody tr');
        allCheckbox = $(':checkbox[value=all]');
        checked = rows.length == rows.find(':checked').length;
        if (checked) {
            allCheckbox.attr('checked', 'checked');
        } else {
            allCheckbox.removeAttr('checked');
        }
    },

    getChecked: function(tableSelector, valueSelector, increment) {

        var table, tableId, dtData, ms;

        table = $(tableSelector);
        tableId = table.attr('id');
        settings = table.DataTable.settings;

        for (var i = 0; i < settings.length; i++) {

            if (settings[i].sTableId == tableId) {

                dtData = settings[i].aoData;
                break;
            }
        }

        if (increment) {

            ms = $(valueSelector).val();
            ms = $.parseJSON(ms);
        } else {
            ms = [];
        }

        for (var i = 0; i < dtData.length; i++) {

            cells = dtData[i].anCells;
            if ($(cells[0]).find(':checkbox, :radio').get(0).checked) {

                id = $(cells[0]).find(':checkbox, :radio').val();
                id = parseInt(id);
                ms.push(id);
            }
        }

        $(valueSelector).val(JSON.stringify(ms));
    },

    clearChecked: function(tableSelector) {

        'use strict';

        var table, checkbox;
        var tableId, settings, dtData, cells;

        table = $(tableSelector);
        tableId = table.attr('id');
        settings = table.DataTable.settings;

        for (var i = 0; i < settings.length; i++) {

            if (settings[i].sTableId == tableId) {

                dtData = settings[i].aoData;
                break;
            }
        }

        for (var i = 0; i < dtData.length; i++) {

            cells = dtData[i].anCells;
            checkbox = $(cells[0]).find(':checkbox').get(0);

            if (checkbox.checked) {

                checkbox.checked = false;
            }
        }
    },

    renderSelectCount: function(container, num) {

        container.find('.select-data-item').remove();
        countSpan = $('<div class="select-data-item">已选 <span class="select-data-count">' + num + '</span> 条</div>');
        countSpan.prependTo(container);
    },

    columnContentEllipsis: function(jqTable, row, className, content) {

        var th, span;

        th = jqTable.find('th' + className);
        span = row.find('span' + className);
        span.addClass('ellipsis').width(th.width()).text(content);
    }

};

OLS.renderMenu = function(authorize) {

    var permissions;

    if (!authorize) {

        $('.menu_dropdown').show();
        return;
    }

    permissions = $('#User').attr('permissions');

    $('.menu_dropdown a[_href]').each(function() {

        var a, item;
        var i;
        var href;

        a = $(this);
        href = a.attr('_href');

        i = href.indexOf('?');
        i = i == -1 ? href.length : i;
        href = href.substring(0, i) + ';';

        if (permissions.indexOf(href) == -1) {

            item = a.parentsUntil('div');
            count = item.find('a[_href]').length;
            if (1 == count) {
                item.remove();
            } else {
                a.parent().remove();
            }
        }
    });

    $('.menu_dropdown').fadeIn();
};
