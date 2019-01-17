SELECT user_id,email,title FROM users,event_users,events WHERE event_users.event_id >= 24 and event_role="speaker" and users.id=user_id and events.id=event_users.event_id and state="Rejected";
