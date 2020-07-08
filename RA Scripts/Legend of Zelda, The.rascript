// Legend of Zelda, The
// #ID = 1454

function Delta(mem) => prev(mem)

// $0012: Game Mode
//        
//        0x1 = file select/title
//        0x2 = loading
//        0x5 = in overworld
//        0x8 = game over
//        0x0B = In Cave
function gameMode() => byte(0x000012)

// $0016: Current Save Slot
function currentSaveSlot() => byte(0x000016)

function IsInGame() => gameMode() > 0x2

// $062D: Current Quest for Save 1
function save1Quest() => byte(0x00062D)

// $062E: Current Quest for Save 2
function save2Quest() => byte(0x00062E)

// $062F: Current Quest for Save 3
function save3Quest() => byte(0x00062F)

// $0662: Ring: 0=None, 1=Blue, 2=Red
function ring() => byte(0x000662)

// $0667: Dungeon Compass bits?
// $0668: Dungeon Map bits?!
// $0669: compasy in inventory level 9
// $066A: map in inventory, level 9

// $066D: Rupees
function rupees() => byte(0x00066D)

// $0002: level 1's first locked door
// $0010: Dungeon Level, 00=overworld
// $0012: Game Mode
//        
//        0x1 = file select/title
//        0x2 = loading
//        0x5 = in overworld
//        0x8 = game over
//        0x0B = In Cave
// $0016: Current Save Slot
// $0038: Timer for bomb to explode
// $0070: Link's X Position
// $0084: Link's Y Position
// $00BF: Heart Container has been obtained in the current
//        dungeon.
// $00E0: Game Paused 00=No, 01=Yes
// $00E1: game menu, 00=in game, 01to07=trans in, 08=in menu, 09=trans out
// $00E7: Screen transition direction
// $00EB: Current Map Location
// $0257: ?
// $0430: Cave Shop Price - Item 1 (Left)
// $0431: Cave Shop Price - Item 2 (Middle)
// $0432: Cave Shop Price - Item 3 (Right)
// $046C: Money making game:
//        02: Win
//        01: Loss
//        00: Bigger loss
// $0486: Enemy 1 HP
// $0505: Item is being held up
// $0521: Dungeon Room _
// $0526: Overworld map to return to when exiting the
//        Underworld
// $052A: Enemy Death Counter (8-bit)
// $0609: Music
// $062D: Current Quest for Save 1
// $062E: Current Quest for Save 2
// $062F: Current Quest for Save 3
// $0630: Number of Deaths in Save 1
// $0631: Number of Deaths for Save 2
// $0632: Number of Deaths for Save 3
// $0638: 1st File - Name: 1st Character
// $063F: 1st File - Name: 8th Character
// $0640: 2nd File - Name: 1st Character
// $0647: 2nd File - Name: 8th Character
// $0648: 3rd File - Name: 1st Character
// $064F: 3rd File - Name: 8th Character
// $0656: Item being used.
// $0657: Sword ID
// $0658: bombs
// $0659: Arrow: 1=Regular, 2=Silver
// $065A: bow
// $065B: Candle: 1=Blue, 2=Red
// $065C: Flute
// $065D: Meat
// $065E: Potion: 1=Blue, 2=Red
// $065F: Magic Staff
// $0660: raft
// $0661: Magic Book
// $0662: Ring: 0=None, 1=Blue, 2=Red
// $0663: ladder
// $0664: lion key
// $0665: Bracelet
// $0666: Letter in Inventory 00=False, 01=True, can buy potions=02
// $0667: Dungeon Compass bits?
// $0668: Dungeon Map bits?!
// $0669: compasy in inventory level 9
// $066A: map in inventory, level 9
// $066C: clock active 00=false, 01=true
// $066D: Rupees
// $066E: Keys
// $066F: Hearts (upper 4) how many hearts containers a player has. Range 0-15. (lower 4) how many hearts are filled (range 0-15) see: 0x0670 for active heart and fratctions of it.
// $0670: Heart Half (bit 7) 1=whole, 0=1/2 (upper 4) fractions of the heart,  (lower 4) when the upper 4 goes below 0 this goes down one, possible tells 0x66f to go down by one. when it goes below 0 restarts at f.
// $0671: Triforce Flag
// $0674: Boomerang
// $0675: Magic Boomerang
// $0676: Shield level: 0=Small, 1=Big
// $067C: how many bombs allowed 8 bit h10=16 max
// $068D: letter: 00 if not collected 10 if collected
// $068E: Event Flags (8-bit)
// $06DA: Event Flags (8-bit)
//        
//        Bit 0 - 2 = ?
//        Bit 4 = 12-03 Moblin treasure acquired.
//        Bit 7 = 12-03 Burned down tree.
// $06EA: Event Flags (8-bit)
//        
//        Bit 0 - 2 = ?
//        Bit 4 = 12-02 Moblin treasure acquired.
//        Bit 7 = 12-02 Burned down tree.
// $0742: expoded wall in room 53 (top)
// $0751: level 1's room 52
// $0752: levle1's room (second above the entrance)
// $0762: level 1's room above the entrance
// $0771: level1's left room
// $0772: level1's first room
// $0773: level1's right room
// $1627: Enemy Death Count (without taking damage)
// $7BF2: Hit Anywhere = 24
// $7C28: Hit Anywhere = AD

achievement(
    title = "It's Dangerous to Go Alone!", description = "Obtain the sword", points = 1,
    id = 3735, badge = "62752", published = "12/5/2013 9:50:15 PM", modified = "5/9/2018 1:56:24 AM",
    trigger = byte(0x000657) == 0x01
)

achievement(
    title = "Magical Upgrade", description = "Acquire the white sword", points = 3,
    id = 3740, badge = "62753", published = "12/6/2013 4:56:07 AM", modified = "8/3/2019 3:41:11 AM",
    trigger = byte(0x000657) == 0x02
)

achievement(
    title = "Complete Upgrade", description = "Acquire the magical sword", points = 5,
    id = 3750, badge = "62754", published = "12/7/2013 4:03:18 AM", modified = "8/3/2019 3:41:14 AM",
    trigger = byte(0x000657) == 0x03
)

achievement(
    title = "Magical Protection", description = "Acquire the magical shield", points = 5,
    id = 3739, badge = "62755", published = "12/6/2013 4:45:42 AM", modified = "8/3/2019 3:41:18 AM",
    trigger = byte(0x000676) == 0x01
)

// Ticket 29433: This achievement will trigger if you have >=250 rupees and approach the ring closely but didn't make
//               the purchase.  Should be easily fixable by adding condition 0xhrupees<d0xhrupees<br>MD5:
//               d3f453931146e95b04a31647de80fdab<br>Emulator: RetroArch (QuickNES)
// Ticket 25341: I just got the blue ring in the 2nd quest. It triggered after I saved the game and returned to the
//               file select screen. (I didn't buy it in the first quest.)<br>MD5: Unknown<br>Emulator: RetroArch
//               (Nintendo - NES/Famicom (FCEUmm))
achievement(
    title = "Boy, This is Really Expensive!", description = "Equip the blue ring in the first quest", points = 5,
    id = 33231, badge = "62756", published = "2/24/2016 9:17:32 PM", modified = "10/20/2019 9:05:01 PM",
    trigger = ring() == 0x01 && Delta(ring()) == 0x0 && IsInGame() &&
              ((currentSaveSlot() == 0x00 && save1Quest() == 0x00) ||
               (currentSaveSlot() == 0x01 && save2Quest() == 0x00) ||
               (currentSaveSlot() == 0x02 && save3Quest() == 0x00))
)

