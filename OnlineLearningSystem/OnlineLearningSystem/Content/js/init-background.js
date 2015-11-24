$(function () {

    window.name = 'Background';

    $('a.show-page').on('click', function () {

        var a, title, url;

        a = $(this);
        title = a.attr('title');
        url = a.attr('url');
        width = a.attr('width');
        height = a.attr('height');

        ShowPageWithSize(title, url, width, height);
    });
});