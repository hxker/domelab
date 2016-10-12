$("#form_change_profile .user_profile_roles input").each(function(i, el) {
    show_info(el);
}).change(function() {
    show_info(this);
});

if ($("#form_change_profile .school-select").hasClass("hidden")) {
    var school_select = $("#form_change_profile .school-select");
    $('#form_change_profile .change-school').click(function() {

        if (school_select.hasClass("hidden")) {
            get_districts();
        }
        school_select.toggleClass("hidden");
    });
} else {
    get_districts();
}

$("#district-select").change(function() {
    var district_id = $(this).val();
    if (district_id !== "0") {
        get_schools(district_id);
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
                school_select.html("<option value='0'>请选择学校</option>")
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
