$(function () {
    $('a.likeable').on('click', function (e) {
        var $el, $target, likeable_id, likeable_type, likes_count;
        $target = $(e.currentTarget);
        likeable_type = $target.data("type");
        likeable_id = $target.data("id");
        likes_count = parseInt($target.data("count"));
        $el = $(".likeable[data-type='" + likeable_type + "'][data-id='" + likeable_id + "']");
        if ($el.data("state") !== "active") {
            $.ajax({
                url: "/likes",
                type: "POST",
                data: {
                    type: likeable_type,
                    id: likeable_id
                },
                success: function (data) {
                    if (data) {
                        likes_count += 1;
                        $el.data('count', likes_count);
                        likeableAsLiked($el);
                        $("i.like-change", $el).attr("class", "like-change icon-heart");
                    } else {
                        alert('提交失败!');
                    }
                }
            });


        } else {
            $.ajax({
                url: "/likes/" + likeable_id,
                type: "DELETE",
                data: {
                    type: likeable_type
                }
            });
            if (likes_count > 0) {
                likes_count -= 1;
            }
            $el.data("state", "").data('count', likes_count).attr("title", "").removeClass("active");
            if (likes_count === 0) {
                $('span', $el).text("(0)");
            } else {
                $('span', $el).text("" + "(" + likes_count + ")");
            }
            $("i.like-change", $el).attr("class", "like-change icon-heart-empty");
        }
        return false;
    });
});
function likeableAsLiked(el) {
    var likes_count;
    likes_count = el.data("count");
    el.data("state", "active").attr("title", "取消赞").addClass("active");
    $('span', el).text("" + '(' + likes_count + ')');
    return $("i.like-change", el).attr("class", "like-change icon-heart");
}