achievement(
    title = "Recommendation for the Old Woman", description = "Find the letter in the first quest", points = 3,
    id = 33338, badge = "62757", published = "2/26/2016 1:59:50 PM", modified = "8/3/2019 3:41:25 AM",
    trigger = byte(0x000526) == 0xFF && byte(0x0000EB) == 0x0E && byte(0x000666) == 0x01 &&
              ((currentSaveSlot() == 0x00 && save1Quest() == 0x00) ||
               (currentSaveSlot() == 0x01 && save2Quest() == 0x00) ||
               (currentSaveSlot() == 0x02 && save3Quest() == 0x00))
)

achievement(
    title = "Stronger Than Ever", description = "Find the bracelet in either quest", points = 5,
    id = 33324, badge = "62758", published = "2/26/2016 10:01:22 AM", modified = "8/3/2019 3:41:30 AM",
    trigger = byte(0x000526) == 0xFF && byte(0x0000EB) == 0x24 && byte(0x000665) == 0x01
)

achievement(
    title = "Archer Link", description = "Obtain the bow in the first quest", points = 5,
    id = 33319, badge = "62759", published = "2/25/2016 5:33:29 PM", modified = "8/3/2019 3:41:34 AM",
    trigger = byte(0x000526) == 0x37 && byte(0x0000EB) == 0x7F && byte(0x00065A) == 0x01
)

achievement(
    title = "Boomerang Amateur", description = "Obtain the boomerang in the first quest", points = 3,
    id = 33232, badge = "62760", published = "2/24/2016 10:03:19 PM", modified = "8/3/2019 3:41:38 AM",
    trigger = byte(0x000526) == 0x37 && byte(0x0000EB) == 0x44 && byte(0x000674) == 0x01
)

achievement(
    title = "Boomerang Pro", description = "Obtain the magical boomerang in the first quest", points = 5,
    id = 33224, badge = "62761", published = "2/24/2016 6:17:38 PM", modified = "8/3/2019 3:41:46 AM",
    trigger = byte(0x000526) == 0x3C && byte(0x0000EB) == 0x4F && byte(0x000675) == 0x01 &&
              ((currentSaveSlot() == 0x00 && save1Quest() == 0x00) ||
               (currentSaveSlot() == 0x01 && save2Quest() == 0x00) ||
               (currentSaveSlot() == 0x02 && save3Quest() == 0x00))
)

achievement(
    title = "Ready to Sail", description = "Obtain the raft in the first quest", points = 5,
    id = 33234, badge = "62762", published = "2/25/2016 7:41:10 AM", modified = "8/3/2019 3:42:21 AM",
    trigger = byte(0x000526) == 0x74 && byte(0x0000EB) == 0x0F && byte(0x000660) == 0x01
)

achievement(
    title = "One Step Across the River", description = "Obtain the stepladder in the first quest", points = 5,
    id = 33235, badge = "62763", published = "2/25/2016 7:41:22 AM", modified = "11/30/2019 8:58:38 PM",
    trigger = byte(0x0000EB) == 0x60 && byte(0x000663) > prev(byte(0x000663))
)

achievement(
    title = "Musician Link", description = "Obtain the recorder in the first quest", points = 5,
    id = 33320, badge = "62764", published = "2/25/2016 6:16:04 PM", modified = "10/23/2019 10:01:02 PM",
    trigger = byte(0x000526) == 0x0B && byte(0x0000EB) == 0x04 && byte(0x00065C) == 0x01
)

achievement(
    title = "Wizard Link", description = "Obtain the magical wand in the first quest", points = 5,
    id = 33227, badge = "62765", published = "2/24/2016 8:55:08 PM", modified = "8/3/2019 3:42:32 AM",
    trigger = byte(0x000526) == 0x22 && byte(0x0000EB) == 0x75 && byte(0x00065F) == 0x01
)

achievement(
    title = "Pyromaniac Link", description = "Obtain the red candle in the first quest", points = 5,
    id = 33228, badge = "62766", published = "2/24/2016 8:55:32 PM", modified = "10/11/2019 6:35:02 PM",
    trigger = byte(0x000526) == 0x42 && byte(0x0000EB) == 0x4A && byte(0x00065B) == 0x02
)

achievement(
    title = "Magician Link", description = "Obtain the book of magic in the first quest", points = 5,
    id = 33341, badge = "62767", published = "2/27/2016 11:46:22 AM", modified = "8/3/2019 3:42:40 AM",
    trigger = byte(0x000526) == 0x6D && byte(0x0000EB) == 0x6F && byte(0x000661) == 0x01
)

achievement(
    title = "Locked Doors Master", description = "Obtain the magical key in the first quest", points = 5,
    id = 33229, badge = "62768", published = "2/24/2016 9:02:02 PM", modified = "8/3/2019 3:42:44 AM",
    trigger = byte(0x000526) == 0x6D && byte(0x0000EB) == 0x0F && byte(0x000664) == 0x01
)

achievement(
    title = "Red Hype", description = "Obtain the red ring in the first quest", points = 10,
    id = 33230, badge = "62769", published = "2/24/2016 9:07:25 PM", modified = "8/3/2019 3:42:48 AM",
    trigger = byte(0x000526) == 0x05 && byte(0x0000EB) == 0x00 && ring() == 0x02
)

achievement(
    title = "Ready to Face the Beast", description = "Obtain the silver arrows in the first quest", points = 10,
    id = 33337, badge = "62770", published = "2/26/2016 1:12:37 PM", modified = "8/3/2019 3:42:52 AM",
    trigger = byte(0x000526) == 0x05 && byte(0x0000EB) == 0x4F && byte(0x000659) == 0x02
)

achievement(
    title = "Good Sense of Direction", description = "Find your way through the lost woods", points = 2,
    id = 33325, badge = "62771", published = "2/26/2016 10:13:18 AM", modified = "8/3/2019 3:43:33 AM",
    trigger = byte(0x000526) == 0xFF && byte(0x0000EB) == 0x60 && byte(0x00052F) == 0x03
)

// Ticket 29431: Needs save protection.  Triggers upon loading a save with 100+ rupees.  Can be fixed with a
//               d0xhrupees!=0 condition<br>MD5: d3f453931146e95b04a31647de80fdab<br>Emulator: RetroArch
//               (FCEUmm/QuickNES)
// Ticket 27221: Cheevo didn't pop. Went from 50 to 150 rupees with the moblin northeast. No deaths so far.<br>MD5:
//               Unknown<br>Emulator: RANes
achievement(
    title = "Rupee Bounty", description = "Have 100 Rupees", points = 3,
    id = 3738, badge = "62772", published = "12/6/2013 4:40:23 AM", modified = "8/3/2019 3:43:37 AM",
    trigger = rupees() >= 0x64 && Delta(rupees()) < 0x64 && IsInGame()
)

