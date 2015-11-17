/* 在模态框中显示页面 */
function ShowPage(title, url) {
    var index = layer.open({
        type: 2,
        title: title,
        content: url,
        // 初始化为小区域，可避免展现错位的控件
        //area: ['180px', '36px']
        area: ['800px', '600px']
    });
    layer.full(index);
}

function ShowPageWithSize(title, url, w, h) {
    layer_show(title, url, w, h);
}

function renderMenu(authorize) {

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
