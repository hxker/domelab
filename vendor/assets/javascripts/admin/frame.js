$(function () {

    //删除两边空格
    function trim(str) {
        return str.replace(/(^\s*)|(\s*$)/g, "");
    }

    //删除左边的空格
    function ltrim(str) {
        return str.replace(/(^\s*)/g, "");
    }

    //删除右边的空格
    function rtrim(str) {
        return str.replace(/(\s*$)/g, "");
    }

    // 操作结果提示信息
    if ($('#notice').length > 0) {
        $.gritter.add({
            title: '操作状态:',
            text: $('#notice').text(),
            time: '5000'
        });
    }
    // date_picker date init 
    $('input[data-control="dateForm"]').datepicker({
        autoclose: true
    });

    // ace-thumbnails photo view
    if ($('.ace-thumbnails [data-rel="colorbox"]').length > 0) {
        jQuery(function ($) {
            var color_box_params = {
                reposition: true,
                scalePhotos: true,
                scrolling: false,
                previous: '<i class="icon-arrow-left"></i>',
                next: '<i class="icon-arrow-right"></i>',
                close: '&times;',
                current: '{current} / {total}',
                maxWidth: '100%',
                maxHeight: '100%',
                onOpen: function () {
                    document.body.style.overflow = 'hidden';
                },
                onClosed: function () {
                    document.body.style.overflow = 'auto';
                },
                onComplete: function () {
                    $.colorbox.resize();
                }
            };
            $('.ace-thumbnails [data-rel="colorbox"]').colorbox(color_box_params);
            $("#cboxLoadingGraphic").append("<i class='icon-spinner orange'></i>");//loading icon
        })
    }

    if ($.cookie('menu-min') == 1) {
        $('.sidebar').addClass('menu-min');
    } else {
        $('.sidebar').removeClass('menu-min');
    }
    $('#sidebar-collapse').on('click', function () {
        if ($('.sidebar').hasClass('menu-min')) {
            $.cookie('menu-min', 1, {path: '/'});
        } else {
            $.cookie('menu-min', 0, {path: '/'});
        }
    });
});