// Ticket 29432: Needs save protection.  Triggers upon loading a save with 100+ rupees.  Can be fixed with a
//               d0xhrupees!=0 condition<br>MD5: d3f453931146e95b04a31647de80fdab<br>Emulator: RetroArch
//               (FCEUmm/QuickNES)
achievement(
    title = "Rupee Hoarder", description = "Have 255 Rupees", points = 5,
    id = 3745, badge = "62773", published = "12/6/2013 7:24:22 AM", modified = "5/9/2018 2:17:10 AM",
    trigger = rupees() == 0xFF && Delta(rupees()) < 0xFF && IsInGame()
)

achievement(
    title = "More Bombs", description = "Obtain your first bomb upgrade in the first quest", points = 3,
    id = 33406, badge = "62774", published = "2/29/2016 4:26:57 PM", modified = "8/3/2019 3:43:40 AM",
    trigger = byte(0x00067C) == 0x0C && gameMode() == 0x05 &&
              ((currentSaveSlot() == 0x00 && save1Quest() == 0x00) ||
               (currentSaveSlot() == 0x01 && save2Quest() == 0x00) ||
               (currentSaveSlot() == 0x02 && save3Quest() == 0x00))
)

achievement(
    title = "So Many Bombs", description = "Obtain your second bomb upgrade in the first quest", points = 5,
    id = 33413, badge = "62775", published = "2/29/2016 4:34:01 PM", modified = "8/3/2019 3:43:44 AM",
    trigger = byte(0x00067C) == 0x10 && gameMode() == 0x05 &&
              ((currentSaveSlot() == 0x00 && save1Quest() == 0x00) ||
               (currentSaveSlot() == 0x01 && save2Quest() == 0x00) ||
               (currentSaveSlot() == 0x02 && save3Quest() == 0x00))
)

achievement(
    title = "Heart Master", description = "Obtain all 16 heart containers in the first quest", points = 10,
    id = 3757, badge = "62776", published = "12/7/2013 7:09:47 AM", modified = "8/3/2019 3:43:47 AM",
    trigger = high4(0x00066F) == 0xF && gameMode() == 0x05 &&
              ((currentSaveSlot() == 0x00 && save1Quest() == 0x00) ||
               (currentSaveSlot() == 0x01 && save2Quest() == 0x00) ||
               (currentSaveSlot() == 0x02 && save3Quest() == 0x00))
)

// Ticket 28215: This triggered when I completed the Dungeon Explorer achievement.<br>MD5: Unknown<br>Emulator: RANes
achievement(
    title = "Dungeon Cartographer", description = "Find all compasses and maps in the first quest", points = 25,
    id = 22744, badge = "62777", published = "5/10/2015 7:23:27 PM", modified = "10/2/2019 4:30:02 PM",
    trigger = byte(0x000667) == 0xFF && byte(0x000668) == 0xFF && byte(0x000669) == 0x01 && byte(0x00066A) == 0x01 &&
              ((save1Quest() == 0x00) ||
               (save2Quest() == 0x00) ||
               (save3Quest() == 0x00))
)

achievement(
    title = "Eagle Novice", description = "Complete the Eagle dungeon in the first quest", points = 5,
    id = 3737, badge = "62778", published = "12/6/2013 4:11:41 AM", modified = "5/9/2018 2:21:14 AM",
    trigger = byte(0x000671) > prev(byte(0x000671)) && byte(0x000526) == 0x37 && byte(0x0000EB) == 0x36 &&
              ((currentSaveSlot() == 0x00 && save1Quest() == 0x00) ||
               (currentSaveSlot() == 0x01 && save2Quest() == 0x00) ||
               (currentSaveSlot() == 0x02 && save3Quest() == 0x00))
)

achievement(
    title = "Moon Novice", description = "Complete the Moon dungeon in the first quest", points = 5,
    id = 3742, badge = "62779", published = "12/6/2013 6:26:26 AM", modified = "5/9/2018 2:21:36 AM",
    trigger = byte(0x000671) > prev(byte(0x000671)) && byte(0x000526) == 0x3C && byte(0x0000EB) == 0x0D &&
              ((save1Quest() == 0x00 && currentSaveSlot() == 0x00) ||
               (save2Quest() == 0x00 && currentSaveSlot() == 0x01) ||
               (save3Quest() == 0x00 && currentSaveSlot() == 0x02))
)

achievement(
    title = "Manji Novice", description = "Complete the Manji dungeon in the first quest", points = 5,
    id = 3744, badge = "62780", published = "12/6/2013 6:54:44 AM", modified = "5/9/2018 2:21:56 AM",
    trigger = byte(0x000671) > prev(byte(0x000671)) && byte(0x000526) == 0x74 && byte(0x0000EB) == 0x3D &&
              ((currentSaveSlot() == 0x00 && save1Quest() == 0x00) ||
               (currentSaveSlot() == 0x01 && save2Quest() == 0x00) ||
               (currentSaveSlot() == 0x02 && save3Quest() == 0x00))
)

achievement(
    title = "Snake Novice", description = "Complete the Snake dungeon in the first quest", points = 5,
    id = 3747, badge = "62781", published = "12/6/2013 7:51:09 AM", modified = "5/9/2018 2:22:21 AM",
    trigger = byte(0x000671) > prev(byte(0x000671)) && byte(0x000526) == 0x45 && byte(0x0000EB) == 0x03 &&
              ((save1Quest() == 0x00 && currentSaveSlot() == 0x00) ||
               (save2Quest() == 0x00 && currentSaveSlot() == 0x01) ||
               (save3Quest() == 0x00 && currentSaveSlot() == 0x02))
)

achievement(
    title = "Lizard Novice", description = "Complete the Lizard dungeon in the first quest", points = 10,
    id = 3749, badge = "62782", published = "12/7/2013 3:51:29 AM", modified = "10/11/2019 6:35:02 PM",
    trigger = byte(0x000671) > prev(byte(0x000671)) && byte(0x000526) == 0x0B && byte(0x0000EB) == 0x14 &&
              ((currentSaveSlot() == 0x00 && save1Quest() == 0x00) ||
               (currentSaveSlot() == 0x01 && save2Quest() == 0x00) ||
               (currentSaveSlot() == 0x02 && save3Quest() == 0x00))
)

achievement(
    title = "Dragon Novice", description = "Complete the Dragon dungeon in the first quest", points = 10,
    id = 3752, badge = "62783", published = "12/7/2013 4:20:00 AM", modified = "10/2/2019 4:30:02 PM",
    trigger = byte(0x000671) > prev(byte(0x000671)) && byte(0x000526) == 0x22 && byte(0x0000EB) == 0x0C &&
              ((save1Quest() == 0x00 && currentSaveSlot() == 0x00) ||
               (save2Quest() == 0x00 && currentSaveSlot() == 0x01) ||
               (save3Quest() == 0x00 && currentSaveSlot() == 0x02))
)

achievement(
    title = "Demon Novice", description = "Complete the Demon dungeon in the first quest", points = 10,
    id = 3753, badge = "62784", published = "12/7/2013 5:21:22 AM", modified = "8/3/2019 3:44:36 AM",
    trigger = byte(0x000671) > prev(byte(0x000671)) && byte(0x000526) == 0x42 && byte(0x0000EB) == 0x2B &&
              ((currentSaveSlot() == 0x00 && save1Quest() == 0x00) ||
               (currentSaveSlot() == 0x01 && save2Quest() == 0x00) ||
               (currentSaveSlot() == 0x02 && save3Quest() == 0x00))
)

