$(function() {
    var clone = $("#new_group_community").clone();
    var wrapper = $('<div class="wrapper form-wrapper"></div>');
    clone.removeAttr("id").find("textarea").removeAttr("placeholder");
    var parent_id_tag = $('<input value="0" class="parent_id" name="group_community[parent_id]" type="hidden">');
    clone.addClass("reply-form").append(parent_id_tag);
    wrapper.append(clone);
    $(".comment-item .reply").on('click', function() {
        var item = $(this).closest(".comment-item");
        var reply_form = item.find(".reply-form");
        if (!reply_form.length) {
            var parent_id = item.data("id");
            wrapper.find('.parent_id').val(parent_id);
            wrapper.find('textarea').val("");
            item.find(".sub-comments").append(wrapper);
        } else {
            wrapper.toggleClass("hidden");
        }
    });
});
