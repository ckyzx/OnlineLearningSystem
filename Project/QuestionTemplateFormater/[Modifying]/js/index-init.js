$(function() {

    var qt;
    var ue;
    var getType;
    var textarea;

    getType = function() {

        var type = $('#type').val();

        if (type == 0) {
            alert('请选择需处理的题型');
            return null;
        }

        return type;
    }

    textarea = {
        val: function(str) {

            var p1;

            if (undefined == str) {

                str = ue.getContent();

                // 格式化粘贴的文本
                p1 = /(<\/p>)/g;
                str = str.replace(p1, '$1<br/>');

                p1 = /(<(\/)?span[^>]*>)/g;
                str = str.replace(p1, '');
        
                // 去除行标签
                p1 = /(<(\/)?p[^>]*>)/g;
                str = str.replace(p1, '');

                // 去除空格符号
                p1 = /&nbsp;/g;
                str = str.replace(p1, ' ');

                // 去除换行标签
                p1 = /(<br\/>)/g;
                str = str.replace(p1, '<r><n>');

                // 去除换行
                p1 = /(%0A(%|\d+[\.%]|[A-Za-z][\.%]|[(]%))/g;
                str = encodeURIComponent(str);
                str = str.replace(p1, '$2');
                str = decodeURIComponent(str);

                return str;

            } else {

                // 转换为 HTML换行符
                p1 = /(<r><n>|<rn>)/g;
                str = str.replace(p1, '<br/>');

                // 清除多余的<r>与<n>
                p1 = /(<r>|<n>)+/g;
                str = str.replace(p1, '');

                ue.setContent(str);
            }
        }
    };

    qt = QT.init();

    // 初始化编辑器
    ue = UE.getEditor('myEditor', {
        toolbars: [
            ['source', 'undo', 'redo']
        ],
        initialFrameHeight: 500
    });
    ue.addListener('ready', function() {

        $('.edui-editor, .edui-editor-iframeholder').css('width', $('body').width() - 24);

        $('#reload').click();
    });
    ue.addListener('contentChange', function(ue){

    });

    // 格式化操作
    $('#replace').on('click', function() {

        var t;

        t = getType();

        if (t == null) {
            return;
        }

        qt.format(textarea, FormatPatterns['type_' + t]());

        $(this).attr('disabled', 'disabled');
    });

    // 检查操作
    $('#check').on('click', function() {

        var t, p, txt;

        t = getType();

        if (t == null) {
            return;
        }

        txt = qt.check(textarea, CheckPatterns['type_' + t])
        txt = '<span style="color:red;">' + txt + '</span>';
        ue.setContent(txt);
    });

    // 复制操作
    $('#CopyToClipboard').zclip({
        path: 'lib/jquery-zclip/ZeroClipboard.swf',
        copy: function() {
            return ue.getPlainTxt();
        }
    });

    $('#reload').on('click', function() {

        var req;

        ue.setContent('');

        req = Request.init();

        // 载入文件
        fileName = req.getValue('file');

        // 载入试题文档
        $.get(fileName, function(data) {

            var txt = data;

            // 转换文本文档的换行符
            txt = encodeURIComponent(txt).replace(/%0D/g, '<br/>');
            txt = '<br/>' + decodeURIComponent(txt) + '<br/><br/>';

            ue.setContent(txt);

        });
        
        $('#replace').removeAttr('disabled');
    });

});
