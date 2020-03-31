// Legend of Zelda, The: Spirit Tracks
// #ID = 9898

// UTILITY

function Delta(addr) => prev(addr)

// $065B68: Max Rupees
// $0B5308: >0x0 = air is being blown into the mic

// $0BB584: Time remaining in the final exam (dynamic?)
function timeRemainingInFinalExam() => word(0x0BB584)

// $261640: Current location (US)
function currentLocation() => word(0x261640)

locationInfo = {
    0x2f: { "id": 0x2f, "name": "Agoda Village", "code": "Agoda", }, 
    0x8: { "id": 0x8, "name": "Hyrule Field (Forest Realm)", "code": "ForestField", }, 
    0x29: { "id": 0x29, "name": "Castle Town", "code": "CastleTown", }, 
}

function GetCurrentLocationByCode(code)
{
    for id in locationInfo
    {
        if (locationInfo[id]["code"] == code)
        {
            return locationInfo[id]
        }
    }
    
}

// $261654: Current location (US) (changes when level is done loading)
function currentLocationAfterLoad() => word(0x261654)

// $262060: Current Location (EU)
// $262074: Location that will load (EU)

// $26479C: Current HP(?)
function currentHP() => byte(0x26479C)

// $26479D: Max HP(?)
function maxHP() => byte(0x26479D)

// $2648F8: Currently equipped item
function currentlyEquippedItem() => byte(0x2648F8)

// $264900: Bit 0: Whirlwind
//          Bit 1: Boomerang
//          Bit 2: Whip
//          Bit 3: Bow
//          Bit 4: Bombs
//          Bit 5: Sand Wand
// $264902: Bit 1: Recruit's Sword
//          Bit 7: Spirit Flute

function hasRecruitSword() => bit1(0x264902)

// $264908: Rupees
function rupees() => word(0x264908)

// $264914: Potion slot 1:
//          
//          0 = no potion
//          1 = Red Potion
//          2 = Purple Potion
//          3 = Yellow Potion
// $264915: Potion slot 2:
//          
//          0 = no potion
//          1 = Red Potion
//          2 = Purple Potion
//          3 = Yellow Potion
// $264CF4: Bit 4: Forest Temple
//          Bit 5: Snow Temple
//          Bit 6: Ocean Temple
//          Bit 7: Fire Temple
// $264CF5: Bit 7: Railmap
// $264CF7: Bit 0: Engineer Certificate

// $264CFB: Bit 0: Postman introduction (first time)
function wasPostmanIntroducedForTheFirstTime() => bit0(0x264CFB)

// $264D05: Bit 4: Rolled into the tree (ow...)
// $264D0E: Bit 0: Sand Temple
//          Bit 6: Rabbit Net
// $264D18: Bit 5: Reward for rolling into the tree (ow...)
// $264D19: Bit 1: Stamp Book
//          Bit 5: Compass of Light
// $264D26: Bit 0: Platinum Card (if Bit 4 is 1)
//          Bit 1: Diamond Card (if Bit 4 is 1)
//          Bit 2: Freebie Card
//          Bit 3: Quintuple Points Card
//          Bit 4: Club Card
// $2651BC: Current HP (EU)
// $2651BD: Max HP (EU)
// $2685E0: Demon Fossil count
// $2685E2: Stalfos Skull count
// $2685E4: Star Fragment count
// $2685E6: Bee Larvae count
// $2685E8: Wood Heart count
// $2685EA: Dark Pearl Loop count
// $2685EC: Pearl Necklaces count
// $2685EE: Ruto Crown count
// $2685F0: Dragon Scale count
// $2685F2: Pirate Necklace count
// $2685F4: Palace Dish count
// $2685F6: Goron Amber count
// $2685F8: Mystic Jade count
// $2685FA: Ancient Gold Piece count
// $2685FC: Alchemy Stone count
// $2685FE: Regal Ring count
// $2C3B00: Rupees (display)

// $264cf6: Bit 4: Trained with the captain
//          Bit 5: Cole appears for the first time
//          Bit 6: Zelda's guard is out of the way
//          Bit 7: Cole has let the guard pass and is at the ceremony
function trainedWithTheRoyalGuard() => bit4(0x264cf6)

// $04a04c: 0x1 = transitioning into game mode after clicking Adventure or Battle
function isLoadingSaveFile() => byte(0x04a04c) != 0

// ACHIEVEMENTS

// "Extra Credit"
hyruleField = GetCurrentLocationByCode("ForestField")
castleTown = GetCurrentLocationByCode("CastleTown")
agoda = GetCurrentLocationByCode("Agoda")
achievement(title = "Extra Credit", description = "Pass your final exam with at least 128 seconds left on the clock.", points = 1,
    trigger = once(Delta(currentLocation()) == agoda["id"] && currentLocation() == hyruleField["id"])
        && never(timeRemainingInFinalExam() < 128)
        && currentLocation() == castleTown["id"]
        && unless(timeRemainingInFinalExam() == 0)
        && never(wasPostmanIntroducedForTheFirstTime() == 1)
)

achievement(title = "Fresh from the Academy",
    description = "Acquire the Recruit's Sword and train under Russell, the Captain of the Guard.", points = 1,
    trigger = once(Delta(trainedWithTheRoyalGuard()) != trainedWithTheRoyalGuard() && trainedWithTheRoyalGuard() == 1)
        && never(isLoadingSaveFile())
)