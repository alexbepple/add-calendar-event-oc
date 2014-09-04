#import <EventKit/EventKit.h>

EKCalendar *findCalendarByTitle(EKEventStore *eventStore, NSString *title)
{
    for (EKCalendar *calendar in [eventStore calendarsForEntityType:EKEntityTypeEvent]) {
        if ([calendar.title hasPrefix:title])
            return calendar;
    }
    return [[eventStore calendarsForEntityType:EKCalendarTypeLocal] objectAtIndex:0];
}

NSDate *dateFromString(NSString *dateString)
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *date = [dateFormatter dateFromString:dateString];
    return date;
}

int main(int argc, const char * argv[])
{
    @autoreleasepool {
        NSUserDefaults *args = [NSUserDefaults standardUserDefaults];
        
        EKEventStore *eventStore = [[EKEventStore alloc] init];
        [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        }];
        
        EKCalendar *calendar = findCalendarByTitle(eventStore, [args stringForKey:@"calendar"]);
        NSLog(@"Using calendar: %@ (%@)", calendar.title, calendar.description);
        
        EKEvent *event = [EKEvent eventWithEventStore:eventStore];
        event.calendar = calendar;
        event.title = [args stringForKey:@"title"];
        
        event.startDate = dateFromString([args stringForKey:@"start"]);
        NSLog(@"Start: %@", event.startDate);
        
        NSString *endDate = [args stringForKey:@"end"];
        if (endDate) {
            event.endDate = dateFromString(endDate);
        } else {
            event.endDate = [event.startDate dateByAddingTimeInterval: [args integerForKey:@"durationInSeconds"]];
        }
        NSLog(@"End: %@", event.endDate);
        
        event.allDay = [args boolForKey:@"allDay"];

        NSError *error = nil;
        BOOL result = [eventStore saveEvent:event span:EKSpanThisEvent commit:YES error:&error];
        if (!result) {
            NSLog(@"Error saving event: %@", error);
            return 1;
        }
    }
}
