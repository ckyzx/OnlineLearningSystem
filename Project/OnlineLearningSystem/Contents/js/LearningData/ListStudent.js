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
                '<a class="view mr-5 fz-16" href="javascript:void(0);" title="查看"><i class="Hui-iconfont">&#xe626;</i></a>'
        }],
        "createdRow": function(row, data, dataIndex) {

            var span;
            var strDate, date;

            row = $(row);

            span = row.find('span.LD_AddTime');
            strDate = data['LD_AddTime'];
            date = strDate.jsonDateToDate();
            strDate = date.format('yyyy-MM-dd hh:mm:ss');
            span.text(strDate);
        }
    };

    list = Kyzx.List.init({
        hasTree: true,
        dtSelector: '.table-sort',
        dtParams: dtParams,
        modelCnName: '资料',
        modelEnName: 'LearningData',
        modelPrefix: 'LD_',
        actionName: 'ListStudent',
        hasCreateBtn: false,
        hasRecycleBin: false,
        hasControlBtn: false,
        treeIdName: 'ldcId',
        /*treeIdDefaultValue: 0,*/
        additionRequestParams: [{name: 'ldcId', input: '#LDCId', value: 0}]
    });
    list.initList();

});