achievement(
    title = "Lion Novice", description = "Complete the Lion dungeon in the first quest", points = 10,
    id = 3754, badge = "62785", published = "12/7/2013 5:42:21 AM", modified = "8/3/2019 3:44:40 AM",
    trigger = byte(0x000671) > prev(byte(0x000671)) && byte(0x000526) == 0x6D && byte(0x0000EB) == 0x2C &&
              ((save1Quest() == 0x00 && currentSaveSlot() == 0x00) ||
               (save2Quest() == 0x00 && currentSaveSlot() == 0x01) ||
               (save3Quest() == 0x00 && currentSaveSlot() == 0x02))
)

achievement(
    title = "The Quest is Over", description = "Defeat Ganon in Death Mountain in the first quest", points = 25,
    id = 3758, badge = "62786", published = "12/7/2013 7:13:11 AM", modified = "10/2/2019 4:30:02 PM",
    trigger = byte(0x000526) == 0x05 && byte(0x0000EB) == 0x32 &&
              ((currentSaveSlot() == 0x00 && save1Quest() == 0x00) ||
               (currentSaveSlot() == 0x01 && save2Quest() == 0x00) ||
               (currentSaveSlot() == 0x02 && save3Quest() == 0x00))
)

achievement(
    title = "Bested Aquamentus", description = "Defeat Aquamentus without being harmed in the Eagle dungeon in the first quest", points = 10,
    id = 3736, badge = "62787", published = "12/6/2013 4:02:05 AM", modified = "11/30/2019 7:05:46 PM",
    trigger = byte(0x000010) == 0x01 && once(byte(0x0000EB) != 0x35) && byte(0x0000EB) == 0x35 && 
              never(low4(0x00066F) < prev(low4(0x00066F))) && never(byte(0x000670) < prev(byte(0x000670))) && byte(0x00052A) != prev(byte(0x00052A))
)

achievement(
    title = "Bested Dodongo", description = "Defeat Dodongo without being harmed in the Moon dungeon in the first quest", points = 10,
    id = 3741, badge = "62788", published = "12/6/2013 5:59:03 AM", modified = "11/30/2019 7:05:50 PM",
    trigger = byte(0x000010) == 0x02 && once(byte(0x0000EB) != 0x0E) && byte(0x0000EB) == 0x0E && 
              never(low4(0x00066F) < prev(low4(0x00066F))) && never(byte(0x000670) < prev(byte(0x000670))) && byte(0x00052A) != prev(byte(0x00052A))
)

achievement(
    title = "Bested Manhandla", description = "Defeat Manhandla without being harmed in the Manji dungeon in the first quest", points = 10,
    id = 3743, badge = "62789", published = "12/6/2013 6:52:14 AM", modified = "11/30/2019 7:05:54 PM",
    trigger = byte(0x000010) == 0x03 && once(byte(0x0000EB) != 0x4D) && byte(0x0000EB) == 0x4D && 
              never(low4(0x00066F) < prev(low4(0x00066F))) && never(byte(0x000670) < prev(byte(0x000670))) && byte(0x00052A) != prev(byte(0x00052A))
)

achievement(
    title = "Bested Gleeok", description = "Defeat Gleeok without being harmed in the Snake dungeon in the first quest", points = 25,
    id = 3746, badge = "62790", published = "12/6/2013 7:44:42 AM", modified = "11/30/2019 7:05:57 PM",
    trigger = byte(0x000010) == 0x04 && once(byte(0x0000EB) != 0x13) && byte(0x0000EB) == 0x13 && 
              never(low4(0x00066F) < prev(low4(0x00066F))) && never(byte(0x000670) < prev(byte(0x000670))) && byte(0x00052A) != prev(byte(0x00052A))
)

achievement(
    title = "Bested Digdogger", description = "Defeat Digdogger without being harmed in the Lizard dungeon in the first quest", points = 10,
    id = 3748, badge = "62791", published = "12/7/2013 3:45:53 AM", modified = "11/30/2019 7:06:01 PM",
    trigger = byte(0x000010) == 0x05 && once(byte(0x0000EB) != 0x24) && byte(0x0000EB) == 0x24 && 
              never(low4(0x00066F) < prev(low4(0x00066F))) && never(byte(0x000670) < prev(byte(0x000670))) && byte(0x00052A) != prev(byte(0x00052A))
)

achievement(
    title = "Bested Gohma", description = "Defeat Gohma without being harmed in the Dragon dungeon in the first quest", points = 10,
    id = 3751, badge = "62792", published = "12/7/2013 4:17:53 AM", modified = "11/30/2019 7:06:05 PM",
    trigger = byte(0x000010) == 0x06 && once(byte(0x0000EB) != 0x1C) && byte(0x0000EB) == 0x1C && 
              never(low4(0x00066F) < prev(low4(0x00066F))) && never(byte(0x000670) < prev(byte(0x000670))) && byte(0x00052A) != prev(byte(0x00052A))
)

achievement(
    title = "Bested Patra", description = "Defeat the Patra south of a wise man in Death Mountain without being harmed in the first quest", points = 25,
    id = 3755, badge = "62793", published = "12/7/2013 6:03:47 AM", modified = "11/30/2019 7:06:10 PM",
    trigger = byte(0x000010) == 0x09 && once(byte(0x0000EB) != 0x16) && byte(0x0000EB) == 0x16 && 
              never(low4(0x00066F) < prev(low4(0x00066F))) && never(byte(0x000670) < prev(byte(0x000670))) && byte(0x00052A) != prev(byte(0x00052A))
)

achievement(
    title = "Did I Unlock That Door?", description = "Unlock the first door in level 1 without using a key", points = 3,
    id = 33399, badge = "62794", published = "2/29/2016 4:08:52 PM", modified = "5/9/2018 2:27:41 AM",
    trigger = once(byte(0x000772) == 0x20) && byte(0x000772) > prev(byte(0x000772)) && byte(0x000772) == 0x28 && 
              byte(0x000084) != 0x5D
)

achievement(
    title = "Optimal Level 1 Explorer", description = "Take and visit everything in level 1 in the first quest but open only four locked doors", points = 10,
    id = 33395, badge = "62795", published = "2/29/2016 1:29:59 PM", modified = "10/23/2019 10:01:02 PM",
    trigger = bit5(0x000771) == 0x1 && bit5(0x000772) == 0x1 && bit5(0x000773) == 0x1 && bit5(0x000762) == 0x1 && 
              bit5(0x000751) == 0x1 && bit5(0x000752) == 0x1 && bit5(0x000753) == 0x1 && bit5(0x000740) == 0x1 && bit5(0x000741) == 0x1 && 
              bit5(0x000742) == 0x1 && bit5(0x000743) == 0x1 && bit5(0x000744) == 0x1 && bit5(0x000732) == 0x1 && bit5(0x000734) == 0x1 && 
              bit5(0x000735) == 0x1 && bit5(0x000721) == 0x1 && bit5(0x000722) == 0x1 && byte(0x00065A) == 0x01 && byte(0x000674) == 0x01 && 
              bit4(0x000771) == 0x1 && bit4(0x000773) == 0x1 && bit4(0x000752) == 0x1 && bit4(0x000732) == 0x1 && bit4(0x000722) == 0x1 && 
              bit4(0x000744) == 0x1 && bit4(0x000753) == 0x1 && bit4(0x000742) == 0x1 && bit3(0x000752) == 0x1 && bit3(0x000751) != 0x1 && 
              bit2(0x000741) != 0x1 && bit0(0x000742) != 0x1 && bit1(0x000743) != 0x1 && bit3(0x000753) == 0x1 && bit0(0x000671) == 0x1
)

