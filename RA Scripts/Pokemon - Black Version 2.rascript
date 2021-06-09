// Pokemon - Black Version 2
// #ID = 5853

// $14111E: Party Slot 1
// $1418E4: Current Hour
// $1418E8: Current Minute
// $21D9E4: Items Pocket - Item 1
// $21D9E6: Items Pocket - Item 1 amnt
// $21E008: TM Pocket - Slot 1
// $21E00C: TM Pocket - Slot 2
// $2266E4: money (32bit)
// $23B474: Trainer ID
// $23B476: Secret Trainer ID
// $23B481: Gender
// $23B4F8: Season
//          0 = Spring
//          1 = Summer
//          2 = Autumn
//          3 = Winter
// $23E4EA: X Coord
// $23E4F2: Y Coord
// $24279E: Minutes played
// $24279F: Seconds played
// $2A3698: Opposing mon current HP

function IsAlwaysInGame() => always_false()

function Delta(mem) => prev(mem)

function WasValueSet(mem, oldValue, newValue)
{
    return once(IsValueJustSet(mem, oldValue, newValue))
}

function IsValueJustSet(mem, oldValue, newValue)
{
    return Delta(mem) == oldValue && mem == newValue
}

function WasValueSetInGame(mem, oldValue, newValue)
{
    return IsAlwaysInGame() && WasValueSet(mem, oldValue, newValue)
}

function WasBitflagSetInGame(mem)
{
    return WasValueSetInGame(mem, 0, 1)
}

// This function allows the creation of achievements with built-in save protection that deal with a collection of values being set
// throughout the game. The schemas for both parameters are as follows:
//
// cheevo: "name": title
//         "description": self-explanatory
//         "points": self-explanatory
//         "threshold": how many values in the "addresses" dictionary must be set before this achievement is triggered
//
// conditions: "countsWhen": the condition that must be true in order for it to be counted in the total
//             "recalculateWhen": the condition that indicates that relevant values in the condition have changed,
//                                and so everything must be recalculated
//
// onlyAvailableWhen: A condition that must be true in all conditions for the achievement to trigger.
function GenerateCheevoFromConditions(cheevo, conditions, onlyAvailableWhen)
{
    loadedCounts = []
    totalCounts = []
    resetAlt = always_false()

    for i in conditions
    {
        condition = conditions[i]
        
        // This is the score when the game is loaded. If the loaded score is greater than or equal to the threshold--that is,
        // if the save file would satisfy enough conditions to trigger the achievement on load--this should trigger a
        // permanant pauselock to serve as save protection.
        array_push(loadedCounts, once(condition["countsWhen"] && IsLoadingSaveFile()))
        
        // We want both loaded and session counts here (that is, we don't care if we're loading a save file when these are tallied).
        // This way, loading a save doesn't invalidate the achievement outright if a player hasn't actually earned it yet.
        array_push(totalCounts, once(condition["countsWhen"]))
        
        resetAlt = resetAlt || condition["recalculateWhen"]
    }

    achievement(title = cheevo["name"], description = cheevo["description"], points = cheevo["points"],
        trigger = !IsOnSaveOrLoadMenu() &&
            measured(tally(cheevo["threshold"], totalCounts)) && unless(tally(cheevo["threshold"], loadedCounts))
            && never(resetAlt) && onlyAvailableWhen && (always_false() || IsAlwaysInGame())
    )
}

locations = {
    0x1b6: {  "id": 0x1b6, "key": "AspertiaGate", "display": "Aspertia Gate", },
}

function GetLocationByKey(key)
{
    for i in locations
    {
        location = locations[i]
        
        if (location["key"] == key)
        {
            return location
        }
    }
}

function IsInLocation(key)
{
    location = GetLocationByKey(key)
    return areaId() == location["id"]
}

function areaId() => word(0x23b444)

// 1 = Got free Potion at the Aspertia Gate
function aspertiaGateFlag() => byte(0x2256a4)

// 1 = Met rival for the first time
// 2 = Rival stays behind before the outlook
// 3 = Met Bianca for the first time
// 4 = Obtained starter Pokemon
// 5 = Rival gets his Pokedex
// 6 = Pokemon Center tutorial complete
// 7 = Got the Running Shoes
function openingFlag() => byte(0x225626)
achievement(title = "On the Road", points = 1, badge = "00000",
    description = "Step into the Aspertia Gate for the first time with your new starter Pokemon in tow.",
    trigger = aspertiaGateFlag() == 0 && openingFlag() == 7 && IsInLocation("AspertiaGate")
)

