$(function() {

    var jqTable, dataTable;
    var request, departmentId;

    request = Request.init();
    departmentId = Request.getValue('departmentId', -1);

    jqTable = $('.department-table');

    if (undefined == jqTable.attr('id')) {
        jqTable.attr('id', 'DepartmentTable');
    }

    dataTable = jqTable.DataTable({
        "ordering": false,
        "pageLength": -1,
        "lengthChange": false,
        "columnDefs": [{
            "orderable": false,
            "targets": [0, 4]
        }],
        "columns": [{
            "width": "10px"
        }, {
            "className": "D_Id",
            "width": "30px"
        }, {
            "className": "nowrap"
        }, {
            "className": "nowrap"
        }, {
            "width": "40%"
        }],
        "drawCallback": function(settings) {

            var api;
            var radios, container, countSpan;

            api = this.api();
            Kyzx.List.resetId(api, 'D_Id');

            radios = jqTable.find(':checked[name=departments]');
            if (radios.length == 0 && departmentId != -1) {

                jqTable.find(':radio[value=' + departmentId + ']').get(0).checked = true;
                $(jqTable.attr('data-value-selector')).val('[' + departmentId + ']');
            }
        }
    });
});