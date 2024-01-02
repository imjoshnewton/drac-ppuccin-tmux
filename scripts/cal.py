import EventKit
from datetime import datetime, timedelta
import Foundation
import pytz

# Get system timezone
def get_system_timezone():
    return Foundation.NSTimeZone.systemTimeZone().name()

# Request access to the calendar
def get_calendar_access():
    store = EventKit.EKEventStore.alloc().init()

    # Asynchronous access request
    def callback(granted, error):
        if not granted:
            print("Access to the calendar is denied.")
            exit(1)

    store.requestAccessToEntityType_completion_(EventKit.EKEntityTypeEvent, callback)

    # Wait for access to be granted
    while not hasattr(callback, 'finished'):
        pass

    return store

# Fetch events within the next 15 minutes
def fetch_upcoming_events(store, now):
    # Define the time range
    fifteen_minutes = now + timedelta(minutes=15)

    # Create a predicate to search for events
    calendars = store.calendarsForEntityType_(EventKit.EKEntityTypeEvent)
    predicate = store.predicateForEventsWithStartDate_endDate_calendars_(now, fifteen_minutes, calendars)

    # Fetch events
    return store.eventsMatchingPredicate_(predicate)

# Main function
def main():
    store = get_calendar_access()
    system_timezone = get_system_timezone()
    now = datetime.now(pytz.timezone(system_timezone))
    events = fetch_upcoming_events(store, now)
    for event in events:
        start_time = event.startDate().strftime("%Y-%m-%d %H:%M:%S")
        time_until_event = (event.startDate() - now).total_seconds() // 60
        print(f"Event '{event.title()}' starts at {start_time} (in {time_until_event} minutes)")

if __name__ == "__main__":
    main()
