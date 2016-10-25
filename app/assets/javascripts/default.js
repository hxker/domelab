$(function() {
    var length = $('.carousel-inner .item').length;
    $('#carousel a.left,#carousel-left').on('click', function() {
        var index;
        var currentIndex = $('#carousel').find('.active').index();
        if (currentIndex === 0) {
            index = length - 1;
        } else {
            index = currentIndex - 1;
        }
        $(".control .index").text(index + 1);
    });
    $('#carousel a.right,#carousel-right').on('click', function() {
        var index;
        var currentIndex = $('#carousel').find('.active').index();
        if (currentIndex === length - 1) {
            index = 0;
        } else {
            index = currentIndex + 1;
        }
        $(".control .index").text(index + 1);
    });
});
