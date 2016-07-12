$(function() {

    var videoJson;

    // 调整图片尺寸
    // $('img').css({
    //     position: 'absolute',
    //     left: $('body').width() + 100 + 'px'
    // })

    // $('img').on('load', function(){
    $('img').each(function(){
        var img, content;
        var imgW, imgH, w, h;

        content = $('.ld-content');
        w = content.width();

        img = $(this);
        imgW = img.width();
        imgH = img.height();

        if(imgW > w){
            imgH = parseInt(w / imgW * imgH);
            imgW = w;
        }

        img.css({
            'position': 'static',
            'width': imgW + 'px',
            'height': imgH + 'px'
        });
    });


    videoJson = $('#LD_Video').val();

    if (videoJson != '') {

        videoJson = JSON.parse(videoJson);

        // jwplayer
        /*jwplayer('VideoPlayer').setup({
            flashplayer: '/Contents/lib/jwplayer-7.3.4/jwplayer.flash.swf',
            file: videoJson.path,
            width: 600,
            height: 400,
            dock: false
        });*/

        // ckplayer
        var flashvars = {
            f: videoJson.path,
            c: 0,
            b: 1
        };
        var params = {
            bgcolor: '#FFF',
            allowFullScreen: true,
            allowScriptAccess: 'always',
            wmode: 'transparent'
        };
        CKobject.embedSWF('/Contents/lib/ckplayer_6.7/ckplayer.swf', 'VideoPlayer', 'VideoPlayerContainer', '600', '400', flashvars, params);

        $('.ld-video-player-container').css({
            'margin': '20px auto',
            'width': '600px',
            'height': '400px'
        });
    }
});
