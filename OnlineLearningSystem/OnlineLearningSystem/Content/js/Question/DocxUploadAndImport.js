﻿$(function() {

    $('.skin-minimal input').iCheck({
        checkboxClass: 'icheckbox-blue',
        radioClass: 'iradio-blue',
        increaseArea: '20%'
    });

    $list = $("#fileList"),
        $btn = $("#btn-star"),
        state = "pending",
        uploader;

    var uploader = WebUploader.create({
        auto: true,
        swf: '/Content/lib/webuploader/0.1.5/Uploader.swf',

        // 文件接收服务端。
        server: '/Content/lib/ueditor/1.4.3/net/controller.ashx?action=uploadfile',

        // 选择文件的按钮。可选。
        // 内部根据当前运行是创建，可能是input元素，也可能是flash.
        pick: '#filePicker',

        // 不压缩image, 默认如果是jpeg，文件上传前会压缩一把再上传！
        resize: false,
        // 只允许选择图片文件。
        accept: {
            title: 'Office Word',
            extensions: 'docx',
            mimeTypes: 'application/vnd.openxmlformats-officedocument.wordprocessingml.document'
        },
        fileVal: "upfile"
    });
    
    uploader.on('fileQueued', function(file) {
        var $li = $(
                '<div id="' + file.id + '" class="item">' +
                '<!--div class="pic-box"><img></div-->' +
                '<div class="info">' + file.name + '</div>' +
                '<p class="state">等待上传...</p>' +
                '</div>'
            ),
            $img = $li.find('img');
        $list.html($li);

        // 创建缩略图
        // 如果为非图片文件，可以不用调用此方法。
        // thumbnailWidth x thumbnailHeight 为 100 x 100
        uploader.makeThumb(file, function(error, src) {
            if (error) {
                $img.replaceWith('<span>不能预览</span>');
                return;
            }

            $img.attr('src', src);
        }, 100, 100);
    });

    uploader.on('error', function(type) {
        alert(type);
    });

    // 文件上传过程中创建进度条实时显示。
    uploader.on('uploadProgress', function(file, percentage) {
        var $li = $('#' + file.id),
            $percent = $li.find('.progress-box .sr-only');

        // 避免重复创建
        if (!$percent.length) {
            $percent = $('<div class="progress-box"><span class="progress-bar radius"><span class="sr-only" style="width:0%"></span></span></div>').appendTo($li).find('.sr-only');
        }
        $li.find(".state").text("上传中");
        $percent.css('width', percentage * 100 + '%');
    });

    // 文件上传成功，给item添加成功class, 用样式标记上传成功。
    uploader.on('uploadSuccess', function(file, response) {

        $('#' + file.id).addClass('upload-state-success').find(".state").text("已上传");
        $('#DocxImport').attr('file-path', response.url).fadeIn();
    });

    // 文件上传失败，显示上传出错。
    uploader.on('uploadError', function(file) {
        $('#' + file.id).addClass('upload-state-error').find(".state").text("上传出错");
    });

    // 完成上传完了，成功或者失败，先删除进度条。
    uploader.on('uploadComplete', function(file) {

        $('#' + file.id).find('.progress-box').fadeOut();
    });

    uploader.on('all', function(type) {
        if (type === 'startUpload') {
            state = 'uploading';
        } else if (type === 'stopUpload') {
            state = 'paused';
        } else if (type === 'uploadFinished') {
            state = 'done';
        }

        if (state === 'uploading') {
            $btn.text('暂停上传');
        } else {
            $btn.text('开始上传');
        }
    });

    $btn.on('click', function() {
        if (state === 'uploading') {
            uploader.stop();
        } else {
            uploader.upload();
        }
    });

    $('#DocxImport').on('click', function() {

        var layerIndex;
        var btn;
        var filePath, jqXHR;
        var message;

        layerIndex = layer.load(0, {
            shade: [0.3, '#FFF']
        });

        btn = $(this);
        btn.hide();
        filePath = btn.attr('file-path');

        if (filePath == undefined || filePath == null || filePath == '') {
            alert('未上传试题模板。');
        }

        filePath = '/Content/lib/ueditor/1.4.3/net/' + filePath;

        jqXHR = $.post('/Question/Import', {
                filePath: filePath
            }, function(data, textStatus, jqXHR) {

                layer.close(layerIndex);

                if (1 == data.Status) {

                    message = '题库导入成功。';
                    if (data.Message != '') {

                        message += '但含有以下问题：\r\n';
                        message += '    ' + data.Message + '\r\n';
                        message += '    请手工检查试题缓存列表。';
                    }
                    alert(message);

                    if (parent.name.toLowerCase().indexOf('list') != -1) {

                        parent.location.href = '/Question/List?status=4';
                    } else {
                        location.href = '/Question/List?status=4';
                    }
                } else if (0 == data.Status) {

                    btn.show();
                    alert(data.Message);
                }
            }, 'json')
            .error(function() {

                layer.close(layerIndex);
                btn.show();
                alert("题库导入失败。");
            })
            //.success(function() { alert("second success"); })
            //.complete(function() { alert("complete"); });
    });

});
