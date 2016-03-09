$(function() {
    //getskincookie();
    //layer.config({extend: 'extend/layer.ext.js'});
    Huiasidedisplay();
    var resizeID;
    $(window).resize(function() {
        clearTimeout(resizeID);
        resizeID = setTimeout(function() {
            Huiasidedisplay();
        }, 500);
    });

    $(".Hui-nav-toggle").click(function() {
        $(".Hui-aside").slideToggle();
    });
    $(".Hui-aside").on("click", ".menu_dropdown dd li a", function() {
        if ($(window).width() < 768) {
            $(".Hui-aside").slideToggle();
        }
    });
    /*左侧菜单*/
    $.Huifold(".menu_dropdown dl dt", ".menu_dropdown dl dd", "fast", 1, "click");
    /*选项卡导航*/

    $(".Hui-aside").on("click", ".menu_dropdown a", function() {
        a_click(this, window.parent, true);
    });

    $('a.desktop').on('click', function() {
		a_click(this, window);
    });

    function a_click(_this, win, refresh) {

        if ($(_this).attr('_href')) {
            var bStop = false;
            var bStopIndex = 0;
            var _href = $(_this).attr('_href');
            var _titleName = $(_this).html();
            var topWindow = $(win.document);
            var show_navLi = topWindow.find("#min_title_list li");
            show_navLi.each(function() {
                if ($(this).find('span').attr("data-href") == _href) {
                    bStop = true;
                    bStopIndex = show_navLi.index($(this));
                    return false;
                }
            });
            if (!bStop) {
                creatIframe(_href, _titleName);
                min_titleList();
            } else {
                show_navLi.removeClass("active").eq(bStopIndex).addClass("active");
                var iframe_box = topWindow.find("#iframe_box");

                if(refresh){
                	iframe_box.find(".show_iframe").hide().eq(bStopIndex).show().find("iframe").attr("src", _href);
                }else{
                	iframe_box.find(".show_iframe").hide().eq(bStopIndex).show().find("iframe");
                }
            }
        }
    }

    function min_titleList() {
        var topWindow = $(window.parent.document);
        var show_nav = topWindow.find("#min_title_list");
        var aLi = show_nav.find("li");
    };

    function creatIframe(href, titleName) {

        var topWindow = $(window.parent.document);
        var show_nav = topWindow.find('#min_title_list');
        show_nav.find('li').removeClass("active");
        var iframe_box = topWindow.find('#iframe_box');
        show_nav.append('<li class="active"><span data-href="' + href + '">' + titleName + '</span><i></i><em></em></li>');
        tabNavallwidth();
        var iframeBox = iframe_box.find('.show_iframe');
        iframeBox.hide();
        iframe_box.append('<div class="show_iframe"><div class="loading"></div><iframe frameborder="0" src=' + href + '></iframe></div>');
        
        var showBox = iframe_box.find('.show_iframe:visible');
        var iframe;

        iframe = showBox.find('iframe');
        iframe.get(0).contentWindow.name = href;
        iframe.attr("src", href).load(function() {
            showBox.find('.loading').hide();
        });
    }

    var num = 0;
    var oUl = $("#min_title_list");
    var hide_nav = $("#Hui-tabNav");
    $(document).on("click", "#min_title_list li", function() {
        var bStopIndex = $(this).index();
        var iframe_box = $("#iframe_box");
        $("#min_title_list li").removeClass("active").eq(bStopIndex).addClass("active");
        iframe_box.find(".show_iframe").hide().eq(bStopIndex).show();
    });
    $(document).on("click", "#min_title_list li i", function() {
        var aCloseIndex = $(this).parents("li").index();
        $(this).parent().remove();
        $('#iframe_box').find('.show_iframe').eq(aCloseIndex).remove();
        num == 0 ? num = 0 : num--;
        tabNavallwidth();
    });
    $(document).on("dblclick", "#min_title_list li", function() {
        var aCloseIndex = $(this).index();
        var iframe_box = $("#iframe_box");
        if (aCloseIndex > 0) {
            $(this).remove();
            $('#iframe_box').find('.show_iframe').eq(aCloseIndex).remove();
            num == 0 ? num = 0 : num--;
            $("#min_title_list li").removeClass("active").eq(aCloseIndex - 1).addClass("active");
            iframe_box.find(".show_iframe").hide().eq(aCloseIndex - 1).show();
            tabNavallwidth();
        } else {
            return false;
        }
    });
    tabNavallwidth();

    $('#js-tabNav-next').click(function() {
        num == oUl.find('li').length - 1 ? num = oUl.find('li').length - 1 : num++;
        toNavPos();
    });
    $('#js-tabNav-prev').click(function() {
        num == 0 ? num = 0 : num--;
        toNavPos();
    });

    function toNavPos() {
        oUl.stop().animate({
            'left': -num * 100
        }, 100);
    }

    /*换肤*/
    $("#Hui-skin .dropDown-menu a").click(function() {
        var v = $(this).attr("data-val");
        setCookie("Huiskin", v);
        $("#skin").attr("href", "/Contents/skin/" + v + "/skin.css");
    });
});