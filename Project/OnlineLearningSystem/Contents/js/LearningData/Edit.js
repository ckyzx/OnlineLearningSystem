$(function() {

    var ldContentInput, ueContent;
    var videoJson;

    ldContentInput = $('#LearningDataContent');
    if ($('#LD_Content').length == 0) {
        $('<script id="LD_Content" name="LD_Content" type="text/plain" style="width:100%;height:400px;">' + ldContentInput.val() + '</script>').insertBefore(ldContentInput);
    }
    ueContent = UE.getEditor('LD_Content');

    // 视频上传
    WebUploaderHelper.init({
        action: 'uploadvideo',
        accept: {
            title: 'Video',
            extensions: 'flv,mp4',
            mimetypes: 'flv-application/octet-stream,video/mp4'
        },
        uploadSuccess: function(file, response) {

            var video;

            videoJson = { name: response.title, path: '/Contents/lib/ueditor/1.4.3/net/' + response.url };
            videoJson = JSON.stringify(videoJson);

            $('#LD_Video').val(videoJson);
        }
    });

    videoJson = $('#LD_Video').val();
    if (videoJson != '') {

        videoJson = JSON.parse(videoJson);
        $('#fileList').append('<div class="item mt-3 mb-10"><div class="info">' + videoJson.name + '</div></div>')
    }
});