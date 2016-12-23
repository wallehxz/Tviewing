//= require jquery
//= require jquery_ujs
//= require jquery-2.2.3.min
//= require lte/js/jquery-ui.min
//= require lte/js/bootstrap.min
//= require lte/js/raphael-min
//= require lte/js/morris.min
//= require lte/js/jquery.sparkline.min
//= require lte/js/moment.min
//= require lte/js/daterangepicker
//= require lte/js/bootstrap-datepicker
//= require lte/js/bootstrap3-wysihtml5.all.min
//= require lte/js/jquery.slimscroll.min
//= require lte/js/fastclick
//= require lte/js/bootstrap.min
//= require lte/js/settings
//= require lte/js/demo

 $.widget.bridge('uibutton', $.ui.button);

function addFileUlr(obj,id){
  if (obj.files && obj.files[0]) {
    var reader = new FileReader();
    reader.onload = function (e) {
      $('#' + id).attr('src', e.target.result);
    }
    reader.readAsDataURL(obj.files[0]);
  }
};

$(function () {$(".textarea").wysihtml5();});

$('#column_english').change(function(){
  var reg = /^[A-Za-z]+$/;
  if(!reg.test($('#column_english').val())){
    $('#column_english').val('');
    $('#english_tip').removeAttr('style');
  }else{
    $('#english_tip').attr('style','display: none');
  }
});

$('#file_select').change(function(){
  if($('#file_select').val() > 0){
    var select_div = $('#file_select').val();
    $('#1_div').attr('style','display: none');
    $('#2_div').attr('style','display: none');
    $('#3_div').attr('style','display: none');
    $('#' +select_div+ '_div').removeAttr('style').show("slow");
  }
});