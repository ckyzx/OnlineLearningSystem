$(function() {

    var loginState;

    $('#Submit').on('click', function() {

        var userName, password;

        userName = $('#UserName').val();
        password = $('#Password').val();

        if ($('#Online').get(0).checked) {

            $.cookie('save_login_state', '{"userName": "' + userName + '", "password": "' + password + '"}', {
                expires: 30,
                path: '/'
            });
        }else{
            $.cookie('save_login_state', null, {path: '/'});
        }

        login(userName, password);
    });

    $('#UserName, #Password').keyup(function(event) {

        if (13 == event.which) {

            $('#Submit').click();
        }
    });

    loginState = $.cookie('save_login_state');

    if ("null" != loginState && undefined != loginState) {

        loginState = JSON.parse(loginState);
        $('#UserName').val(loginState.userName);
        $('#Password').val('**********');
        $('#Online').get(0).checked = true;

        login(loginState.userName, loginState.password);
    }

    function login(userName, password) {

        var index;

        index = layer.load(0, {
            shade: [0.6, '#FFF']
        });

        $.post('/User/Login', {
                userName: userName,
                password: password
            }, function(data) {

                if (1 == data.status) {

                    location.href = '/Panel/Index';
                } else if (0 == data.status) {

                    layer.close(index);
                    alert(data.message);
                }
            }, 'json')
            .error(function() {

                layer.close(index);
                alert('请求返回错误！');
            })
            .complete(function() {

            });
    }
});
