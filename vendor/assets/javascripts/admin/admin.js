$(function () {
    // 搜索框toggle
    $('.btn-search-toggle').on('click', function () {
        $('.form-search-toggle').toggleClass('hide show');
    });
    // 搜索属性选择 
    var searchControl = $('[data-search]');
    if (searchControl.length > 0) {
        $.each(searchControl, function () {
            var self = $(this);
            var target = self.attr('data-search');
            var targetInput = self.find('[name="' + target + '"]');
            var option = self.find('[data-search-option]');
            option.on('click', function () {
                var val = $(this).attr('data-search-option');
                targetInput.val(val);
                self.find('[data-search-text]').text($(this).text());
            });
            var initVal = targetInput.val();
            if (initVal.length > 0) {
                self.find('[data-search-text]').text(self.find('[data-search-option="' + initVal + '"]').text());
            }
        })
    }

    // check file extension and size, then preview
    var check_img_ts = $('#check-img-type-size');
    var check_lesson_ts = $('#check-file-type-size');
    if (check_img_ts.length > 0) {

        check_img_ts.bind('change', function () {
            var this_file = this.files[0];
            var file_name = this_file.name;
            var file_type = file_name.substring(file_name.lastIndexOf(".") + 1);

            if ($.inArray(file_type, ['jpg', 'jpeg', 'png', 'gif']) == -1) {
                alert('文件格式不规范,请上传 jpg、jpeg、png、gif 格式的文件');
                this.value = '';
                return false;
            }
            var file_size = this_file.size / 1024 / 1024;
            if (file_size > 1) {
                alert("文件大小不能大于1MB，请重新选择图片");
                this.value = '';
                return false;
            }
            var windowURL = window.URL || window.webkitURL;
            var dataURL;
            var preview_img = $("#preview_img");
            dataURL = windowURL.createObjectURL(this_file);
            preview_img.attr('src', dataURL);
        });
    }
    // check course lesson type and size
    if (check_lesson_ts.length > 0) {
        check_lesson_ts.bind('change', function () {
            var this_file = this.files[0];
            var file_name = this_file.name;
            var file_type = file_name.substring(file_name.lastIndexOf(".") + 1);

            if ($.inArray(file_type, ['ppt', 'pptx', 'doc', 'docx']) == -1) {
                alert('文件格式不规范,请上传 ppt、pptx、doc、docx 格式的文件');
                this.value = '';
                return false;
            }
            var file_size = this_file.size / 1024 / 1024;
            if (file_size > 10) {
                alert("文件大小不能大于10MB，请重新选择文件");
                this.value = '';
                return false;
            }
        });
    }


    // review group students
    $('.open-review-student').on('click', function () {
        var g_u_id = $(this).attr('data-id');
        $('.review-student-submit').on('click', function () {
            var status = $(".select-review-status [name='review-status']:checked").val();
            if (!status) {
                alert('请选择审核结果');
                return false;
            }
            if (g_u_id) {
                $.ajax({
                    url: '/admin/checks/review_students',
                    type: 'post',
                    data: {
                        "status": status, "g_u_id": g_u_id
                    },
                    success: function (data) {
                        if (data[0]) {
                            alert(data[1]);
                            window.location.reload();
                        } else {
                            alert(data[1]);
                        }
                    }
                });
            }
            $(".select-review-status [name='review-status']").prop('checked', false);
        });
    });

    // 教师审核
    $(".teacher-apply-status [name='teacher-apply']").on('click', function () {
        var status = $(".teacher-apply-status [name='teacher-apply']:checked").val();
        if (status == 1) {
            $(".teacher-apply-level").removeClass('hide');
        } else {
            $(".teacher-apply-level").addClass('hide');
        }
    });
    $('.review-teacher-info-submit').on('click', function () {
        var level;
        var status = $(".teacher-apply-status [name='teacher-apply']:checked").val();
        var ud = $(this).attr('data-id');

        if (status) {
            level = $(".teacher-apply-level [name='teacher-apply-level']:checked").val();
            if (!level && status == 1) {
                alert('请选择老师级别');
                return false;
            }
            $.ajax({
                url: '/admin/checks/review_teacher',
                type: 'post',
                data: {
                    "status": status, "level": level, "ud": ud
                },
                success: function (data) {
                    if (data[0]) {
                        alert(data[1]);
                        window.location.reload();
                    } else {
                        alert(data[1]);
                    }
                }
            });
        } else {
            alert('请选择审核结果');
        }

        $(".teacher-apply-status [name='teacher-apply']").prop("checked", false);
        $(".teacher-apply-level [name='teacher-apply-level']").prop("checked", false);
    });

    // 家庭创客审核
    $('.review-hacker-info-submit').on('click', function () {
        var status = $(".hacker-apply-status [name='hacker-apply']:checked").val();
        var id = $(this).attr('data-id');

        if (status) {
            $.ajax({
                url: '/admin/checks/review_hacker',
                type: 'post',
                data: {
                    "status": status, "id": id
                },
                success: function (data) {
                    if (data[0]) {
                        $('#modal-form-' + id).modal('hide');
                        $("#after-audit-" + id).addClass('hide');
                        alert(data[1]);
                    } else {
                        alert(data[1]);
                    }
                }
            });
        } else {
            alert('请选择审核结果');
        }

        $(".hacker-apply-status [name='hacker-apply']").prop("checked", false);
    });

    // chosen select init
    var chosen_select = $(".chosen-select");
    chosen_select.chosen({
        max_selected_options: 3
    });

    $('#show-add-group-course').on('shown.bs.modal', function () {
        $(this).find('.chosen-container').each(function () {
            var self = $(this);
            self.find('a:first-child').css('width', '320px');
            self.find('.chosen-drop').css('width', '320px');
            self.find('.chosen-search input').css('width', '310px');

        });
        $(this).find('.chosen-container-multi').css('width', '320px');
    });

    // 班级添加课程
    $('.group-add-course-submit').on('click', function () {
        var course_ids = $("#selected-course-ids").val();
        var group_id = $(this).attr('data-course');
        if (course_ids == null) {
            alert('请选择课程!');
            return false;
        }
        if (course_ids.length > 3) {
            alert('一次只能添加3个课程!');
            return false;
        }
        $.ajax({
            url: '/admin/groups/add_course',
            type: 'post',
            data: {
                "group_id": group_id,
                "course_ids": course_ids
            },
            success: function (data) {
                alert(data[1]);
                if (data[0]) {
                    window.location.reload();
                }
            }
        });
    });
    // 课程添加属性星级
    $('.course-add-stars-submit').on('click', function () {
        var course_attr = trim($("#course-attr").val());
        var course_star = trim($("#course-star").val());
        var course_id = $(this).attr('data-course');

        if (course_attr == '') {
            alert('请填写中文属性!');
            return false;
        }
        if (course_star == '') {
            alert('请选择星级!');
            return false;
        }
        $.ajax({
            url: '/admin/courses/add_attr_star',
            type: 'post',
            data: {
                "id": course_id,
                "attr": course_attr,
                "star": course_star
            },
            success: function (data) {
                alert(data[1]);
                if (data[0]) {
                    window.location.reload();
                }
            }
        });
    });

});
function delete_group_course(group_course_id, group_id) {
    if (confirm('确认删除?')) {
        if (group_course_id && group_id) {
            $.ajax({
                url: '/admin/groups/delete_course',
                type: 'post',
                data: {
                    "group_id": group_id,
                    "group_course_id": group_course_id
                },
                success: function (data) {
                    alert(data[1]);
                    if (data[0]) {
                        $('#delete-hide-' + group_course_id).addClass('hide');
                    }
                }
            });
        } else {
            alert('参数不完整');
        }
    }
}