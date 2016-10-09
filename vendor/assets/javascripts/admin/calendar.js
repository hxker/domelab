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
                var $extraEventCourse = $(this).attr('data-course');


                // we need to copy it, so that multiple events don't have a reference to the same object
                var copiedEventObject = $.extend({}, originalEventObject);

                // assign it the date that was reported
                copiedEventObject.start = date;
                copiedEventObject.allDay = allDay;

                if ($extraEventClass) copiedEventObject['className'] = [$extraEventClass];

                if ($extraEventCourse && group_id) {
                    $.ajax({
                        url: '/admin/groups/add_schedule',
                        type: 'post',
                        data: {
                            title: originalEventObject.title,
                            start: date,
                            course_id: $extraEventCourse,
                            end: null,
                            allDay: allDay,
                            group_id: group_id
                        },
                        success: function (data) {
                            if (data[0]) {
                                calendar.fullCalendar('renderEvent',
                                    {
                                        id: data[2],
                                        title: originalEventObject.title,
                                        start: date,
                                        end: null,
                                        allDay: allDay
                                    }
                                );
                            } else {
                                alert(data[1]);
                            }
                        }
                    });
                } else {
                    alert('不规范操作');
                }


                // render the event on the calendar
                // the last `true` argument determines if the event "sticks" (http://arshaw.com/fullcalendar/docs/event_rendering/renderEvent/)
                // $('#calendar').fullCalendar('renderEvent', copiedEventObject, true); // important

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

                // bootbox.prompt("新事件:", function (title) {
                //
                //     if ($.trim(title) != '' && title !== null) {
                //
                //         $.ajax({
                //             url: '/admin/groups/add_schedule',
                //             type: 'post',
                //             data: {
                //                 title: title,
                //                 start: start,
                //                 end: end,
                //                 allDay: allDay,
                //                 group_id: group_id
                //             },
                //             success: function (data) {
                //                 if (data[0]) {
                //                     calendar.fullCalendar('renderEvent',
                //                         {
                //                             id: data[2],
                //                             title: title,
                //                             start: start,
                //                             end: end,
                //                             allDay: allDay
                //                         }
                //                     );
                //                 } else {
                //                     alert(data[1]);
                //                 }
                //             }
                //         });
                //
                //
                //     }
                // });
                calendar.fullCalendar('unselect');
            },
            eventMouseover: function (data) {
                var tooltip = '<div class="tooltip-event" style="width:auto;height:auto;background:#9fe1e7;position:absolute;z-index:10001;padding:0 10px ; line-height: 200%;">'
                    + data.title + '</br>' +
                    (data.allDay ? "全天" : (data.start.getHours() + ":" + (data.start.getMinutes() == '0' ? '00' : data.start.getMinutes())) + (data.end != null ? ' -- ' + (data.end.getHours() + ":" + (data.end.getMinutes() == '0' ? "00" : data.end.getMinutes())) : '')) + '</div>';
                $("body").append(tooltip);
                $(this).mouseover(function (e) {
                    $(this).css('z-index', 10000);
                    var topic_event = $('.tooltip-event');
                    topic_event.fadeIn('500');
                    topic_event.fadeTo('10', 1.9);
                }).mousemove(function (e) {
                    var topic_event = $('.tooltip-event');
                    topic_event.css('top', e.pageY + 10);
                    topic_event.css('left', e.pageX + 20);
                });
            },
            eventMouseout: function (event) {
                $(this).css('z-index', 8);
                $('.tooltip-event').remove();
            },
            eventClick: function (calEvent) {
                var form = $('<h3>确认删除吗?</h3>');
                // var form = $("<form class='form-inline'><label>更改事件名称 &nbsp;</label></form>");
                // form.append("<input class='middle' autocomplete=off type=text value='" + calEvent.title + "' /> ");
                // form.append("<button type='submit' class='btn btn-sm btn-success'><i class='icon-ok'></i> 提交</button>");

                var div = bootbox.dialog({
                    message: form,

                    buttons: {
                        "delete": {
                            "label": "<i class='icon-trash'></i> 删除",
                            "className": "btn-sm btn-danger",
                            "callback": function () {

                                if (calEvent._id) {
                                    $.ajax({
                                        url: '/admin/groups/delete_schedule',
                                        type: 'post',
                                        data: {id: calEvent.id},
                                        success: function (data) {
                                            if (data[0]) {
                                                calendar.fullCalendar('removeEvents', calEvent.id);
                                            } else {
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
                        update_event(calEvent);
                    }
                    div.modal("hide");
                    return false;
                });
            },

            eventDrop: function (event, revertFunc) {
                update_event(event, 'update', revertFunc);
            },
            eventResize: function (event, revertFunc) {
                update_event(event, 'update', revertFunc)
            },
            monthNames: ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"],
            titleFormat: {
                month: 'yyyy年 MMMM月',
                week: "yyyy.MMMM.d { '&#8212;' yyyy.MMMM.d}",
                day: 'yyyy年 MMMM月d日 dddd'
            },
            firstDay: 1,
            firstHour: 8,
            slotMinutes: 15,
            weekNumbers: true,
            allDayText: '全天',
            header: {
                left: 'prev,next today',
                center: 'title',
                right: 'month,agendaWeek,agendaDay'
            }
        });

        function update_event(calEvent, revertFunc) {
            $.ajax({
                url: '/admin/groups/update_schedule',
                type: 'post',
                data: {
                    event: {
                        id: calEvent.id,
                        title: calEvent.title,
                        start: calEvent.start,
                        end: calEvent.end,
                        allDay: calEvent.allDay
                    }
                },
                success: function (data) {
                    if (!data[0]) {
                        alert(data[1]);
                        revertFunc();
                    }
                }
            });
        }
    }
});
