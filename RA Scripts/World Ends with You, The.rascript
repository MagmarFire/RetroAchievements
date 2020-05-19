// World Ends with You, The
// #ID = 4887

// UTILITY

framesPerSecond = 60

function Delta(addr) => prev(addr)

function WasBitflagSetInGame(bit)
{
    return once(Delta(bit) != bit && bit == 1)
        && never(IsLoadingSaveFile())
}

function SecondsToFormat(value)
{
    leadingZero = ""
    if (value % 60 < 10)
    {
        leadingZero = "0"
    }
    return value / 60 + ":" + leadingZero + value % 60
}

enemyNamesToIds = {
    "Metal Corehog": {  }
}

// $074194: 0x1 = transitioning into game mode after clicking Adventure or Battle
function IsLoadingSaveFile() => Delta(isOnTitleScreen()) == 0x1 && isOnTitleScreen() == 0x0

function isOnTitleScreen() => byte(0x074194)

// $071D1C: Money (32-bit)
// $071D28: Partner ID (8-bit)
//          
//          0x0 = Shiki
//          0x1 = Joshua
//          0x2 = Beat
// $071D84: Deck 1, Slot 1, Pin ID (16-bit)
// $0737B8: ESP'er Points
// $07415C: Overworld x-coordinate (32-bit)
// $074160: Overworld y-coordinate (32-bit)
// $074168: Map ID (16-bit)
// $074171: Bit 3: "Noise!?"
function noiseInterrobang() => bit3(0x074171)

// $074E52: Battle state:
//          
//          0x0 = switch to battle
//          0x1 = in battle
//          0x2 = victory
function InBattle() => byte(0x074e52) == 0x1
function OutOfBattle() => byte(0x074e52) == 0x2

// $074E98: Time elapsed in battle (frames) (32-bit)
// $074E9C: Number of consecutive hits in battle (16-bit)
// $074E9F: Hits taken in battle
// $3984C4: Slot 1 pin ID (pins screen) (16-bit)
//          
//          Set to 0xffff if there is no pin in that slot.
// $3984DA: Slot 1 is in a sub-slot
// $398BE4: ID of pin in Slot 1 of your inventory
// $398BF8: Stockpile pin, Slot 1 - Level (8-bit)
// $398C30: ID of pin in Slot 2 of stockpile

function currentRankingGraphic() => byte(0x06879c)

function whipSoundEffect() => byte(0x39d544)
function WhipSoundEffectPlayed() => Delta(whipSoundEffect()) == 0x0 && whipSoundEffect() == 0x1

rankingGraphicIndices = {
    "Star": { "index": 0x10 },
    "A": { "index": 0x80 },
    "B": { "index": 0x30 },
    "C": { "index": 0x70 },
    "D": { "index": 0x40 },
    "E": { "index": 0x50 }
}

function GetRankingGraphicIndexByName(name)
{
    for index in rankingGraphicIndices
    {
        if (index == name)
        {
            return rankingGraphicIndices[index]["index"]
        }
    }
}

function IsRankingRevealed()
{
    return OutOfBattle() && WhipSoundEffectPlayed()
}

// Pin-related functionality
// ---
// The data structures for pins vary depending on whether or not they're in a player's deck/stockpile or if they're in the Mastered collection.
//
// DECK/STOCKPILE (11 bytes each)
// ***
// Bytes 0-1: Pin ID. Equal to 0xffff if there is no pin equipped in that slot. IDs go from 0x0 to 0x12f.
// Bytes 2-3: Battle PP.
// Bytes 4-5: Mingle PP.
// Bytes 6-7: Shutdown PP.
// Byte 9: Bit 0 determines if a pin is in a subslot.
// Byte A: Pin LV (lower 4 only)
//
// MASTERED (4 bytes each)
// ***
// Bytes 0-1: Pin ID. Equal to 0xffff if there is no pin in that slot.
// Byte 2: Count.
// Byte 3: Pin LV (lower 4 only; probably redundant?)
//
// To check mastery, we'll have to check both the deck and Mastered collection.

achievement(title = "Save Protection Test", points = 0,
    description = "If this pops when the game loads, save protection is bugged!",
    trigger = WasBitflagSetInGame(noiseInterrobang())
)

achievement(title = "Battle Star", points = 5,
    description = "Attain a 🟊 ranking in battle on Hard or Ultimate difficulty.",
    trigger = currentRankingGraphic() == GetRankingGraphicIndexByName("Star") && IsRankingRevealed()
)

timeLimit = 30
achievement(title = "Don't Kill Me Slowly", points = 5,
    description = "Defeat the Metal Corehog on Week 1, Day 2, within " + SecondsToFormat(timeLimit) + " on Normal difficulty or higher.",
    trigger = always_false()
)