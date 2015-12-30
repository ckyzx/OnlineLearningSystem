$(function () {

    window.name = 'Background';

    $('a.show-page').on('click', function () {

        var a, title, url;

        a = $(this);
        title = a.attr('data-title');
        url = a.attr('data-url');
        width = a.attr('data-width');
        height = a.attr('data-height');

        ShowPageWithSize(title, url, width, height);
    });

    $('#Logout').on('click',function(){

        $.cookie('save_login_state', null, {path: '/'});

        location.href = '/User/Logout';
    });
});