// Rayman 2: The Great Escape (E)
// #ID = 10269

// $0C6DF9: Area ID (32-bit)
function areaId() => dword(0x0C6DF9)

// $0C6E59: 43 treasure maybe
// $0C8CA1: Golden Gloves
//          00= No Golden Gloves
//          01= Golden Gloves
// $0C9470: Text appearing (gameplay or cutscene)
//          01= No text
//          02>= Text appeared
// $0CDDC6: lums rougemaybe
// $0E14BC: globox race better
// $0E5C34: Level ID 16bits (These do not seem correct)
//          
//          6172 = The Woods of Light
//          6172 = The Fairy Glade
//          6e75= Main Menu/Bonus Stage
//          706d= Main Hub (Hall of Doors)
//          7963= Results Screen
// $0E6911: Pause Mode
//          01= Paused
// $0EA27C: Current Slot Loaded (01/02/03)
// $1768B4: Music 1
// $17691E: Camera X Coordinates 16bits
// $1FA240: Animation relatde
// $1FA780: 0c basketball
// $1FA781: ad Basketball
// $21A288: Rayman Animation ID 1 16bits
//          4428= Elixir of Life
//          43bc= Respawn
//          43c8= Static
//          45a8= Basketball idle
//          44ac= Yeah!
// $21A289: 45 basket
// $21A28C: Last Rayman Animation loaded 16bits
// $21A28D: 43 basket
// $2248C8: Cages Destroyed in this Level
// $22493C: Lums remaining current level
// $224941: Cages total
// $224942: Current Lums 8bits
//          Resets to 0 when you enter a level (even if you re-enter to someone)
//          If you enter a level through other level (like Bad Dreams Cave), the variable doesn't restart to 0
// $22494E: Cutscene Mode
//          0c= cutscene playing
// $224988: Fairy Glade Total Lums 16bits
//          ffff= All lums collected
// $224994: Marais fin Bayou debut
// $22499A: Santuary of Water Lums 01 8bits
//          ff= All Lums Collected
// $2249BA: Echoing caves debut
// $2249C0: Echoing caves fin precipice debut
// $2249C6: Precipice fin The top of the world debut
// $2249CC: Top of the world fin Sanctuary1 debut
// $2249D2: Sanctuary of rock and lava1 fin
// $2249DE: Tomb of the anciens fin
// $224A00: 7f power shots
// $224A10: 2d nwhite shots 6d blue
// $224A13: df all mask
// $224A16: Charging shots
// $224A2B: Final debut
// $224A31: avant dernier niveau quelque part
// $224A35: Final final
// $224A36: Bit 3: Yellow Lum 2 - Woods of Light, Area 1 (free)
//          Bit 4: Yellow Lum 5 - Woods of Light, Area 1 (wall)
//          Bit 5: Yellow Lum 3 - Woods of Light, Area 1 (free)
//          Bit 6: Yellow Lum 1 - Woods of Light, Area 1 (Cage)
//          Bit 7: Yellow Lum 4 - Woods of Light, Area 2 (waterfall)
// $5D4C62: Input stable
// $5DE45C: Total Lums 16bits (at Main Hub)
// $5E976E: SWITCH obus
// $5E9AC0: Walk of Life Timer (ms) 16bits
// $5E9AC2: Walk of Life Timer (mm/ss) 16bits
// $5ECF34: Walk of Power Timer 2 (ms) 16bits
// $5ECF36: Walk of Power Timer 1 (mm/ss) 16bits
// $5ECF37: Timer race positive 2
// $5F01BF: Final Fight Unlimited Ammo Flag
//          01= Unlocked
// $5FD47E: lums vert ancient1
// $74CEE8: Globox Son Animation 16bits
//          cb88= Race haven´t started
//          cba8= Race have just started
//          ccc8= Race Won
// $74E2F2: Bonus Race Timer 1 16bits
// $76ED14: lumsrazor
// $76ED30: lumsrazor2
// $76ED31: lumsrazor 3
// $76ED32: lumsrazor4
// $77AB93: Iron Mountains Switch 1
//          08= Switch pressed
// $77B44B: Iron Mountains Switch 2
//          08= Switch pressed
// $780970: Rayman Animation ID (Only at Hall of Doors)
//          b8 = Static
//          38 = Jumping
//          18 = Falling from a Jump
// $7871CC: Menezis Current Score 16bits
// $787F62: Barbe a HP
// $787F6C: Menezis Current Score 16bits
// $78863C: Menezis Current Score 16bits
// $7A08E6: 1000th lum
//          2e= Lum spawned
//          2b= Lum taked
// $7A325E: lums vert ancien 2
// $7A325F: lums vert ancient suite

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

    achievement(title = cheevo["name"], description = cheevo["description"], points = cheevo["points"], badge = cheevo["badge"],
        trigger = IsInGame() &&
            measured(tally(cheevo["threshold"], totalCounts)) && unless(tally(cheevo["threshold"], loadedCounts))
            && never(resetAlt) && onlyAvailableWhen && (always_false() || never(Delta(char1()) == 0 && char1() == 0))
    )
}

