var Kyzx = {};
var OLS = {};

Kyzx.Utility = {
    showPage: function(title, url) {
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
    },

    showPageWithSize: function(title, url, w, h) {

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
            shade: 0,
            offset: '0'
        });
    },

    redirect: function(title, url) {

        var search;

        search = location.search;

        if (search != '') {
            search = search.substring(1);
            search = 'p_' + search.replace(/&/g, '&p_');
            url = url.indexOf('?') != -1 ? (url + '&' + search) : (url + '?' + search);
        }

        location.href = url;
    }
};

Kyzx.Common = {
    getElemHeight: function(elem) {

        var h, tmp;

        elem = $(elem);
        h = elem.height()
        tmp = parseInt(elem.css('margin-top'));
        h += isNaN(tmp) ? 0 : tmp;
        tmp = parseInt(elem.css('margin-bottom'));
        h += isNaN(tmp) ? 0 : tmp;
        tmp = parseInt(elem.css('padding-top'));
        h += isNaN(tmp) ? 0 : tmp;
        tmp = parseInt(elem.css('padding-bottom'));
        h += isNaN(tmp) ? 0 : tmp;

        return h;
    },

    refreshUserOnlineTime: function() {

        $.post('/User/RefreshTime', {}, function(data) {

                var undoNumber;

                if (0 == data.status) {

                    //alert(data.message);
                }
            }, 'json')
            .error(function() {

                //alert('请求返回错误！');
            });
    },

    setUserOnlineNumber: function(placeholder) {

        $.post('/User/ListOnline', {}, function(data) {

                var undoNumber;

                if (1 == data.status) {

                    $(placeholder).text(' | 在线人数 ' + data.data.length + ' | ');
                } else if (0 == data.status) {

                    //alert(data.message);
                }
            }, 'json')
            .error(function() {

                //alert('请求返回错误！');
            });
    }
};

