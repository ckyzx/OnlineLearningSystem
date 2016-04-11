/*H-ui.admin.js v2.3.1 date:15:42 2015.08.19 by:guojunhui*/
/*获取顶部选项卡总长度*/
function tabNavallwidth() {
    var taballwidth = 0,
        $tabNav = $(".acrossTab"),
        $tabNavWp = $(".Hui-tabNav-wp"),
        $tabNavitem = $(".acrossTab li"),
        $tabNavmore = $(".Hui-tabNav-more");
    if (!$tabNav[0]) {
        return
    }
    $tabNavitem.each(function(index, element) {
        taballwidth += Number(parseFloat($(this).width() + 60))
    });
    $tabNav.width(taballwidth + 25);
    var w = $tabNavWp.width();
    if (taballwidth + 25 > w) {
        $tabNavmore.show()
    } else {
        $tabNavmore.hide();
        $tabNav.css({
            left: 0
        })
    }
}

/*左侧菜单响应式*/
function Huiasidedisplay() {
    if ($(window).width() >= 768) {
        $(".Hui-aside").show()
    }
}

function getskincookie() {
    var v = getCookie("Huiskin");
    if (v == null || v == "") {
        v = "default";
    }
    $("#skin").attr("href", "/Contents/skin/" + v + "/skin.css");
}
/*弹出层*/
/*
    参数解释：
    title   标题
    url     请求的url
    id      需要操作的数据id
    w       弹出层宽度（缺省调默认值）
    h       弹出层高度（缺省调默认值）
*/
function layer_show(title, url, w, h) {
    if (title == null || title == '') {
        title = false;
    };
    if (url == null || url == '') {
        url = "404.html";
    };
    if (w == null || w == '') {
        w = 800;
    };
    if (h == null || h == '') {
        h = ($(window).height() - 50);
    };
    layer.open({
        type: 2,
        area: [w + 'px', h + 'px'],
        fix: false, //不固定
        maxmin: true,
        shade: 0.4,
        title: title,
        content: url
    });
}
/*关闭弹出框口*/
function layer_close() {

    var iframeName, search, path;
    var redirect, close;

    iframeName = window.name;
    path = location.pathname;

    redirect = function(href) {
        search = location.search;
        if (search != "") {
            search = search.substring(search.indexOf('p_'));
            search = '?' + search.replace(/p_/g, '');
        }
        location.href = href + search;
    };

    close = function(layerName) {
        var index;
        index = parent.layer.getFrameIndex(layerName);
        parent.layer.close(index);
    };

    if (iframeName == '') {

        if (path.indexOf('Create') != -1) {
            redirect(path.replace('Create', 'List'));
        } else if (path.indexOf('Edit') != -1) {
            redirect(path.replace('Edit', 'List'));
        } else {
            close(iframeName);
        }
    } else if (path != iframeName && iframeName.indexOf('/') != -1) {

        redirect(iframeName);
    } else {
        close(iframeName);
    }
}
