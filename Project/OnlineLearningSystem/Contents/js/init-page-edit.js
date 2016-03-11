$(function() {

    var events;

    events = $._data($('form')[0], 'events');

    if (!events || (events && !events['submit'])) {

        submitCallback = function() {

            layer.confirm('确定保存吗？', {
                title: '',
                btn: ['确定', '取消']
            }, function() {
                $('form').submit();
                return;
            }, function() {
                return;
            });
        }
    }

});
