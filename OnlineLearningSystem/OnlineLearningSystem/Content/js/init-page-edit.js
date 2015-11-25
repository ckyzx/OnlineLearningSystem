$(function() {

    /*$('form').on('click', ':submit', function() {
        
        var layerIndex;
        
        layerIndex = layer.load(0, {
            shade: [0.3, '#FFF']
        });
        
        $(this).attr('layer-index', layerIndex);

    });*/

    var events;

    events = $._data($('form')[0], 'events');

    if (events && !events['submit']) {

        $('form').submit(function(e) {

            if (!confirm('确认提交吗？')) {

                e.preventDefault();
            }
        });
    }
});
