#import <EventKit/EventKit.h>

EKCalendar *findCalendarByTitle(EKEventStore *eventStore, NSString *title)
{
    for (EKCalendar *calendar in [eventStore calendarsForEntityType:EKEntityTypeEvent]) {
        if ([calendar.title hasPrefix:title])
            return calendar;
    }
    return [[eventStore calendarsForEntityType:EKCalendarTypeLocal] objectAtIndex:0];
}

NSDate *dateFromString(NSString *dateString, NSString *dateFormat)
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:dateFormat];
    NSDate *date = [dateFormatter dateFromString:dateString];
    return date;
}

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        NSUserDefaults *args = [NSUserDefaults standardUserDefaults];
        
        EKEventStore *eventStore = [[EKEventStore alloc] init];
        EKCalendar *calendar = findCalendarByTitle(eventStore, [args stringForKey:@"calendar"]);
        NSLog(@"Using calendar: %@ (%@)", calendar.title, calendar.description);
        
        EKEvent *event = [EKEvent eventWithEventStore:eventStore];
        event.calendar = calendar;
        event.title = [args stringForKey:@"title"];
        
        event.startDate = dateFromString([args stringForKey:@"start"], @"yyyy-MM-dd HH:mm");
        NSLog(@"Start: %@", event.startDate);
        event.endDate = [event.startDate dateByAddingTimeInterval:3600 * 0];

        NSError *error = nil;
        BOOL result = [eventStore saveEvent:event span:EKSpanThisEvent commit:YES error:&error];
        if (result) {
            return YES;
        } else {
            NSLog(@"Error saving event: %@", error);
            // unable to save event to the calendar
            return NO;
        }
    }
    return 0;
}
