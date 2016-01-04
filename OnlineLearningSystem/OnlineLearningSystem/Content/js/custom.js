
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
        area: ['800px', '600px']
    });
    layer.full(index);
}

function ShowPageWithSize(title, url, w, h) {
    layer.open({
        type: 2,
        area: [w + 'px', h + 'px'],
        fix: false, //不固定
        shade: 0.4,
        title: title,
        content: url
    });
}

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

Kyzx.Common = {
    getElemHeight: function(elem) {

        var h;

        elem = $(elem);
        h = elem.height() + parseInt(elem.css('margin-top')) + parseInt(elem.css('margin-bottom')) + parseInt(elem.css('padding-top')) + parseInt(elem.css('padding-bottom'));

        return h;
    }
};