achievement(
    title = "Swordless Level 2 ", description = "Complete level 2 without owning a sword", points = 25,
    id = 33225, badge = "62796", published = "2/24/2016 6:24:01 PM", modified = "10/23/2019 10:01:02 PM",
    trigger = byte(0x000671) > prev(byte(0x000671)) && byte(0x000526) == 0x3C && byte(0x0000EB) == 0x0D && 
              byte(0x000657) == 0x00
)

achievement(
    title = "Darknut Bombing Expert", description = "Clear the item room in level 3 only using bombs (not owning the magical sword and without leaving)", points = 25,
    id = 33340, badge = "62797", published = "2/26/2016 3:49:42 PM", modified = "10/17/2019 8:11:01 PM",
    trigger = byte(0x000526) == 0x74 && byte(0x0000EB) == 0x69 && never(byte(0x0000EB) != 0x69) && 
              once(byte(0x00034F) == 0x00) && byte(0x00034F) == 0x08 && once(byte(0x000657) != 0x03) && never(byte(0x000486) == 0x20) && 
              never(byte(0x000487) == 0x20) && never(byte(0x000488) == 0x20) && never(byte(0x000489) == 0x20) && never(byte(0x00048A) == 0x20) && 
              never(byte(0x00048B) == 0x20) && never(byte(0x00048C) == 0x20) && never(byte(0x00048D) == 0x20)
)

achievement(
    title = "Level 4 Secret Room", description = "Find the secret room in level 4", points = 2,
    id = 33396, badge = "62798", published = "2/29/2016 2:07:58 PM", modified = "5/9/2018 2:32:23 AM",
    trigger = byte(0x000526) == 0x45 && byte(0x0000EB) == 0x11
)

achievement(
    title = "Blue Darknut Expert", description = "Clear the item room in level 5 without taking damage (not owning the magical sword and without leaving)", points = 25,
    id = 33339, badge = "62799", published = "2/26/2016 3:48:10 PM", modified = "10/14/2019 7:21:02 PM",
    trigger = byte(0x0000EB) == 0x05 && never(byte(0x0000EB) != 0x05) && byte(0x000526) == 0x0B && 
              byte(0x000657) != 0x03 && once(byte(0x00034F) == 0x00) && byte(0x00034F) == 0x06 && never(low4(0x00066F) < prev(low4(0x00066F))) && 
              once(byte(0x000486) == 0x80) && once(byte(0x000487) == 0x80) && once(byte(0x000488) == 0x80) && once(byte(0x000489) == 0x80) && 
              once(byte(0x00048A) == 0x80) && once(byte(0x00048B) == 0x80)
)

achievement(
    title = "Level 7 Secret Room", description = "Find the secret room in level 7", points = 2,
    id = 33397, badge = "62800", published = "2/29/2016 2:21:17 PM", modified = "5/9/2018 2:35:22 AM",
    trigger = byte(0x000526) == 0x42 && byte(0x0000EB) == 0x08
)

achievement(
    title = "Level 8 Secret Room", description = "Find the secret room in level 8", points = 2,
    id = 33398, badge = "62801", published = "2/29/2016 3:27:54 PM", modified = "5/9/2018 2:35:42 AM",
    trigger = byte(0x000526) == 0x6D && byte(0x0000EB) == 0x2D
)

achievement(
    title = "Bounty Hunter", description = "Receive money from every hidden moblin in the first quest", points = 10,
    id = 33226, badge = "62802", published = "2/24/2016 8:35:56 PM", modified = "11/30/2019 8:49:26 PM",
    trigger = gameMode() == 0x0B && (prev(bit4(0x0006E6)) + prev(bit4(0x00068E)) + prev(bit4(0x0006EA)) +
               prev(bit4(0x0006E1)) + prev(bit4(0x0006D5)) + prev(bit4(0x0006AC)) + prev(bit4(0x0006DA)) +
               prev(bit4(0x0006BC)) + prev(bit4(0x0006CD)) + prev(bit4(0x0006A7)) + prev(bit4(0x0006C7)) +
               prev(bit4(0x000692)) + prev(bit4(0x0006F0)) + prev(bit4(0x0006D0))) == 0x13 && (bit4(0x0006E6) +
               bit4(0x00068E) + bit4(0x0006EA) + bit4(0x0006E1) + bit4(0x0006D5) + bit4(0x0006AC) + bit4(0x0006DA) +
               bit4(0x0006BC) + bit4(0x0006CD) + bit4(0x0006A7) + bit4(0x0006C7) + bit4(0x000692) + bit4(0x0006F0) +
               bit4(0x0006D0)) == 0x14
)

achievement(
    title = "It's Not Easy Being Green", description = "Beat the game without obtaining a ring in the first quest", points = 25,
    id = 33233, badge = "62803", published = "2/24/2016 10:15:25 PM", modified = "10/23/2019 10:01:02 PM",
    trigger = byte(0x000526) == 0x05 && byte(0x0000EB) == 0x32 && ring() == 0x00 && gameMode() == 0x05 && 
              gameMode() != 0x01
)

achievement(
    title = "Swordless Adventurer", description = "Get to Ganon's room in Death Mountain in the first quest without a sword", points = 50,
    id = 33775, badge = "62804", published = "3/14/2016 10:27:01 AM", modified = "10/23/2019 10:01:02 PM",
    trigger = byte(0x0000EB) == 0x42 && byte(0x000657) == 0x00 && byte(0x000010) == 0x09 && byte(0x000526) == 0x05 && 
              never(once(byte(0x000657) > 0x00)) &&
              ((save1Quest() == 0x00 && currentSaveSlot() == 0x00) ||
               (save2Quest() == 0x00 && currentSaveSlot() == 0x01) ||
               (save3Quest() == 0x00 && currentSaveSlot() == 0x02))
)

achievement(
    title = "Boy, This is Really Expensive! Too", description = "Equip the blue ring in the second quest", points = 5,
    id = 33322, badge = "62805", published = "2/26/2016 9:46:37 AM", modified = "9/23/2019 3:23:01 PM",
    trigger = ring() == 0x01 && gameMode() == 0x0B &&
              ((currentSaveSlot() == 0x00 && save1Quest() == 0x01) ||
               (currentSaveSlot() == 0x01 && save2Quest() == 0x01) ||
               (currentSaveSlot() == 0x02 && save3Quest() == 0x01))
)

achievement(
    title = "Heart Master 2", description = "Obtain all 16 heart containers in the second quest", points = 25,
    id = 33416, badge = "62806", published = "3/1/2016 12:00:57 AM", modified = "10/23/2019 10:01:02 PM",
    trigger = high4(0x00066F) == 0xF && gameMode() == 0x05 &&
              ((currentSaveSlot() == 0x00 && save1Quest() == 0x01) ||
               (currentSaveSlot() == 0x01 && save2Quest() == 0x01) ||
               (currentSaveSlot() == 0x02 && save3Quest() == 0x01))
)

