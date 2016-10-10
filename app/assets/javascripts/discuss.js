$(function() {
    var clone = $("#new_group_community").clone();
    clone.removeAttr("id").find("textarea").removeAttr("placeholder");
    var parent_id_tag = $('<input value="0" class="parent_id" name="group_community[parent_id]" type="hidden">');
    clone.append(parent_id_tag);
    $(".comment-item .reply").on('click', function() {
        var item = $(this).closest(".comment-item");
        var reply_form = item.find(".reply-form");
        if (!reply_form.length) {
            var parent_id = item.data("id");
            clone.find('.parent_id').val(parent_id);
            clone.find('textarea').val("");
            item.find(".sub-comments").append(clone);
        }
    });
});
