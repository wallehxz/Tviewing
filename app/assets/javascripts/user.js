//= require jquery
//= require jquery_ujs
//= require jquery-2.2.3.min
//= require animation
//= require cropbox
// require nprogress
// require particles
// require particles.state

$(document).on('page:fetch',function() { NProgress.start(); })
$(document).on('page:change',function() { NProgress.done(); })
$(document).on('page:restore',function() { NProgress.remove(); })

$('#submit').click(function(){
  $(this).addClass('processing');
})

$('#email').change(function(){
  var reg = /^([a-zA-Z0-9-._-])+@([a-zA-Z0-9_-])+((\.[a-zA-Z0-9_-]{2,3}){1,2})$/;
  if(!reg.test($.trim($('#email').val())))
  {
    $('#email').val('');
    $('#email').attr('placeholder','请填写正确邮箱');
  }
});

$('#password').change(function(){
  if($('#password').val().length < 6){
    $('#password').val('');
    $('#password').attr('placeholder','密码不能少于6位');
    return false;
  }
});

$('#confirmation').change(function(){
  if($('#password').val() != $('#confirmation').val()){
    $('#confirmation').val('');
    $('#confirmation').attr('placeholder','确认密码不匹配');
    return false;
  }
});
