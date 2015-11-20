$(function() {

    $('#Submit').on('click', function() {

        var userName, password;
        var index;

        index = layer.load(0, {shade: [0.3, '#FFF']});   

        userName = $('#UserName').val();
        password = $('#Password').val();

        $.post('/User/Login', {
                userName: userName,
                password: password
            }, function(data) {

            	if(1 == data.status){

            		location.href = '/Panel/Index';
            	}else if(0 == data.status){

                    layer.close(index);
            		alert(data.message);
            	}
            }, 'json')
            .error(function() {

                layer.close(index);
                alert('请求返回错误！');
            })
            .complete(function(){

            });
    });

    $('#UserName, #Password').keyup(function(event){

        if(13 == event.which){

            $('#Submit').click();
        }
    });
});
