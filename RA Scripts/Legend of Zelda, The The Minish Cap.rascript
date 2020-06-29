// Legend of Zelda, The: The Minish Cap
// #ID = 559

// $000BF4: Main Map Coordinate - 00-00=MinishWoods, 01=MinishVillage, 02=HyruleTown, 03=HyruleField, 03-00=WesternWood, MANY MORE
// $000BF5: Sub Map Coordinate
//          WAY TOO MANY TO NOTE!!
// $00188D: Giant ChuChu Boss = 00=UnspawnedOrDead, FF=Spawned
//          Set to 00 to kill instantly
//          Used with both Green and Blue ChuChu Bosses
// $00AA46: Game Beaten Status - Makes part of Triforce appear on Save File
//          00=False, 01=True, Becomes 01 the moment Credits start
//          Changing this to 01 will instantly make the final 6 figurines available
// $00AA80: Complete Hyrule Map = FFFF
//          16bit
// $00AA83: Wind Crests - bit7=1=MinishWoods, bit6=1=LinksHouse, bit3=1=HyruleTown
//          bit0=1=MtCrenel, bit5=1=CastorWilds, bit1=1=VeilFalls, bit2=1=CloudTops
// $00AAEA: Current Health
// $00AAEB: Heart Containers - First 3=18, 4th=20, every one from there is plus 8 (remember a,b,c,d,e,f)
//          Max = a0
//          8,10,18,20,28,30,38,40,48,50,etc
// $00AAF0: Figurines - Amount of unique figurines owned
//          Changing this doesn't affect which ones you own.
//          82=130, 88=136(Max with 6 hidden figurines)
// $00AB00: Rupees - 16bit
//          03e7=Max
//          (e7 03 in 8bit)
// $00AB0E: Figurines 1-7
//          FF=Have All 7
// $00AB10: Figurines 16=23
//          FF=Have All 8
// $00AB12: Figurines 32-39
//          FF=Have All 8
// $00AB14: Figurines 48-55
//          FF=Have All 8
// $00AB16: Figurines 64-71
//          FF=Have All 8
// $00AB18: Figurines 80-87
//          FF=Have All 8
// $00AB1A: Figurines 96-103
//          FF=Have All 8
// $00AB1C: Figurines 112-119
//          FF=Have All 8
// $00AB1E: Figurines - 128-130
//          07=Have All 3, FF=Have Final 5of6
//          6 more figurines are available after beating the game, and you can't get them if you complete your collection beforehand!
// $00AB32: Inventory - bit0=1=SmithsSwordWrapped??, bit2=1=SmithSwordUsable, bit4=1=WhiteSword1, bit6=1=WhiteSword2
// $00AB33: Inventory - bit0=1=WhiteSword3, bit6=1=Bombs, bit4=1=FourSword
// $00AB34: Inventory - bit0=1=RemoteBombs, bit2=1=Bow, bit4=1=LightArrow, bit6=1=Boomerang
// $00AB35: Inventory - bit2=1=SmallShield, bit0=1=MagicalBoomerang, bit6=1=Lantern, bit4=1=MirrorShield
// $00AB36: Inventory - bit2=1=GustJar, bit6=1=MoleMitts, bit4=1=CaneOfPacci
// $00AB37: Inventory - bit0=1=Cape, bit2=1=Boots, bit6=1=Ocarina
// $00AB39: Empty Bottle = bit0=1=Bottle1, bit6=1=Bottle4
//          bit4=1=Bottle3, bit2=1=Bottle2
//          0x55=Have All
// $00AB3F: Quest - bit0=1=SmithSwordWrapped, bit2=1=BrokenPicoriSword
//          bit6=1=LonLonRanchKeyFound, bit7=1=LonLonRanchKeyReturned
//          bit4=1=BottleOfDogFood
// $00AB41: Quest - bit2=1=TingleTrophy, bit4=1=CarlovMedal
//          bit0=1=GraveyardKey(FirstTime)
//          bit1=1=GraveyardKey used to open graveyard(also true very first moment u get key, so use coord check)
// $00AB42: Quest - bit0=1=EarthElement, bit2=1=FireElement, bit4=1=WaterElement, bit6=1=WindElement
//          All Elements = 0x55
// $00AB43: Quest - bit0=1=GripRing, bit2=1=PowerBracelets, bit4=1=Flippers, bit6=1=Map
// $00AB44: Quest - Tiger Scrolls
//          All Sword Techniques 16bit - 5555=HaveAll
//          Bit0=1=Spin, bit6=1=RockBreaker, bit4=1=DashAttack, bit2=1=RollAttack
// $00AB4E: Passive Permanent Upgrades (Part 1)
//          bit6=1=ChargeFast, bit4=1=SwimFast
//          bit2=1=DigFast, bit0=1=ShootArrowsFast
// $00AB57: Fused Kinstone Count
// $00ACDF: Swordsman Newsletter Issues Part 1 - 8bit
//          bit7=1=1st Issue = 0x80
//          Only the 1st issue is on this address
// $00ACE0: Swordsman Newsletter Issues Part 2 - 8bit
//          bit0=1=2nd, bit1=1=3rd, bit2=1=4th, bit4=1=6th
//          bit6=1=8th, bit5=1=7th, bit3=1=5th - Have All=0x7F