function GenerateConditionFromBitflag(bit)
{
    return { "countsWhen": (bit == 1), "recalculateWhen": (Delta(bit) != bit) }
}

MapLookup = {
    0xcccc: "Main Menu",
    0x6e75: "Main Menu",
    0x696c: "Intro",
    0x6172: "The Iron Mountains",
    0x706d: "The Hall of Doors",
    0x695f: "The Marshes of Awakening",
    0x6173: "The Bayou",
    0x7461: "Razorbeard's Ship",
    0x7465: "The Sanctuary of Water and Ice",
    0x6c6f: "Polokus home",
    0x6465: "The Menhir Hills",
    0x645f: "Ending",
    0x6c63: "The Cave of Bad Dreams",
    0x6f62: "The Canopy",
    0x616c: "Whale Bay",
    0x6166: "Ending",
    0x756d: "The Sanctuary of Stone and Fire",
    0x7374: "The Echoing Caves",
    0x736b: "The Echoing Caves",
    0x7665: "The Precipice",
    0x6174: "The Prison Ship",
    0x7274: "The Sanctuary of Rock and Lava",
    0x6c69: "Beneath the Sanctuary of Rock and Lava",
    0x7262: "Tomb of the Ancients",
    0x6f70: "The Crow's Nest",
    0x5f31: "The Walk of Life",
    0x5f32: "The Walk of Power",
}

achievement(
    title = "King of Teensies", description = "Meet the... king?", points = 5,
    id = 71511, badge = "165863", published = "2/5/2019 4:38:34 AM", modified = "4/5/2021 3:03:33 PM",
    trigger = prev(word(0x0E5C34)) == 24946 && word(0x0E5C34) == 28781
)

achievement(
    title = "Ly... are you ok?", description = "Save Ly", points = 10,
    id = 71512, badge = "165864", published = "2/5/2019 4:38:38 AM", modified = "4/5/2021 3:03:35 PM",
    trigger = never(byte(0x22494E) != 12) && never(word(0x0E5C34) != 29556) && never(areaId() != 30655) && 
              unless(byte(0x0C9470) == 4) && repeated(150, word(0x17691E) == 42)
)

achievement(
    title = "Sorry Rayman our missing lums are in another level", description = "Find everything in \"The Fairy Glade\"", points = 5,
    id = 54209, badge = "165866", published = "11/2/2017 7:03:50 PM", modified = "4/5/2021 3:03:40 PM",
    trigger = unless(word(0x0E5C34) != 24946) && word(0x0E5C34) == 24946 &&
              ((byte(0x2248C8) == 7 && prev(byte(0x22493C)) == 1 && byte(0x22493C) == 0) ||
               (byte(0x22493C) == 0 && prev(byte(0x2248C8)) == 6 && byte(0x2248C8) == 7))
)

achievement(
    title = "SSSSO easy", description = "Find everything in \"The Marshes of Awakening\"", points = 5,
    id = 54210, badge = "165894", published = "11/2/2017 7:03:54 PM", modified = "4/5/2021 3:03:42 PM",
    trigger = unless(word(0x0E5C34) != 26975) && word(0x0E5C34) == 26975 &&
              ((byte(0x22493C) < prev(byte(0x22493C)) && byte(0x22493C) == 0 && byte(0x2248C8) == 5) ||
               (byte(0x2248C8) > prev(byte(0x2248C8)) && byte(0x2248C8) == 5 && byte(0x22493C) == 0))
)

