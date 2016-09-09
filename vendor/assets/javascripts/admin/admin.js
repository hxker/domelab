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

});
function delete_group_course(group_course_id, group_id) {
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