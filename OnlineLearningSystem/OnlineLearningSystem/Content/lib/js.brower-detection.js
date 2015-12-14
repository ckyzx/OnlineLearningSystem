var brower;
var ieRegex, ieRegex11;

brower = {};
brower.codeName = navigator.appCodeName;
brower.name = navigator.appName;
brower.version = navigator.appVersion;
brower.cookiesEnabled = navigator.cookieEnabled;
brower.platform = navigator.platform;
brower.userAgent = navigator.userAgent;
brower.systemLanguage = navigator.systemLanguage;

ieRegex = new RegExp("MSIE (\\d+\\.\\d+);");
ieRegex11 = new RegExp('rv\:(\\d+\\.\\d+)');

if (ieRegex.test(brower.userAgent)) {

    brower.ieVersion = parseInt(RegExp["$1"]);
} else if (ieRegex11.test(brower.userAgent)) {

    brower.ieVersion = parseInt(RegExp["$1"]);
}

if (brower.ieVersion && brower.ieVersion < 8) {

    location.href = "/Content/html/upgrade_brower.htm";
}