achievement(
    title = "Easier than Bayou Billy", description = "Find everything in \"The Bayou\"", points = 5,
    id = 54212, badge = "165895", published = "11/2/2017 7:04:01 PM", modified = "4/5/2021 3:03:44 PM",
    trigger = unless(word(0x0E5C34) != 24947) && word(0x0E5C34) == 24947 &&
              ((byte(0x22493C) < prev(byte(0x22493C)) && byte(0x22493C) == 0 && byte(0x2248C8) == 7) ||
               (prev(byte(0x2248C8)) > 2246856 && byte(0x2248C8) == 7 && byte(0x22493C) == 0))
)

achievement(
    title = "I feel alive", description = "Find every lums in \"The Walk of Life\"", points = 5,
    id = 54213, badge = "165896", published = "11/2/2017 7:04:04 PM", modified = "4/5/2021 3:03:46 PM",
    trigger = unless(word(0x0E5C34) != 24369) && word(0x0E5C34) == 24369 && byte(0x22493C) < prev(byte(0x22493C)) && 
              byte(0x22493C) == 0
)

achievement(
    title = "Colder than ice", description = "Find everything in \"The Sanctuary of Water and Ice\"", points = 5,
    id = 54215, badge = "165897", published = "11/2/2017 7:04:34 PM", modified = "4/5/2021 3:03:47 PM",
    trigger = unless(word(0x0E5C34) != 29797) && word(0x0E5C34) == 29797 &&
              ((byte(0x22493C) < prev(byte(0x22493C)) && byte(0x22493C) == 0 && byte(0x2248C8) == 2) ||
               (byte(0x2248C8) > prev(byte(0x2248C8)) && byte(0x2248C8) == 2 && byte(0x22493C) == 0))
)

achievement(
    title = "Water and Ice", description = "Beat the Guardian Axel and get the first mask", points = 10,
    id = 71513, badge = "165865", published = "2/5/2019 4:38:40 AM", modified = "4/5/2021 3:03:48 PM",
    trigger = prev(word(0x0E5C34)) == 29797 && word(0x0E5C34) == 27759 && byte(0x22494E) == 12
)

achievement(
    title = "Game over", description = "Give me money", points = 5,
    id = 71514, badge = "165867", published = "2/5/2019 4:38:42 AM", modified = "4/5/2021 3:03:50 PM",
    trigger = never(word(0x0E5C34) != 27747) && never(areaId() != 30849) && never(byte(0x22494E) != 12) && 
              repeated(200, word(0x17691E) == 65516)
)

achievement(
    title = "You deserve this!", description = "Get the Elixir of Life", points = 10,
    id = 71515, badge = "165868", published = "2/5/2019 4:38:44 AM", modified = "4/5/2021 3:03:51 PM",
    trigger = unless(byte(0x0E6911) == 1) && unless(byte(0x22494E) != 12) && never(word(0x0E5C34) == 28781) && 
              prev(word(0x0E5C34)) == 27747 && word(0x0E5C34) == 26975
)

achievement(
    title = "The dream master", description = "Find everything in \"The Cave of Bad Dreams\"", points = 5,
    id = 54217, badge = "165898", published = "11/2/2017 7:04:40 PM", modified = "4/5/2021 3:03:52 PM",
    trigger = unless(word(0x0E5C34) != 27747) && unless(byte(0x22494E) == 12) && word(0x0E5C34) == 27747 && 
              byte(0x22493C) < prev(byte(0x22493C)) && byte(0x22493C) == 0
)

achievement(
    title = "What the hell are you doing Obelix?!", description = "Find everything in \"The Menhir Hills\"", points = 5,
    id = 54218, badge = "165899", published = "11/2/2017 7:04:44 PM", modified = "4/5/2021 3:03:54 PM",
    trigger = unless(word(0x0E5C34) != 25701) && word(0x0E5C34) == 25701 &&
              ((byte(0x22493C) < prev(byte(0x22493C)) && byte(0x22493C) == 0 && byte(0x2248C8) == 8) ||
               (byte(0x2248C8) > prev(byte(0x2248C8)) && byte(0x2248C8) == 8 && byte(0x22493C) == 0))
)

achievement(
    title = "Globox not afraid", description = "Get the ability to charge", points = 10,
    id = 71516, badge = "165869", published = "2/5/2019 4:38:46 AM", modified = "4/5/2021 3:03:55 PM",
    trigger = never(word(0x0E5C34) != 28514) && never(areaId() != 30916) && never(byte(0x22494E) != 12) && 
              repeated(60, word(0x17691E) == 65483)
)

