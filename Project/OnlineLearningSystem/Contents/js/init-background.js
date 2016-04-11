$(function() {

    window.name = 'Background';

    $('a.show-page').on('click', function() {

        var a, title, url;

        a = $(this);
        title = a.attr('data-title');
        url = a.attr('data-url');
        width = a.attr('data-width');
        height = a.attr('data-height');

        Kyzx.Utility.showPageWithSize(title, url, width, height);
    });

    $('#Logout').on('click', function() {

        $.cookie('save_login_state', null, { path: '/' });

        location.href = '/User/Logout';
    });

    // 定时刷新用户在线时间
    Kyzx.Common.refreshUserOnlineTime();
    
    $('body').everyTime(20 * 60 + 's', 'RefreshUserOnlineTime', function() {
        Kyzx.Common.refreshUserOnlineTime();
    });

    // 定时获取用户在线人数
    if ($('#User').attr('permissions').indexOf('/User/ListOnline;') != -1) {
        
        Kyzx.Common.setUserOnlineNumber('#UserOnlineNumber');

        $('body').everyTime(20 * 60 + 's', 'SetUserOnlineNumber', function() {
            Kyzx.Common.setUserOnlineNumber('#UserOnlineNumber');
        });
    }
});