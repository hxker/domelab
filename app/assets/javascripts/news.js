$('#carousel').on('slide.bs.carousel', function() {
    var currentIndex = $(this).find('.active').index() + 1;
    $(".control .index").text(currentIndex);
});