achievement(
    title = "Rayman VS Wild", description = "Find everything in \"The Canopy\"", points = 5,
    id = 54220, badge = "165900", published = "11/2/2017 7:04:50 PM", modified = "4/5/2021 3:03:56 PM",
    trigger = unless(word(0x0E5C34) != 28514) && word(0x0E5C34) == 28514 &&
              ((byte(0x22493C) < prev(byte(0x22493C)) && byte(0x22493C) == 0 && byte(0x2248C8) == 4) ||
               (byte(0x2248C8) > prev(byte(0x2248C8)) && byte(0x2248C8) == 4 && byte(0x22493C) == 0))
)

achievement(
    title = "Breathing whale farts", description = "Find everything in \"The Whale Bay\"", points = 5,
    id = 54223, badge = "165901", published = "11/2/2017 7:05:12 PM", modified = "4/5/2021 3:03:58 PM",
    trigger = unless(word(0x0E5C34) != 24940) && word(0x0E5C34) == 24940 &&
              ((byte(0x22493C) < prev(byte(0x22493C)) && byte(0x22493C) == 0 && byte(0x2248C8) == 4) ||
               (byte(0x2248C8) > prev(byte(0x2248C8)) && byte(0x2248C8) == 4 && byte(0x22493C) == 0))
)

achievement(
    title = "Harder like Souls", description = "Beat the Guardian Umber and get the second mask", points = 10,
    id = 71517, badge = "165870", published = "2/5/2019 4:38:47 AM", modified = "4/5/2021 3:03:59 PM",
    trigger = prev(word(0x0E5C34)) == 30061 && word(0x0E5C34) == 27759 && byte(0x22494E) == 12
)

achievement(
    title = "The Plump Master", description = "Find everything in \"The Sanctuary of Stone and Fire\"", points = 5,
    id = 54225, badge = "165902", published = "11/2/2017 7:05:27 PM", modified = "4/5/2021 3:04:01 PM",
    trigger = unless(word(0x0E5C34) != 30061) && word(0x0E5C34) == 30061 &&
              ((byte(0x22493C) < prev(byte(0x22493C)) && byte(0x22493C) == 0 && byte(0x2248C8) == 8) ||
               (byte(0x2248C8) > prev(byte(0x2248C8)) && byte(0x2248C8) == 8 && byte(0x22493C) == 0))
)

achievement(
    title = "Do a barrel roll", description = "Find everything in \"The Echoing Caves\"", points = 10,
    id = 54226, badge = "165903", published = "11/2/2017 7:05:31 PM", modified = "4/5/2021 3:04:02 PM",
    trigger = ((byte(0x22493C) < prev(byte(0x22493C)) && byte(0x22493C) == 0 && byte(0x2248C8) == 5 && 
                word(0x0E5C34) == 29547) ||
               (byte(0x2248C8) > prev(byte(0x2248C8)) && byte(0x2248C8) == 5 && byte(0x22493C) == 0 && 
                word(0x0E5C34) == 29547) ||
               (byte(0x22493C) < prev(byte(0x22493C)) && byte(0x22493C) == 0 && byte(0x2248C8) == 5 && 
                word(0x0E5C34) == 29556) ||
               (byte(0x2248C8) > prev(byte(0x2248C8)) && byte(0x2248C8) == 5 && byte(0x22493C) == 0 && 
                word(0x0E5C34) == 29556))
)

achievement(
    title = "Run Forrest run!", description = "Find everything in \"The Precipice\"", points = 5,
    id = 54227, badge = "165904", published = "11/2/2017 7:05:34 PM", modified = "4/5/2021 3:04:03 PM",
    trigger = unless(word(0x0E5C34) != 30309) && word(0x0E5C34) == 30309 &&
              ((byte(0x22493C) < prev(byte(0x22493C)) && byte(0x22493C) == 0 && byte(0x2248C8) == 6) ||
               (byte(0x2248C8) > prev(byte(0x2248C8)) && byte(0x2248C8) == 6 && byte(0x22493C) == 0))
)

