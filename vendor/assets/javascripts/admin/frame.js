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
