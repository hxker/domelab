function readURL(input, limit) {
    var isIE = (navigator.appName == "Microsoft Internet Explorer");
    var path = $(input).val();
    var ext = path.substring(path.lastIndexOf('.') + 1).toLowerCase();
    if (ext == "gif" || ext == "jpeg" || ext == "jpg" || ext == "png") {
        $(".upload-path").text(path);
        if (isIE) {
            $('.preview').attr('src', path);
        } else {
            if (input.files && input.files[0] && check_file_size(input.files[0].size, limit)) {
                var reader = new FileReader();
                reader.onload = function(e) {
                    $('.preview').attr('src', e.target.result);
                };
                reader.readAsDataURL(input.files[0]);
            }
        }

    } else {
        alert('文件格式不规范,请上传 jpg、jpeg、png、gif 格式的文件');
    }
}

function check_file_size(file_size, limit_size) {
    var size = file_size / 1024 / 1024;
    if (size > limit_size) {
        alert("文件大小不能大于" + limit_size + "M，请重新选择");
        return false;
    } else {
        return true;
    }
}


$("#group_opu_content").change(function() {
    readURL(this, 1.5);
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
                    $("#modal-form").modal('hide');
                    $("#group_opu_content").val("");
                    $(".upload-path").text('请选择图片');
                    $(".preview").attr("src", "");
                    if (typeof d.message === 'string') {
                        $.notify(d.message);
                    }
                },
                error: function(d) {
                    console.log(d);
                    $("#modal-form").modal('hide');
                    if (d.status === 413) {
                        alert('文件过大,上传失败');
                    } else {
                        alert(d.responseJSON.error);
                    }
                }
            });
        }
    }

});
