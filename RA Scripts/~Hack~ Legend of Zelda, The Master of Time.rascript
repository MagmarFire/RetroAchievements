// ~Hack~ Legend of Zelda, The: Master of Time
// #ID = 16509

// Utility

function Delta(addr) => prev(addr)

function Min(x, y)
{
    if (x > y)
    {
        return x
    }
    else
    {
        return y
    }
}

function IsBitflagSetInGame(bit)
{
    return IsValueSetInGame(bit, 0, 1)
}

function WasBitflagSetInGame(bit)
{
    return WasValueSetInGame(bit, 0, 1)
}

function IsValueSetInGame(bit)
{
    return IsValueSet(bit, 0, 1)
}

function WasValueSetInGame(mem, oldValue, newValue)
{
    return WasValueSet(mem, oldValue, newValue)
        && never(IsLoadingSaveFile())
}

function IsValueSetInGame(mem, oldValue, newValue)
{
    return IsValueSet(mem, oldValue, newValue)
        && never(IsLoadingSaveFile())
}

function WasValueSet(mem, oldValue, newValue)
{
    return once(Delta(mem) == oldValue && mem == newValue)
}

function WasBitflagSet(mem)
{
    return WasValueSet(mem, 0, 1)
}

function IsValueSet(mem, oldValue, newValue)
{
    return Delta(mem) == oldValue && mem == newValue
}

function DidValueBecomeGreaterThanGivenInGame(mem, value)
{
    return once(Delta(mem) <= value && mem > value) && never(IsLoadingSaveFile())
}

function IsLoadingSaveFile() => Delta(status()) == 2 && status() == 0 || status() == 1 || status() == 2

// $11A5D0: Entrance ID (16-bit)
function entranceId() => word(0x11A5D0)

// $11A5F4: Save file name, character 4 (8-bit)
function char4() => byte(0x11A5F4)

// $11A5F5: Save file name, character 3 (8-bit)
function char3() => byte(0x11A5F5)

// $11A5F6: Save file name, character 2 (8-bit)
function char2() => byte(0x11A5F6)

// $11A5F7: Save file name, character 1 (8-bit)
function char1() => byte(0x11A5F7)

// $11A5F8: Save file name, character 8 (8-bit)
function char8() => byte(0x11A5F8)

// $11A5F9: Save file name, character 7 (8-bit)
function char7() => byte(0x11A5F9)

// $11A5FA: Save file name, character 6 (8-bit)
function char6() => byte(0x11A5FA)

// $11A5FB: Save file name, character 5 (8-bit)
function char5() => byte(0x11A5FB)

function rupees() => word(0x11a606)

// $11b92c: 00: Boot, Gameplay
//          01: Title Screen
//          02: File select
function status() => byte(0x11b92c)

// $11B4A7: Bit 5: Sagnol Village cutscene (first time exiting the inn)
// $11B4F9: Bit 0: Magic Jar (first time)
// $1CA1D8: Chest flags for the current area
// $11a6a2: Gold Skulltula tokens collected (16-bit)
function goldSkulltulas() => word(0x11a6a2)

// This function allows the creation of achievements with built-in save protection that deal with a collection of values being set
// throughout the game. The schemas for both parameters are as follows:
//
// cheevo: "name": title
//         "description": self-explanatory
//         "points": self-explanatory
//         "threshold": how many values in the "addresses" dictionary must be set before this achievement is triggered
//         "id": the ID of the achievement on the RA server
//
// conditions: "countsWhen": the condition that must be true in order for it to be counted in the total
//             "recalculateWhen": the condition that indicates that relevant values in the condition have changed,
//                                and so everything must be recalculated
function GenerateSaveProtectedAchievementFromConditions(cheevo, conditions)
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

    achievement(title = cheevo["name"], description = cheevo["description"], points = cheevo["points"], id = cheevo["id"],
        trigger = !IsLoadingSaveFile() && never(IsBooting())
            && measured(tally(cheevo["threshold"], totalCounts)) && unless(tally(cheevo["threshold"], loadedCounts))
            && never(resetAlt)
    )
}

function SlotHasBottleItem(mem)
{
    return mem >= 0x14 && mem <= 0x20
}

function WasItemSlotFilled(mem)
{
    return Delta(mem) == 0xff && mem != 0xff
}

achievement(title = "Save Protection Test", description = "If this pops when the game loads, save protection is broken.", points = 0,
    trigger = DidValueBecomeGreaterThanGivenInGame(rupees(), 0) || DidValueBecomeGreaterThanGivenInGame(goldSkulltulas(), 0)
)

function currentAreaChestBuffer() => byte(0x1ca1d8)
chestFlags = {
    "medicine": { "storage": 0x11ab58, "buffer": 0x1ca1d8, "bit": 7 }
}

medicineChest = chestFlags["medicine"]
achievement(title = "Are You Proud of Yourself?", description = "Raid the chest in the sleeping man's room in Sagnol Village.", points = 1,
    trigger = WasBitflagSetInGame(bit(medicineChest["bit"], medicineChest["buffer"])) && unless(bit(medicineChest["bit"], medicineChest["storage"]) == 1)
)

function bottle1() => byte(0x11a655)
function bottle2() => byte(0x11a654)
function bottle3() => byte(0x11a65b)
function bottle4() => byte(0x11a65a)
achievement(title = "Take One Down, Pass It Around", description = "Obtain four bottles.", points = 10,
    // All bottle slots have to be filled with a bottle item, and any one of those slots must have just been an empty slot.
    trigger = SlotHasBottleItem(bottle1()) && SlotHasBottleItem(bottle2()) && SlotHasBottleItem(bottle3()) && SlotHasBottleItem(bottle4()) && 
        (WasItemSlotFilled(bottle1()) || WasItemSlotFilled(bottle2()) || WasItemSlotFilled(bottle3()) || WasItemSlotFilled(bottle4()))
        && never(IsLoadingSaveFile())
)

skulltulaCheevos = [
    { "name": "Rookie Exterminator", "points": 3, "threshold": 10 },
    { "name": "Regular Exterminator", "points": 5, "threshold": 25 },
    { "name": "Veteran Exterminator", "points": 10, "threshold": 50 },
    { "name": "Legendary Exterminator", "points": 25, "threshold": 100 },
]

for cheevo in skulltulaCheevos
{
    achievement(title = cheevo["name"], points = cheevo["points"], description = "Collect " + cheevo["threshold"] + " Gold Skulltula tokens.",
        trigger = Delta(goldSkulltulas()) == cheevo["threshold"] - 1 && measured(goldSkulltulas() == cheevo["threshold"]) && never(IsLoadingSaveFile())
    )
}