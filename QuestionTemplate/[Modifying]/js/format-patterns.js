﻿var FormatPatterns = {
    patterns: {

        // 1. 规范
        '1.1': {
            id: 1.1,
            name: '1.1 规范题目编号',
            pats: [{
                pat: /^\s*(\d+)[、.·．]+\s*/,
                rep: /$1./
            }]
        },
        '1.2': {
            id: 1.2,
            name: '1.2 规范选择题选项编号',
            pats: [{
                pat: /^\s*([A-Z])\s*[、.·．]\s*/,
                rep: /$1./
            }]
        },
        '1.3': {
            id: 1.3,
            name: '1.3 规范选择题答案',
            pats: [{
                pre: [
                    // 1.3.1 替换字母间的空格
                    { pat: /([A-Z]{1})\s+(?=[A-Z])/, rep: '$1' },
                    // 1.3.2 替换无字母的括号
                    { pat: /[（(]\s*[)）]/, rep: ' ___ ' }
                ],
                pat: /[（(]\s*([A-Z]*)\s*[)）]/,
                rep: /\( $1 \)/
            }, {
                name: '1.3.4 去除金额数字间的空格',
                pat: /([A-Z]{1}\.)(\d+)\s+(\d+)/,
                rep: /$1$2$3/
            }]
        },
        '1.4': {
            id: 1.4,
            name: '1.4 规范判断题答案',
            pats: [{
                pat: /[（(]\s*([Xx])\s*[)）]\s*/,
                rep: /\( × \)/
            }, {
                pat: /[（(]\s*([×√])\s*[)）]\s*/,
                rep: /\( $1 \)/
            }]
        },
        '1.5': {
            id: 1.5,
            name: '1.5 规范答案标志',
            pats: [{
                pat: /^(解析[:：]|(参考答案[:：])|【(参考)?答案】)/,
                rep: '答案：'
            }]
        },
        /*----------------------------------------------------------------------------------------------------*/

        // 2. 去除
        '2.1': {
            id: 2.1,
            name: '2.1 去除备注',
            pats: [{
                pat: /^ *[（(].*?$/,
                rep: ''
            }]
        },
        '2.2': {
            id: 2.2,
            name: '2.2 去除分节',
            pats: [{
                pat: /^ *(第[一二三四五六七八九十]{1}节)\s*?/,
                rep: '// $1 '
            }]
        },
        '2.3': {
            id: 2.3,
            name: '2.3 去除“解析”、“依据”、“解释”文本',
            pats: [{
                pat: /^ *(解析|依据|解释)[：:]?.*?$/,
                rep: ''
            }]
        },
        // TODO: 是否起到去除作用？
        '2.4': {
            id: 2.4,
            name: '2.4 去除多余换行',
            pats: [{
                pat: /(^\s$){1}/,
                rep: ''
            }]
        },
        /*----------------------------------------------------------------------------------------------------*/

        // 3. 设置
        '3.1': {
            id: 3.1,
            name: '3.1 设置分类',
            pats: [{
                pat: /(^)? *第[一二三四五六七八九十]{1}章\s*/,
                rep: '分类：'
            }]
        },
        '3.2': {
            id: 3.2,
            name: '3.2 设置题型“单选题”',
            pats: [{
                pat: /^ *[一二三四五六七八九十]{1}(、|\.)(单项选择题|单选题){1}$/,
                rep: '题型：单选题'
            }]
        },
        '3.3': {
            id: 3.3,
            name: '3.3 设置题型“多选题”',
            pats: [{
                pat: /^ *[一二三四五六七八九十]{1}(、|\.)(多项选择题|多选题){1}$/,
                rep: '题型：多选题'
            }]
        },
        '3.4': {
            id: 3.4,
            name: '3.4 设置题型“判断题”',
            pats: [{
                pat: /^ *[一二三四五六七八九十]{1}(、|\.)(判断改错题|判断辨析题|判断题|辨析题){1}.*?$/,
                rep: '题型：判断题'
            }]
        },
        '3.5': {
            id: 3.5,
            name: '3.5 设置题型“实务题”',
            pats: [{
                pat: /^ *[一二三四五六七八九十]{1}(、|\.)(实务题){1}.*?$/,
                rep: '题型：案例分析题'
            }]
        },
        /*----------------------------------------------------------------------------------------------------*/

        // 4. 后置处理 
        '4.1': {
            id: 4.1,
            name: '4.1 去除“解析”、“依据”、“解释”文本',
            pats: [{
                pre: [{
                    pat: /(<r><n>)([0-9A-Z]+)(?![0-9A-Z]+)(?!\.)/,
                    rep: '$1'
                }],
                pat: '(<r><n>)' +
                    '(' +
                    '(?![0-9A-Z</分题]+)' +
                    ')' +
                    '(.+?)' +
                    '(?=<r><n>)',
                rep: '$1',
                time: 0
            }]
        }
    },
    // 单选题与多选题
    type_1: function() {
        var ps = this.patterns;
        return [
            ps['1.1'],
            ps['1.2'],
            ps['1.3'],
            ps['2.1'],
            ps['2.2'],
            ps['2.3'],
            ps['2.4'],
            ps['3.1'],
            ps['3.2'],
            ps['3.3'],
            ps['3.4'],
            ps['3.5'],
            ps['4.1']
        ];
    },
    // 判断题
    type_2: function() {
        var ps = this.patterns;
        return [
            ps['1.1'],
            ps['1.4'],
            ps['2.1'],
            ps['2.2'],
            ps['2.3'],
            ps['2.4'],
            ps['3.1'],
            ps['3.2'],
            ps['3.3'],
            ps['3.4'],
            ps['3.5'],
            ps['4.1']
        ];
    },
    // 案例分析题
    type_5: function(){
        var ps = this.patterns;
        return [
            ps['1.1'],
            ps['1.5'],
            ps['2.2'],
            ps['2.3'],
            ps['2.4'],
            ps['3.1'],
            ps['3.2'],
            ps['3.3'],
            ps['3.4'],
            ps['3.5']
        ];
    }
}