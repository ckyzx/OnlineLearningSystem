$(function () {

    var table;

    table = $('.table-sort').DataTable({
        "processing": true,
        "serverSide": true,
        "ajax": {
            "url": "/Question/ListDataTablesAjax",
            "type": "POST"
        },
        "stateSave": false,
        "lengthChange": false,
        "pageLength": 15,
        "sorting": [[1, "desc"]],
        "columnDefs": [{ "orderable": false, "targets": [0, 6]}],
        "columns": [
                {
                    "width": "10px",
                    "className": "text-c",
                    "defaultContent": '<input type="checkbox" value="" name="">'
                },
                { "name": "Q_Id", "data": "Q_Id" },
                { "name": "Q_Type", "data": "Q_Type" },
                { "name": "Q_ClassifyName", "data": "Q_ClassifyName" },
                { "name": "Q_AddTime", "defaultContent": '<span class="Q_AddTime"></span>' },
                { "name": "Q_Content", "defaultContent": '<span class="Q_Content"></span>' },
                { "name": "Q_DifficultyCoefficient", "data": "Q_DifficultyCoefficient" },
                {
                    "width": "80px",
                    "className": "text-c",
                    "defaultContent":
                        '<a style="text-decoration: none" class="recycle fz-18" href="javascript:;" title="回收"><i class="Hui-iconfont">&#xe6de;</i></a>' +
                        '<a style="text-decoration: none" class="edit ml-5 fz-18" href="javascript:;" title="编辑"><i class="Hui-iconfont">&#xe6df;</i></a>' +
                        '<a style="text-decoration: none" class="delete ml-5 fz-18" href="javascript:;" title="删除"><i class="Hui-iconfont">&#xe6e2;</i></a>'
                }
            ],
        "createdRow": function (row, data, dataIndex) {

            var span, strDate, date, content;

            row = $(row);

            span = row.find('span.Q_AddTime');
            strDate = data['Q_AddTime'];
            date = strDate.jsonDateToDate(strDate);
            strDate = date.format('yyyy-MM-dd hh:mm:ss');

            span.text(strDate);

            span = row.find('span.Q_Content');
            content = data['Q_Content'];
            content = content.replace(/\\r\\n/g, '<br />');

            span.html(content);
        }
    });

    $('.table-sort tbody').on('click', 'a.recycle', function () {

        var data, id;

        data = table.row($(this).parents('tr')).data();
        id = data['Q_Id'];

        alert(id);
    });

    $('.table-sort tbody').on('click', 'a.edit', function () {

        var data, id;

        data = table.row($(this).parents('tr')).data();
        id = data['Q_Id'];

        alert(id);
    });

    $('.table-sort tbody').on('click', 'a.delete', function () {

        var data, id;

        data = table.row($(this).parents('tr')).data();
        id = data['Q_Id'];

        alert(id);
    });

    $('#CreateBtn').on('click', function () {
        ShowPage('添加试题', '/Question/Create');
    });

    $('#DocxUploadBtn').on('click', function () {
        ShowPageWithSize('导入试题', '/Question/DocxUploadAndImport', 800, 300);
    });
});