Kyzx.List = {
    self: null,
    settings: {
        hasCreateBtn: true,
        hasRecycleBin: true,
        hasControlBtn: true,
        hasTree: false,
        dtSelector: null,
        dtParams: {},
        modelCnName: null,
        modelEnName: null,
        modelPrefix: null,
        actionName: null,
        treeIdName: null,
        treeIdDefaultValue: null,
        treeDataModelEnName: null,
        additionRequestParams: null // 格式：[{ name: '[paramName]', input: '[paramInputSelector]', value: '[value]' }]
    },
    request: null,
    jqTable: null,
    dataTables: null,
    zTree: null,
    zTreeId: null,

    init: function(settings) {

        var self;

        self = this;
        this.self = self;

        $.extend(self.settings, settings);

        self.request = Request.init();

        //[Obsolete]使用 additionRequestParams参数代替
        if (null != self.settings.treeIdName) {

            self.settings.dtParams.ajax.url +=
                '?' + self.settings.treeIdName + '=' +
                self.request.getValue(self.settings.treeIdName, self.settings.treeIdDefaultValue);
        }

        if (undefined == self.settings.dtParams.initComplete) {

            self.settings.dtParams.initComplete = function() {
                self._adjustElem(self.settings.hasTree);
            };
        }

        self._initAdditionRequestParams();

        return self;
    },

    _initAdditionRequestParams: function() {

        var self;
        var additionParams, input, selector;

        self = this;

        if (self.settings.additionRequestParams != null) {

            additionParams = self.settings.additionRequestParams;
            for (var i = 0; i < additionParams.length; i++) {

                selector = additionParams[i]['input'];
                if ($(selector).length > 0) {
                    continue;
                }

                input = $('<input type="hidden" value="' + additionParams[i]['value'] + '" />');
                if (selector.indexOf('#') == 0) {
                    input.attr('id', selector.substring(1));
                } else if (selector.indexOf('.') == 0) {
                    input.attr('class', selector.substring(1));
                }

                $('body').append(input);
            }
        }
    },

    initList: function() {

        var self;

        self = this.self;

        self._addCreateBtn();
        self._addControlBtn();
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

                var url, search;

                url = '/' + self.settings.modelEnName + '/Create';

                /*if (self.settings.treeIdName) {
                    url += '?' + self.settings.treeIdName + '=' + self.request.getValue(self.settings.treeIdName, 0);
                }*/

                search = self._getAdditionRequestSearch();
                if (search != '') {
                    url += '?' + search;
                }

                Kyzx.Utility.redirect('添加' + self.settings.modelCnName, url);
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

        status = self.request.getValue('status', 1);

        self._showControlBtn(status);

        if (self.settings.hasRecycleBin) {

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

                // 刷新列表
                recycleBin.attr('data-status', status);
                self.dataTables.ajax.reload(null, true);

                // 刷新树表
                self._reloadTreeData('/' + self.settings.treeDataModelEnName + '/GetZTreeResJson', status);

                self._showControlBtn(status);
            });
        } else {

            self.settings.dtParams.ajax.data = function(originData) {

                setParams(params);
                return $.extend({}, originData, params);
            };

        }
    },

    _reloadTreeData: function(url, status) {

        var self;

        self = this.self;

        if (self.settings.hasTree) {

            $.post(url, { status: status }, function(data) {

                var ul;

                if (data.status == 1) {
                    $('ul.ztree').attr('data-ztree-json', data.data);
                    self._addTree();
                } else if (data.status == 0) {
                    alert(data.message);
                }

            }, 'json');
        }
    },

    _addTree: function() {

        var status, nodeId;
        var ul;
        var settings, nodes, n;
        var ztree, treeId;
        var self;

        self = this.self;

        if (self.settings.hasTree) {

            ul = $('ul.ztree');

            // 销毁原树表
            treeId = ul.attr('id');
            if (treeId != undefined) {
                $.fn.zTree.destroy(treeId);
            }

            status = self.request.getValue('status', 1);
            nodeId = self.request.getValue(self.settings.treeIdName, 0);

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
                        self._setAdditionRequestParams(treeNode);
                        self.dataTables.ajax.reload(null, true);
                    }
                }
            };

            self.zTreeId = 'ZTree_' + (new Date()).getTime();
            ul.attr('id', self.zTreeId);
            nodes = ul.attr('data-ztree-json');
            nodes = $.parseJSON(nodes);

            for (var i = 0; i < nodes.length; i++) {

                n = nodes[i];

                if (n[self.settings.treeIdName] == nodeId) {

                    n.ifChecked = true;
                }
            };

            // 添加根节点“全部”
            nodes = [{
                name: '全部',
                open: true,
                children: nodes
            }];
            nodes[0][self.settings.treeIdName] = 0;

            if (0 == nodeId) {

                nodes[0].ifChecked = true;
            }

            ztree = $.fn.zTree.init(ul, settings, nodes);
            self._setZTreeCheck(ztree);
        }
    },

    _setZTreeCheck: function(ztree) {
        var n;
        $('a.curSelectedNode').removeClass('curSelectedNode');
        n = ztree.getNodeByParam('ifChecked', true);
        $('#' + n.tId + '_a').addClass('curSelectedNode');
    },

    _setAdditionRequestParams: function(node) {

        var self;
        var additionParams, p, input, selector;

        self = this;

        if (self.settings.additionRequestParams != null) {

            additionParams = self.settings.additionRequestParams;
            for (var i = 0; i < additionParams.length; i++) {

                p = additionParams[i];
                selector = p['input'];
                input = $(selector);
                if (input.length > 0 && node[p['name']] != undefined) {
                    input.val(node[p['name']]);
                }
            }
        }
    },

    _getAdditionRequestParams: function() {

        var self;
        var additionParams, p;

        self = this;

        additionParams = self.settings.additionRequestParams;
        if (null != additionParams) {

            for (var i = 0; i < additionParams.length; i++) {

                p = additionParams[i];
                p['value'] = $(p['input']).val();
            }
        }

        return additionParams;
    },

    _getAdditionRequestSearch: function() {

        var self;
        var additionParams, p, search;

        self = this;

        additionParams = self.settings.additionRequestParams;
        search = '';

        if (null != additionParams) {

            for (var i = 0; i < additionParams.length; i++) {

                p = additionParams[i];
                search += p['name'] + '=' + $(p['input']).val() + '&';
            }
        }

        search = search != '' ? search.substring(0, search.length - 1) : '';

        return search;
    },

    _addControlBtn: function() {

        var funcBtnContainer, recycleBtn, resumeBtn, deleteBtn, editBtn;
        var hasBtnContainer;
        var self;
        var btnClick;

        self = this.self;

        if (!self.settings.hasControlBtn) {
            return;
        }

        funcBtnContainer = $('.function-btn-container');
        hasBtnContainer = funcBtnContainer.length != 0;
        if (!hasBtnContainer) {

            funcBtnContainer = $('<div class="function-btn-container cl pd-5 bg-1 bk-gray"><span class="l"></span></div>');
            $('div.list-body').prepend(funcBtnContainer);
        }

        btnClick = function(btnClassName) {

            var checkboxs, tr, btn;

            checkboxs = $('.list-body table input:checked');
            if (checkboxs.length == 0) {

                alert('请选择数据项。');
                return;
            } else if (checkboxs.length > 1) {

                alert('请选择单条数据项。');
                return;
            }

            tr = checkboxs.parents('tr');
            btn = tr.find('a.' + btnClassName);
            if (btn.length == 1 && (btn.hasClass('hide') || btn.css('display') == 'none')) {

                alert('不允许的操作。');
                return;
            } else if (btn.length == 1) {
                btn.click();
            }
        };

        recycleBtn = $('<a id="RecycleBtn" class="btn btn-warning ml-5 radius hide" href="javascript:void(0);">回收</a>');
        funcBtnContainer.find('span.l').append(recycleBtn);
        recycleBtn.on('click', function() {
            btnClick('recycle');
        });

        resumeBtn = $('<a id="ResumeBtn" class="btn btn-warning ml-5 radius hide" href="javascript:void(0);">恢复</a>');
        funcBtnContainer.find('span.l').append(resumeBtn);
        resumeBtn.on('click', function() {
            btnClick('resume');
        });

        deleteBtn = $('<a id="DeleteBtn" class="btn btn-warning ml-5 radius hide" href="javascript:void(0);">删除</a>');
        funcBtnContainer.find('span.l').append(deleteBtn);
        deleteBtn.on('click', function() {
            btnClick('delete');
        });

        editBtn = $('<a id="EditBtn" class="btn btn-warning ml-5 radius hide" href="javascript:void(0);">编辑</a>');
        funcBtnContainer.find('span.l').append(editBtn);
        editBtn.on('click', function() {
            btnClick('edit');
        });
    },

    _addBatchControlBtn: function() {

        var funcBtnContainer, recycleBtn, resumeBtn, deleteBtn, editBtn;
        var hasBtnContainer;
        var self;
        var btnClick, batchBtnClick;

        self = this.self;

        if (!self.settings.hasControlBtn) {
            return;
        }

        funcBtnContainer = $('.function-btn-container');
        hasBtnContainer = funcBtnContainer.length != 0;
        if (!hasBtnContainer) {

            funcBtnContainer = $('<div class="function-btn-container cl pd-5 bg-1 bk-gray"><span class="l"></span></div>');
            $('div.list-body').prepend(funcBtnContainer);
        }

        btnClick = function(btnClassName) {

            var checkboxs, tr, btn;

            checkboxs = $('.list-body table input:checked');
            if (checkboxs.length == 0) {

                alert('请选择数据项。');
                return;
            } else if (checkboxs.length > 1) {

                alert('请选择单条数据项。');
                return;
            }

            tr = checkboxs.parents('tr');
            btn = tr.find('a.' + btnClassName);
            if (btn.length == 1 && (btn.hasClass('hide') || btn.css('display') == 'none')) {

                alert('不允许的操作。');
                return;
            } else if (btn.length == 1) {
                btn.click();
            }
        };

        batchBtnClick = function(operate) {

            var checkboxs;
            var ids;
            var url;

            checkboxs = $('.list-body tbody input:checked');
            if (checkboxs.length == 0) {

                alert('请选择数据项。');
                return;
            }

            ids = '';
            checkboxs.each(function() {
                ids += this.value + ',';
            });
            ids = ids != '' ? ids.substring(0, ids.length - 1) : 0;

            if (ids == 0) {
                return;
            }

            url = location.pathname;
            url = url.substring(0, url.lastIndexOf('/') + 1);
            url += operate;

            if (!confirm('确定执行批量操作吗？')) {
                return;
            }

            $.post(url, { ids: ids }, function(data) {

                if (data.status == 1) {
                    self.dataTables.ajax.reload(null, false);
                } else if (data.status == 0) {
                    alert(data.message);
                }
            }, 'json');
        };

        recycleBtn = $('<a id="RecycleBtn" class="btn btn-warning ml-5 radius hide" href="javascript:void(0);">回收</a>');
        funcBtnContainer.find('span.l').append(recycleBtn);
        recycleBtn.on('click', function() {
            batchBtnClick('Recycles');
        });

        resumeBtn = $('<a id="ResumeBtn" class="btn btn-warning ml-5 radius hide" href="javascript:void(0);">恢复</a>');
        funcBtnContainer.find('span.l').append(resumeBtn);
        resumeBtn.on('click', function() {
            batchBtnClick('Resumes');
        });

        deleteBtn = $('<a id="DeleteBtn" class="btn btn-warning ml-5 radius hide" href="javascript:void(0);">删除</a>');
        funcBtnContainer.find('span.l').append(deleteBtn);
        deleteBtn.on('click', function() {
            batchBtnClick('Deletes');
        });

        editBtn = $('<a id="EditBtn" class="btn btn-warning ml-5 radius hide" href="javascript:void(0);">编辑</a>');
        funcBtnContainer.find('span.l').append(editBtn);
        editBtn.on('click', function() {
            btnClick('edit');
        });
    },

    _showControlBtn: function(status) {

        if (status == 1) {

            $('#RecycleBtn').removeClass('hide');
            $('#ResumeBtn').addClass('hide');
            $('#DeleteBtn').addClass('hide');
            $('#EditBtn').removeClass('hide');
        } else if (status == 2) {

            $('#RecycleBtn').addClass('hide');
            $('#ResumeBtn').removeClass('hide');
            $('#DeleteBtn').removeClass('hide');
            $('#EditBtn').addClass('hide');
        }
    },

    _initListEvent: function() {

        var self;

        self = this.self;

        self.jqTable.on('click', 'tbody a.view', function() {

            var data, id;

            data = self.dataTables.row($(this).parents('tr')).data();
            id = data[self.settings.modelPrefix + 'Id'];

            Kyzx.Utility.redirect('查看' + self.settings.modelCnName, '/' + self.settings.modelEnName + '/View?id=' + id);
        });

        self.jqTable.on('click', 'tbody a.edit', function() {

            var data, id;

            data = self.dataTables.row($(this).parents('tr')).data();
            id = data[self.settings.modelPrefix + 'Id'];

            Kyzx.Utility.redirect('修改' + self.settings.modelCnName, '/' + self.settings.modelEnName + '/Edit?id=' + id);
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

                        /*tr.fadeOut(function() {

                            tr.remove();
                            self.__refreshRowBackgroundColor();
                        });*/
                        self.dataTables.ajax.reload(null, false);
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

                        /*tr.fadeOut(function() {

                            tr.remove();
                            self.__refreshRowBackgroundColor();
                        });*/
                        self.dataTables.ajax.reload(null, false);
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

            if (!confirm('是否确定执行删除操作？')) {
                return;
            }

            tr = $(this).parents('tr');
            data = self.dataTables.row(tr).data();
            id = data[self.settings.modelPrefix + 'Id'];

            $.post('/' + self.settings.modelEnName + '/Delete', {
                    id: id
                }, function(data) {

                    if (1 == data.status) {

                        /*tr.fadeOut(function() {

                            tr.remove();
                            self.__refreshRowBackgroundColor();
                        });*/
                        self.dataTables.ajax.reload(null, false);
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
            h = bodyH > h ? bodyH - 40 : h;
            //$('.tree-container').height(h);
            $('.list-body').height(h);
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
            checkbox = $(cells[0]).find(':checkbox, :radio');
            id = checkbox.val();

            for (var i1 = 0; i1 < ms.length; i1++) {

                if (id == ms[i1]) {

                    $(cells[0]).find(':checkbox, :radio').get(0).checked = true;
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
        span.addClass('ellipsis').width(th.width()).text(content).attr('title', content);
    },

    columnContentEllipsisAgain: function(jqTable, className) {

        $('span' + className).each(function() {

            var span;
            span = $(this);
            Kyzx.List.columnContentEllipsis(jqTable, span.parents('tr'), className, span.text());
        });
    },

    resetId: function(dataTables, idClassName) {

        var pageInfo;
        var currentPageIndex, pages, length, recordsDisplay, id;

        currentPageIndex = dataTables.page();
        pageInfo = dataTables.page.info();
        pages = pageInfo.pages;
        length = pageInfo.length;
        recordsDisplay = pageInfo.recordsDisplay;

        id = length * currentPageIndex + 1;
        $('.table-sort tbody td.' + idClassName).each(function() {

            $(this).text(id);
            id += 1;
        })
    }
};

OLS = {
    renderMenu: function(authorize) {

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
    }
};

OLS.WebUploaderHelper = {
    self: null,
    settings: {
        action: 'uploadfile',
        accept: {
            title: '',
            extensions: '',
            mimeTypes: ''
        },
        uploadSuccess: function(file, response) {
            return;
        }
    },
    init: function(settings) {

        var self;

        self = this;
        this.self = self;

        $.extend(self.settings, settings);

        $list = $("#fileList"),
            $btn = $("#btn-star"),
            state = "pending",
            uploader;

        var uploader = WebUploader.create({
            auto: true,
            swf: '/Contents/lib/webuploader/0.1.5/Uploader.swf',

            // 文件接收服务端。
            server: '/Contents/lib/ueditor/1.4.3/net/controller.ashx?action=' + settings.action,

            // 选择文件的按钮。可选。
            // 内部根据当前运行是创建，可能是input元素，也可能是flash.
            pick: '#filePicker',

            // 不压缩image, 默认如果是jpeg，文件上传前会压缩一把再上传！
            resize: false,
            // 上传文件类型。
            accept: self.settings.accept,
            fileVal: "upfile"
        });

        uploader.on('fileQueued', function(file) {
            var $li = $(
                    '<div id="' + file.id + '" class="item mt-3 mb-10">' +
                    '<!--div class="pic-box"><img></div-->' +
                    '<div class="info">' + file.name + '</div>' +
                    '<p class="state">等待上传...</p>' +
                    '</div>'
                ),
                $img = $li.find('img');
            $list.html($li);

            // 创建缩略图
            // 如果为非图片文件，可以不用调用此方法。
            // thumbnailWidth x thumbnailHeight 为 100 x 100
            uploader.makeThumb(file, function(error, src) {
                if (error) {
                    $img.replaceWith('<span>不能预览</span>');
                    return;
                }

                $img.attr('src', src);
            }, 100, 100);
        });

        uploader.on('error', function(type) {

            switch (type) {
                case 'Q_EXCEED_NUM_LIMIT':
                    //在设置了fileNumLimit且尝试给uploader添加的文件数量超出这个值时派送。
                    alert('上传的文件超过最大数量限制。');
                    break;
                case 'Q_EXCEED_SIZE_LIMIT':
                    //在设置了Q_EXCEED_SIZE_LIMIT且尝试给uploader添加的文件总大小超出这个值时派送。
                    alert('上传的文件超过最大尺寸限制。');
                    break;
                case 'Q_TYPE_DENIED':
                    //当文件类型不满足时触发。
                    alert('只支持上传 ' + self.settings.accept.extensions + ' 格式的文件。');
                    break;
                default:
                    break;
            }
        });

        // 文件上传过程中创建进度条实时显示。
        uploader.on('uploadProgress', function(file, percentage) {
            var $li = $('#' + file.id),
                $percent = $li.find('.progress-box .sr-only');

            // 避免重复创建
            if (!$percent.length) {
                $percent = $('<div class="progress-box"><span class="progress-bar radius"><span class="sr-only" style="width:0%"></span></span></div>').appendTo($li).find('.sr-only');
            }
            $li.find(".state").text("上传中");
            $percent.css('width', percentage * 100 + '%');
        });

        // 文件上传成功，给item添加成功class, 用样式标记上传成功。
        uploader.on('uploadSuccess', function(file, response) {

            $('#' + file.id).addClass('upload-state-success').find(".state").text("已上传");

            self.settings.uploadSuccess(file, response);
        });

        // 文件上传失败，显示上传出错。
        uploader.on('uploadError', function(file) {
            $('#' + file.id).addClass('upload-state-error').find(".state").text("上传出错");
        });

        // 完成上传完了，成功或者失败，先删除进度条。
        uploader.on('uploadComplete', function(file) {

            $('#' + file.id).find('.progress-box').fadeOut();
        });

        uploader.on('all', function(type) {
            if (type === 'startUpload') {
                state = 'uploading';
            } else if (type === 'stopUpload') {
                state = 'paused';
            } else if (type === 'uploadFinished') {
                state = 'done';
            }

            if (state === 'uploading') {
                $btn.text('暂停上传');
            } else {
                $btn.text('开始上传');
            }
        });

        $btn.on('click', function() {
            if (state === 'uploading') {
                uploader.stop();
            } else {
                uploader.upload();
            }
        });
    }
};

OLS.Question = {};

function renderPaper(eptId, epId) {

    $.post('/ExaminationPaperTemplate/GetQuestionsForUser', {
            eptId: eptId,
            epId: epId
        }, function(data) {

            var paperContainer;
            var questions, answers, paperData;
            var epId, uId;

            paperContainer = $('#PaperContainer');
            paperContainer.html('');

            if (1 == data.status) {

                data.data = JSON.parse(data.data);
                questions = data.data[0];
                answers = data.data[1];
                epId = data.data[2];

                paperData = adjustQuestions(questions, answers);
                paperData = {
                    epId: epId,
                    uId: uId,
                    types: paperData
                };

                paperContainer.addClass('bg-f')
                $('#PaperTmpl').tmpl(paperData).appendTo(paperContainer);

                // 在本地保存考题数据
                initLocalQuestions('#PaperContainer', questions, answers);

                // 清除未选评分项
                $('span.grade i.active').each(function() {
                    $(this).parentsUntil('div').last().attr('data-active', 1);
                });
                $('span.grade:not([data-active])').hide();

            } else {

                paperContainer
                    .removeClass('bg-f')
                    .html('<div class="prompt">' + data.message.replace(/。/g, '') + '</div>');
            }
        }, 'json')
        .error(function() {

            alert('请求返回错误！');
        });
}

function initButtonEvent() {

    $('#ExaminationPaperGradeContainer').on('click', '#Close', function() {
        layer_close();
    });
}
