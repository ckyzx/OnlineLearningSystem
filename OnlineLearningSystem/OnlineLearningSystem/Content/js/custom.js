
/* 在模态框中显示页面 */
function ShowPage(title,url){
    var index = layer.open({
        type: 2,
        title: title,
        content: url,
        //area: ['180px', '36px']
        area: ['800px', '600px']
    });
    //layer.full(index);
}

function ShowPageWithSize(title,url,w,h){
    layer_show(title,url,w,h);
}