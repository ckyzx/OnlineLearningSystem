$(function() {

    $('#Submit').on('click', function() {

        var userName, password;

        userName = $('#UserName').val();
        password = $('#Password').val();

        $.post('/User/Login', {
                userName: userName,
                password: password
            }, function(data) {

            	if(1 == data.status){

            		location.href = '/Panel';
            	}else if(0 == data.status){

            		alert(data.message);
            	}
            }, 'json')
            .error(function() {

                alert('请求返回错误！');
            });
    });

    $('#UserName, #Password').keyup(function(event){

        if(13 == event.which){

            $('#Submit').click();
        }
    });
});
