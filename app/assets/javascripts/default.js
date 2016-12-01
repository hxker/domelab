$(function() {
    $(".sign_in_link,.sign_up_link").click(function(e) {
        $(".loading").removeClass('hidden');
    });

    $('#logout').on('confirm:complete', function(e, response) {
        $(".loading").removeClass('hidden');
    });

    var lesson_test = $("#lesson-test-link");
    var length = $('.carousel-inner .item').length;
    $('#carousel a.left,#carousel-left').on('click', function() {
        var index;
        var currentIndex = $('#carousel').find('.active').index();
        if (currentIndex === 0) {
            index = length - 1;
            lesson_test.removeClass('hidden');
        } else {
            index = currentIndex - 1;
            lesson_test.addClass('hidden');
        }
        $(".control .index").text(index + 1);
    });
    $('#carousel a.right,#carousel-right').on('click', function() {
        lesson_test.addClass('hidden');
        var index;
        var currentIndex = $('#carousel').find('.active').index();
        if (currentIndex === length - 1) {
            index = 0;
        } else {
            index = currentIndex + 1;
            if (index === length - 1) {
                lesson_test.removeClass('hidden');
            }
        }
        $(".control .index").text(index + 1);
    });
});
