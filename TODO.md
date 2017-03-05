To do
===

Lots of different types of events

* booked court 
* court fee
* provided balls
* transfered money on system
* transfered money by cash
* transfered money by paypal
* provided extras
* took part in practice

Things I've just noticed
---

### bad names
practice_note in event builder
expected json in event builder

### other things
have to pass in player name and practice date to event builder from note
event builder uses the same id for all events
event builder spec checks for the same event id for all events
build user service
build event service

### notes
how to handle carried events
* ignore them
* ignore all events before them
* ignore all amounts in events before them
* ignore all of them apart from the first one. set amount to carried amount on first carried event.

### non-note events
cells with dates but no notes still represents participation in practice. could make these participation events of amount 0