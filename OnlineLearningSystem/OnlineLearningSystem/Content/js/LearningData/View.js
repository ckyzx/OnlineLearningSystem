$(function() {

    var videoJson;

    videoJson = $('#LD_Video').val();

    if (videoJson != '') {

        videoJson = JSON.parse(videoJson);

        jwplayer('VideoPlayer').setup({
            flashplayer: '/Content/lib/jwplayer-7.3.4/jwplayer.flash.swf',
            file: videoJson.path,
            width: 500,
            height: 350,
            dock: false
        });

        $('.ld-video-player-container').css({
            'margin': '20px auto',
            'width': '500px',
            'height': '350px'
        });
    }
});
