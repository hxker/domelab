/**
 * Created by huaxiukun on 16/9/26.
 */

$(function () {
    var user_lesson_test = $('#user-lesson-test-submit');
    if (user_lesson_test.length > 0) {
        user_lesson_test.on('click', function () {
            var lesson_id = $('#course-lesson-id').val();
            var test_ids = $('#lesson-test-ids').val().split(',');
            var answers = {};
            if (test_ids.length > 0) {
                for (var i = 0; i < test_ids.length; i++) {
                    // console.log(test_ids[i]);
                    var answer = $('input[name="lesson-answer[' + test_ids[i] + ']"]:checked').val();
                    // console.log(answer);
                    if (answer) {
                        answers[test_ids[i]] = answer;
                    } else {
                        alert('没有选择做完测验!');
                        return false;
                    }
                }
            }
            console.log(answers); //
            if (answers && getJsonLength(answers) == test_ids.length) {
                $.ajax({
                    url: '/courses/check_lesson_test',
                    type: 'post',
                    data: {answers: answers, lesson_id: lesson_id},
                    success: function (data) {
                        console.log(data)
                    }
                })
            }

        });
    }
});
function getJsonLength(jsonObj) {

    var jsonLength = 0;
    for (var item in jsonObj) {
        jsonLength++;
    }
    return jsonLength;
}