achievement(
    title = "Deadly stairlift", description = "Find everything in \"The top of the World\"", points = 5,
    id = 54228, badge = "165905", published = "11/2/2017 7:05:38 PM", modified = "4/5/2021 3:04:04 PM",
    trigger = unless(word(0x0E5C34) != 24948) && word(0x0E5C34) == 24948 &&
              ((byte(0x22493C) < prev(byte(0x22493C)) && byte(0x22493C) == 0 && byte(0x2248C8) == 2) ||
               (byte(0x2248C8) > prev(byte(0x2248C8)) && byte(0x2248C8) == 2 && byte(0x22493C) == 0))
)

achievement(
    title = "Hotter than lava", description = "Find everything in \"The Sanctuary of Rock and Lava\"", points = 5,
    id = 54230, badge = "165906", published = "11/2/2017 7:05:53 PM", modified = "4/5/2021 3:04:05 PM",
    trigger = unless(word(0x0E5C34) != 29300) && word(0x0E5C34) == 29300 &&
              ((byte(0x22493C) < prev(byte(0x22493C)) && byte(0x22493C) == 0 && byte(0x2248C8) == 7) ||
               (byte(0x2248C8) > prev(byte(0x2248C8)) && byte(0x2248C8) == 7 && byte(0x22493C) == 0))
)

achievement(
    title = "Fast and fairies", description = "Find everything in \"The Walk of Power\"", points = 5,
    id = 54231, badge = "165907", published = "11/2/2017 7:05:57 PM", modified = "4/5/2021 3:04:11 PM",
    trigger = unless(word(0x0E5C34) != 24370) && word(0x0E5C34) == 24370 && byte(0x22493C) < prev(byte(0x22493C)) && 
              byte(0x22493C) == 0
)

achievement(
    title = "Rock and Lava", description = "Beat the Guardian Foutch and get the third mask", points = 10,
    id = 71518, badge = "165871", published = "2/5/2019 4:38:49 AM", modified = "4/5/2021 3:04:12 PM",
    trigger = prev(word(0x0E5C34)) == 27753 && word(0x0E5C34) == 27759 && byte(0x22494E) == 12
)

achievement(
    title = "Use your head", description = "Find everything in \"Beneath the Sanctuary of Rock and Lava\"", points = 5,
    id = 54234, badge = "165908", published = "11/2/2017 7:06:18 PM", modified = "4/5/2021 3:04:14 PM",
    trigger = unless(word(0x0E5C34) != 27753) && word(0x0E5C34) == 27753 &&
              ((byte(0x22493C) < prev(byte(0x22493C)) && byte(0x22493C) == 0 && byte(0x2248C8) == 4) ||
               (byte(0x2248C8) > prev(byte(0x2248C8)) && byte(0x2248C8) == 4 && byte(0x22493C) == 0))
)

achievement(
    title = "Uh, oh...", description = "Beat Clark", points = 10,
    id = 71519, badge = "165872", published = "2/5/2019 4:38:50 AM", modified = "4/5/2021 3:04:15 PM",
    trigger = never(word(0x0E5C34) != 29282) && never(areaId() != 30900) && never(byte(0x22494E) != 12) && 
              repeated(100, word(0x17691E) == 34)
)

achievement(
    title = "I'm not afraid (or just a little)", description = "Find everything in \"The Tomb of the Ancients\"", points = 5,
    id = 54236, badge = "165909", published = "11/2/2017 7:06:25 PM", modified = "4/5/2021 3:04:18 PM",
    trigger = unless(word(0x0E5C34) != 29282) && word(0x0E5C34) == 29282 &&
              ((byte(0x22493C) < prev(byte(0x22493C)) && byte(0x22493C) == 0 && byte(0x2248C8) == 6) ||
               (byte(0x2248C8) > prev(byte(0x2248C8)) && byte(0x2248C8) == 6 && byte(0x22493C) == 0))
)

achievement(
    title = "Hi, mama", description = "Save Globox sons and get the last mask", points = 10,
    id = 71520, badge = "165873", published = "2/5/2019 4:38:52 AM", modified = "4/5/2021 3:04:19 PM",
    trigger = never(word(0x0E5C34) != 28261) && never(areaId() != 31136) && never(byte(0x22494E) != 12) && 
              repeated(100, word(0x17691E) == 65528)
)