achievement(
    title = "Dungeon Explorer", description = "Find all compasses and maps in the second quest", points = 25,
    id = 22743, badge = "62807", published = "5/10/2015 7:23:19 PM", modified = "10/23/2019 10:01:02 PM",
    trigger = byte(0x000667) == 0xFF && byte(0x000668) == 0xFF && byte(0x000669) == 0x01 && byte(0x00066A) == 0x01 && 
              gameMode() == 0x05 &&
              ((save1Quest() == 0x01 && currentSaveSlot() == 0x00) ||
               (save2Quest() == 0x01 && currentSaveSlot() == 0x01) ||
               (save3Quest() == 0x01 && currentSaveSlot() == 0x02))
)

achievement(
    title = "Fully Loaded and Upgraded", description = "Get all items and item upgrades in the second quest", points = 25,
    id = 33237, badge = "62808", published = "2/25/2016 1:50:32 PM", modified = "10/23/2019 10:01:02 PM",
    trigger = byte(0x000657) == 0x03 && byte(0x000659) == 0x02 && byte(0x00065A) == 0x01 && byte(0x00065B) == 0x02 && 
              byte(0x00065C) == 0x01 && byte(0x00065D) == 0x01 && byte(0x00065F) == 0x01 && byte(0x000660) == 0x01 && byte(0x000661) == 0x01 && 
              ring() == 0x02 && byte(0x000663) == 0x01 && byte(0x000664) == 0x01 && byte(0x000665) == 0x01 && byte(0x000666) >= 0x01 && 
              byte(0x000675) == 0x01 && byte(0x000676) == 0x01 && byte(0x00067C) == 0x10 && gameMode() != 0x01 && gameMode() != 0x00 &&
              ((currentSaveSlot() == 0x00 && save1Quest() == 0x01) ||
               (currentSaveSlot() == 0x01 && save2Quest() == 0x01) ||
               (currentSaveSlot() == 0x02 && save3Quest() == 0x01))
)

achievement(
    title = "Eagle Expert", description = "Complete the Eagle dungeon in the second quest", points = 10,
    id = 3760, badge = "62809", published = "12/7/2013 7:35:54 AM", modified = "10/20/2019 9:05:01 PM",
    trigger = byte(0x000671) > prev(byte(0x000671)) && byte(0x000526) == 0x37 && byte(0x0000EB) == 0x08 &&
              ((currentSaveSlot() == 0x00 && save1Quest() == 0x01) ||
               (currentSaveSlot() == 0x01 && save2Quest() == 0x01) ||
               (currentSaveSlot() == 0x02 && save3Quest() == 0x01))
)

achievement(
    title = "Moon Expert", description = "Complete the Moon dungeon in the second quest", points = 10,
    id = 3776, badge = "62810", published = "12/7/2013 8:19:57 PM", modified = "10/20/2019 9:05:01 PM",
    trigger = byte(0x000671) > prev(byte(0x000671)) && byte(0x000526) == 0x34 && byte(0x0000EB) == 0x1B &&
              ((save1Quest() == 0x01 && currentSaveSlot() == 0x00) ||
               (save2Quest() == 0x01 && currentSaveSlot() == 0x01) ||
               (save3Quest() == 0x01 && currentSaveSlot() == 0x02))
)

achievement(
    title = "Manji Expert", description = "Complete the Manji dungeon in the second quest", points = 10,
    id = 3864, badge = "62811", published = "12/9/2013 7:47:12 PM", modified = "8/3/2019 3:47:31 AM",
    trigger = byte(0x000671) > prev(byte(0x000671)) && byte(0x000526) == 0x3C && byte(0x0000EB) == 0x20 &&
              ((currentSaveSlot() == 0x00 && save1Quest() == 0x01) ||
               (currentSaveSlot() == 0x01 && save2Quest() == 0x01) ||
               (currentSaveSlot() == 0x02 && save3Quest() == 0x01))
)

achievement(
    title = "Snake Expert", description = "Complete the Snake dungeon in the second quest", points = 10,
    id = 3865, badge = "62812", published = "12/9/2013 8:48:28 PM", modified = "9/23/2019 3:23:01 PM",
    trigger = byte(0x000671) > prev(byte(0x000671)) && byte(0x000526) == 0x1B && byte(0x0000EB) == 0x4F &&
              ((save1Quest() == 0x01 && currentSaveSlot() == 0x00) ||
               (save2Quest() == 0x01 && currentSaveSlot() == 0x01) ||
               (save3Quest() == 0x01 && currentSaveSlot() == 0x02))
)

achievement(
    title = "Lizard Expert", description = "Complete the Lizard dungeon in the second quest", points = 10,
    id = 3979, badge = "62813", published = "12/12/2013 8:45:05 PM", modified = "9/23/2019 3:23:01 PM",
    trigger = byte(0x000671) > prev(byte(0x000671)) && byte(0x000526) == 0x45 && byte(0x0000EB) == 0x00 &&
              ((currentSaveSlot() == 0x00 && save1Quest() == 0x01) ||
               (currentSaveSlot() == 0x01 && save2Quest() == 0x01) ||
               (currentSaveSlot() == 0x02 && save3Quest() == 0x01))
)

achievement(
    title = "Dragon Expert", description = "Complete the Dragon dungeon in the second quest", points = 10,
    id = 3980, badge = "62814", published = "12/12/2013 9:25:39 PM", modified = "10/23/2019 10:01:02 PM",
    trigger = byte(0x000671) > prev(byte(0x000671)) && byte(0x000526) == 0x30 && byte(0x0000EB) == 0x16 &&
              ((save1Quest() == 0x01 && currentSaveSlot() == 0x00) ||
               (save2Quest() == 0x01 && currentSaveSlot() == 0x01) ||
               (save3Quest() == 0x01 && currentSaveSlot() == 0x02))
)

achievement(
    title = "Demon Expert", description = "Complete the Demon dungeon in the second quest", points = 10,
    id = 3981, badge = "62815", published = "12/12/2013 9:53:57 PM", modified = "9/23/2019 3:23:01 PM",
    trigger = byte(0x000671) > prev(byte(0x000671)) && byte(0x000526) == 0x6C && byte(0x0000EB) == 0x1B &&
              ((currentSaveSlot() == 0x00 && save1Quest() == 0x01) ||
               (currentSaveSlot() == 0x01 && save2Quest() == 0x01) ||
               (currentSaveSlot() == 0x02 && save3Quest() == 0x01))
)

achievement(
    title = "Lion Expert", description = "Complete the Lion dungeon in the second quest", points = 10,
    id = 3982, badge = "62816", published = "12/12/2013 10:19:10 PM", modified = "10/8/2019 5:52:02 PM",
    trigger = byte(0x000671) > prev(byte(0x000671)) && byte(0x000526) == 0x19 && byte(0x0000EB) == 0x2D &&
              ((save1Quest() == 0x01 && currentSaveSlot() == 0x00) ||
               (save2Quest() == 0x01 && currentSaveSlot() == 0x01) ||
               (save3Quest() == 0x01 && currentSaveSlot() == 0x02))
)

