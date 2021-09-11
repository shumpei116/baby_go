$(function () {
  $("#back").hide();
  $(function() {
    $(window).on('scroll', function () {
      if ($(this).scrollTop() > 500) {
        $('#back').fadeIn();
      } else {
        $('#back').fadeOut();
      }
    });
    $('#back a').on('click',function(event){
      $('body, html').animate({
        scrollTop:0
      }, 200);
      event.preventDefault();
    });
  });
});
