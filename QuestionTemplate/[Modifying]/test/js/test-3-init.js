$(function() {

    var req;
    var um, umParams;
    var eduiContainerHight;
    var txt, fileName;
    var pat;

    req = Request.init();
    fileName = req.getValue('file');

    umParams = {
        toolbars: [
            ['source', 'undo', 'redo']
        ],
        initialFrameHeight: 500
    };
    //um = UM.getEditor('myEditor', umParams);
    um = UE.getEditor('myEditor', umParams);
    um.addListener('ready', function() {

        //um.execCommand('pasteplain');

        $('.edui-editor, .edui-editor-iframeholder').css('width', $('body').width() - 24);

        $.get('../' + fileName, function(data) {

            txt = data;
            txt = encodeURIComponent(txt).replace(/%0D/g, '<br/>');
            txt = '<br/>' + decodeURIComponent(txt) + '<br/><br/>';

            um.setContent(txt);
        });

    });

    /*eduiContainerHight = $('body').height() - 80;
    $('.edui-container').css('height', eduiContainerHight + 'px');
    $('.edui-editor-body').css('height', eduiContainerHight - $('.edui-toolbar').height() + 'px')*/

    $('#check').on('click', function() {

        var txt, p1, p, r;
        var type;

        txt = um.getContent();

        type = $('#type').val();

        // 检查分类、题型、注释的格式
        p1 = '((分类：.*?)|(\\/\\/.*?)|(题型：.*?))|';

        if (type == 1) {
            // 检查单选题和多选题的格式
            p = '(<r><n>)' + '(' + p1 + '(' + '([0-9]+\\.)' + '([^<>]*)' + '(\\( [A-Z]+ \\))' + '(.*?)' + '(([A-Z]\\.)([^<>]*)(<r><n>)?)+' + ')' + ')' + '(?=<r><n>)';
        }else if(type == 2){
            // 检查判断题格式
            p = '(<r><n>)' + '(' + p1 + '(' + '(([0-9]+\\.)' + '([^<>]*)' + '(\\( [×√] \\))){1}' + ')' + ')' + '(<r><n>)';
        }else{
            alert('请选择题型');
            return;
        }
        r = '<rn><span style="color:gray;">$2</span><rn>';
        txt = check(txt, p, r);
        txt = '<span style="color:red;">' + txt + '</span>';
        um.setContent(txt);
    });

    $('#CopyToClipboard').zclip({
        path: '../../lib/jquery-zclip/ZeroClipboard.swf',
        copy: function() {
            return um.getPlainTxt();
        }
    });

});

function check(txt, p, r) {

    var p1;

    p = new RegExp(p, 'g');

    // 去除行标签
    p1 = /(<(\/)?p>)/g;
    txt = txt.replace(p1, '');

    // 去除空格符号
    p1 = /&nbsp;/g;
    txt = txt.replace(p1, ' ');

    // 去除换行标签
    p1 = /(<br\/>)/g;
    txt = txt.replace(p1, '<r><n>');

    while (p.test(txt)) {
        txt = txt.replace(p, r);
    }

    p1 = /(<r><n>|<rn>)/g;
    txt = txt.replace(p1, '<br/>');

    return txt;
}