achievement(
    title = "Quest Master", description = "Defeat Ganon in Death Mountain in the second quest", points = 25,
    id = 3983, badge = "62817", published = "12/12/2013 10:41:36 PM", modified = "10/23/2019 10:01:02 PM",
    trigger = byte(0x000526) == 0x00 && byte(0x0000EB) == 0x07 &&
              ((save1Quest() == 0x01 && currentSaveSlot() == 0x00) ||
               (save2Quest() == 0x01 && currentSaveSlot() == 0x01) ||
               (save3Quest() == 0x01 && currentSaveSlot() == 0x02))
)

achievement(
    title = "Get to D Level-4 Secret", description = "Find the secret room in level 4 in the second quest", points = 3,
    id = 33774, badge = "62818", published = "3/14/2016 10:26:29 AM", modified = "8/3/2019 3:48:29 AM",
    trigger = byte(0x000526) == 0x1B && byte(0x0000EB) == 0x3E
)

achievement(
    title = "Swordless Master", description = "Get to Ganon's room in Death Mountain in the second quest without a sword", points = 50,
    id = 33776, badge = "62819", published = "3/14/2016 10:27:05 AM", modified = "10/23/2019 10:01:02 PM",
    trigger = byte(0x0000EB) == 0x17 && byte(0x000657) == 0x00 && byte(0x000010) == 0x09 && byte(0x000526) == 0x00 && 
              never(once(byte(0x000657) > 0x00)) &&
              ((save1Quest() == 0x01 && currentSaveSlot() == 0x00) ||
               (save2Quest() == 0x01 && currentSaveSlot() == 0x01) ||
               (save3Quest() == 0x01 && currentSaveSlot() == 0x02))
)

achievement(
    title = "8-Bit Master", description = "Defeat Ganon in either quest without being killed", points = 50,
    id = 3759, badge = "62820", published = "12/7/2013 7:13:16 AM", modified = "10/14/2019 7:21:02 PM",
    trigger = byte(0x0000EB) == 0x32 && byte(0x000526) == 0x05 && byte(0x000609) != 0x00 &&
              ((currentSaveSlot() == 0x00 && byte(0x000630) == 0x00) ||
               (currentSaveSlot() == 0x01 && byte(0x000631) == 0x00) ||
               (currentSaveSlot() == 0x02 && byte(0x000632) == 0x00))
)

achievement(
    title = "3 Heart Challenge", description = "Complete the 1st Quest with 3 Hearts (avoid all Heart Containers)", points = 25,
    id = 33790, badge = "34736", published = "3/17/2016 11:07:05 PM", modified = "3/17/2016 11:07:05 PM",
    trigger = byte(0x000526) == 0x05 && byte(0x0000EB) == 0x32 && byte(0x00066F) <= 0x22 && 
              never(once(byte(0x00066F) > 0x22)) &&
              ((save1Quest() == 0x00 && currentSaveSlot() == 0x00) ||
               (save2Quest() == 0x00 && currentSaveSlot() == 0x01) ||
               (save3Quest() == 0x00 && currentSaveSlot() == 0x02))
)

achievement(
    title = "Bombs Away", description = "Obtain Max 16 Bombs", points = 10,
    id = 22745, badge = "22743", published = "5/10/2015 7:25:01 PM", modified = "5/10/2015 7:25:01 PM",
    trigger = byte(0x00067C) == 0x10
)

achievement(
    title = "Keymaster", description = "Defeat Ganon in Death Mountain in the First Quest with 20 keys or more", points = 30,
    id = 22746, badge = "04313", published = "5/10/2015 7:25:41 PM", modified = "5/10/2015 7:25:41 PM",
    trigger = byte(0x000526) == 0x05 && byte(0x0000EB) == 0x32 && byte(0x00066E) >= 0x14 &&
              ((currentSaveSlot() == 0x00 && save1Quest() == 0x00) ||
               (currentSaveSlot() == 0x01 && save2Quest() == 0x00) ||
               (currentSaveSlot() == 0x02 && save3Quest() == 0x00))
)

achievement(
    title = "Rupee Addict", description = "Receive every100 Rupee gift from the Moblins in the first quest", points = 5,
    id = 33236, badge = "34020", published = "2/25/2016 7:42:48 AM", modified = "6/30/2020 10:35:50 PM",
    trigger = byte(0x00068E) == 0x10 && byte(0x0006E1) >= 0x90 && byte(0x0006EA) >= 0x90
)

achievement(
    title = "Full inventory fully upgraded", description = "Get all items, max item upgrades in the first quest", points = 5,
    id = 33238, badge = "34030", published = "2/25/2016 1:54:41 PM", modified = "3/3/2016 5:11:31 PM",
    trigger = byte(0x000657) == 0x03 && byte(0x000659) == 0x02 && byte(0x00065A) == 0x01 && byte(0x00065B) == 0x02 && 
              byte(0x00065C) == 0x01 && byte(0x00065D) == 0x01 && byte(0x00065F) == 0x01 && byte(0x000660) == 0x01 && byte(0x000661) == 0x01 && 
              ring() == 0x02 && byte(0x000663) == 0x01 && byte(0x000664) == 0x01 && byte(0x000665) == 0x01 && byte(0x000666) >= 0x01 && 
              byte(0x000675) == 0x01 && byte(0x000676) == 0x01 && byte(0x00067C) == 0x10 && gameMode() != 0x00 && gameMode() != 0x01 &&
              ((currentSaveSlot() == 0x00 && save1Quest() == 0x00) ||
               (currentSaveSlot() == 0x01 && save2Quest() == 0x00) ||
               (currentSaveSlot() == 0x02 && save3Quest() == 0x00))
)

achievement(
    title = "Boomerang Amateur 2", description = "Obtain the boomerang in the second quest", points = 2,
    id = 33321, badge = "34143", published = "2/26/2016 9:24:14 AM", modified = "3/1/2016 9:23:42 AM",
    trigger = byte(0x000526) == 0x37 && byte(0x0000EB) == 0x78 && byte(0x000674) == 0x01
)

achievement(
    title = "Recommended to the old woman 2", description = "find the letter in the second quest", points = 3,
    id = 33323, badge = "34095", published = "2/26/2016 9:53:52 AM", modified = "3/1/2016 1:32:42 PM",
    trigger = byte(0x000526) == 0xFF && byte(0x0000EB) == 0x11 && byte(0x000666) == 0x01 &&
              ((currentSaveSlot() == 0x00 && save1Quest() == 0x01) ||
               (currentSaveSlot() == 0x01 && save2Quest() == 0x01) ||
               (currentSaveSlot() == 0x02 && save3Quest() == 0x01))
)

achievement(
    title = "Musician Link 2", description = "Obtain the recorder in the second quest", points = 2,
    id = 33326, badge = "34069", published = "2/26/2016 10:19:38 AM", modified = "3/1/2016 9:24:09 AM",
    trigger = byte(0x000526) == 0x34 && byte(0x0000EB) == 0x0B && byte(0x00065C) == 0x01
)

