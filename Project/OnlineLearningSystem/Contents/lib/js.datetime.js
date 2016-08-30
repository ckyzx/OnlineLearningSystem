String.prototype.toDate = function() {

    var ary, date;

    /*strDate = this.replace(/\d+(?=-[^-]+$)/, function (a) {
        return parseInt(a, 10) - 1;
    }).match(/\d+/g);*/

    /*ary = this.replace(/-/g, '/').replace(/\d+(?=-[^-]+$)/).match(/\d+/g);
    ary[1] = parseInt(ary[1]) - 1;
    date = eval('new Date(' + ary + ')');*/

    date = new Date(this.replace(/-/g, '/'));

    return date;
};

String.prototype.jsonDateToDate = function() {

    var strDate,
        date;

    strDate = this.replace('/Date(', '').replace(')/', '');
    date = eval('new Date(' + strDate + ')');

    return date;
};

Date.prototype.format = function(fmt) {
    var o = {
        "M+": this.getMonth() + 1, //月份
        "d+": this.getDate(), //日
        "h+": this.getHours(), //小时
        "m+": this.getMinutes(), //分
        "s+": this.getSeconds(), //秒
        "q+": Math.floor((this.getMonth() + 3) / 3), //季度
        "S": this.getMilliseconds() //毫秒
    };
    if (/(y+)/.test(fmt))
        fmt = fmt.replace(RegExp.$1, (this.getFullYear() + "").substr(4 - RegExp.$1.length));
    for (var k in o)
        if (new RegExp("(" + k + ")").test(fmt))
            fmt = fmt.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
    return fmt;
};

/* 得到日期年月日等加数字后的日期 */
Date.prototype.add = function(interval, number) {
    var d = this;
    var k = {
        'y': 'FullYear',
        'q': 'Month',
        'm': 'Month',
        'w': 'Date',
        'd': 'Date',
        'h': 'Hours',
        'n': 'Minutes',
        's': 'Seconds',
        'ms': 'MilliSeconds'
    };
    var n = {
        'q': 3,
        'w': 7
    };
    eval('d.set' + k[interval] + '(d.get' + k[interval] + '()+' + ((n[interval] || 1) * number) + ')');
    return d;
};

/* 计算两日期相差的日期年月日等 */
Date.prototype.diff = function(interval, objDate2) {
    var d = this,
        i = {},
        t = d.getTime(),
        t2 = objDate2.getTime();
    i['y'] = objDate2.getFullYear() - d.getFullYear();
    i['q'] = i['y'] * 4 + Math.floor(objDate2.getMonth() / 4) - Math.floor(d.getMonth() / 4);
    i['m'] = i['y'] * 12 + objDate2.getMonth() - d.getMonth();
    i['ms'] = objDate2.getTime() - d.getTime();
    i['w'] = Math.floor((t2 + 345600000) / (604800000)) - Math.floor((t + 345600000) / (604800000));
    i['d'] = Math.floor(t2 / 86400000) - Math.floor(t / 86400000);
    i['h'] = Math.floor(t2 / 3600000) - Math.floor(t / 3600000);
    i['n'] = Math.floor(t2 / 60000) - Math.floor(t / 60000);
    i['s'] = Math.floor(t2 / 1000) - Math.floor(t / 1000);
    return i[interval];
};

Date.now = function() {
    return new Date();
};
