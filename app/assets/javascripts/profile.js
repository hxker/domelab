$(function() {

    $("#user_avatar").change(function() {
        readURL(this, 0.5);
    });

    $('#avatar-modal input[type="submit"]').click(function(event) {
        event.preventDefault();
        var form = $("#avatar-form");
        if (typeof FormData === 'undefined') {
            var iframe = $('<iframe name="postiframe" id="postiframe" style="display: none"></iframe>');
            $("body").append(iframe);
            form.attr("target", "postiframe");
            form.attr("file", $("#user_avatar").val());
            form.submit();

            $("#postiframe").load(function() {
                $("#avatar-modal").modal('hide');
                $("#myavatar").attr("src", $("#myavatar").attr('src') + "?" + new Date().getTime());
            });
        } else {
            if (!$("#user_avatar").val()) {
                alert('未选择图片');
            } else {
                $.ajax({
                    data: new FormData(form[0]),
                    type: "POST",
                    dataType: "XML",
                    url: form.attr('action'),
                    contentType: false,
                    processData: false,
                    xhrFields: {
                        withCredentials: true
                    },
                    crossDomain: true,
                    success: function(d) {
                        $("#avatar-modal").modal('hide');
                        $("#user_avatar").val("");
                        $(".upload-path").text('请选择图片');
                        $(".preview").attr("src", "");
                        $("#myavatar").attr("src", $("#myavatar").attr('src') + "?" + new Date().getTime());
                    },
                    error: function(d) {
                        console.log(d);
                        $("#avatar-modal").modal('hide');
                        if (d.status === 413) {
                            alert('文件过大,上传失败');
                        } else {
                            alert($(d).find("error").text());
                        }
                    }
                });
            }
        }

    });

    $("#form_change_profile .user_profile_roles input").each(function(i, el) {
        show_info(el);
    }).change(function() {
        show_info(this);
    });

    if ($("#form_change_profile").length) {
        if ($("#form_change_profile .school-select").hasClass("hidden")) {
            var school_select = $("#form_change_profile .school-select");
            $('#form_change_profile .change-school').click(function() {

                if (school_select.hasClass("hidden") && $("#district-select").val() === "0") {
                    get_districts();
                }
                school_select.toggleClass("hidden");
            });
        } else {
            get_districts();
        }
    }

    $("#district-select").change(function() {
        var district_id = $(this).val();
        if (district_id !== "0") {
            get_schools(district_id);
            $("#district_id").val(district_id);
        }
    });


    $("#school-select").change(function() {
        var school_id = $(this).val();
        if (school_id !== "0") {
            $("#school_id").val(school_id);
        }
    });

    $('#user_profile_birthday').datepicker();

    function get_districts() {
        $.get('/api/v1/users/get_districts', function(data) {
            if (data.length) {
                console.log(data);
                var district_select = $("#district-select");
                district_select.html("<option value='0'>请选择区县</option>");
                $.each(data, function(i, value) {
                    district_select.append('<option value="' + value.id + '">' + value.name + '</option>');
                });

            }
        });
    }

    function get_schools(district_id) {
        $.get('/api/v1/users/get_schools', {
                district_id: district_id
            },
            function(data) {
                if (data.length) {
                    console.log(data);
                    var school_select = $("#school-select");
                    school_select.html("<option value='0'>请选择学校</option>");
                    $.each(data, function(i, value) {
                        school_select.append('<option value="' + value.id + '">' + value.name + '</option>');
                    });
                }
            });
    }

    function show_info(input) {
        var index = $(input).parent().index();
        var role_info = $('.role-info fieldset').eq(index);
        if ($(input).is(':checked')) {
            role_info.removeClass('hidden');
        } else {
            role_info.addClass('hidden');
        }
    }

});