achievement(
    title = "Boomerang Pro 2", description = "Obtain the magical boomerang in the second quest", points = 2,
    id = 33327, badge = "34140", published = "2/26/2016 10:32:57 AM", modified = "3/1/2016 8:30:58 PM",
    trigger = byte(0x000526) == 0x3C && byte(0x0000EB) == 0x15 && byte(0x000675) == 0x01 &&
              ((currentSaveSlot() == 0x00 && save1Quest() == 0x01) ||
               (currentSaveSlot() == 0x01 && save2Quest() == 0x01) ||
               (currentSaveSlot() == 0x02 && save3Quest() == 0x01))
)

achievement(
    title = "Magician Link 2", description = "Obtain the book of magic in the second quest", points = 2,
    id = 33328, badge = "34117", published = "2/26/2016 11:08:52 AM", modified = "3/1/2016 9:24:21 AM",
    trigger = byte(0x000526) == 0x1B && byte(0x0000EB) == 0x7F && byte(0x000661) == 0x01
)

achievement(
    title = "Ready to sail 2", description = "Obtain the raft in the second quest", points = 2,
    id = 33329, badge = "34094", published = "2/26/2016 11:16:53 AM", modified = "3/1/2016 9:24:26 AM",
    trigger = byte(0x000526) == 0x1B && byte(0x0000EB) == 0x6A && byte(0x000660) == 0x01
)

achievement(
    title = "One step across the river 2", description = "Obtain the stepladder in the second quest", points = 2,
    id = 33330, badge = "34112", published = "2/26/2016 11:21:11 AM", modified = "3/1/2016 9:24:33 AM",
    trigger = byte(0x000526) == 0x30 && byte(0x0000EB) == 0x46 && byte(0x000663) == 0x01
)

achievement(
    title = "Archer Link 2", description = "Obtain the bow in the second quest", points = 2,
    id = 33331, badge = "34082", published = "2/26/2016 11:35:38 AM", modified = "3/1/2016 9:24:38 AM",
    trigger = byte(0x000526) == 0x45 && byte(0x0000EB) == 0x7A && byte(0x00065A) == 0x01
)

achievement(
    title = "Wizard Link 2", description = "Obtain the magical wand in the second quest", points = 2,
    id = 33333, badge = "34036", published = "2/26/2016 12:24:10 PM", modified = "3/1/2016 9:24:48 AM",
    trigger = byte(0x000526) == 0x19 && byte(0x0000EB) == 0x2B && byte(0x00065F) == 0x01
)

achievement(
    title = "3 Heart Challenge Revisited", description = "Complete the 2nd Quest with 3 Hearts (avoid all Heart Containers)", points = 25,
    id = 33778, badge = "34724", published = "3/14/2016 10:28:27 PM", modified = "3/16/2016 7:25:53 AM",
    trigger = byte(0x000526) == 0x00 && byte(0x0000EB) == 0x07 && byte(0x00066F) <= 0x22 && 
              never(once(byte(0x00066F) > 0x22)) &&
              ((save1Quest() == 0x01 && currentSaveSlot() == 0x00) ||
               (save2Quest() == 0x01 && currentSaveSlot() == 0x01) ||
               (save3Quest() == 0x01 && currentSaveSlot() == 0x02))
)

achievement(
    title = "Heart Master 1st quest", description = "Obtain all 16 Heart Containers in the first quest", points = 10,
    id = 33417, badge = "04337", published = "3/1/2016 12:01:53 AM", modified = "3/1/2016 12:07:49 AM",
    trigger = high4(0x00066F) == 0xF && gameMode() == 0x05 &&
              ((currentSaveSlot() == 0x00 && save1Quest() == 0x00) ||
               (currentSaveSlot() == 0x01 && save2Quest() == 0x00) ||
               (currentSaveSlot() == 0x02 && save3Quest() == 0x00))
)

achievement(
    title = "16 bombs max (2nd quest)", description = "Obtain your second bomb upgrade in the second quest", points = 3,
    id = 33412, badge = "34240", published = "2/29/2016 4:33:54 PM", modified = "3/3/2016 5:07:01 PM",
    trigger = byte(0x00067C) == 0x10 && gameMode() == 0x05 &&
              ((currentSaveSlot() == 0x00 && save1Quest() == 0x01) ||
               (currentSaveSlot() == 0x01 && save2Quest() == 0x01) ||
               (currentSaveSlot() == 0x02 && save3Quest() == 0x01))
)

achievement(
    title = "12 bombs max (2nd quest)", description = "Obtain your first bomb upgrade in the second quest", points = 3,
    id = 33407, badge = "34239", published = "2/29/2016 4:28:34 PM", modified = "3/3/2016 5:04:54 PM",
    trigger = byte(0x00067C) == 0x0C && gameMode() == 0x05 &&
              ((currentSaveSlot() == 0x00 && save1Quest() == 0x01) ||
               (currentSaveSlot() == 0x01 && save2Quest() == 0x01) ||
               (currentSaveSlot() == 0x02 && save3Quest() == 0x01))
)

achievement(
    title = "Ready to face the beast 2", description = "Obtain the silver arrows in the second quest", points = 2,
    id = 33336, badge = "34097", published = "2/26/2016 12:54:34 PM", modified = "3/1/2016 9:25:05 AM",
    trigger = byte(0x000526) == 0x00 && byte(0x0000EB) == 0x76 && byte(0x000659) == 0x02
)

achievement(
    title = "Red hype 2", description = "Obtain the red ring in the second quest", points = 2,
    id = 33335, badge = "34088", published = "2/26/2016 12:54:28 PM", modified = "3/1/2016 9:24:59 AM",
    trigger = byte(0x000526) == 0x00 && byte(0x0000EB) == 0x77 && ring() == 0x02
)

achievement(
    title = "Locked doors master 2", description = "Obtain the magical key in the second quest", points = 2,
    id = 33334, badge = "34115", published = "2/26/2016 12:32:05 PM", modified = "3/1/2016 9:24:53 AM",
    trigger = byte(0x000526) == 0x19 && byte(0x0000EB) == 0x2C && byte(0x000664) == 0x01
)

achievement(
    title = "Pyromaniac Link 2", description = "Obtain the red candle in the second quest", points = 2,
    id = 33332, badge = "34083", published = "2/26/2016 12:01:00 PM", modified = "3/1/2016 9:24:43 AM",
    trigger = byte(0x000526) == 0x6C && byte(0x0000EB) == 0x70 && byte(0x00065B) == 0x02
)

achievement(
    title = "Bested Ganon", description = "Defeat Ganon without being harmed in Death Mountain in the First Quest.", points = 10,
    id = 3756, badge = "04330", published = "12/7/2013 6:55:43 AM", modified = "12/28/2013 9:49:27 PM",
    trigger = never(once(low4(0x00066F) < prev(low4(0x00066F)))) && never(once(byte(0x000670) < prev(byte(0x000670)))) && 
              once(byte(0x0000EB) == 0x52) && byte(0x000526) == 0x05 && byte(0x0000BF) < prev(byte(0x0000BF)) && 
              never(once(byte(0x0000EB) > prev(byte(0x0000EB)))) &&
              ((currentSaveSlot() == 0x00 && save1Quest() == 0x00) ||
               (currentSaveSlot() == 0x01 && save2Quest() == 0x00) ||
               (currentSaveSlot() == 0x02 && save3Quest() == 0x00))
)
