$(function() {
    
    $('form').on('click', ':submit', function() {
        
        var layerIndex;
        
        layerIndex = layer.load(0, {
            shade: [0.3, '#FFF']
        });
        
        $(this).attr('layer-index', layerIndex);
    }
    );
    
    /*$('form').submit(function(e) {
        e.preventDefault();
    }
    );*/
}
);
