//[IECompatible]
Array.prototype.indexOf = function (e) {
    for (var i = 0, j; j = this[i]; i++) {
        if (j == e) { return i; }
    }
    return -1;
}
Array.prototype.lastIndexOf = function (e) {
    for (var i = this.length - 1, j; j = this[i]; i--) {
        if (j == e) { return i; }
    }
    return -1;
}