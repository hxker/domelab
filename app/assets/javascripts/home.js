/**
 * Created by yaolin on 16/8/23.
 */


$(function () {
    var mySwiper = new Swiper('.swiper-container', {
        // Optional parameters
        direction: 'horizontal',
        loop: true,
        // 设置自动
        autoplay: '5000',
        // 设置按钮
        pagination: '.swiper-pagination',
        // 按钮可用
        paginationClickable: true,
        // 交互后依旧自动
        autoplayDisableOnInteraction: false
    })
});