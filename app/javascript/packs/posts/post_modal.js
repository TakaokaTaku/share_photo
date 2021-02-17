$('.modal-close').on('click', function(e) {
  $(".modal").attr('style', 'display: none !important');
  $(".modal-backdrop").attr('style', 'display: none !important');
  $("body").attr('style', 'overflow: auto');
});
