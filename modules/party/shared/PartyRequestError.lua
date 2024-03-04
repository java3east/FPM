---@author Java3east [Discord: java3east]

---@enum PartyRequestError
PartyRequestError = {
    
    ---@type integer
    ---The player is already in a party
    ALREDY_IN_PARTY     = 0,

    ---@type integer
    ---The player is not in a/your party
    NOT_IN_PARTY        = 1,

    ---@type integer
    ---You / the player is not the party leader.
    NOT_PARTY_LEADER    = 2,

    ---@type integer
    ---The selected player is not online.
    NOT_ONLINE          = 3,

    ---@type integer
    ---The player has no invitation to the party he is trying to join.
    NO_INVITATION       = 4,

    ---@type integer
    ---Unspecified errors, which are not (yet) specified
    ERROR               = 5
}