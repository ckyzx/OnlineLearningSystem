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

    redirect: function(title, url){

        var search;

        search = location.search;
        if(search != ''){
            search = search.substring(1);
            search = 'p_' + search.replace(/&/g, '&p_');
        }

        url = url.indexOf('?') != -1 ? (url + '&' + search) : (url + '?' + search);
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
        additionRequestParams: null // 格式：[{ name: '[paramName]', input: '[paramInputSelector]' }]
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

            self.settings.dtParams.ajax.url +=
                '?' + self.settings.treeIdName + '=' +
                self.request.getValue(self.settings.treeIdName, self.settings.treeIdDefaultValue);
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

                var url;

                url = '/' + self.settings.modelEnName + '/Create';
                if (self.settings.treeIdName) {
                    url += '?' + self.settings.treeIdName + '=' + self.request.getValue(self.settings.treeIdName, 0);
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

                recycleBin.attr('data-status', status);
                self.dataTables.ajax.reload((null, true));

                self._showControlBtn(status);
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
                }
            };

            ul = $('.tree-container ul');
            nodes = ul.attr('data-ztree-json');
            nodes = $.parseJSON(nodes);

            for (var i = 0; i < nodes.length; i++) {

                n = nodes[i];

                if (n[self.settings.treeIdName] == nodeId) {

                    n.ifChecked = true;
                }

                n.click = 'location.href = \'/' + self.settings.modelEnName + '/' +
                    (self.settings.actionName == null ? 'List' : self.settings.actionName) +
                    '?status=' + status + '&' + self.settings.treeIdName + '=' + n[self.settings.treeIdName] + '\';';
            };

            // 添加根节点“全部”
            nodes = [{
                name: '全部',
                open: true,
                click: 'location.href = \'/' + self.settings.modelEnName + '/' +
                    (self.settings.actionName == null ? 'List' : self.settings.actionName) +
                    '?status=' + status + '&' + self.settings.treeIdName + '=0\';',
                children: nodes
            }];
            nodes[0][self.settings.treeIdName] = 0;

            if (0 == nodeId) {

                nodes[0].ifChecked = true;
            }

            ztree = $.fn.zTree.init(ul, settings, nodes);

        }
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

    _addBatchControlBtn: function(){

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

        batchBtnClick = function(operate){

            var checkboxs;
            var ids;
            var url;

            checkboxs = $('.list-body tbody input:checked');
            if (checkboxs.length == 0) {

                alert('请选择数据项。');
                return;
            }

            ids = '';
            checkboxs.each(function(){
                ids += this.value + ',';
            });
            ids = ids != '' ? ids.substring(0, ids.length - 1) : 0;

            if(ids == 0){
                return;
            }

            url = location.pathname;
            url = url.substring(0, url.lastIndexOf('/') + 1);
            url += operate;

            if(!confirm('确定执行批量操作吗？')){
                return;
            }

            $.post(url, {ids: ids}, function(data){

                if(data.status == 1){
                    self.dataTables.ajax.reload(null, false);
                }
                else if(data.status == 0){
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

            if(!confirm('是否确定执行删除操作？')){
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

OLS.ExaminationTask = {
    settings: {
        idPrefix: ''
    },
    s: null,
    v: {
        ztree: null,
        qcZtree: null,
        userIds: [],
        userNames: [],
        departmentIds: [],
        departmentNames: []
    },

    init: function(settings) {

        $.extend(this.settings, settings);

        this.s = this.settings;

        // 初始化任务模板事件
        this.initTemplateEvent();

        // 初始化成绩统计方式控件事件
        this.initStatisticTypeEvent();

        // 初始化出题方式控件事件
        this.initModeEvent();

        // 初始化出题方式控件事件
        this.initAutoTypeEvent();

        // 初始化部门/用户选择控件
        this.renderDepartmentsAndUsers();

        // 初始化试题分类选择控件
        this.renderQuestionClassifies();

        // 初始化自动出题比例选择控件
        this.renderAutoRatio();

        // 初始化开始时间、结束时间控件事件
        this.initStartTimeEvent();
        this.initEndTimeEvent();

        // 初始化控件
        this.initControls();

        return this;
    },

    initTemplateEvent: function() {

        var me;

        me = this;

        $('#' + me.s.idPrefix + 'Template').on('change', function() {

            var select, template, departmentIds, userIds;
            var ztree, nodes, autoClassifies;

            select = $(this);
            template = select.val();

            if ('' == template) {
                return;
            }

            template = $.parseJSON(template);

            $('#' + me.s.idPrefix + 'Type').val(template.ETT_Type);
            $('#' + me.s.idPrefix + 'ParticipatingDepartment').val(template.ETT_ParticipatingDepartment);
            $('#' + me.s.idPrefix + 'Attendee').val(template.ETT_Attendee);
            $('#' + me.s.idPrefix + 'StatisticType').val(template.ETT_StatisticType).change();
            $('#' + me.s.idPrefix + 'TotalScore').val(template.ETT_TotalScore);
            $('#' + me.s.idPrefix + 'TotalNumber').val(template.ETT_TotalNumber)
            $('#' + me.s.idPrefix + 'Mode').val(template.ETT_Mode).change();
            $('#' + me.s.idPrefix + 'AutoType').val(template.ETT_AutoType).change();
            $('#AutoOffsetDayContainer .offset-day-num').val(template.ETT_AutoOffsetDay).change();
            $('#' + me.s.idPrefix + 'DifficultyCoefficient').val(template.ETT_DifficultyCoefficient);
            $('#' + me.s.idPrefix + 'AutoClassifies').val(template.ETT_AutoClassifies);
            $('#' + me.s.idPrefix + 'AutoRatio').val(template.ETT_AutoRatio);
            $('#' + me.s.idPrefix + 'StartTime').val(template.ETT_StartTime.toDate().format('yyyy/M/d hh:mm:ss'));
            $('#' + me.s.idPrefix + 'EndTime').val(template.ETT_EndTime.toDate().format('yyyy/M/d hh:mm:ss'));
            $('#' + me.s.idPrefix + 'TimeSpan').val(template.ETT_TimeSpan);

            departmentIds = $.parseJSON(template.ETT_ParticipatingDepartment);
            userIds = $.parseJSON(template.ETT_Attendee);

            // 设置参与人员
            ztree = $.fn.zTree.getZTreeObj('DepartmentsAndUsers');
            nodes = ztree.getNodes();
            me.setDepartmentsAndUsersNodeChecked(ztree, nodes, departmentIds, userIds);

            // 设置自动出题分类
            ztree = $.fn.zTree.getZTreeObj('QuestionClassifies');
            nodes = ztree.getNodes();
            autoClassifies = JSON.parse(template.ETT_AutoClassifies);
            me.setQuestionClassifiesNodeChecked(ztree, nodes, autoClassifies);

            // 设置出题比例
            me.setAutoRatio($('#RatioContainer'), JSON.parse(template.ETT_AutoRatio));

            // 设置开始时间、结束时间
            me._setTime('StartTime');
            me._setTime('EndTime');
        });
    },

    initStatisticTypeEvent: function() {

        var me;

        me = this;

        $('#' + me.s.idPrefix + 'StatisticType').on('change', function() {

            var select, etTotalScore, etTotalNumber, tsContainer, anContainer;
            var type;

            select = $(this);
            type = parseInt(select.val());

            etTotalScore = $('#' + me.s.idPrefix + 'TotalScore');
            etTotalNumber = $('#' + me.s.idPrefix + 'TotalNumber');
            tsContainer = etTotalScore.parentsUntil('form').last();
            anContainer = etTotalNumber.parentsUntil('form').last();

            switch (type) {
                case 0:

                    tsContainer.hide();
                    anContainer.hide();

                    break;
                case 1:

                    tsContainer.show();
                    anContainer.hide();

                    break;
                case 2:

                    tsContainer.hide();
                    anContainer.show();

                    break;
                default:
                    break;
            }

        });
        $('#' + me.s.idPrefix + 'StatisticType').change();
    },

    initModeEvent: function() {

        var etMode, etAutoType;
        var autoType;
        var me;

        me = this;

        etMode = $('#' + me.s.idPrefix + 'Mode');
        etAutoType = $('#' + me.s.idPrefix + 'AutoType');

        etMode.on('change', function() {

            var etMode, etAutoType;
            var mode;

            etAutoType = $('#' + me.s.idPrefix + 'AutoType');

            etMode = $(this);
            mode = parseInt(etMode.val());

            switch (mode) {
                case 0:

                    etAutoType.find('option[value=0]').get(0).selected = true;
                    etAutoType.change();
                    break;
                case 1:

                    etAutoType.find('option[value=1]').get(0).selected = true;
                    etAutoType.change();
                    break;
                case 2:

                    etAutoType.find('option[value=4]').get(0).selected = true;
                    etAutoType.change();
                    break;
                default:
                    break;
            }
        });

        etAutoType.attr('data-origin-value', etAutoType.val());

        etMode.change();

        etAutoType.val(etAutoType.attr('data-origin-value'));
    },

    initStartTimeEvent: function() {

        var me = this;

        me._initDateTimeControl('StartTime');
        me._setTime('StartTime');
    },

    initEndTimeEvent: function() {

        var me = this;

        me._initDateTimeControl('EndTime');
        me._setTime('EndTime');
    },

    _initDateTimeControl: function(controlId) {

        var me = this;

        $('#' + controlId)
            .on('change', 'select', function() {

                var container, hourcombo, mincombo, seccombo;
                var hour, min, sec, datetime;

                container = $(this).parent();
                hourcombo = container.find('select.hourcombo');
                mincombo = container.find('select.mincombo');
                seccombo = container.find('select.seccombo');

                hour = hourcombo.val();
                min = mincombo.val();
                sec = seccombo.val();

                datetime = '1970/1/1 ' + hour + ':' + min + ':' + sec;

                $('#' + me.s.idPrefix + controlId).val(datetime);
            });
    },

    initAutoTypeEvent: function() {

        var me;
        var etAutoType, etAutoOffsetDay;

        me = this;

        etAutoType = $('#' + me.s.idPrefix + 'AutoType');
        etAutoOffsetDay = $('#' + me.s.idPrefix + 'AutoOffsetDay');

        etAutoType.on('change', function() {

            var questionsList, etAutoType, etAutoOffsetDay, etaodContainer, atContainer,
                etContinuedDays, etMode, etStartDateContainer, etQuestions;
            var autoType;

            etAutoType = $('#' + me.s.idPrefix + 'AutoType');
            autoType = parseInt(etAutoType.val());
            atContainer = etAutoType.parentsUntil('form').last();

            etMode = $('#' + me.s.idPrefix + 'Mode');

            questionsList = $('#QuestionListSelectContainer');
            etStartDateContainer = $('#ETStartDateContainer');

            etAutoOffsetDay = $('#' + me.s.idPrefix + 'AutoOffsetDay');
            etaodContainer = etAutoOffsetDay.parentsUntil('form').last();

            etQuestions = $('#' + me.s.idPrefix + 'Questions');

            switch (autoType) {
                case 0:

                    me._hideAutoTaskControls();
                    questionsList.show();
                    etStartDateContainer.remove();

                    etMode.find('option[value=0]').get(0).selected = true;
                    break;
                case 1:

                    questionsList.find(':checkbox').attr('checked', false);
                    etQuestions.val('[]');
                    questionsList.hide();
                    etaodContainer.hide();
                    me._showAutoTaskControls();
                    etStartDateContainer.remove();
                    break;
                case 2:

                    questionsList.find(':checkbox').attr('checked', false);
                    etQuestions.val('[]');
                    questionsList.hide();
                    etaodContainer.show();
                    me._showAutoTaskControls();
                    etStartDateContainer.remove();
                    break;
                case 3:

                    questionsList.find(':checkbox').attr('checked', false);
                    etQuestions.val('[]');
                    questionsList.hide();
                    etaodContainer.show();
                    me._showAutoTaskControls();
                    etStartDateContainer.remove();
                    break;
                case 4:

                    me._hideAutoTaskControls();
                    questionsList.show();
                    me._showDateTimeControls();
                    me._renderStartDateControl();

                    etMode.find('option[value=2]').get(0).selected = true;

                    etContinuedDays = $('#' + me.s.idPrefix + 'ContinuedDays');
                    etContinuedDays.parentsUntil('form').last().show();
                    if (etContinuedDays.val() == 0) {
                        etContinuedDays.val(1);
                    }

                    break;
                default:
                    break;
            }

            me._renderOffsetDayNumberControl(autoType);
        });

        $('#AutoOffsetDayContainer').on('change', 'select.offset-day-num', function() {

            etAutoOffsetDay.val($(this).val());
        });

        etAutoOffsetDay.attr('data-origin-value', etAutoOffsetDay.val());

        etAutoType.change();

        $('#AutoOffsetDayContainer select.offset-day-num')
            .val(etAutoOffsetDay.attr('data-origin-value'))
            .change();
    },

    initControls: function() {

        var me;
        var etTimeSpan, etContinuedDays;

        me = this;

        if (!brower.ieVersion) {

            etTimeSpan = $('#' + me.s.idPrefix + 'TimeSpan');
            etContinuedDays = $('#' + me.s.idPrefix + 'ContinuedDays');

            $('script[src$="jquery.min.js"]').after('<script type="text/javascript" src="/Contents/lib/jquery-ui/jquery-ui.min.js"></script>');
            $('head').prepend('<link href="/Contents/lib/jquery-ui/jquery-ui.min.css" rel="stylesheet" type="text/css" />');

            etTimeSpan.spinner({
                min: 0,
                max: 600,
                step: 10
            });

            etContinuedDays.spinner({
                min: 1,
                max: 30,
                step: 1
            });

            etTimeSpan.parents('div').addClass('custom-spinner');
            etContinuedDays.parents('div').addClass('custom-spinner');
        }
    },

    /* --------------------------------------------------------------------------------- */

    _renderOffsetDayNumberControl: function(autoType) {

        var me;
        var aodContainer, etAutoOffsetDay, container, offsetDayNum;

        me = this;

        aodContainer = $('#AutoOffsetDayContainer');
        etAutoOffsetDay = $('#' + me.s.idPrefix + 'AutoOffsetDay');
        container = etAutoOffsetDay.parentsUntil('form').last();

        switch (autoType) {
            case 2:

                container.show();
                aodContainer.html('');
                aodContainer.append(
                    '<span class="offset-day-item">' +
                    '<span class="offset-day-text">每周星期</span>' +
                    '<span class="select-box">' +
                    '<select class="select offset-day-num">' +
                    '<option value="1">一</option>' +
                    '<option value="2">二</option>' +
                    '<option value="3">三</option>' +
                    '<option value="4">四</option>' +
                    '<option value="5">五</option>' +
                    '<option value="6">六</option>' +
                    '<option value="7">日</option>' +
                    '</select>' +
                    '</span>' +
                    '</span>')

                etAutoOffsetDay.val(1);
                break;
            case 3:

                container.show();
                aodContainer.html('');
                aodContainer.append(
                    '<span class="offset-day-item">' +
                    '<span class="offset-day-text">每月</span>' +
                    '<span class="select-box">' +
                    '<select class="select offset-day-num">' +
                    '</select>' +
                    '</span>' +
                    '<span class="offset-day-text">号</span>' +
                    '</span>')

                offsetDayNum = $('#AutoOffsetDayContainer select.offset-day-num');
                for (var i = 1; i < 32; i++) {
                    offsetDayNum.append('<option value="' + i + '">' + i + '</option>');
                }

                etAutoOffsetDay.val(1);
                break;
            default:

                container.hide();
                aodContainer.html('');
                etAutoOffsetDay.val(0);
                break;
        };
    },

    _renderStartDateControl: function() {

        var me;
        var etStartTime;
        var autoType, startTime, startDate;

        me = this;

        autoType = Number($('#' + me.s.idPrefix + 'AutoType').val());

        if (autoType != 4) {
            return;
        }

        etStartTime = $('#' + me.s.idPrefix + 'StartTime');
        startDate = etStartTime.val();
        startDate = startDate.toDate();
        if (startDate.getFullYear() == 1970) {
            startDate = (new Date()).add('d', 1).format('yyyy-MM-dd');
        } else {
            startDate = startDate.format('yyyy-MM-dd');
        }

        if ($('#ETStartDateContainer').length == 0) {

            $('#' + me.s.idPrefix + 'AutoType').parentsUntil('form').last().after(
                '<div id="ETStartDateContainer" class="row cl">' +
                '   <label class="form-label col-2">' +
                '       考试日期' +
                '   </label>' +
                '   <div class="formControls col-2">' +
                '       <input type="text" id="ETStartDate" value="' + startDate + '" class="input-text Wdate" onfocus="WdatePicker({minDate: \'%y-%M-%d\'});" />' +
                '   </div>' +
                '</div>');
        }
    },

    /* --------------------------------------------------------------------------------- */

    _showAutoTaskControls: function() {

        var me;

        me = this;

        $('#' + me.s.idPrefix + 'AutoType').parentsUntil('form').last().show();
        $('#' + me.s.idPrefix + 'AutoOffsetDay').parentsUntil('form').last().show();
        $('#' + me.s.idPrefix + 'DifficultyCoefficient').parentsUntil('form').last().show();
        $('#' + me.s.idPrefix + 'AutoClassifies').parentsUntil('form').last().show();
        $('#' + me.s.idPrefix + 'AutoRatio').parentsUntil('form').last().show();

        me._showDateTimeControls();
    },

    _showDateTimeControls: function() {

        var me;

        me = this;

        $('#' + me.s.idPrefix + 'StartTime').parentsUntil('form').last().show();
        $('#' + me.s.idPrefix + 'EndTime').parentsUntil('form').last().show();
    },

    _hideAutoTaskControls: function() {

        var me;

        me = this;

        $('#' + me.s.idPrefix + 'AutoType').parentsUntil('form').last().hide();
        $('#' + me.s.idPrefix + 'AutoOffsetDay').parentsUntil('form').last().hide();
        $('#' + me.s.idPrefix + 'DifficultyCoefficient').parentsUntil('form').last().hide();
        $('#' + me.s.idPrefix + 'AutoClassifies').parentsUntil('form').last().hide();
        $('#' + me.s.idPrefix + 'AutoRatio').parentsUntil('form').last().hide();
        $('#' + me.s.idPrefix + 'StartTime').parentsUntil('form').last().hide();
        $('#' + me.s.idPrefix + 'EndTime').parentsUntil('form').last().hide();
        $('#' + me.s.idPrefix + 'ContinuedDays').parentsUntil('form').last().hide();
    },

    _setTime: function(controlId) {

        var me = this;

        $('body').everyTime('3s', 'Set' + controlId, function() {

            var startTimeDiv, hourcombo, mincombo, seccombo;
            var startTime;

            startTimeDiv = $('#' + controlId);
            hourcombo = startTimeDiv.find('select.hourcombo');
            mincombo = startTimeDiv.find('select.mincombo');
            seccombo = startTimeDiv.find('select.seccombo');
            hourcombo.addClass('select');
            mincombo.addClass('select');
            seccombo.addClass('select');

            if (hourcombo.length > 0) {

                startTime = $('#' + me.s.idPrefix + controlId).val();
                startTime = startTime.toDate();

                hourcombo.val(startTime.getHours())
                mincombo.val(startTime.getMinutes());
                seccombo.val(startTime.getSeconds())

                $('body').stopTime('Set' + controlId);
            }
        });
    },

    validateCustomAutoTypeData: function(valid) {

        var etStartDate;
        var startDate;
        var me;

        me = this;

        etStartDate = $('#ETStartDate');
        startDate = etStartDate.val();

        if (startDate == '') {

            me.appendError('ETStartDate', '请选择考试日期', etStartDate);
            valid = false;
        }

        valid = this.validateStartTime(valid);
        valid = this.validateEndTime(valid);

        return valid;
    },

    validateAutoClassifies: function(valid) {

        var me;
        var acRegex;
        var etAutoClassifies;
        var autoClassifies;

        me = this;

        // 出题分类数据验证
        // 数据格式：['分类名1', '分类名2', ...]
        acRegex = /^\[(".+",?\s*)+\]$/g;

        etAutoClassifies = $('#' + me.s.idPrefix + 'AutoClassifies');
        autoClassifies = etAutoClassifies.val();

        if (!acRegex.test(autoClassifies)) {

            me.appendError(me.s.idPrefix + 'AutoClassifies', '请选择出题分类', etAutoClassifies);
            valid = false;
        }

        return valid;
    },

    validateAutoRatios: function(valid) {

        var me;
        var arRegex;
        var etAutoRatio;
        var autoRatio, ratioNumber;

        me = this;

        // 出题比例数据验证
        // 数据格式： [{type: '单选题', percent: 0.2}, {type: '多选题', percent: 0.2}, ...]
        arRegex = /^\[(\{"type"\:\s*".+"\,\s*"percent"\:\s*(0\.)?\d{1,2}},?\s*)+\]$/g;

        etAutoRatio = $('#' + me.s.idPrefix + 'AutoRatio');
        autoRatio = etAutoRatio.val();

        if (!arRegex.test(autoRatio)) {

            me.appendError(me.s.idPrefix + 'AutoRatio', '请输入出题比例', etAutoRatio)
            valid = false;
        }

        // 限制出题比例 >= 50% 与 <= 100%
        ratioNumber = 0;
        autoRatio = JSON.parse(autoRatio);
        for (var i = 0; i < autoRatio.length; i++) {
            ratioNumber += autoRatio[i].percent;
        }

        if (ratioNumber < 0.5 || ratioNumber > 1) {

            me.appendError(me.s.idPrefix + 'AutoRatio', '出题比例必须大于 50% 、小于 100%', etAutoRatio)
            valid = false;
        }

        return valid;
    },

    validateStartTime: function(valid) {

        var stRegex, stRegex1;
        var etStartTime;
        var startTime;
        var me;

        me = this;

        // 开始时间验证
        // 数据格式：2016/1/1 8:00:00
        stRegex = /^\d{4}\/\d{1,2}\/\d{1,2} (([0-9]{1})|(1{1}[0-9]{1})|(2{1}[0-3]{1})):[0-5]{1}[0-9]{0,1}:[0-5]{0,1}[0-9]{1}$/g;
        stRegex1 = /^\d{4}\/\d{1,2}\/\d{1,2} 0{1,2}:0{1,2}:0{1,2}$/g;

        etStartTime = $('#' + me.s.idPrefix + 'StartTime');
        startTime = etStartTime.val();

        if (stRegex1.test(startTime) || !stRegex.test(startTime)) {

            me.appendError(me.s.idPrefix + 'StartTime', '请选择开始时间', etStartTime);
            valid = false;
        }

        return valid;
    },

    validateEndTime: function(valid) {

        var stRegex, stRegex1;
        var etEndTime;
        var endTime;
        var me;

        me = this;

        // 结束时间验证
        // 数据格式：2016/1/1 8:00:00
        stRegex = /^\d{4}\/\d{1,2}\/\d{1,2} (([0-9]{1})|(1{1}[0-9]{1})|(2{1}[0-3]{1})):[0-5]{1}[0-9]{0,1}:[0-5]{0,1}[0-9]{1}$/g;
        stRegex1 = /^\d{4}\/\d{1,2}\/\d{1,2} 0{1,2}:0{1,2}:0{1,2}$/g;

        etEndTime = $('#' + me.s.idPrefix + 'EndTime');
        endTime = etEndTime.val();

        if (stRegex1.test(endTime) || !stRegex.test(endTime)) {

            me.appendError(me.s.idPrefix + 'EndTime', '请选择结束时间', etEndTime);
            valid = false;
        }

        return valid;
    },

    validateContinuedDays: function(valid) {

        var etAutoType, etContinuedDays;
        var autoType, continuedDays;
        var me;

        me = this;

        etAutoType = $('#' + me.s.idPrefix + 'AutoType');
        etContinuedDays = $('#' + me.s.idPrefix + 'ContinuedDays');

        autoType = Number(etAutoType.val());
        continuedDays = Number(etContinuedDays.val());

        if (!isNaN(autoType) && autoType == 4) {

            if (isNaN(continuedDays) || continuedDays == 0) {

                me.appendError(me.s.idPrefix + 'ContinuedDays', '请输入 1 至 30 之间的天数', etContinuedDays);
                valid = false;
            } else if (continuedDays > 30) {

                me.appendError(me.s.idPrefix + 'ContinuedDays', '请输入 1 至 30 之间的天数', etContinuedDays);
                valid = false;
            } else {
                etContinuedDays.val(continuedDays);
            }
        }

        return valid;
    },

    validateQuestions: function(valid) {
        'use strict';

        var me;
        var mode;
        var questions, qAry, statisticType, totalNumber, totalScore;
        var qsRegex;
        var sdiContainer;

        me = this;

        mode = Number($('#' + me.s.idPrefix + 'Mode').val());
        statisticType = Number($('#' + me.s.idPrefix + 'StatisticType').val());
        totalNumber = Number($('#' + me.s.idPrefix + 'TotalNumber').val());
        totalScore = Number($('#' + me.s.idPrefix + 'TotalScore').val());

        sdiContainer = $('.select-data-item');

        // 试题选择数据验证
        // 数据格式：[1, 2, ...]
        questions = $('#' + me.s.idPrefix + 'Questions').val();
        qsRegex = /^\[((\d+)|("{1}\d+"{1}),?\s*)+\]$/g;
        if (1 != mode && !qsRegex.test(questions)) {

            me.appendErrorAfter('Questions', '请选择试题', sdiContainer);
            return false;
        }

        qAry = JSON.parse(questions);
        if (1 != mode && qAry.length == 0) {

            me.appendErrorAfter('Questions', '请选择试题', sdiContainer);
            return false;
        }

        // 检查“已选试题数量”与“出题数量”是否一致
        if (1 != mode && qAry.length != 0 && statisticType == 2 && qAry.length != totalNumber) {

            me.appendErrorAfter('Questions', '已选试题数量与出题数量不一致', sdiContainer);
            return false;
        }

        // 限制选题数量
        if (1 != mode && qAry.length != 0 && statisticType == 1 && (totalScore * 0.1 > qAry.length || qAry.length > totalScore)) {

            me.appendErrorAfter('Questions', '选题总数不合理。选题数量最低应占总分的 10% ，最高不超过出题总分。', sdiContainer);
            return false;
        }

        return valid;
    },

    validateTotal: function(valid) {

        var me;
        var etTotalScore, etStatisticType, etTotalNumber;
        var totalScore, statisticType, totalNumber;

        me = this;

        etStatisticType = $('#' + me.s.idPrefix + 'StatisticType');
        statisticType = Number(etStatisticType.val());

        etTotalScore = $('#' + me.s.idPrefix + 'TotalScore');
        totalScore = parseInt(etTotalScore.val());

        etTotalNumber = $('#' + me.s.idPrefix + 'TotalNumber');
        totalNumber = parseInt(etTotalNumber.val());

        if (1 == statisticType && totalScore % 10 != 0) {

            me.appendError('TotalScore', '出题总分必须为 10 的倍数', etTotalScore);
            valid = false;
        } else if (2 == statisticType && totalNumber % 10 != 0) {

            me.appendError('TotalScore', '出题总数必须为 10 的倍数', etTotalNumber);
            valid = false;
        }

        return valid;
    },

    appendError: function(idValue, tip, jqElem) {

        var me = this;

        me._appendError(idValue, tip, jqElem.parents('div.row'));
    },

    _appendError: function(idValue, tip, container) {

        container.find('.custom-validation-error').remove();

        $('<div class="custom-validation-error col-offset-2" style="clear:both;">' +
            '<div class="cl"></div>' +
            '<span class="field-validation-error">' +
            '<span htmlfor="' + idValue + '" generated="true" class="">' + tip + '</span>' +
            '</span>' +
            '<div>').appendTo(container);
    },

    appendErrorBefore: function(idValue, tip, jqElem) {

        jqElem.parents('div.row').find('.custom-validation-error').remove();

        jqElem.before($('<div class="custom-validation-error">' +
            '<div class="cl"></div>' +
            '<span class="field-validation-error">' +
            '<span htmlfor="' + idValue + '" generated="true" class="">' + tip + '</span>' +
            '</span>' +
            '<div>'));
    },

    appendErrorAfter: function(idValue, tip, jqElem) {

        jqElem.parents('div.row').find('.custom-validation-error').remove();

        jqElem.after($('<div class="custom-validation-error">' +
            '<div class="cl"></div>' +
            '<span class="field-validation-error">' +
            '<span htmlfor="' + idValue + '" generated="true" class="">' + tip + '</span>' +
            '</span>' +
            '<div>'));
    },

    /* --------------------------------------------------------------------------------- */

    renderDepartmentsAndUsers: function() {

        var me;
        var dus, settings, nodes;

        me = this;

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

        dus = $('#DepartmentsAndUsers');
        nodes = dus.attr('data-value');
        nodes = $.parseJSON(nodes);

        me.v.userIds = $('#' + me.s.idPrefix + 'Attendee').val();
        me.v.userIds = $.parseJSON(me.v.userIds);
        me.v.departmentIds = $('#' + me.s.idPrefix + 'ParticipatingDepartment').val();
        me.v.departmentIds = $.parseJSON(me.v.departmentIds);

        me.v.ztree = $.fn.zTree.init(dus, settings, nodes);
        nodes = me.v.ztree.getNodes();
        me.setDepartmentsAndUsersNodeChecked(me.v.ztree, nodes, me.v.departmentIds, me.v.userIds);

        dus.find('.chk').attr('tabIndex', 1);
        dus.on('blur', '.chk', function() {
            me.setAttendees();
        });
    },

    getDepartmentsAndUsersNodeChecked: function(nodes) {

        var me;

        me = this;

        for (var i = 0; i < nodes.length; i++) {

            if (nodes[i].checked) {

                if (nodes[i].userNode) {

                    me.v.userIds.push(nodes[i].userId);
                    me.v.userNames.push(nodes[i].name);
                } else {

                    me.v.departmentIds.push(nodes[i].departmentId);
                    me.v.departmentNames.push(nodes[i].name);
                }
            }

            if (nodes[i].children != undefined) {

                me.getDepartmentsAndUsersNodeChecked(nodes[i].children);
            }
        }
    },

    setDepartmentsAndUsersNodeChecked: function(ztree, nodes, departmentIds, userIds) {

        var checkedCount, checked;
        var depNode, userNode, now;
        var me;

        me = this;

        checkedCount = 0;
        now = undefined == now ? (new Date()).format('yyyy-MM-dd hh:mm:ss.S') : now;
        /*for (var i = 0; i < nodes.length; i++) {

            for (var i1 = 0; i1 < userIds.length; i1++) {

                for (var i2 = 0; i2 < departmentIds.length; i2++) {

                    if (departmentIds[i2] == nodes[i].departmentId && userIds[i1] == nodes[i].userId) {

                        ztree.checkNode(nodes[i], true, true);
                        nodes[i].now = now;
                        checkedCount += 1;
                    } else if (nodes[i].now != now) {

                        ztree.checkNode(nodes[i], false, true);
                    }
                }
            }

            if (nodes[i].children != undefined) {

                checked = me.setDepartmentsAndUsersNodeChecked(ztree, nodes[i].children, departmentIds, userIds);
                if (checked) {
                    ztree.checkNode(nodes[i], true, true);
                }
            }
        }*/
        for (var i1 = 0; i1 < userIds.length; i1++) {

                for (var i2 = 0; i2 < departmentIds.length; i2++) {

                    depNode = ztree.getNodeByParam('departmentId', departmentIds[i2]);
                    userNode = ztree.getNodeByParam('userId', userIds[i1], depNode);

                    if(depNode != null && userNode != null){

                        ztree.checkNode(userNode, true, true);
                        userNode.now = now;
                        checkedCount += 1;
                    }else if(userNode != null && userNode.now != now){
                        ztree.checkNode(nodes[i], false, true);
                    }
                }
            }

        /*// 是否复选父节点
        if (nodes.length == checkedCount) {
            return true;
        }

        return false;*/
    },

    setAttendees: function() {

        var me;
        var nodes;

        me = this;

        // 设置参与部门/用户
        me.v.userIds = [];
        me.v.userNames = [];
        me.v.departmentIds = [];
        me.v.departmentNames = [];
        nodes = me.v.ztree.getNodes();

        me.getDepartmentsAndUsersNodeChecked(nodes);

        $('#' + me.s.idPrefix + 'ParticipatingDepartment').val(JSON.stringify(me.v.departmentIds));
        $('#' + me.s.idPrefix + 'Attendee').val(JSON.stringify(me.v.userIds));
    },

    /* --------------------------------------------------------------------------------- */

    renderQuestionClassifies: function() {

        var me;
        var settings, qcs, nodes, autoClassifies;

        me = this;

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

        qcs = $('#QuestionClassifies');
        nodes = qcs.attr('data-value');
        nodes = JSON.parse(nodes);
        nodes = [{
            name: '全部',
            questionClassifyId: 0,
            open: true,
            children: nodes
        }];

        me.v.qcZtree = $.fn.zTree.init(qcs, settings, nodes);
        nodes = me.v.qcZtree.getNodes();
        autoClassifies = $('#' + me.s.idPrefix + 'AutoClassifies').val();
        autoClassifies = JSON.parse(autoClassifies);
        me.setQuestionClassifiesNodeChecked(me.v.qcZtree, nodes, autoClassifies);

        qcs.find('.chk').attr('tabIndex', 1);
        qcs.on('blur', '.chk', function() {
            me.setClassifies();
        });
    },

    getQuestionClassifiesNodeChecked: function(nodes, autoClassifies) {

        var n;
        var me;

        me = this;

        autoClassifies = undefined == autoClassifies ? [] : autoClassifies;
        for (var i = 0; i < nodes.length; i++) {

            n = nodes[i];

            if (n.checked) {

                if (n.name && '全部' != n.name) {

                    autoClassifies.push(n.name);
                }
            }

            if (n.children != undefined) {

                autoClassifies = me.getQuestionClassifiesNodeChecked(n.children, autoClassifies);
            }
        }

        return autoClassifies;
    },

    setQuestionClassifiesNodeChecked: function(ztree, nodes, autoClassifies, now) {

        var checkedCount, checked;
        var now;
        var me;

        me = this;

        checkedCount = 0;
        now = undefined == now ? (new Date()).format('yyyy-MM-dd hh:mm:ss.S') : now;
        for (var i = 0; i < nodes.length; i++) {
            for (var i1 = 0; i1 < autoClassifies.length; i1++) {

                if (nodes[i].name == autoClassifies[i1]) {

                    ztree.checkNode(nodes[i], true, true);
                    nodes[i].now = now;
                    checkedCount += 1;
                } else if (nodes[i].now != now) {

                    ztree.checkNode(nodes[i], false, true);
                }
            }

            if (nodes[i].children != undefined) {

                checked = me.setQuestionClassifiesNodeChecked(ztree, nodes[i].children, autoClassifies, now);
                if (checked) {
                    ztree.checkNode(nodes[i], true, true);
                }
            }
        }

        // 是否复选父节点
        if (nodes.length == checkedCount) {
            return true;
        }

        return false;
    },

    setClassifies: function() {

        var me;
        var nodes, autoClassifies;

        me = this;

        // 设置自动出题分类
        nodes = me.v.qcZtree.getNodes();
        autoClassifies = me.getQuestionClassifiesNodeChecked(nodes);
        // 数据格式：['分类名1', '分类名2', ...]
        $('#' + me.s.idPrefix + 'AutoClassifies').val(JSON.stringify(autoClassifies));
    },

    /* --------------------------------------------------------------------------------- */

    renderAutoRatio: function() {

        var rs, r, p;
        var etAutoRatio, container;
        var me;

        me = this;

        etAutoRatio = $('#' + me.s.idPrefix + 'AutoRatio');
        rs = etAutoRatio.val();
        if (undefined == rs || '[]' == rs) {

            rs = me.getOriginRatios();
            etAutoRatio.val(JSON.stringify(rs));
        } else {
            rs = JSON.parse(rs);
        }

        container = $('#RatioContainer');

        for (var i = 0; i < rs.length; i++) {

            r = rs[i];
            p = r.percent * 100;

            $('<span class="ratio-item">' +
                '<span class="ratio-type">' + r.type + '</span>' +
                '<input type="text" class="input-text ratio-percent" value="' + p + '" data-origin-val="' + p + '" />%' +
                '</span>').appendTo(container);

        }

        container.on('change', 'input.ratio-percent', function() {

            var input;
            var ratio;

            input = $(this);
            ratio = input.val();

            if ('' == ratio || isNaN(ratio) || /[-.+]+/.test(ratio)) {

                alert('请输入整数。');
                ratio = input.attr('data-origin-val');
            }

            ratio = parseInt(ratio);
            input.val(ratio);

            input.attr('data-origin-val', ratio);

            me.setRatios();
        });
    },

    getOriginRatios: function() {

        return [{
            type: '单选题',
            percent: 0.2
        }, {
            type: '多选题',
            percent: 0.2
        }, {
            type: '判断题',
            percent: 0.2
        }, {
            type: '公文改错题',
            percent: 0.1
        }, {
            type: '计算题',
            percent: 0.1
        }, {
            type: '案例分析题',
            percent: 0.1
        }, {
            type: '问答题',
            percent: 0.1
        }];
    },

    getRatios: function() {

        var ratios;

        ratios = [];
        $('#RatioContainer').find('.ratio-item').each(function() {

            var item;
            var type, percent;

            item = $(this);
            type = item.find('.ratio-type').text();
            percent = item.find('input.ratio-percent').val();
            percent = parseInt(percent) / 100;

            ratios.push({
                type: type,
                percent: percent
            });
        });

        return ratios;
    },

    setRatios: function() {

            var me;

            me = this;

            // 设置自动出题比例
            $('#' + me.s.idPrefix + 'AutoRatio').val(JSON.stringify(me.getRatios()));
        }
        /* --------------------------------------------------------------------------------- */
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
