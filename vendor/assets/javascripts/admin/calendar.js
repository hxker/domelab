/**
 * Created by huaxiukun on 16/9/12.
 */
$(function () {
    var group_calendar = $('#calendar');
    if (group_calendar.length > 0) {

        /* initialize the external events
         -----------------------------------------------------------------*/

        $('#external-events div.external-event').each(function () {

            // create an Event Object (http://arshaw.com/fullcalendar/docs/event_data/Event_Object/)
            // it doesn't need to have a start or end
            var eventObject = {
                title: $.trim($(this).text()) // use the element's text as the event title
            };

            // store the Event Object in the DOM element so we can get to it later
            $(this).data('eventObject', eventObject);

            // make the event draggable using jQuery UI
            $(this).draggable({
                zIndex: 999,
                revert: true,      // will cause the event to go back to its
                revertDuration: 0  //  original position after the drag
            });

        });


        /* initialize the calendar
         -----------------------------------------------------------------*/

        var date = new Date();
        var d = date.getDate();
        var m = date.getMonth();
        var y = date.getFullYear();

        var group_id = location.search.split('id=')[1];
        var calendar = group_calendar.fullCalendar({

            buttonText: {
                prev: '<i class="icon-chevron-left"></i>',
                next: '<i class="icon-chevron-right"></i>'
            },
            events: '/admin/groups/get_schedule?group_id=' + group_id,
            editable: true,
            droppable: true, // this allows things to be dropped onto the calendar !!!
            drop: function (date, allDay) { // this function is called when something is dropped

                // retrieve the dropped element's stored Event Object
                var originalEventObject = $(this).data('eventObject');
                var $extraEventClass = $(this).attr('data-class');


                // we need to copy it, so that multiple events don't have a reference to the same object
                var copiedEventObject = $.extend({}, originalEventObject);

                // assign it the date that was reported
                copiedEventObject.start = date;
                copiedEventObject.allDay = allDay;
                if ($extraEventClass) copiedEventObject['className'] = [$extraEventClass];

                // render the event on the calendar
                // the last `true` argument determines if the event "sticks" (http://arshaw.com/fullcalendar/docs/event_rendering/renderEvent/)
                $('#calendar').fullCalendar('renderEvent', copiedEventObject, true);

                // is the "remove after drop" checkbox checked?
                if ($('#drop-remove').is(':checked')) {
                    // if so, remove the element from the "Draggable Events" list
                    $(this).remove();
                }

            }
            ,
            selectable: true,
            selectHelper: true,
            select: function (start, end, allDay) {

                bootbox.prompt("新事件:", function (title) {

                    if ($.trim(title) != '' && title !== null) {

                        $.ajax({
                            url: '/admin/groups/add_schedule',
                            type: 'post',
                            data: {
                                title: title,
                                start: start,
                                end: end,
                                allDay: allDay,
                                group_id: group_id
                            },
                            success: function (data) {
                                if (data[0]) {
                                    calendar.fullCalendar('renderEvent',
                                        {
                                            title: title,
                                            start: start,
                                            end: end,
                                            allDay: allDay
                                        }
                                        // true // make the event "stick"
                                    );
                                } else {
                                    alert(data[1]);
                                }
                            }
                        });


                    }
                });
                calendar.fullCalendar('unselect');
            },

            // dayClick: function (date, allDay, jsEvent, view) {//日期点击后弹出的jq ui的框，添加日程记录
            //     var selectdate = $.fullCalendar.formatDate(date, "yyyy-MM-dd");//选择当前日期的时间转换
            // },

            eventClick: function (calEvent, jsEvent, view) {

                var form = $("<form class='form-inline'><label>更改事件名称 &nbsp;</label></form>");
                form.append("<input class='middle' autocomplete=off type=text value='" + calEvent.title + "' /> ");
                form.append("<button type='submit' class='btn btn-sm btn-success'><i class='icon-ok'></i> 提交</button>");

                var div = bootbox.dialog({
                    message: form,

                    buttons: {
                        "delete": {
                            "label": "<i class='icon-trash'></i> 删除",
                            "className": "btn-sm btn-danger",
                            "callback": function () {
                                calendar.fullCalendar('removeEvents', calEvent.id);
                                if (calEvent._id) {
                                    $.ajax({
                                        url: '/admin/groups/delete_schedule',
                                        type: 'post',
                                        data: {id: calEvent.id},
                                        success: function (data) {
                                            if (!data[0]) {
                                                alert(data[1]);
                                            }
                                        }
                                    });
                                }
                            }
                        },
                        "close": {
                            "label": "<i class='icon-remove'></i> 取消",
                            "className": "btn-sm"
                        }
                    }

                });

                form.on('submit', function () {
                    calEvent.title = form.find("input[type=text]").val();
                    calendar.fullCalendar('updateEvent', calEvent);
                    if (calEvent._id) {
                        $.ajax({
                            url: '/admin/groups/update_schedule',
                            type: 'post',
                            data: {id: calEvent.id, title: calEvent.title},
                            success: function (data) {
                                if (!data[0]) {
                                    alert(data[1]);
                                }
                            }
                        });
                    }
                    div.modal("hide");
                    return false;
                });
            },
            monthNames: ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"],
            titleFormat: {
                month: 'yyyy年 MMMM月',
                week: "yyyy.MMMM.d { '&#8212;' yyyy.MMMM.d}",
                day: 'yyyy年 MMMM月d日 dddd'
            },
            firstDay: 1,
            weekNumbers: true,
            allDayText: '全天',
            header: {
                left: 'prev,next today',
                center: 'title',
                right: 'month,agendaWeek,agendaDay'
            }
        });
    }
});