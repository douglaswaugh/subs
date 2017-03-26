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

Getting a player's balance by name
---

* Get the player's ID by player name
* Use the ID to get the events for the player
* Hydrate the player from the events