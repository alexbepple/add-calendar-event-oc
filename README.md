
## What is this?

A small command-line utility to create events in the Calendar app on OS X.


## Try it

	make
	build/Release/addEvent -calendar 'personal' -title 'Dinner' -start '2014-10-17 20:00' -end '2014-10-17 22:00'

All-day event:

	build/Release/addEvent -calendar 'personal' -title 'Anniversary' -start '2014-10-17 0:00' -end '2014-10-17 0:00' -allDay true

