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
                var ms = start_time - Date.now();
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
                        if (data[0] == true) {
                            // var html = $('<div><h1>正确率:' + data[1]["right_per"] + '</h1><p><img src="' + data[1]["teacher_avatar"] + '"></p>' +
                            //     '<p><a class="btn btn-xs btn-primary" href="javascript:history.go(-1);">返回</a></p></div>');
                            // $('#lesson-test-container').html(html)
                            $('#lesson-test-container').addClass("hidden");
                            $('#timepassed span').text(min + ':' + sec);
                            $('#test-result span').text(data[1]["right_per"]);
                            $('test-teacher-wrapper').aapend($('<img>', {
                                src: data[1]["teacher_avatar"]
                            }));
                            $('#test-result-container').removeClass("hidden");
                        } else {
                            alert(data[1])
                        }

                    }
                })
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
        var fd = [d.getMonth() + 1, "/", d.getDate(), "/", d.getFullYear()].join('')
        return fd
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
        scheduler_here.dhx_scheduler({
            date: new Date(),
            mode: "month"
        });
        //scheduler.init('scheduler_here', new Date(), "month");
        scheduler.templates.event_bar_date = function(start, end, ev) {
            return "";
        };
        scheduler.templates.event_bar_text = function(start, end, event) {
            return "<div class='course'>" + event.text + "</div>" + "<div class='lesson'>" + event.text + "</div>";
        };

        var data = $('.scheduler-data').data('scheduler');
        var final_data = data.map(function(obj) {
            return {
                text: obj.title,
                start_date: formate_date(obj.start),
                end_date: formate_date(obj.end)
            }
        });
        scheduler.parse(final_data, "json");
        $(".month-list li").click(function() {
            var year = $(".dhx_cal_date").text();
            var month = $(".month-list li").index(this);
            scheduler.setCurrentView(new Date(year, month, 1), "month");
        });
    }


}