achievement(
    title = "Globox... why so many babies?!", description = "Find everything in \"The Iron Mountains\"", points = 5,
    id = 54238, badge = "165910", published = "11/2/2017 7:06:33 PM", modified = "4/5/2021 3:04:21 PM",
    trigger = unless(word(0x0E5C34) != 28261) && word(0x0E5C34) == 28261 &&
              ((byte(0x22493C) < prev(byte(0x22493C)) && byte(0x22493C) == 0 && byte(0x2248C8) == 3) ||
               (byte(0x2248C8) > prev(byte(0x2248C8)) && byte(0x2248C8) == 3 && byte(0x22493C) == 0))
)

achievement(
    title = "That's a great escape", description = "Beat Razorbeard", points = 25,
    id = 71521, badge = "165874", published = "2/5/2019 4:38:53 AM", modified = "4/5/2021 3:04:26 PM",
    trigger = prev(word(0x0E5C34)) == 28528 && word(0x0E5C34) == 25695 && byte(0x22494E) == 12
)

achievement(
    title = "Eating Screws", description = "Find everything in \"The Prison Ship\"", points = 5,
    id = 71959, badge = "165911", published = "2/14/2019 12:42:31 AM", modified = "4/5/2021 3:04:38 PM",
    trigger = byte(0x22493C) < prev(byte(0x22493C)) && byte(0x22493C) == 0 &&
              ((word(0x0E5C34) == 24948) ||
               (word(0x0E5C34) == 29810))
)

achievement(
    title = "Nice, lums!", description = "Get a total of 100 lums  (Triggered at Hall of Doors)", points = 5,
    id = 71522, badge = "165875", published = "2/5/2019 4:38:55 AM", modified = "4/5/2021 3:04:42 PM",
    trigger = never(byte(0x0EA27C) == 0) && word(0x0E5C34) == 28781 && word(0x5DE45C) >= 100 && byte(0x780970) == 184
)

achievement(
    title = "Kind of a collection", description = "Get a total of 250 lums  (Triggered at Hall of Doors)", points = 10,
    id = 71523, badge = "165876", published = "2/5/2019 4:38:57 AM", modified = "4/5/2021 3:05:21 PM",
    trigger = never(byte(0x0EA27C) == 0) && word(0x0E5C34) == 28781 && word(0x5DE45C) >= 250 && byte(0x780970) == 184
)

achievement(
    title = "Lummania", description = "Get a total of 500 lums  (Triggered at Hall of Doors)", points = 10,
    id = 71524, badge = "165877", published = "2/5/2019 4:38:59 AM", modified = "4/5/2021 3:05:23 PM",
    trigger = never(byte(0x0EA27C) == 0) && word(0x0E5C34) == 28781 && word(0x5DE45C) >= 500 && byte(0x780970) == 184
)

achievement(
    title = "Lum addicted", description = "Get a total of 750 lums  (Triggered at Hall of Doors)", points = 10,
    id = 71525, badge = "165878", published = "2/5/2019 4:39:00 AM", modified = "4/5/2021 3:05:25 PM",
    trigger = never(byte(0x0EA27C) == 0) && word(0x0E5C34) == 28781 && word(0x5DE45C) >= 750 && byte(0x780970) == 184
)

achievement(
    title = "Really a collection", description = "Get all 999 lums  (Triggered at Hall of Doors)", points = 25,
    id = 71526, badge = "165879", published = "2/5/2019 4:39:02 AM", modified = "4/5/2021 3:05:27 PM",
    trigger = never(byte(0x0EA27C) == 0) && word(0x0E5C34) == 28781 && word(0x5DE45C) == 999 && byte(0x780970) == 184
)

achievement(
    title = "Thanks for playing", description = "Get the 1000th lum", points = 25,
    id = 71540, badge = "165893", published = "2/5/2019 4:39:26 AM", modified = "4/5/2021 3:05:50 PM",
    trigger = word(0x0E5C34) == 29282 && areaId() == 31242 && byte(0x7A08E6) == 43
)

achievement(
    title = "You and how many more?", description = "Beat the Sanctuary of Stone and Fire without losing the Golden Fists", points = 10,
    id = 71960, badge = "165892", published = "2/14/2019 11:54:54 PM", modified = "4/5/2021 3:05:28 PM",
    trigger = prev(word(0x0E5C34)) == 30061 && word(0x0E5C34) == 31075 && byte(0x0C8CA1) == 1
)

achievement(
    title = "Thanks, navi", description = "Beat the Bonus Stage", points = 10,
    id = 71530, badge = "165883", published = "2/5/2019 4:39:09 AM", modified = "4/5/2021 3:05:32 PM",
    trigger = word(0x0E5C34) == 28277 && areaId() == 29977 && byte(0x0EF5BB) == 65
)

