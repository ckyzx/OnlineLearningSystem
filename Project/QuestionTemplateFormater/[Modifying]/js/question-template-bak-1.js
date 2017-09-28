//'use strict';

var QT = {

    req: undefined,

    patterns: {
        newLine: /(%0A(%|\d+[\.%]|[A-Za-z][\.%]|[(]%))/g
    },

    init: function() {

        this.req = Request.init();

        return this;
    },

    format: function(textarea, patterns) {

        var me;
        var pids, epids, types;

        me = this;

        pids = me.req.getValue('pids', 0);
        epids = me.req.getValue('epids', 0);
        types = me.req.getValue('types', 0);

        for (var i = 0; i < patterns.length; i++) {
            p = patterns[i];

            // 需要执行的正则表达式
            if (pids != 0 && pids.indexOf('|' + p.id + '|') == -1) {
                continue;
            }

            // 需要排除的正则表达式
            if (epids != 0 && epids.indexOf('|' + p.id + '|') != -1) {
                continue;
            }

            // 需要执行的正则表达式分类
            if (types != 0 && types.indexOf('|' + p.type + '|') == -1) {
                continue;
            }

            pats = p.pats;

            // 循环处理用于格式化的表达式组
            for (var i1 = 0; i1 < pats.length; i1++) {
                p1 = pats[i1];

                pres = p1.pre;
                pres = pres == undefined ? [] : pres;

                for (var i2 = 0; i2 < pres.length; i2++) {
                    p2 = pres[i2];

                    me._format(textarea, p2.pat, p2.pat, p2.rep, p2.time);
                };

                me._format(textarea, p1.pat, p1.pat, p1.rep, p1.time);
            };
        };

        me.clear(textarea);
    },

    _format: function(textarea, oriPat, pat, rep, totalTime) {

        var txt;
        var sFlag, eFlag;
        var time;

        txt = textarea.val();
        sFlag = false, eFlag = false;
        time = 0;

        if (totalTime == undefined) {
            totalTime = 1;
        }

        // 转换、定义表达式
        if ($.type(pat) == 'regexp') {

            pat = pat.toString();
        }

        //pat = pat.replace(/\\/g, '\\\\');
        pat = pat.replace(/(^\/)|(\/$)/g, '');

        if (pat.indexOf('^') != -1) {

            pat = pat.replace(/(\^)/g, '<n>');
            pat = pat.replace(/\[<n>/g, '[^');

            if (pat.indexOf('<n>') != -1) {
                sFlag = true;
            }
        }
        if (pat.indexOf('$') != -1) {
            pat = pat.replace(/(\$)/g, '<r>');
            eFlag = true;
        }
        if (pat.indexOf('\\n') != -1) {
            pat = pat.replace(/(\\n)/g, '<r><n>');
        }
        pat = new RegExp(pat, 'g');

        // 
        if ($.type(rep) == 'regexp') {
            rep = rep.toString();
            rep = rep.replace(/\/?/g, '');
            rep = rep.replace(/\\?/g, '');
        }

        // 添加换行标志
        if (sFlag) {
            rep = '<n>' + rep;
        }
        if (eFlag) {
            rep += '<r>';
        }

        // 去除原换行符。需将文本转为十六进制的转义序列。
        txt = encodeURIComponent(txt);
        p = this.patterns.newLine;
        while (p.test(txt)) {
            txt = txt.replace(p, '$2');
        }

        // 还原转义文本
        txt = decodeURIComponent(txt);

        // 执行自定义的正则表达式替换
        while (pat.test(txt) && ((0 < totalTime && time < totalTime) || 0 == totalTime)) {
            txt = txt.replace(pat, rep);
            time += 1;
        }

        // 恢复换行
        txt = txt.replace(/(<r><n>)/g, '$1\n');

        textarea.val(txt);
    },

    clear: function(textarea) {

        var p, txt;

        txt = textarea.val();
        txt = encodeURIComponent(txt)
        p = this.patterns.newLine;
        while (p.test(txt)) {
            txt = txt.replace(p, '$2');
        }
        txt = decodeURIComponent(txt);

        // 清除多余换行
        //p = /\s*(<r><n>){2,4}\s*/g;
        p = /(<r><n>){2,4}/g;
        while (p.test(txt)) {
            txt = txt.replace(p, '<r><n>');
        }

        // 添加分类、题型前换行
        p = /(分类：|\/\/|题型：)/g
        txt = txt.replace(p, '<r><n><r><n>$1');

        // 添加题目内容前换行
        p = /<r><n>(\d+\.)/g
        txt = txt.replace(p, '<r><n><r><n>$1');

        // 添加换行符
        //p = /\s*<r><n>\s*/g;
        p = /<r><n>/g;
        while (p.test(txt)) {
            txt = txt.replace(p, '\n');
        }

        // 清除单独的换行符
        txt = this._replace(txt, /(<r>)|(<n>)/g, '');

        textarea.val(txt);
    },

    _replace: function(str, p, r) {
        p = new RegExp(p);
        while (p.test(str)) {
            str = str.replace(p, r);
        }
        return str;
    }
};
