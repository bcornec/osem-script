SELECT user_id,email,title,event_schedules.start_time,rooms.name FROM users,event_users,events,event_schedules,rooms WHERE event_users.event_id=73 and event_role="speaker" and users.id=user_id and events.id=event_users.event_id and state="Confirmed" and event_schedules.event_id=event_users.event_id and rooms.id=event_schedules.room_id;
