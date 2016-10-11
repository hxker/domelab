function readURL(input) {
    var isIE = (navigator.appName == "Microsoft Internet Explorer");
    var path = $(input).val();
    var ext = path.substring(path.lastIndexOf('.') + 1).toLowerCase();
    if (ext == "gif" || ext == "jpeg" || ext == "jpg" || ext == "png") {
        $(".upload-path").text(path);
        if (isIE) {
            $('.preview').attr('src', path);
        } else {
            if (input.files && input.files[0]) {
                var reader = new FileReader();
                reader.onload = function(e) {
                    $('.preview').attr('src', e.target.result);
                };

                reader.readAsDataURL(input.files[0]);
            }
        }

    } else {
        alert("不能上传该格式的文件");
    }
}

$("#group_opu_content").change(function() {
    readURL(this);
});

$('#new_group_opu input[type="submit"]').click(function(event) {
    event.preventDefault();
    var form = $("#new_group_opu");
    if (typeof FormData === 'undefined') {
        form.submit();
    } else {
        if (!$("#group_opu_content").val()) {
            alert('未选择图片');
        } else {
            $.ajax({
                data: new FormData(form[0]),
                type: "POST",
                dataType: "JSON",
                url: form.attr('action'),
                contentType: false,
                processData: false,
                success: function(d) {
                    console.log("upload successfully");
                    $("#modal-form").modal('toggle');
                    $(this).val("");
                    $(".upload-path").text('请选择图片');
                    $(".preview").attr("src", "");
                    if (typeof d.message === 'string') {
                        $.notify(d.message);
                    }
                },
                error: function(d) {
                    console.log(d);
                }
            });
        }
    }

});
