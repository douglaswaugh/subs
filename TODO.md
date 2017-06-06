To do
===

Things I've just noticed
---

### bad names
practice_note in event builder
expected json in event builder

### other things
have to pass in player name and practice date to event builder from note
build event service

### notes
how to handle carried events
* ignore them all but use them to check totals

### non-note events
cells with dates but no notes still represents participation in practice. could make these participation events of amount 0

player's balance
---

build carried events
ignore carried events
check running total against carried events

get balance for each player
check running total against carried events
print statement up to any discrepancy

removing duplication in event builder spec
---

1. organise common behaviour tests using contexts - not sure if this will work

  ### Likes:

  ### Dislikes:


2. Split parsing type from creating event hash

  1. Extract one, or a number of, factories from the EventBuilder.  
  2. Test the EventBuilder calls the correct factory/factory method, or perhaps verify the correct event type is returned.
  3. Test the factory/factory methods independently to make sure they work as expected.  Potentially use shared examples to test objects returned from factory/factory methods

  ### Likes:
  1. 

  ### Disli
  1. Not sure if I need to create a big old object hierarchy for the events as they just get written to disk as yaml at the moment