achievement(
    title = "Faster than daddy", description = "Beat the Bonus stage in 21s 77ms or less", points = 10,
    id = 71531, badge = "165884", published = "2/5/2019 4:39:11 AM", modified = "4/5/2021 3:05:33 PM",
    trigger = unless(word(0x0E5C34) != 28277) && unless(areaId() != 29977) && once(word(0x74CEE8) == 52136) && 
              never(word(0x176940) == 64213) && never(word(0x74E2F2) > 1085) && word(0x74CEE8) == 52424
)

achievement(
    title = "That was very fast!", description = "Beat the Walk of Life at 01 45 98ms or less", points = 25,
    id = 71532, badge = "165885", published = "2/5/2019 4:39:12 AM", modified = "4/5/2021 3:05:36 PM",
    trigger = word(0x0E5C34) == 24369 && areaId() == 30905 && byte(0x0C9470) == 2 && dword(0x5E9AC0) <= 1204748416
)

achievement(
    title = "Make a good hero", description = "Beat the Walk of Power at 01 35 23ms or less", points = 25,
    id = 71533, badge = "165886", published = "2/5/2019 4:39:14 AM", modified = "4/5/2021 3:05:37 PM",
    trigger = word(0x0E5C34) == 24370 && areaId() == 30717 && byte(0x0C9470) == 2 && dword(0x5ECF34) <= 1203372032
)

achievement(
    title = "Rayman the handyman", description = "At the Echoing Caves open the main door in 1m37s or less", points = 10,
    id = 71534, badge = "165887", published = "2/5/2019 4:39:15 AM", modified = "4/5/2021 3:05:38 PM",
    trigger = never(byte(0x22494E) == 12) && word(0x0E5C34) == 29556 && areaId() == 30920 &&
              (always_false() || (unless(byte(0x22493B) == 1) && unless(repeated(5820, word(0x0E5C34) == 29556)) && 
                word(0x21A288) == 17580))
)

achievement(
    title = "Think of the Children", description = "In Iron Mountains, save Globox's children from the Reformatory for Disturbing Children.", points = 10,
    id = 71535, badge = "165888", published = "2/5/2019 4:39:17 AM", modified = "4/21/2021 4:00:12 PM",
    trigger = word(0x0E5C34) == 25951 && areaId() == 30727 && byte(0x77AB93) == 8 && byte(0x77B44B) == 8
)

achievement(
    title = "Wasn't like my childhood", description = "At the final fight spawn the blue orb", points = 10,
    id = 71536, badge = "165889", published = "2/5/2019 4:39:19 AM", modified = "4/5/2021 3:05:42 PM",
    trigger = byte(0x22494E) != 12 && word(0x0E5C34) == 28528 && areaId() == 31153 && byte(0x5F01BF) == 1
)

achievement(
    title = "Mini shootem up", description = "Play some Menezis", points = 10,
    id = 71538, badge = "165891", published = "2/5/2019 4:39:23 AM", modified = "4/5/2021 3:05:47 PM",
    trigger = word(0x0E5C34) == 24934 && areaId() == 30767 && word(0x17691E) == 65492
)

achievement(
    title = "Thanks, dude", description = "Destroy a total of 10 cages", points = 5,
    id = 71527, badge = "165880", published = "2/5/2019 4:39:04 AM", modified = "4/5/2021 3:05:31 PM",
    trigger = prev(byte(0x224941)) == 9 && byte(0x224941) == 10
)

achievement(
    title = "Thanks, buddy", description = "Destroy a total of 40 cages", points = 10,
    id = 71528, badge = "165882", published = "2/5/2019 4:39:05 AM", modified = "4/5/2021 3:05:52 PM",
    trigger = prev(byte(0x224941)) == 39 && byte(0x224941) == 40
)

achievement(
    title = "Thanks, pal", description = "Destroy all 80 cages", points = 25,
    id = 71529, badge = "165881", published = "2/5/2019 4:39:07 AM", modified = "4/5/2021 3:05:48 PM",
    trigger = prev(byte(0x224941)) == 79 && byte(0x224941) == 80
)