function Delta(addr) => prev(addr)

function IsFileLoaded() => byte(0x001002) == 0x2

function IsLoadingSaveFile() => Delta(byte(0x001002)) == 0x1 && IsFileLoaded()

function WasValueSet(mem, oldValue, newValue)
{
    return once(Delta(mem) == oldValue && mem == newValue)
}

function WasValueSetInGame(mem, oldValue, newValue)
{
    return WasValueSet(mem, oldValue, newValue)
        && never(!IsFileLoaded())
}

function WasBitflagSetInGame(mem)
{
    return WasValueSetInGame(mem, 0, 1)
}

function GenerateConditionsForByte(addr)
{
    conditions = {}
    for i in range(0, 7)
    {
        conditions[i] = { "countsWhen": (bit(i, addr) == 1), "recalculateWhen": (Delta(bit(i, addr)) == 0) }
    }
    return conditions
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
function GenerateSaveProtectedAchievementFromConditions(cheevo, conditions)
{
    loadedCounts = []
    totalCounts = []
    resetAlt = always_false()

    for i in conditions
    {
        condition = conditions[i]
        
        // This is the score when the game is loaded. If he loaded score is greater than or equal to the threshold--that is,
        // if the save file would satisfy enough conditions to trigger the achievement on load--this should trigger a
        // permanant pauselock to serve as save protection.
        array_push(loadedCounts, once(condition["countsWhen"] && IsLoadingSaveFile()))
        
        // We want both loaded and session counts here (that is, we don't care if we're loading a save file when these are tallied).
        // This way, loading a save doesn't invalidate the achievement outright if a player hasn't actually earned it yet.
        array_push(totalCounts, once(condition["countsWhen"]))
        
        resetAlt = resetAlt || condition["recalculateWhen"]
    }

    achievement(title = cheevo["name"], description = cheevo["description"], points = cheevo["points"],
        trigger = IsFileLoaded()
            && measured(tally(cheevo["threshold"], totalCounts)) && unless(tally(cheevo["threshold"], loadedCounts))
            && never(resetAlt)
    )
}

// Ticket 26994: Needs save protection; will trigger when a completed save file is loaded.
//               
//               Rich Presence at time of trigger:
//               Name: Link, 20(all) Heart Containers, 136 Figurines, 100 Fusions<br>MD5:
//               a104896da0047abe8bee2a6e3f4c7290
achievement(
    title = "Fire", description = "Obtain the Fire Element", points = 5,
    id = 2036, badge = "02487", published = "8/4/2013 8:00:34 AM", modified = "8/4/2013 8:10:47 AM",
    trigger = WasBitflagSetInGame(bit2(0x00AB42))
)

// Ticket 26993: Needs save protection; will trigger when a completed save file is loaded.
//               
//               Rich Presence at time of trigger:
//               Name: Link, 20(all) Heart Containers, 136 Figurines, 100 Fusions<br>MD5:
//               a104896da0047abe8bee2a6e3f4c7290
achievement(
    title = "Water", description = "Obtain the Water Element", points = 5,
    id = 2035, badge = "02486", published = "8/4/2013 8:00:31 AM", modified = "8/4/2013 8:10:41 AM",
    trigger = WasBitflagSetInGame(bit4(0x00AB42))
)

// Ticket 26995: Needs save protection; will trigger when a completed save file is loaded.
//               
//               Rich Presence at time of trigger:
//               Name: Link, 20(all) Heart Containers, 136 Figurines, 100 Fusions<br>MD5:
//               a104896da0047abe8bee2a6e3f4c7290
achievement(
    title = "Wind", description = "Obtain the Wind Element", points = 5,
    id = 2037, badge = "02488", published = "8/4/2013 8:00:38 AM", modified = "8/4/2013 8:10:52 AM",
    trigger = WasBitflagSetInGame(bit6(0x00AB42))
)

// Ticket 26996: Needs save protection; will trigger when a completed save file is loaded.
//               
//               Rich Presence at time of trigger:
//               Name: Link, 20(all) Heart Containers, 136 Figurines, 100 Fusions<br>MD5:
//               a104896da0047abe8bee2a6e3f4c7290
achievement(
    title = "Power Bracelets", description = "Obtain the Power Bracelets", points = 5,
    id = 2039, badge = "02490", published = "8/4/2013 8:00:49 AM", modified = "8/4/2013 8:11:06 AM",
    trigger = WasBitflagSetInGame(bit2(0x00AB43))
)

// Ticket 26997: Needs save protection; will trigger when a completed save file is loaded.
//               
//               Rich Presence at time of trigger:
//               Name: Link, 20(all) Heart Containers, 136 Figurines, 100 Fusions<br>MD5:
//               a104896da0047abe8bee2a6e3f4c7290
achievement(
    title = "Going For A Swim", description = "Obtain Flippers", points = 5,
    id = 2040, badge = "02491", published = "8/4/2013 8:00:51 AM", modified = "10/17/2019 3:22:01 PM",
    trigger = WasBitflagSetInGame(bit4(0x00AB43))
)

// Ticket 26998: Needs save protection; will trigger when a completed save file is loaded.
//               
//               Rich Presence at time of trigger:
//               Name: Link, 20(all) Heart Containers, 136 Figurines, 100 Fusions<br>MD5:
//               a104896da0047abe8bee2a6e3f4c7290
achievement(
    title = "Light It Up", description = "Obtain the Lantern", points = 5,
    id = 2042, badge = "02493", published = "8/4/2013 8:00:57 AM", modified = "8/4/2013 8:11:22 AM",
    trigger = WasBitflagSetInGame(bit6(0x00AB35))
)

// Ticket 26999: Needs save protection; will trigger when a completed save file is loaded.
//               
//               Rich Presence at time of trigger:
//               Name: Link, 20(all) Heart Containers, 136 Figurines, 100 Fusions<br>MD5:
//               a104896da0047abe8bee2a6e3f4c7290
function graveyardKeyUsed() => bit1(0x00AB41)
achievement(
    title = "Graveyard", description = "Obtain the Graveyard Key and use it", points = 5,
    id = 2043, badge = "02494", published = "8/4/2013 8:01:00 AM", modified = "8/4/2019 9:04:58 PM",
    trigger = once(Delta(graveyardKeyUsed()) == 0 && graveyardKeyUsed() == 1 && word(0x000BF4) == 0x9) && never(word(0x000BF4) != 0x9)
)

// Ticket 27000: Needs save protection; will trigger when a completed save file is loaded.
//               
//               Rich Presence at time of trigger:
//               Name: Link, 20(all) Heart Containers, 136 Figurines, 100 Fusions<br>MD5:
//               a104896da0047abe8bee2a6e3f4c7290
achievement(
    title = "White Sword", description = "Obtain the White Sword", points = 5,
    id = 2044, badge = "02495", published = "8/4/2013 8:01:02 AM", modified = "8/4/2013 8:11:27 AM",
    trigger = WasBitflagSetInGame(bit4(0x00AB32))
)

// Ticket 27001: Needs save protection; will trigger when a completed save file is loaded.
//               
//               Rich Presence at time of trigger:
//               Name: Link, 20(all) Heart Containers, 136 Figurines, 100 Fusions<br>MD5:
//               a104896da0047abe8bee2a6e3f4c7290
achievement(
    title = "White Sword 2", description = "Infuse your sword with Earth and Fire elements", points = 10,
    id = 2045, badge = "02496", published = "8/4/2013 8:01:05 AM", modified = "8/4/2019 9:04:45 PM",
    trigger = WasBitflagSetInGame(bit6(0x00AB32))
)

// Ticket 27002: Needs save protection; will trigger when a completed save file is loaded.
//               
//               Rich Presence at time of trigger:
//               Name: Link, 20(all) Heart Containers, 136 Figurines, 100 Fusions<br>MD5:
//               a104896da0047abe8bee2a6e3f4c7290
achievement(
    title = "White Sword 3", description = "Infuse your sword with the third element - Water", points = 10,
    id = 2046, badge = "02497", published = "8/4/2013 8:01:29 AM", modified = "9/26/2019 10:32:01 AM",
    trigger = WasBitflagSetInGame(bit0(0x00AB33))
)

// Ticket 27003: Needs save protection; will trigger when a completed save file is loaded.
//               
//               Rich Presence at time of trigger:
//               Name: Link, 20(all) Heart Containers, 136 Figurines, 100 Fusions<br>MD5:
//               a104896da0047abe8bee2a6e3f4c7290
achievement(
    title = "Four Sword", description = "Infuse your sword with the fourth element - Wind", points = 10,
    id = 2047, badge = "02498", published = "8/4/2013 8:01:40 AM", modified = "8/4/2019 9:04:50 PM",
    trigger = WasBitflagSetInGame(bit4(0x00AB33)) == 0x1
)

// Ticket 27004: Needs save protection; will trigger when a completed save file is loaded.
//               
//               Rich Presence at time of trigger:
//               Name: Link, 20(all) Heart Containers, 136 Figurines, 100 Fusions<br>MD5:
//               a104896da0047abe8bee2a6e3f4c7290
achievement(
    title = "Shiny!", description = "Obtain the Mirror Shield", points = 5,
    id = 2049, badge = "02500", published = "8/4/2013 8:01:46 AM", modified = "8/4/2013 8:11:43 AM",
    trigger = WasBitflagSetInGame(bit4(0x00AB35))
)

// Ticket 27008: Needs save protection; will trigger when a completed save file is loaded.
//               
//               Rich Presence at time of trigger:
//               Name: Link, 20(all) Heart Containers, 136 Figurines, 100 Fusions<br>MD5:
//               a104896da0047abe8bee2a6e3f4c7290
achievement(
    title = "Bow Down", description = "Obtain a Bow", points = 5,
    id = 2057, badge = "02509", published = "8/4/2013 8:02:34 AM", modified = "8/4/2013 8:12:06 AM",
    trigger = WasBitflagSetInGame(bit2(0x00AB34))
)

// Ticket 27009: Needs save protection; will trigger when a completed save file is loaded.
//               
//               Rich Presence at time of trigger:
//               Name: Link, 20(all) Heart Containers, 136 Figurines, 100 Fusions<br>MD5:
//               a104896da0047abe8bee2a6e3f4c7290
achievement(
    title = "It Doesn't Feel Lighter", description = "Obtain Light Arrows", points = 10,
    id = 2059, badge = "02511", published = "8/4/2013 8:02:40 AM", modified = "8/4/2019 9:04:41 PM",
    trigger = WasBitflagSetInGame(bit4(0x00AB34))
)

// Ticket 27005: Needs save protection; will trigger when a completed save file is loaded.
//               
//               Rich Presence at time of trigger:
//               Name: Link, 20(all) Heart Containers, 136 Figurines, 100 Fusions<br>MD5:
//               a104896da0047abe8bee2a6e3f4c7290
achievement(
    title = "Magic Trick", description = "Obtain the Magical Boomerang", points = 10,
    id = 2050, badge = "02501", published = "8/4/2013 8:01:48 AM", modified = "8/4/2019 9:04:28 PM",
    trigger = WasBitflagSetInGame(bit0(0x00AB35))
)

// Ticket 27007: Needs save protection; will trigger when a completed save file is loaded.
//               
//               Rich Presence at time of trigger:
//               Name: Link, 20(all) Heart Containers, 136 Figurines, 100 Fusions<br>MD5:
//               a104896da0047abe8bee2a6e3f4c7290
achievement(
    title = "Set Up Us The Bomb", description = "Obtain a Remote Bomb", points = 5,
    id = 2055, badge = "02507", published = "8/4/2013 8:02:30 AM", modified = "8/4/2013 8:11:59 AM",
    trigger = WasBitflagSetInGame(bit0(0x00AB34))
)

// Ticket 27006: Needs save protection; will trigger when a completed save file is loaded.
//               
//               Rich Presence at time of trigger:
//               Name: Link, 20(all) Heart Containers, 136 Figurines, 100 Fusions<br>MD5:
//               a104896da0047abe8bee2a6e3f4c7290
achievement(
    title = "Dig Dug", description = "Obtain Mole Mitts", points = 5,
    id = 2054, badge = "02505", published = "8/4/2013 8:02:26 AM", modified = "8/4/2013 8:11:55 AM",
    trigger = WasBitflagSetInGame(bit6(0x00AB36))
)

// Ticket 27010: Needs save protection; will trigger when a completed save file is loaded.
//               
//               Rich Presence at time of trigger:
//               Name: Link, 20(all) Heart Containers, 136 Figurines, 100 Fusions<br>MD5:
//               a104896da0047abe8bee2a6e3f4c7290
achievement(
    title = "I Can Fly!", description = "Obtain Roc's Cape", points = 5,
    id = 2060, badge = "02512", published = "8/4/2013 8:02:43 AM", modified = "8/4/2013 8:12:17 AM",
    trigger = WasBitflagSetInGame(bit0(0x00AB37))
)

// Ticket 27011: Needs save protection; will trigger when a completed save file is loaded.
//               
//               Rich Presence at time of trigger:
//               Name: Link, 20(all) Heart Containers, 136 Figurines, 100 Fusions<br>MD5:
//               a104896da0047abe8bee2a6e3f4c7290
achievement(
    title = "Pegasus Boots", description = "Obtain Pegasus Boots", points = 5,
    id = 2061, badge = "02513", published = "8/4/2013 8:02:46 AM", modified = "8/4/2013 8:12:22 AM",
    trigger = WasBitflagSetInGame(bit2(0x00AB37))
)

// Ticket 27012: Needs save protection; will trigger when a completed save file is loaded.
//               
//               Rich Presence at time of trigger:
//               Name: Link, 20(all) Heart Containers, 136 Figurines, 100 Fusions<br>MD5:
//               a104896da0047abe8bee2a6e3f4c7290
achievement(
    title = "Ocarina of Wind", description = "Obtain the Ocarina of Wind", points = 5,
    id = 2062, badge = "02514", published = "8/4/2013 8:02:49 AM", modified = "8/4/2013 8:12:25 AM",
    trigger = WasBitflagSetInGame(bit6(0x00AB37))
)

// Ticket 27013: Needs save protection; will trigger when a completed save file is loaded.
//               
//               Rich Presence at time of trigger:
//               Name: Link, 20(all) Heart Containers, 136 Figurines, 100 Fusions<br>MD5:
//               a104896da0047abe8bee2a6e3f4c7290
achievement(
    title = "Lon Lon Ranch", description = "Find and return the Lon Lon Ranch Key", points = 3,
    id = 2089, badge = "02564", published = "8/7/2013 9:49:34 PM", modified = "8/4/2019 9:04:16 PM",
    trigger = WasBitflagSetInGame(bit7(0x00AB3F))
)

newsletterConditions = {
    1: { "countsWhen": (bit7(0x00ACDF) == 0x1), "recalculateWhen": (Delta(bit7(0x00ACDF)) != bit7(0x00ACDF)) },
    2: { "countsWhen": (bit0(0x00ACE0) == 0x1), "recalculateWhen": (Delta(bit0(0x00ACE0)) != bit0(0x00ACE0)) },
    3: { "countsWhen": (bit1(0x00ACE0) == 0x1), "recalculateWhen": (Delta(bit1(0x00ACE0)) != bit1(0x00ACE0)) },
    4: { "countsWhen": (bit2(0x00ACE0) == 0x1), "recalculateWhen": (Delta(bit2(0x00ACE0)) != bit2(0x00ACE0)) },
    5: { "countsWhen": (bit3(0x00ACE0) == 0x1), "recalculateWhen": (Delta(bit3(0x00ACE0)) != bit3(0x00ACE0)) },
    6: { "countsWhen": (bit4(0x00ACE0) == 0x1), "recalculateWhen": (Delta(bit4(0x00ACE0)) != bit4(0x00ACE0)) },
    7: { "countsWhen": (bit5(0x00ACE0) == 0x1), "recalculateWhen": (Delta(bit5(0x00ACE0)) != bit5(0x00ACE0)) },
    8: { "countsWhen": (bit6(0x00ACE0) == 0x1), "recalculateWhen": (Delta(bit6(0x00ACE0)) != bit6(0x00ACE0)) },
}

// Just to test to make sure the generated achievement is still the same as the old one and that the conditions are right.
function VanillaNewsletterConditions()
{
    result = always_true()
    for i in newsletterConditions
    {
        condition = newsletterConditions[i]
        result = result && condition["countsWhen"]
    }
    return result
}

// Ticket 27014: Needs save protection; will trigger when a completed save file is loaded.
//               
//               Rich Presence at time of trigger:
//               Name: Link, 20(all) Heart Containers, 136 Figurines, 100 Fusions<br>MD5:
//               a104896da0047abe8bee2a6e3f4c7290
GenerateSaveProtectedAchievementFromConditions({
    "name": "Swordsman Newsletter",
    "description": "Subscribe to Swordsman Newsletter and collect all issues",
    "points": 10,
    "threshold": 8
}, newsletterConditions)

// Ticket 27023: Needs save protection. Will trigger upon loading up and starting a completed save file.
//               
//               Rich Presence at time of trigger:
//               Name: Link, 20(all) Heart Containers, 136 Figurines, 100 Fusions<br>MD5:
//               a104896da0047abe8bee2a6e3f4c7290
achievement(
    title = "Miracle Maker", description = "Fuse at least 50 Kinstones", points = 10,
    id = 2347, badge = "02843", published = "8/20/2013 5:26:51 AM", modified = "8/4/2019 9:03:45 PM",
    trigger = WasValueSetInGame(byte(0x00AB57), 0x31, 0x32)
)

// Ticket 27022: Needs save protection; will trigger when a completed save file is loaded.
//               
//               Rich Presence at time of trigger:
//               Name: Link, 20(all) Heart Containers, 136 Figurines, 100 Fusions<br>MD5:
//               a104896da0047abe8bee2a6e3f4c7290
achievement(
    title = "Tingle Trophy", description = "Complete all Kinstone Fusions", points = 25,
    id = 2349, badge = "02506", published = "8/20/2013 5:40:45 AM", modified = "3/30/2020 2:40:29 PM",
    trigger = WasBitflagSetInGame(bit2(0x00AB41)) && byte(0x00AB57) >= 0x63
)

dexterousConditions = {
    1: { "countsWhen": (bit0(0x00AB4E) == 1), "recalculateWhen": (Delta(bit0(0x00AB4E)) == 0) },
    2: { "countsWhen": (bit2(0x00AB4E) == 1), "recalculateWhen": (Delta(bit2(0x00AB4E)) == 0) },
    3: { "countsWhen": (bit4(0x00AB4E) == 1), "recalculateWhen": (Delta(bit4(0x00AB4E)) == 0) },
    4: { "countsWhen": (bit6(0x00AB4E) == 1), "recalculateWhen": (Delta(bit6(0x00AB4E)) == 0) },
    5: { "countsWhen": (bit0(0x00ab4f) == 1), "recalculateWhen": (Delta(bit0(0x00ab4f)) == 0) },
    6: { "countsWhen": (bit2(0x00ab4f) == 1), "recalculateWhen": (Delta(bit2(0x00ab4f)) == 0) },
}

// Just to test to make sure the generated achievement is still the same as the old one and that the conditions are right.
function VanillaDexterousConditions()
{
    result = always_true()
    for i in dexterousConditions
    {
        condition = dexterousConditions[i]
        result = result && condition["countsWhen"]
    }
    return result
}


// Ticket 27017: Needs save protection; will trigger when a completed save file is loaded.
//               
//               Rich Presence at time of trigger:
//               Name: Link, 20(all) Heart Containers, 136 Figurines, 100 Fusions<br>MD5:
//               a104896da0047abe8bee2a6e3f4c7290
GenerateSaveProtectedAchievementFromConditions({
    "name": "Dexterous",
    "description": "Learn all 6 abilities speeding up various actions",
    "points": 10,
    "threshold": 6
}, dexterousConditions)


// Ticket 27018: Needs save protection; will trigger when a completed save file is loaded.
//               
//               Rich Presence at time of trigger:
//               Name: Link, 20(all) Heart Containers, 136 Figurines, 100 Fusions<br>MD5:
//               a104896da0047abe8bee2a6e3f4c7290

navigatorConditions = {
    // Map
    1: { "countsWhen": (bit0(0x00AB4E) == 1), "recalculateWhen": (Delta(bit0(0x00AB4E)) == 0) },
}
mapConditions1 = GenerateConditionsForByte(0x00AA80)
mapConditions2 = GenerateConditionsForByte(0x00AA81)
windCrestConditions = GenerateConditionsForByte(0x00AA83)
windCrestConditions[8] = { "countsWhen": (bit0(0x00AA82) == 1), "recalculateWhen": (Delta(bit0(0x00AA82)) == 0)}

count = 0
navigatorConditions = {}
for i in mapConditions1
{
    navigatorConditions[count] = mapConditions1[i]
    count = count + 1
}

for i in mapConditions2
{
    navigatorConditions[count] = mapConditions2[i]
    count = count + 1
}

for i in windCrestConditions
{
    navigatorConditions[count] = windCrestConditions[i]
    count = count + 1
}
GenerateSaveProtectedAchievementFromConditions({
    "name": "Navigator",
    "description": "Complete the Hyrule Map and activate all Wind Crests",
    "points": 10,
    "threshold": 25
}, navigatorConditions)


//achievement(
//    title = "Navigator", description = "Complete the Hyrule Map and activate all Wind Crests", points = 10,
//    id = 2249, badge = "02741", published = "8/15/2013 11:25:04 PM", modified = "8/4/2019 9:03:42 PM",
//    trigger = word(0x00AA80) == 0xFFFF && byte(0x00AA83) == 0xFF && byte(0x00AA82) == 0x01
//)

// Ticket 26991: Needs save protection; will trigger when a completed save file is loaded.
//               
//               Rich Presence at time of trigger:
//               Name: Link, 20(all) Heart Containers, 136 Figurines, 100 Fusions<br>MD5:
//               a104896da0047abe8bee2a6e3f4c7290
function rupees() => word(0x00AB00)
achievement(
    title = "Rupee Gatherer", description = "Gather 300 Rupees", points = 5,
    id = 1474, badge = "02661", published = "5/31/2013 4:40:39 AM", modified = "8/4/2019 9:03:49 PM",
    trigger = rupees() >= 0x012C && Delta(rupees()) < 0x12c && IsFileLoaded()
)

// Ticket 27019: Needs save protection; will trigger when a completed save file is loaded.
//               
//               Rich Presence at time of trigger:
//               Name: Link, 20(all) Heart Containers, 136 Figurines, 100 Fusions<br>MD5:
//               a104896da0047abe8bee2a6e3f4c7290
scrollConditions = {
    1: { "countsWhen": (bit0(0x00ab44) == 1), "recalculateWhen": (Delta(bit0(0x00ab44)) == 0) },
    2: { "countsWhen": (bit2(0x00ab44) == 1), "recalculateWhen": (Delta(bit2(0x00ab44)) == 0) },
    3: { "countsWhen": (bit4(0x00ab44) == 1), "recalculateWhen": (Delta(bit4(0x00ab44)) == 0) },
    4: { "countsWhen": (bit6(0x00ab44) == 1), "recalculateWhen": (Delta(bit6(0x00ab44)) == 0) },
    5: { "countsWhen": (bit0(0x00ab45) == 1), "recalculateWhen": (Delta(bit0(0x00ab45)) == 0) },
    6: { "countsWhen": (bit2(0x00ab45) == 1), "recalculateWhen": (Delta(bit2(0x00ab45)) == 0) },
    7: { "countsWhen": (bit4(0x00ab45) == 1), "recalculateWhen": (Delta(bit4(0x00ab45)) == 0) },
    8: { "countsWhen": (bit6(0x00ab45) == 1), "recalculateWhen": (Delta(bit6(0x00ab45)) == 0) },
}
//achievement(
//    title = "Crouching Tiger", description = "Obtain all Tiger Scrolls", points = 10,
//    id = 2258, badge = "02749", published = "8/16/2013 9:23:34 AM", modified = "8/4/2019 9:03:53 PM",
//    trigger = word(0x00AB44) == 0x5555
//)
GenerateSaveProtectedAchievementFromConditions({
    "name": "Crouching Tiger",
    "description": "Obtain all Tiger Scrolls",
    "points": 10,
    "threshold": 8
}, scrollConditions)

achievement(title = "Rupee Accumulator", description = "Accumulate 100 Rupees", points = 1,
    id = 1473, badge = "02662",
    trigger = rupees() >= 0x64 && Delta(rupees()) < 0x64 && IsFileLoaded())

// Ticket 27015: Needs save protection; will trigger when a completed save file is loaded.
//               
//               Rich Presence at time of trigger:
//               Name: Link, 20(all) Heart Containers, 136 Figurines, 100 Fusions<br>MD5:
//               a104896da0047abe8bee2a6e3f4c7290
achievement(
    title = "Rupee Collector", description = "Collect 500 Rupees", points = 5,
    id = 2179, badge = "02663", published = "8/12/2013 1:13:56 PM", modified = "8/4/2019 9:03:51 PM",
    trigger = rupees() >= 0x01F4 && Delta(rupees()) < 0x1f4 && IsFileLoaded()
)

// Ticket 27016: Needs save protection; will trigger when a completed save file is loaded.
//               
//               Rich Presence at time of trigger:
//               Name: Link, 20(all) Heart Containers, 136 Figurines, 100 Fusions<br>MD5:
//               a104896da0047abe8bee2a6e3f4c7290
achievement(
    title = "Rupee Hoarder", description = "Hoard 999 Rupees", points = 10,
    id = 2180, badge = "02664", published = "8/12/2013 1:13:59 PM", modified = "8/4/2019 9:03:55 PM",
    trigger = rupees() >= 0x03E7 && Delta(rupees()) < 0x3e7 && IsFileLoaded()
)

// Ticket 27020: Needs save protection; will trigger when a completed save file is loaded.
//               
//               Rich Presence at time of trigger:
//               Name: Link, 20(all) Heart Containers, 136 Figurines, 100 Fusions<br>MD5:
//               a104896da0047abe8bee2a6e3f4c7290
bottleConditions = {
    1: { "countsWhen": (bit0(0x00AB39) == 1), "recalculateWhen": (Delta(bit0(0x00AB39)) == 0) },
    2: { "countsWhen": (bit2(0x00AB39) == 1), "recalculateWhen": (Delta(bit2(0x00AB39)) == 0) },
    3: { "countsWhen": (bit4(0x00AB39) == 1), "recalculateWhen": (Delta(bit4(0x00AB39)) == 0) },
    4: { "countsWhen": (bit6(0x00AB39) == 1), "recalculateWhen": (Delta(bit6(0x00AB39)) == 0) },
}
//achievement(
//    title = "Resourceful", description = "Obtain all four Bottles", points = 25,
//    id = 2260, badge = "02751", published = "8/16/2013 11:22:22 AM", modified = "10/23/2019 5:12:02 PM",
//    trigger = byte(0x00AB39) == 0x55
//)
GenerateSaveProtectedAchievementFromConditions({
    "name": "Resourceful",
    "description": "Obtain all four Bottles",
    "points": 25,
    "threshold": 4
}, bottleConditions)

// Ticket 27021: Needs save protection; will trigger when a completed save file is loaded.
//               
//               Rich Presence at time of trigger:
//               Name: Link, 20(all) Heart Containers, 136 Figurines, 100 Fusions<br>MD5:
//               a104896da0047abe8bee2a6e3f4c7290
achievement(
    title = "Carlov Medal", description = "Collect all 136 Figurines", points = 25,
    id = 2310, badge = "02809", published = "8/19/2013 8:49:12 PM", modified = "10/23/2019 5:12:02 PM",
    trigger = word(0x00AB0E) >= 0xFFFE && word(0x00AB10) == 0xFFFF && word(0x00AB12) == 0xFFFF && 
              word(0x00AB14) == 0xFFFF && word(0x00AB16) == 0xFFFF && word(0x00AB18) == 0xFFFF && word(0x00AB1A) == 0xFFFF && 
              word(0x00AB1C) == 0xFFFF && word(0x00AB1E) == 0x01FF && byte(0x00AAF0) == 0x88 && byte(0x00AA46) == 0x01 && bit4(0x00AB41) == 0x1
              && IsFileLoaded()
              && (
                // Any of the relevant valules must also change. I'd use the save protection I've already developed, but the number of moving parts
                // here makes me nervous, and I'm somewhat lazy to set up the conditions at the moment besides.
                  Delta(word(0x00AB0E)) < 0xFFFE || Delta(word(0x00AB10)) < 0xFFFF || Delta(word(0x00AB12)) < 0xFFFF
                  || Delta(word(0x00AB14)) < 0xFFFF || Delta(word(0x00AB16)) < 0xFFFF || Delta(word(0x00AB18)) < 0xFFFF || Delta(word(0x00AB1A)) < 0xFFFF
                  || Delta(word(0x00AB1C)) < 0xFFFF || Delta(word(0x00AB1E)) < 0x01FF || Delta(byte(0x00AAF0)) < 0x88 || Delta(bit4(0x00AB41)) < 0x1
              )
)

// Ticket 26992: Needs save protection; will trigger when a completed save file is loaded.
//               
//               Rich Presence at time of trigger:
//               Name: Link, 20(all) Heart Containers, 136 Figurines, 100 Fusions<br>MD5:
//               a104896da0047abe8bee2a6e3f4c7290
achievement(
    title = "Stayin' Alive", description = "Have 20 Heart Containers", points = 25,
    id = 1496, badge = "01735", published = "5/31/2013 5:40:11 PM", modified = "9/29/2019 11:02:03 AM",
    trigger = Delta(byte(0x00AAEB)) < 0xA0 && byte(0x00AAEB) == 0xa0 && IsFileLoaded()
)

// Ticket 26315: Kill the boss 3 times without getting damaged and doesn't trigger<br>MD5: Unknown<br>Emulator:
//               RetroArch (VMA)
achievement(
    title = "Bested Big Green Chuchu", description = "Defeat the Big Green Chuchu without taking damage", points = 10,
    id = 2078, badge = "02540", published = "8/5/2013 5:15:22 AM", modified = "8/5/2013 5:31:38 AM",
    trigger = once(byte(0x000BF4) == 0x48) && once(byte(0x000BF5) == 0x17) && never(byte(0x000BF5) == 0x0B) && 
              word(0x000BF4) == 0x0049 && never(byte(0x00AAEA) < prev(byte(0x00AAEA))) && once(byte(0x00188D) == 0xFF) && byte(0x00188D) == 0x00 && 
              never(bit0(0x00AB42) < prev(bit0(0x00AB42))) && bit0(0x00AB42) == 0x1
)

achievement(
    title = "Wake Up", description = "Obtain the Wake-Up Mushroom", points = 5,
    id = 2048, badge = "02499", published = "8/4/2013 8:01:43 AM", modified = "8/4/2019 9:04:52 PM",
    trigger = WasBitflagSetInGame(bit0(0x00ab40))
)

achievement(
    title = "Hyrulean Bestiary", description = "Obtain the Library Book - A Hyrulean Bestiary", points = 5,
    id = 2051, badge = "02502", published = "8/4/2013 8:02:07 AM", modified = "8/4/2019 9:04:30 PM",
    trigger = WasBitflagSetInGame(bit2(0x00ab40))
)

achievement(
    title = "Legend of the Picori", description = "Obtain the Library Book - Legend of the Picori", points = 5,
    id = 2052, badge = "02503", published = "8/4/2013 8:02:14 AM", modified = "8/4/2019 9:04:32 PM",
    trigger = WasBitflagSetInGame(bit4(0x00AB40))
)

achievement(
    title = "History of Masks", description = "Obtain the Library Book - A History of Masks", points = 5,
    id = 2053, badge = "02504", published = "8/4/2013 8:02:22 AM", modified = "8/4/2019 9:04:36 PM",
    trigger = WasBitflagSetInGame(bit6(0x00AB40))
)

achievement(
    title = "Where's The Boom?", description = "Obtain a Boomerang", points = 5,
    id = 2058, badge = "02510", published = "8/4/2013 8:02:37 AM", modified = "8/4/2013 8:12:10 AM",
    trigger = WasBitflagSetInGame(bit6(0x00AB34))
)
