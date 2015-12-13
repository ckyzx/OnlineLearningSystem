$(function () {

    window.name = location.pathname;

    rowResponse();

    function rowResponse(){

    	$('.table-sort')
    	.on('mouseenter', 'tbody tr', function(){
    		$(this).addClass('hover');
    	})
    	.on('mouseleave', 'tbody tr', function(){
    		$(this).removeClass('hover');
    	});
    }
});