achievement(
    title = "No fairy can beat me !", description = "Beat race under 01 37 00 in the walk of power", points = 15,
    id = 54232, badge = "55960", published = "11/2/2017 7:06:10 PM", modified = "11/4/2017 8:00:13 PM",
    trigger = byte(0x008000) == 0 && byte(0x5ECF37) <= 71 && byte(0x5ECF36) <= 189 && byte(0x1768B4) == 172 && 
              word(0x1FA780) == 44312
)

achievement(
    title = "Eating screws", description = "Find every lums and prisoners in the level \"The prison ship\"", points = 10,
    id = 54243, badge = "55951", published = "11/2/2017 7:07:13 PM", modified = "11/4/2017 1:47:13 PM",
    trigger = byte(0x224A2B) == 255 && byte(0x224A2C) == 255 && byte(0x224A2D) == 255 && byte(0x224A2E) == 255 && 
              byte(0x224A2F) == 255 && byte(0x224A30) == 255 && byte(0x224A31) == 255 && byte(0x224A32) == 255 && byte(0x224A33) == 255 && 
              byte(0x224A34) == 255 && byte(0x224A35) == 255 && byte(0x224A36) == 255
)

achievement(
    title = "Still the best in the arcade", description = "In a Menezis minigame score 250 points ", points = 20,
    id = 71539, badge = "76569", published = "2/5/2019 4:39:24 AM", modified = "2/5/2019 4:40:24 AM",
    trigger = word(0x0E5C34) == 24934 && areaId() == 30767 &&
              ((word(0x78863C) == 250) ||
               (word(0x787F6C) == 250) ||
               (word(0x7871CC) == 250))
)

achievement(
    title = "Ski challenge", description = "Complete the ski part without pressing the jump or turbo button", points = 25,
    id = 54211, badge = "55942", published = "11/2/2017 7:03:57 PM", modified = "11/3/2017 11:30:32 AM",
    trigger = once(byte(0x1768B4) == 236) && once(byte(0x1768B4) == 76) && once(byte(0x1768B4) == 108) && 
              never(byte(0x5D4C62) == 23) && never(byte(0x5D4C62) == 25) && byte(0x1768B4) == 236 && once(word(0x22495C) == 46312) && 
              once(word(0x22495E) == 50066) && once(word(0x224960) == 11328) && never(word(0x22495C) == 33776)
)

achievement(
    title = "Ho-Ly shit !", description = "Beat the race under a time of 01 45 00 in the walk of life", points = 15,
    id = 54214, badge = "55943", published = "11/2/2017 7:04:07 PM", modified = "11/4/2017 7:59:42 PM",
    trigger = byte(0x5E9AC2) <= 205 && byte(0x5E9AC3) <= 71 && byte(0x5E9AC2) != 0 && byte(0x1768B4) == 172 && 
              word(0x1FA780) == 44312 && word(0x22495C) == 51792
)

achievement(
    title = "Faster than daddy !", description = "Win the bonus race in the canopy", points = 3,
    id = 54221, badge = "55964", published = "11/2/2017 7:05:04 PM", modified = "11/2/2017 7:28:36 PM",
    trigger = byte(0x1768B4) == 236 && byte(0x22495C) == 57316 && byte(0x0E14BC) == 91 && byte(0x0E14BD) == 41 && 
              byte(0x0E14BE) == 12
)

achievement(
    title = "Charging !", description = "Get the second fist upgrade", points = 3,
    id = 54219, badge = "55961", published = "11/2/2017 7:04:47 PM", modified = "11/2/2017 7:23:43 PM",
    trigger = byte(0x224A10) == 109 && byte(0x224A16) == 64
)

//rich_presence_conditional_display(IsOnMainMenu(), "In the main menu...")

//rich_presence_conditional_display(SaveFileIsLoaded(), "Rayman is {0}",
//    rich_presence_lookup("Map", word(0x0E5C34), MapLookup)
//)

rich_presence_conditional_display(word(0x0E5C34) == 28781, "{0} | 🌞x{1}/999 lums| 🔒x{2}/80 cages",
    rich_presence_lookup("Map", word(0x0E5C34), MapLookup),
    rich_presence_value("lum1", word(0x5DE45C)),
    rich_presence_value("cage", byte(0x224941))
)

rich_presence_display("{0} | 🔒x{1}/80 cages",
    rich_presence_lookup("Map", word(0x0E5C34), MapLookup),
    rich_presence_value("cage", byte(0x224941))
)
