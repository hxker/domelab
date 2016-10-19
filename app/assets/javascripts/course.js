/**
 * Created by huaxiukun on 16/9/26.
 */

$(function() {
    var start_time = Date.now();
    var user_lesson_test = $('#user-lesson-test-submit');
    if (user_lesson_test.length > 0) {
        user_lesson_test.on('click', function() {
            var lesson_id = $('#course-lesson-id').val();
            var test_ids = $('#lesson-test-ids').val().split(',');
            var answers = {};
            if (test_ids.length > 0) {
                for (var i = 0; i < test_ids.length; i++) {
                    var answer = $('input[name="lesson-answer[' + test_ids[i] + ']"]:checked').val();
                    if (answer) {
                        answers[test_ids[i]] = answer;
                    } else {
                        alert('请做完测验再提交!');
                        return false;
                    }
                }
            }
            if (answers && getJsonLength(answers) == test_ids.length) {
                var ms = Date.now() - start_time;
                min = (ms / 1000 / 60) << 0,
                    sec = (ms / 1000) % 60;
                $.ajax({
                    url: '/courses/check_lesson_test',
                    type: 'post',
                    data: {
                        answers: answers,
                        lesson_id: lesson_id
                    },
                    success: function(data) {
                        console.log(data);
                        if (data[0] === true) {
                            var right_per = data[1]["right_per"];
                            $('#lesson-test-container').addClass("hidden");
                            $('#timepassed span').text(min + '分' + sec + '秒');
                            $('#test-result span').text(right_per);
                            $('#test-teacher-wrapper').append($('<img>', {
                                src: data[1]["teacher_avatar"]
                            }));
                            if (right_per === 100) {
                                $('.full-marks').removeClass('hidden');
                            } else {
                                $('.not-full-marks').removeClass('hidden');
                            }
                            $('#test-result-container').removeClass("hidden");
                        } else {
                            console.log(data[1]);
                            $.notify("提交失败");
                        }

                    }
                });
            }

        });
    }
    initScheduler();
});

function getJsonLength(jsonObj) {

    var jsonLength = 0;
    for (var item in jsonObj) {
        jsonLength++;
    }
    return jsonLength;
}

function initScheduler() {
    function formate_date(datestring) {
        var d = new Date(datestring);
        return [d.getMonth() + 1, "/", d.getDate(), "/", d.getFullYear()].join('');
    }
    var scheduler_here = $("#scheduler_here");
    if (scheduler_here.length) {
        scheduler.config.start_on_monday = false;
        scheduler.config.readonly = true;
        scheduler.config.month_day = "%j";
        scheduler.config.week_date = "%D";
        scheduler.templates.month_date = function(date) {
            var d = new Date(date);
            var month = d.getMonth() + 1;
            $(".month-list a").removeClass("selected");
            $(".month-list li:nth-child(" + month + ") a").addClass("selected");
            return d.getFullYear();
        };
        scheduler.templates.month_day = function(date) {
            var dateToStr_func = scheduler.date.date_to_str(scheduler.config.month_day);
            return "<div>" + dateToStr_func(date) + "</div>";
        };
        scheduler.xy.bar_height = 100;
        scheduler.xy.month_scale_height = 40;
        scheduler.xy.scale_height = 30;
        scheduler.xy.margin_top = 20;
        scheduler_here.dhx_scheduler({
            date: new Date(),
            mode: "month"
        });
        scheduler.templates.event_bar_date = function(start, end, ev) {
            return "";
        };
        scheduler.templates.event_bar_text = function(start, end, event) {
            //console.log(event);
            var name = event.text.split("--");
            var link = "/courses/" + event.course_id;
            $("tbody tr:nth-child(" + (event._sweek + 1) + ") td:nth-child(" + (event._sday + 1) + ") .dhx_month_head div").addClass("hasLesson");
            return "<a href='" + link + "'><div class='course'>" + name[0] + "</div>" + "<div class='lesson'>" + name[1] + "</div></a>";
        };

        var data = $('.scheduler-data').data('scheduler');
        if (data.length) {
            var final_data = data.map(function(obj) {
                var tmp = formate_date(obj.start);
                return {
                    text: obj.title,
                    start_date: tmp,
                    end_date: tmp,
                    course_id: obj.course_id
                };
            });

            scheduler.parse(final_data, "json");
        }

        $(".month-list li").click(function() {
            var year = $(".dhx_cal_date").text();
            var month = $(".month-list li").index(this);
            scheduler.setCurrentView(new Date(year, month, 1), "month");
        });
    }


}
