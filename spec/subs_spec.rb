require "spec_helper"

# Adding court booking (write event)
# add-court-booking --player jamie --cost 18 --date 5/1/2016

# Adding a new practice (write events for each player)
# add-practice --players douglas,jamie,raul --balls douglas,jamie --date 15/12/2016

# Adding payment received
# add-payment-received --from jamie --amount 50 --type cash/coolhurst-transfer/bank-transfer (--reference?)

# Adding payment made
# add-payment-made --to jamie --amount 50 --type cash/coolhurst-transfer/bank-transfer

# Print balance for player (load events, filter by player, hydrate player, print statement - get to define everything we need)
#   court fee event
#   balls fee event
#   transfer received event
#   cash received event
#   booked court event
#   provided balls event
#   transfer paid event
# get-balance --player jamie

# Print statement for player
# get-statement --player jamie --from 13/12/2015 --to 27/12/2016

# Print balance for all players (load events, hydrate all players, print statement for each player)
# get-balances