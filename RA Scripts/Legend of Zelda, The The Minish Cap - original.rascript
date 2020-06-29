// Legend of Zelda, The: The Minish Cap
// #ID = 559

// $000004: X Cam location
// $000006: Y Cam location
// $000BF4: Main Map Coordinate - 00-00=MinishWoods, 01=MinishVillage, 02=HyruleTown, 03=HyruleField, 03-00=WesternWood, MANY MORE
// $000BF5: Sub Map Coordinate
//          WAY TOO MANY TO NOTE!!
// $0010A6: Treasure Chest Game - Current Rupees - 16bit
//          0a=10 Rupees, didn't choose chest yet, Becomes 00 when you lose.
//          20 Rupees = 14, 40 Rupees = 28, etc
// $0015AC: Gyorg Pair Boss
//          09=Killed
//          01=NotFighting
// $0015E5: Gleerok Health - FF=MaxHealth, 00=DeadOrNotVisible
//          Mt Crenel Boss for the Fire Element
// $0016F5: Darknut Trio - Red(Left) - Killswitch
//          Max=14, Dead=0
// $00177D: Giant Octorok in Temple of Droplets AND DarknutTrioBlackKnight(1a)
//          Health remaining on current phase of the fight
//          01=Frozen phases, 03=Unfrozen phases, 00=Phase over
// $0017B4: Giant Octorok in Temple of Droplets
//          Phase Status of fight!
//          00=Phase1, 04=Final Phase, when 0x00177d=00, dies.
// $0017CC: Green Wizzrobes entrance barrier status
//          04=Going up, 01=Up, 03=Down
// $001805: Killswitch for Scissor Beatle 2(Right)
//          0x14=MaxHP
//          Darknut Trio - Red(Right) - Killswitch
// $00188D: Giant ChuChu Boss = 00=UnspawnedOrDead, FF=Spawned
//          Set to 00 to kill instantly
//          Used with both Green and Blue ChuChu Bosses
// $00210D: Madderpillar Killswitch - FF=Spawned and Alive, 00=OffScreen or Dead
//          Setting to 00 from FF kills.
// $00221D: Mazaal Left Hand Killswitch - unkown part, not whole hand
//          Set to 00 to kill
//          Also used for one Madderpillar during the duo madderpillar fight
// $0022A5: Mazaal Killswitch?
//          Also used for one of the Madderpillars in the fight with 2 Madderpillars
// $003FB0: Mini Mode - 08=Normal, 80=Mini
// $00AA46: Game Beaten Status - Makes part of Triforce appear on Save File
//          00=False, 01=True, Becomes 01 the moment Credits start
//          Changing this to 01 will instantly make the final 6 figurines available
// $00AA80: Complete Hyrule Map = FFFF
//          16bit
// $00AA83: Wind Crests - bit7=1=MinishWoods, bit6=1=LinksHouse, bit3=1=HyruleTown
//          bit0=1=MtCrenel, bit5=1=CastorWilds, bit1=1=VeilFalls, bit2=1=CloudTops
// $00AAC0: File Name - Letter in Slot 1
// $00AAC1: File Name - Letter in Slot 2
// $00AAC2: File Name - Letter in Slot 3
// $00AAC3: File Name - Letter in Slot 4
// $00AAC4: File Name - Letter in Slot 5
// $00AAE9: Heart Piece Count
// $00AAEA: Current Health
// $00AAEB: Heart Containers - First 3=18, 4th=20, every one from there is plus 8 (remember a,b,c,d,e,f)
//          Max = a0
//          8,10,18,20,28,30,38,40,48,50,etc
// $00AAEC: Bomb Count - 63=99 Bombs
// $00AAED: Arrow Count 8bit
//          63=99 Arrows
// $00AAEE: Bomb Bag Upgrade Count
//          00=30 Bombs, 01=50 Bombs, 02=70 Bombs, 03=99 Bombs
// $00AAF0: Figurines - Amount of unique figurines owned
//          Changing this doesn't affect which ones you own.
//          82=130, 88=136(Max with 6 hidden figurines)
// $00AAF2: Charm Effects - 2F=Nayru(IncreaseDefense), 30=Farore(IncreaseDefenseAndOffence), 31=Din(IncreaseOffense)
// $00AAF3: Picolyte Effects - 29=Red, 2A=Orange, 2B=Yellow, 2C=Green, 2D=Blue, 2E=White
// $00AAF6: Empty Bottle CONTENTS - 1
//          20=Empty, 21=Butter, 22=LonMilk, 23=LonMilk1/2, 24=RedPotion, 25=BluePotion, 26=Water
//          27=CrenelHotSpringWater, 28=Fairy, 29=RedPicolyte, 30=FaroresCharm, 31=DinsCharm
// $00AAF7: Empty Bottle CONTENTS - 2
//          20=Empty, 21=Butter, 22=LonMilk, 23=LonMilk1/2, 24=RedPotion, 25=BluePotion, 26=Water
//          27=CrenelHotSpringWater, 28=Fairy, 29=RedPicolyte, 30=FaroresCharm, 31=DinsCharm
// $00AAF8: Empty Bottle CONTENTS - 3
//          20=Empty, 21=Butter, 22=LonMilk, 23=LonMilk1/2, 24=RedPotion, 25=BluePotion, 26=Water
//          27=CrenelHotSpringWater, 28=Fairy, 29=RedPicolyte, 30=FaroresCharm, 31=DinsCharm
// $00AAF9: Empty Bottle CONTENTS - 4
//          20=Empty, 21=Butter, 22=LonMilk, 23=LonMilk1/2, 24=RedPotion, 25=BluePotion, 26=Water
//          27=CrenelHotSpringWater, 28=Fairy, 29=RedPicolyte, 30=FaroresCharm, 31=DinsCharm
// $00AB00: Rupees - 16bit
//          03e7=Max
//          (e7 03 in 8bit)
// $00AB02: Mysterious Shells - 16bit
//          03e7=Max
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
// $00AB40: Quest - bit0=1=WakeUpMushroom, bit2=1=BookHyruleanBestiary, bit4=1=BookPicori, bit6=1=BookMasks
// $00AB41: Quest - bit2=1=TingleTrophy, bit4=1=CarlovMedal
//          bit0=1=GraveyardKey(FirstTime)
//          bit1=1=GraveyardKey used to open graveyard(also true very first moment u get key, so use coord check)
// $00AB42: Quest - bit0=1=EarthElement, bit2=1=FireElement, bit4=1=WaterElement, bit6=1=WindElement
//          All Elements = 0x55
// $00AB43: Quest - bit0=1=GripRing, bit2=1=PowerBracelets, bit4=1=Flippers, bit6=1=Map
// $00AB44: Quest - Tiger Scrolls
//          All Sword Techniques 16bit - 5555=HaveAll
//          Bit0=1=Spin, bit6=1=RockBreaker, bit4=1=DashAttack, bit2=1=RollAttack
// $00AB48: Bit6=1=JabberNut
//          Setting this true (0x50) or (0x54 normally), makes picori use English without Jabber Nut
// $00AB4B: Items - Bit6=1=KinstoneBag, Bit0=1=BigWallet
// $00AB4E: Passive Permanent Upgrades (Part 1)
//          bit6=1=ChargeFast, bit4=1=SwimFast
//          bit2=1=DigFast, bit0=1=ShootArrowsFast
// $00AB57: Fused Kinstone Count
// $00AC9E: Minish Cap - Bit4=1=Have or 0x38=Have
// $00ACDF: Swordsman Newsletter Issues Part 1 - 8bit
//          bit7=1=1st Issue = 0x80
//          Only the 1st issue is on this address
// $00ACE0: Swordsman Newsletter Issues Part 2 - 8bit
//          bit0=1=2nd, bit1=1=3rd, bit2=1=4th, bit4=1=6th
//          bit6=1=8th, bit5=1=7th, bit3=1=5th - Have All=0x7F
// $00AD8C: bit6=1=PulledLever in BigBlueChuChu Boss Room
//          bit7=1=OpenedChest in Big Blue Chuchu Room
// $00AD97: Duo Madderpillar Door
//          bit6=1=Open
// $00ADAA: bit0=1=GreenWizzrobesRocsCape Chest Appeared
// $00ADC3: EndGame status? - 10=AfterBigKeyDoor
//          30=PurpleFoxHall, 70=Darknut Trio Room, 60=Vaati1, 61=Vaati1Fight, 69=Vaati2Dead, 6b,6f=GetawayStart, ef=Vaati3Dead
//          Always 00 before boss key door
// $00AECC: 16bit Bell Countdown at end game
// $03C364: bit0=1=Door Barrier Up in Big Blue Chuchu Boss Room
//          bit0=0=Door Barrier Down
//          Also spiny chuchus room: 01 when battle begins

achievement(
    title = "Bested Gyorg Pair", description = "Defeat the Gyorg Pair without taking damage", points = 25,
    id = 2257, badge = "02748", published = "8/16/2013 8:24:47 AM", modified = "10/14/2019 2:31:01 PM",
    trigger = byte(0x0015AC) == 0x09 && once(byte(0x0015AC) == 0x01) && once(byte(0x0015AC) == 0x02) && 
              once(byte(0x0015AC) == 0x03) && once(byte(0x0015AC) == 0x04) && once(byte(0x0015AC) == 0x05) && once(byte(0x0015AC) == 0x06) && 
              once(byte(0x0015AC) == 0x07) && once(byte(0x0015AC) == 0x08) && word(0x000BF4) == 0x0071 && 
              never(byte(0x00AAEA) < prev(byte(0x00AAEA))) && never(byte(0x0015AC) < prev(byte(0x0015AC)))
)

achievement(
    title = "Earth", description = "Obtain the Earth Element.", points = 5,
    id = 2034, badge = "02517", published = "8/4/2013 8:00:28 AM", modified = "11/18/2018 10:07:05 PM",
    trigger = word(0x000BF4) == 0x0049 && bit0(0x00AB42) > prev(bit0(0x00AB42))
)

// Ticket 26994: Needs save protection; will trigger when a completed save file is loaded.
//               
//               Rich Presence at time of trigger:
//               Name: Link, 20(all) Heart Containers, 136 Figurines, 100 Fusions<br>MD5:
//               a104896da0047abe8bee2a6e3f4c7290
achievement(
    title = "Fire", description = "Obtain the Fire Element", points = 5,
    id = 2036, badge = "02487", published = "8/4/2013 8:00:34 AM", modified = "8/4/2013 8:10:47 AM",
    trigger = bit2(0x00AB42) == 0x1
)

// Ticket 26993: Needs save protection; will trigger when a completed save file is loaded.
//               
//               Rich Presence at time of trigger:
//               Name: Link, 20(all) Heart Containers, 136 Figurines, 100 Fusions<br>MD5:
//               a104896da0047abe8bee2a6e3f4c7290
achievement(
    title = "Water", description = "Obtain the Water Element", points = 5,
    id = 2035, badge = "02486", published = "8/4/2013 8:00:31 AM", modified = "8/4/2013 8:10:41 AM",
    trigger = bit4(0x00AB42) == 0x1
)

// Ticket 26995: Needs save protection; will trigger when a completed save file is loaded.
//               
//               Rich Presence at time of trigger:
//               Name: Link, 20(all) Heart Containers, 136 Figurines, 100 Fusions<br>MD5:
//               a104896da0047abe8bee2a6e3f4c7290
achievement(
    title = "Wind", description = "Obtain the Wind Element", points = 5,
    id = 2037, badge = "02488", published = "8/4/2013 8:00:38 AM", modified = "8/4/2013 8:10:52 AM",
    trigger = bit6(0x00AB42) == 0x1
)

achievement(
    title = "Gust Jar", description = "Obtain the Gust Jar.", points = 5,
    id = 2033, badge = "02485", published = "8/4/2013 8:00:23 AM", modified = "11/18/2018 9:36:01 PM",
    trigger = word(0x000BF4) == 0x0048 && bit2(0x00AB36) > prev(bit2(0x00AB36))
)

achievement(
    title = "Grip Ring", description = "Obtain the Grip Ring.", points = 5,
    id = 2038, badge = "02489", published = "8/4/2013 8:00:45 AM", modified = "11/18/2018 11:01:24 PM",
    trigger = word(0x000BF4) == 0x0426 && bit0(0x00AB43) > prev(bit0(0x00AB43))
)

// Ticket 26996: Needs save protection; will trigger when a completed save file is loaded.
//               
//               Rich Presence at time of trigger:
//               Name: Link, 20(all) Heart Containers, 136 Figurines, 100 Fusions<br>MD5:
//               a104896da0047abe8bee2a6e3f4c7290
achievement(
    title = "Power Bracelets", description = "Obtain the Power Bracelets", points = 5,
    id = 2039, badge = "02490", published = "8/4/2013 8:00:49 AM", modified = "8/4/2013 8:11:06 AM",
    trigger = bit2(0x00AB43) == 0x1
)

// Ticket 26997: Needs save protection; will trigger when a completed save file is loaded.
//               
//               Rich Presence at time of trigger:
//               Name: Link, 20(all) Heart Containers, 136 Figurines, 100 Fusions<br>MD5:
//               a104896da0047abe8bee2a6e3f4c7290
achievement(
    title = "Going For A Swim", description = "Obtain Flippers", points = 5,
    id = 2040, badge = "02491", published = "8/4/2013 8:00:51 AM", modified = "10/17/2019 3:22:01 PM",
    trigger = bit4(0x00AB43) == 0x1
)

achievement(
    title = "But I Can Walk Just Fine!", description = "Obtain the Cane of Pacci.", points = 5,
    id = 2041, badge = "02492", published = "8/4/2013 8:00:54 AM", modified = "11/18/2018 11:20:06 PM",
    trigger = word(0x000BF4) == 0x0150 && bit4(0x00AB36) > prev(bit4(0x00AB36))
)

// Ticket 26998: Needs save protection; will trigger when a completed save file is loaded.
//               
//               Rich Presence at time of trigger:
//               Name: Link, 20(all) Heart Containers, 136 Figurines, 100 Fusions<br>MD5:
//               a104896da0047abe8bee2a6e3f4c7290
achievement(
    title = "Light It Up", description = "Obtain the Lantern", points = 5,
    id = 2042, badge = "02493", published = "8/4/2013 8:00:57 AM", modified = "8/4/2013 8:11:22 AM",
    trigger = bit6(0x00AB35) == 0x1
)

// Ticket 26999: Needs save protection; will trigger when a completed save file is loaded.
//               
//               Rich Presence at time of trigger:
//               Name: Link, 20(all) Heart Containers, 136 Figurines, 100 Fusions<br>MD5:
//               a104896da0047abe8bee2a6e3f4c7290
achievement(
    title = "Graveyard", description = "Obtain the Graveyard Key and use it", points = 5,
    id = 2043, badge = "02494", published = "8/4/2013 8:01:00 AM", modified = "8/4/2019 9:04:58 PM",
    trigger = bit1(0x00AB41) == 0x1 && word(0x000BF4) != 0x1222
)

achievement(
    title = "A New Quest", description = "Obtain the Broken Picori Blade.", points = 5,
    id = 2031, badge = "02484", published = "8/3/2013 6:22:56 PM", modified = "8/4/2019 9:04:55 PM",
    trigger = word(0x000BF4) == 0x0280 && bit2(0x00AB3F) > prev(bit2(0x00AB3F))
)

// Ticket 27000: Needs save protection; will trigger when a completed save file is loaded.
//               
//               Rich Presence at time of trigger:
//               Name: Link, 20(all) Heart Containers, 136 Figurines, 100 Fusions<br>MD5:
//               a104896da0047abe8bee2a6e3f4c7290
achievement(
    title = "White Sword", description = "Obtain the White Sword", points = 5,
    id = 2044, badge = "02495", published = "8/4/2013 8:01:02 AM", modified = "8/4/2013 8:11:27 AM",
    trigger = bit4(0x00AB32) == 0x1
)

// Ticket 27001: Needs save protection; will trigger when a completed save file is loaded.
//               
//               Rich Presence at time of trigger:
//               Name: Link, 20(all) Heart Containers, 136 Figurines, 100 Fusions<br>MD5:
//               a104896da0047abe8bee2a6e3f4c7290
achievement(
    title = "White Sword 2", description = "Infuse your sword with Earth and Fire elements", points = 10,
    id = 2045, badge = "02496", published = "8/4/2013 8:01:05 AM", modified = "8/4/2019 9:04:45 PM",
    trigger = bit6(0x00AB32) == 0x1
)

// Ticket 27002: Needs save protection; will trigger when a completed save file is loaded.
//               
//               Rich Presence at time of trigger:
//               Name: Link, 20(all) Heart Containers, 136 Figurines, 100 Fusions<br>MD5:
//               a104896da0047abe8bee2a6e3f4c7290
achievement(
    title = "White Sword 3", description = "Infuse your sword with the third element - Water", points = 10,
    id = 2046, badge = "02497", published = "8/4/2013 8:01:29 AM", modified = "9/26/2019 10:32:01 AM",
    trigger = bit0(0x00AB33) == 0x1
)

// Ticket 27003: Needs save protection; will trigger when a completed save file is loaded.
//               
//               Rich Presence at time of trigger:
//               Name: Link, 20(all) Heart Containers, 136 Figurines, 100 Fusions<br>MD5:
//               a104896da0047abe8bee2a6e3f4c7290
achievement(
    title = "Four Sword", description = "Infuse your sword with the fourth element - Wind", points = 10,
    id = 2047, badge = "02498", published = "8/4/2013 8:01:40 AM", modified = "8/4/2019 9:04:50 PM",
    trigger = bit4(0x00AB33) == 0x1
)

achievement(
    title = "Wake Up", description = "Obtain the Wake-Up Mushroom", points = 5,
    id = 2048, badge = "02499", published = "8/4/2013 8:01:43 AM", modified = "8/4/2019 9:04:52 PM",
    trigger = bit0(0x00AB40) == 0x1
)

// Ticket 27004: Needs save protection; will trigger when a completed save file is loaded.
//               
//               Rich Presence at time of trigger:
//               Name: Link, 20(all) Heart Containers, 136 Figurines, 100 Fusions<br>MD5:
//               a104896da0047abe8bee2a6e3f4c7290
achievement(
    title = "Shiny!", description = "Obtain the Mirror Shield", points = 5,
    id = 2049, badge = "02500", published = "8/4/2013 8:01:46 AM", modified = "8/4/2013 8:11:43 AM",
    trigger = bit4(0x00AB35) == 0x1
)

// Ticket 27008: Needs save protection; will trigger when a completed save file is loaded.
//               
//               Rich Presence at time of trigger:
//               Name: Link, 20(all) Heart Containers, 136 Figurines, 100 Fusions<br>MD5:
//               a104896da0047abe8bee2a6e3f4c7290
achievement(
    title = "Bow Down", description = "Obtain a Bow", points = 5,
    id = 2057, badge = "02509", published = "8/4/2013 8:02:34 AM", modified = "8/4/2013 8:12:06 AM",
    trigger = bit2(0x00AB34) == 0x1
)

// Ticket 27009: Needs save protection; will trigger when a completed save file is loaded.
//               
//               Rich Presence at time of trigger:
//               Name: Link, 20(all) Heart Containers, 136 Figurines, 100 Fusions<br>MD5:
//               a104896da0047abe8bee2a6e3f4c7290
achievement(
    title = "It Doesn't Feel Lighter", description = "Obtain Light Arrows", points = 10,
    id = 2059, badge = "02511", published = "8/4/2013 8:02:40 AM", modified = "8/4/2019 9:04:41 PM",
    trigger = bit4(0x00AB34) == 0x1
)

achievement(
    title = "Where's The Boom?", description = "Obtain a Boomerang", points = 5,
    id = 2058, badge = "02510", published = "8/4/2013 8:02:37 AM", modified = "8/4/2013 8:12:10 AM",
    trigger = bit6(0x00AB34) == 0x1
)

// Ticket 27005: Needs save protection; will trigger when a completed save file is loaded.
//               
//               Rich Presence at time of trigger:
//               Name: Link, 20(all) Heart Containers, 136 Figurines, 100 Fusions<br>MD5:
//               a104896da0047abe8bee2a6e3f4c7290
achievement(
    title = "Magic Trick", description = "Obtain the Magical Boomerang", points = 10,
    id = 2050, badge = "02501", published = "8/4/2013 8:01:48 AM", modified = "8/4/2019 9:04:28 PM",
    trigger = bit0(0x00AB35) == 0x1
)

achievement(
    title = "Hyrulean Bestiary", description = "Obtain the Library Book - A Hyrulean Bestiary", points = 5,
    id = 2051, badge = "02502", published = "8/4/2013 8:02:07 AM", modified = "8/4/2019 9:04:30 PM",
    trigger = bit2(0x00AB40) == 0x1
)

achievement(
    title = "Legend of the Picori", description = "Obtain the Library Book - Legend of the Picori", points = 5,
    id = 2052, badge = "02503", published = "8/4/2013 8:02:14 AM", modified = "8/4/2019 9:04:32 PM",
    trigger = bit4(0x00AB40) == 0x1
)

achievement(
    title = "History of Masks", description = "Obtain the Library Book - A History of Masks", points = 5,
    id = 2053, badge = "02504", published = "8/4/2013 8:02:22 AM", modified = "8/4/2019 9:04:36 PM",
    trigger = bit6(0x00AB40) == 0x1
)

achievement(
    title = "Don't Hurt Yourself", description = "Obtain a Bomb Bag.", points = 5,
    id = 2056, badge = "02508", published = "8/4/2013 8:02:32 AM", modified = "8/4/2019 9:04:38 PM",
    trigger = word(0x000BF4) == 0x2620 && bit6(0x00AB33) > prev(bit6(0x00AB33))
)

// Ticket 27007: Needs save protection; will trigger when a completed save file is loaded.
//               
//               Rich Presence at time of trigger:
//               Name: Link, 20(all) Heart Containers, 136 Figurines, 100 Fusions<br>MD5:
//               a104896da0047abe8bee2a6e3f4c7290
achievement(
    title = "Set Up Us The Bomb", description = "Obtain a Remote Bomb", points = 5,
    id = 2055, badge = "02507", published = "8/4/2013 8:02:30 AM", modified = "8/4/2013 8:11:59 AM",
    trigger = bit0(0x00AB34) == 0x1
)

// Ticket 27006: Needs save protection; will trigger when a completed save file is loaded.
//               
//               Rich Presence at time of trigger:
//               Name: Link, 20(all) Heart Containers, 136 Figurines, 100 Fusions<br>MD5:
//               a104896da0047abe8bee2a6e3f4c7290
achievement(
    title = "Dig Dug", description = "Obtain Mole Mitts", points = 5,
    id = 2054, badge = "02505", published = "8/4/2013 8:02:26 AM", modified = "8/4/2013 8:11:55 AM",
    trigger = bit6(0x00AB36) == 0x1
)

// Ticket 27010: Needs save protection; will trigger when a completed save file is loaded.
//               
//               Rich Presence at time of trigger:
//               Name: Link, 20(all) Heart Containers, 136 Figurines, 100 Fusions<br>MD5:
//               a104896da0047abe8bee2a6e3f4c7290
achievement(
    title = "I Can Fly!", description = "Obtain Roc's Cape", points = 5,
    id = 2060, badge = "02512", published = "8/4/2013 8:02:43 AM", modified = "8/4/2013 8:12:17 AM",
    trigger = bit0(0x00AB37) == 0x1
)

// Ticket 27011: Needs save protection; will trigger when a completed save file is loaded.
//               
//               Rich Presence at time of trigger:
//               Name: Link, 20(all) Heart Containers, 136 Figurines, 100 Fusions<br>MD5:
//               a104896da0047abe8bee2a6e3f4c7290
achievement(
    title = "Pegasus Boots", description = "Obtain Pegasus Boots", points = 5,
    id = 2061, badge = "02513", published = "8/4/2013 8:02:46 AM", modified = "8/4/2013 8:12:22 AM",
    trigger = bit2(0x00AB37) == 0x1
)

// Ticket 27012: Needs save protection; will trigger when a completed save file is loaded.
//               
//               Rich Presence at time of trigger:
//               Name: Link, 20(all) Heart Containers, 136 Figurines, 100 Fusions<br>MD5:
//               a104896da0047abe8bee2a6e3f4c7290
achievement(
    title = "Ocarina of Wind", description = "Obtain the Ocarina of Wind", points = 5,
    id = 2062, badge = "02514", published = "8/4/2013 8:02:49 AM", modified = "8/4/2013 8:12:25 AM",
    trigger = bit6(0x00AB37) == 0x1
)

achievement(
    title = "Jibber-Jabber", description = "Obtain the Jabber Nut.", points = 5,
    id = 2065, badge = "02518", published = "8/4/2013 6:20:26 PM", modified = "11/18/2018 9:24:26 PM",
    trigger = word(0x000BF4) == 0x0920 && bit6(0x00AB48) > prev(bit6(0x00AB48))
)

// Ticket 27013: Needs save protection; will trigger when a completed save file is loaded.
//               
//               Rich Presence at time of trigger:
//               Name: Link, 20(all) Heart Containers, 136 Figurines, 100 Fusions<br>MD5:
//               a104896da0047abe8bee2a6e3f4c7290
achievement(
    title = "Lon Lon Ranch", description = "Find and return the Lon Lon Ranch Key", points = 3,
    id = 2089, badge = "02564", published = "8/7/2013 9:49:34 PM", modified = "8/4/2019 9:04:16 PM",
    trigger = bit7(0x00AB3F) == 0x1
)

achievement(
    title = "Red Picolyte", description = "Use a Red Picolyte to find a heart and refill your health", points = 1,
    id = 2169, badge = "02653", published = "8/12/2013 10:21:31 AM", modified = "8/4/2019 9:04:08 PM",
    trigger = byte(0x00AAF3) == 0x29 && byte(0x00AAEA) > prev(byte(0x00AAEA)) && byte(0x00AAE9) == prev(byte(0x00AAE9)) && 
              byte(0x00AAEB) == prev(byte(0x00AAEB)) && never(byte(0x00AAEB) != prev(byte(0x00AAEB))) && never(byte(0x00AAE9) != prev(byte(0x00AAE9)))
)

achievement(
    title = "Orange Picolyte", description = "Use an Orange Picolyte to find and bottle a fairy in your bottle", points = 1,
    id = 2170, badge = "02656", published = "8/12/2013 10:21:34 AM", modified = "3/30/2020 2:31:13 PM",
    trigger = byte(0x00AAF3) == 0x2A &&
              ((prev(byte(0x00AAF6)) == 0x20 && byte(0x00AAF6) == 0x28) ||
               (prev(byte(0x00AAF7)) == 0x20 && byte(0x00AAF7) == 0x28) ||
               (prev(byte(0x00AAF8)) == 0x20 && byte(0x00AAF8) == 0x28) ||
               (prev(byte(0x00AAF9)) == 0x20 && byte(0x00AAF9) == 0x28))
)

achievement(
    title = "Yellow Picolyte", description = "Use a Yellow Picolyte to find Rupees", points = 1,
    id = 2171, badge = "02654", published = "8/12/2013 10:21:40 AM", modified = "8/4/2019 9:04:12 PM",
    trigger = byte(0x00AAF3) == 0x2B && word(0x00AB00) > prev(word(0x00AB00))
)

achievement(
    title = "Green Picolyte", description = "Use a Green Picolyte to find a Mysterious Shell", points = 1,
    id = 2172, badge = "02651", published = "8/12/2013 10:21:44 AM", modified = "8/4/2019 9:04:14 PM",
    trigger = byte(0x00AAF3) == 0x2C && word(0x00AB02) > prev(word(0x00AB02))
)

achievement(
    title = "Blue Picolyte", description = "Use a Blue Picolyte to find Bombs or Arrows", points = 1,
    id = 2173, badge = "02655", published = "8/12/2013 10:21:47 AM", modified = "3/30/2020 2:30:55 PM",
    trigger = byte(0x00AAF3) == 0x2D && word(0x00AAEE) == prev(word(0x00AAEE)) && 
              never(word(0x00AAEE) != prev(word(0x00AAEE))) &&
              ((word(0x00AAEC) > prev(word(0x00AAEC))) ||
               (word(0x00AAED) > prev(word(0x00AAED))))
)

achievement(
    title = "White Picolyte", description = "Use a White Picolyte for an increased chance of finding Kinstones", points = 1,
    id = 2174, badge = "02652", published = "8/12/2013 10:21:51 AM", modified = "8/4/2019 9:04:20 PM",
    trigger = byte(0x00AAF3) == 0x2E
)

achievement(
    title = "Din's Charm", description = "Use Din's Charm for increased attack power", points = 5,
    id = 2175, badge = "02674", published = "8/12/2013 10:22:03 AM", modified = "10/17/2019 3:22:01 PM",
    trigger = repeated(200, byte(0x00AAF2) == 0x31)
)

achievement(
    title = "Farore's Charm", description = "Use Farore's Charm for increased attack and defense power", points = 5,
    id = 2176, badge = "02675", published = "8/12/2013 10:22:06 AM", modified = "8/13/2013 3:59:24 PM",
    trigger = repeated(200, byte(0x00AAF2) == 0x30)
)

achievement(
    title = "Nayru's Charm", description = "Use Nayru's Charm for increased defense power", points = 5,
    id = 2177, badge = "02676", published = "8/12/2013 10:22:09 AM", modified = "8/13/2013 3:59:27 PM",
    trigger = repeated(200, byte(0x00AAF2) == 0x2F)
)

// Ticket 27014: Needs save protection; will trigger when a completed save file is loaded.
//               
//               Rich Presence at time of trigger:
//               Name: Link, 20(all) Heart Containers, 136 Figurines, 100 Fusions<br>MD5:
//               a104896da0047abe8bee2a6e3f4c7290
achievement(
    title = "Swordsman Newsletter", description = "Subscribe to Swordsman Newsletter and collect all issues", points = 10,
    id = 2178, badge = "02660", published = "8/12/2013 11:43:19 AM", modified = "8/4/2019 9:04:22 PM",
    trigger = bit7(0x00ACDF) == 0x1 && low4(0x00ACE0) == 0xF && bit4(0x00ACE0) == 0x1 && bit5(0x00ACE0) == 0x1 && 
              bit6(0x00ACE0) == 0x1
)

// Ticket 27023: Needs save protection. Will trigger upon loading up and starting a completed save file.
//               
//               Rich Presence at time of trigger:
//               Name: Link, 20(all) Heart Containers, 136 Figurines, 100 Fusions<br>MD5:
//               a104896da0047abe8bee2a6e3f4c7290
achievement(
    title = "Miracle Maker", description = "Fuse at least 50 Kinstones", points = 10,
    id = 2347, badge = "02843", published = "8/20/2013 5:26:51 AM", modified = "8/4/2019 9:03:45 PM",
    trigger = byte(0x00AB57) >= 0x32 && word(0x000BF4) != 0x0000
)

// Ticket 27022: Needs save protection; will trigger when a completed save file is loaded.
//               
//               Rich Presence at time of trigger:
//               Name: Link, 20(all) Heart Containers, 136 Figurines, 100 Fusions<br>MD5:
//               a104896da0047abe8bee2a6e3f4c7290
achievement(
    title = "Tingle Trophy", description = "Complete all Kinstone Fusions", points = 25,
    id = 2349, badge = "02506", published = "8/20/2013 5:40:45 AM", modified = "3/30/2020 2:40:29 PM",
    trigger = bit2(0x00AB41) == 0x1 && prev(bit2(0x00AB41)) == 0x0 && byte(0x00AB57) >= 0x63
)

// Ticket 27017: Needs save protection; will trigger when a completed save file is loaded.
//               
//               Rich Presence at time of trigger:
//               Name: Link, 20(all) Heart Containers, 136 Figurines, 100 Fusions<br>MD5:
//               a104896da0047abe8bee2a6e3f4c7290
achievement(
    title = "Dexterous", description = "Learn all 6 abilities speeding up various actions", points = 10,
    id = 2248, badge = "02740", published = "8/15/2013 10:06:34 PM", modified = "4/15/2015 12:42:09 PM",
    trigger = word(0x00AB4E) == 0x0555
)

achievement(
    title = "Rupee Accumulator", description = "Accumulate 100 Rupees", points = 1,
    id = 1473, badge = "02662", published = "5/31/2013 3:39:00 AM", modified = "8/12/2013 1:14:18 PM",
    trigger = word(0x00AB00) >= 0x0064
)

// Ticket 27018: Needs save protection; will trigger when a completed save file is loaded.
//               
//               Rich Presence at time of trigger:
//               Name: Link, 20(all) Heart Containers, 136 Figurines, 100 Fusions<br>MD5:
//               a104896da0047abe8bee2a6e3f4c7290
achievement(
    title = "Navigator", description = "Complete the Hyrule Map and activate all Wind Crests", points = 10,
    id = 2249, badge = "02741", published = "8/15/2013 11:25:04 PM", modified = "8/4/2019 9:03:42 PM",
    trigger = word(0x00AA80) == 0xFFFF && byte(0x00AA83) == 0xFF && byte(0x00AA82) == 0x01
)

// Ticket 26991: Needs save protection; will trigger when a completed save file is loaded.
//               
//               Rich Presence at time of trigger:
//               Name: Link, 20(all) Heart Containers, 136 Figurines, 100 Fusions<br>MD5:
//               a104896da0047abe8bee2a6e3f4c7290
achievement(
    title = "Rupee Gatherer", description = "Gather 300 Rupees", points = 5,
    id = 1474, badge = "02661", published = "5/31/2013 4:40:39 AM", modified = "8/4/2019 9:03:49 PM",
    trigger = word(0x00AB00) >= 0x012C
)

// Ticket 27019: Needs save protection; will trigger when a completed save file is loaded.
//               
//               Rich Presence at time of trigger:
//               Name: Link, 20(all) Heart Containers, 136 Figurines, 100 Fusions<br>MD5:
//               a104896da0047abe8bee2a6e3f4c7290
achievement(
    title = "Crouching Tiger", description = "Obtain all Tiger Scrolls", points = 10,
    id = 2258, badge = "02749", published = "8/16/2013 9:23:34 AM", modified = "8/4/2019 9:03:53 PM",
    trigger = word(0x00AB44) == 0x5555
)

// Ticket 27015: Needs save protection; will trigger when a completed save file is loaded.
//               
//               Rich Presence at time of trigger:
//               Name: Link, 20(all) Heart Containers, 136 Figurines, 100 Fusions<br>MD5:
//               a104896da0047abe8bee2a6e3f4c7290
achievement(
    title = "Rupee Collector", description = "Collect 500 Rupees", points = 5,
    id = 2179, badge = "02663", published = "8/12/2013 1:13:56 PM", modified = "8/4/2019 9:03:51 PM",
    trigger = word(0x00AB00) >= 0x01F4
)

// Ticket 27016: Needs save protection; will trigger when a completed save file is loaded.
//               
//               Rich Presence at time of trigger:
//               Name: Link, 20(all) Heart Containers, 136 Figurines, 100 Fusions<br>MD5:
//               a104896da0047abe8bee2a6e3f4c7290
achievement(
    title = "Rupee Hoarder", description = "Hoard 999 Rupees", points = 10,
    id = 2180, badge = "02664", published = "8/12/2013 1:13:59 PM", modified = "8/4/2019 9:03:55 PM",
    trigger = word(0x00AB00) >= 0x03E7
)

achievement(
    title = "Packing Heat", description = "Fully upgrade your Quiver and Bomb Bag", points = 10,
    id = 2259, badge = "02750", published = "8/16/2013 10:43:54 AM", modified = "8/4/2019 9:03:58 PM",
    trigger = word(0x00AAEE) == 0x0303
)

achievement(
    title = "Putting The Pieces Together", description = "Assemble 4 Pieces of Heart.", points = 5,
    id = 1475, badge = "02519", published = "5/31/2013 4:40:43 AM", modified = "11/18/2018 10:58:22 PM",
    trigger = byte(0x00AAE9) < prev(byte(0x00AAE9)) && byte(0x00AAEB) > prev(byte(0x00AAEB))
)

// Ticket 27020: Needs save protection; will trigger when a completed save file is loaded.
//               
//               Rich Presence at time of trigger:
//               Name: Link, 20(all) Heart Containers, 136 Figurines, 100 Fusions<br>MD5:
//               a104896da0047abe8bee2a6e3f4c7290
achievement(
    title = "Resourceful", description = "Obtain all four Bottles", points = 25,
    id = 2260, badge = "02751", published = "8/16/2013 11:22:22 AM", modified = "10/23/2019 5:12:02 PM",
    trigger = byte(0x00AB39) == 0x55
)

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
)

// Ticket 26992: Needs save protection; will trigger when a completed save file is loaded.
//               
//               Rich Presence at time of trigger:
//               Name: Link, 20(all) Heart Containers, 136 Figurines, 100 Fusions<br>MD5:
//               a104896da0047abe8bee2a6e3f4c7290
achievement(
    title = "Stayin' Alive", description = "Have 20 Heart Containers", points = 25,
    id = 1496, badge = "01735", published = "5/31/2013 5:40:11 PM", modified = "9/29/2019 11:02:03 AM",
    trigger = byte(0x00AAEB) == 0xA0
)

achievement(
    title = "Courage", description = "Restore peace to Hyrule with only 3 Heart Containers", points = 50,
    id = 2311, badge = "02810", published = "8/19/2013 10:10:52 PM", modified = "10/23/2019 5:12:02 PM",
    trigger = word(0x000BF4) == 0x0081 && byte(0x00AA46) == 0x01 && byte(0x00AAEB) == 0x18
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
    title = "Hero of Hyrule", description = "Restore peace to Hyrule", points = 25,
    id = 2312, badge = "02807", published = "8/19/2013 10:11:40 PM", modified = "10/17/2019 3:22:01 PM",
    trigger = word(0x000BF4) == 0x0081 && byte(0x00AA46) == 0x01
)

achievement(
    title = "Bested Gleerok", description = "Defeat Gleerok without taking damage", points = 25,
    id = 2086, badge = "02561", published = "8/7/2013 9:26:09 AM", modified = "8/4/2019 9:03:28 PM",
    trigger = never(byte(0x00AAEA) < prev(byte(0x00AAEA))) && once(byte(0x0015E5) == 0xFF) && byte(0x0015E5) == 0x00 && 
              never(byte(0x000BF5) == 0x17) && once(byte(0x000BF5) == 0x12) && once(byte(0x000BF4) == 0x50) && byte(0x000BF4) == 0x51 && 
              byte(0x000BF5) == 0x00 && once(bit2(0x00AB42) > prev(bit2(0x00AB42))) && never(bit2(0x00AB42) < prev(bit2(0x00AB42))) && 
              never(byte(0x000BF4) == 0x06)
)

achievement(
    title = "Gambler", description = "Win 270 Rupees or more at the Chest Mini-Game Shop", points = 25,
    id = 2344, badge = "02841", published = "8/20/2013 4:22:53 AM", modified = "10/20/2019 4:15:02 PM",
    trigger = word(0x0010A6) >= 0x010E && word(0x000BF4) == 0x0623
)

achievement(
    title = "Bested Mazaal", description = "Defeat Mazaal without taking damage", points = 25,
    id = 2188, badge = "02671", published = "8/12/2013 7:16:01 PM", modified = "8/4/2019 9:03:35 PM",
    trigger = once(word(0x000BF4) == 0x0158) && once(word(0x000BF4) == 0x015A) && once(word(0x000BF4) == 0x005A) && 
              word(0x000BF4) == 0x0059 && once(word(0x000BF4) == 0x1658) && never(word(0x000BF4) == 0x0458) && 
              never(byte(0x00AAEA) < prev(byte(0x00AAEA))) && once(bit6(0x00AB37) > prev(bit6(0x00AB37))) && never(bit6(0x00AB37) < prev(bit6(0x00AB37)))
)

achievement(
    title = "Bested Big Blue Chuchu", description = "Defeat the Big Blue Chuchu without taking damage", points = 25,
    id = 2198, badge = "02718", published = "8/14/2013 8:36:42 PM", modified = "10/14/2019 2:31:01 PM",
    trigger = bit6(0x00AD8C) == 0x1 && once(bit6(0x00AD8C) > prev(bit6(0x00AD8C))) && 
              never(bit6(0x00AD8C) < prev(bit6(0x00AD8C))) && word(0x000BF4) == 0x1060 && once(byte(0x00188D) == 0xFF) && byte(0x00188D) == 0x00 && 
              bit0(0x03C364) == 0x0 && once(bit0(0x03C364) < prev(bit0(0x03C364))) && never(byte(0x000BF5) == 0x0F) && 
              never(byte(0x00AAEA) < prev(byte(0x00AAEA)))
)

achievement(
    title = "Bested Big Octorok", description = "Defeat the Big Octorok without taking damage", points = 25,
    id = 2245, badge = "02719", published = "8/15/2013 10:33:00 AM", modified = "10/14/2019 2:31:01 PM",
    trigger = never(word(0x000BF4) == 0x0760) && never(word(0x000BF4) == 0x0B60) && never(word(0x000BF4) == 0x0960) && 
              never(word(0x000BF4) == 0x0360) && once(word(0x000BF4) == 0x0860) && word(0x000BF4) == 0x0E60 && bit4(0x00AB42) == 0x1 && 
              once(bit4(0x00AB42) > prev(bit4(0x00AB42))) && never(bit4(0x00AB42) < prev(bit4(0x00AB42))) && never(byte(0x00AAEB) > prev(byte(0x00AAEB))) && 
              once(byte(0x0017B4) == 0x01) && once(byte(0x0017B4) == 0x02) && once(byte(0x0017B4) == 0x03) && once(byte(0x0017B4) == 0x04) && 
              byte(0x0017B4) == 0x00 && byte(0x00177D) == 0x00 && never(byte(0x00AAEA) < prev(byte(0x00AAEA)))
)

achievement(
    title = "Bested Vaati", description = "Defeat Vaati without taking damage", points = 50,
    id = 2313, badge = "02802", published = "8/19/2013 11:38:00 PM", modified = "10/23/2019 5:12:02 PM",
    trigger = once(word(0x000BF4) == 0x0688) && once(byte(0x00ADC3) == 0x60) && once(byte(0x00ADC3) == 0x61) && 
              once(byte(0x00ADC3) == 0x69) && once(byte(0x00ADC3) == 0x6B) && once(byte(0x00ADC3) == 0x6F) && byte(0x00ADC3) == 0xEF && 
              never(byte(0x00ADC3) < prev(byte(0x00ADC3))) && repeated(5, byte(0x00ADC3) > prev(byte(0x00ADC3))) && never(byte(0x00ADC3) < 0x60) && 
              never(byte(0x00AAEA) < prev(byte(0x00AAEA))) && word(0x000BF4) == 0x0189
)

achievement(
    title = "Bested Madderpillar Duo", description = "Defeat the Madderpillar Duo without taking damage", points = 5,
    id = 2244, badge = "02736", published = "8/15/2013 8:34:35 AM", modified = "8/15/2013 8:35:18 AM",
    trigger = once(byte(0x00221D) == 0xFF) && byte(0x00221D) == 0x00 && once(byte(0x0022A5) == 0xFF) && 
              byte(0x0022A5) == 0x00 && never(byte(0x000BF5) > prev(byte(0x000BF5))) && once(word(0x000BF4) == 0x3060) && 
              word(0x000BF4) == 0x2C60 && never(byte(0x00AAEA) < prev(byte(0x00AAEA))) && bit6(0x00AD97) == 0x1 && 
              never(bit6(0x00AD97) < prev(bit6(0x00AD97))) && once(bit6(0x00AD97) > prev(bit6(0x00AD97)))
)

achievement(
    title = "Bested Madderpillar On Ice", description = "Defeat the Madderpillar on ice without taking damage", points = 5,
    id = 2195, badge = "02716", published = "8/14/2013 7:31:22 PM", modified = "8/14/2013 8:03:18 PM",
    trigger = bit4(0x00AD93) == 0x1 && bit4(0x00AD93) > prev(bit4(0x00AD93)) && byte(0x001CCD) == 0x00 && 
              once(byte(0x001CCD) == 0xFF) && never(byte(0x000BF5) < prev(byte(0x000BF5))) && once(byte(0x000BF5) == 0x34) && 
              word(0x000BF4) == 0x3560 && never(byte(0x00AAEA) < prev(byte(0x00AAEA))) && once(byte(0x000BF5) > prev(byte(0x000BF5)))
)

achievement(
    title = "Bested Scissors Beetles", description = "Defeat the Scissors Beetles without taking damage", points = 5,
    id = 2190, badge = "02673", published = "8/13/2013 3:23:12 PM", modified = "8/14/2013 7:33:28 PM",
    trigger = once(byte(0x001805) == 0x14) && once(byte(0x00177D) == 0x14) && 
              once(bit4(0x00AB43) > prev(bit4(0x00AB43))) && never(bit4(0x00AB43) < prev(bit4(0x00AB43))) && word(0x000BF4) == 0x1062 && 
              never(byte(0x000BF4) != 0x62) && byte(0x001805) == 0x00 && byte(0x00177D) == 0x00 && never(word(0x000BF4) > prev(word(0x000BF4))) && 
              never(byte(0x000004) <= 0x32) && once(byte(0x000BF5) == 0x13) && never(byte(0x00AAEA) < prev(byte(0x00AAEA)))
)

achievement(
    title = "Bested Green Wizzrobes", description = "Defeat the Green Wizzrobes without taking damage", points = 5,
    id = 2256, badge = "02745", published = "8/16/2013 5:45:14 AM", modified = "8/16/2013 5:45:18 AM",
    trigger = once(byte(0x0017CC) == 0x03) && once(byte(0x0017CC) == 0x04) && byte(0x0017CC) == 0x01 && 
              bit0(0x00ADAA) == 0x1 && once(bit0(0x00ADAA) > prev(bit0(0x00ADAA))) && never(byte(0x00AAEA) < prev(byte(0x00AAEA))) && 
              word(0x000BF4) == 0x2C70 && never(bit0(0x00ADAA) < prev(bit0(0x00ADAA))) && never(word(0x000006) >= 0x2343) && 
              once(word(0x000006) >= 0x2333)
)

achievement(
    title = "Great View!", description = "Climb the giant beanstalk of Mt. Crenel", points = 2,
    id = 2187, badge = "02670", published = "8/12/2013 3:53:01 PM", modified = "8/14/2013 5:26:40 PM",
    trigger = word(0x000BF4) == 0x100D
)

achievement(
    title = "Bested Darknut Trio", description = "Defeat the Darknut Trio without taking damage", points = 5,
    id = 2301, badge = "02801", published = "8/19/2013 3:10:25 PM", modified = "8/19/2013 3:10:29 PM",
    trigger = once(byte(0x0016F5) == 0x14) && once(byte(0x00177D) == 0x1A) && once(byte(0x001805) == 0x14) && 
              byte(0x0016F5) == 0x00 && byte(0x00177D) == 0x00 && byte(0x001805) == 0x00 && word(0x000BF4) == 0x0688 && 
              never(word(0x000BF4) != 0x0688) && never(word(0x00AECC) == 0x0000) && once(word(0x00AECC) >= 0x2A20) && word(0x00AECC) > 0x0000 && 
              never(byte(0x00AAEA) < prev(byte(0x00AAEA)))
)

achievement(
    title = "Bested Spiny Chuchus", description = "Defeat the 8 Spiny Chuchus without taking damage", points = 5,
    id = 2084, badge = "02559", published = "8/7/2013 1:38:31 AM", modified = "11/16/2013 5:29:57 PM",
    trigger = bit4(0x00AB36) == 0x1 && prev(bit4(0x00AB36)) == 0x0 && never(byte(0x00AAEA) != byte(0x00AAEB)) && 
              byte(0x03C364) == 0x01 && once(byte(0x03C364) == 0x00)
)

achievement(
    title = "Kinstone Bag", description = "Obtain a Kinstone Bag", points = 2,
    id = 2082, badge = "02556", published = "8/6/2013 4:10:39 AM", modified = "8/6/2013 4:56:36 AM",
    trigger = bit6(0x00AB4B) == 0x1
)

achievement(
    title = "Bested Madderpillar", description = "Defeat the Madderpillar without taking damage", points = 5,
    id = 2079, badge = "02522", published = "8/5/2013 5:55:28 AM", modified = "8/14/2013 7:33:40 PM",
    trigger = byte(0x000BF4) == 0x48 && byte(0x000BF5) == 0x00 && once(byte(0x000BF5) == 0x01) && 
              never(byte(0x000BF5) == 0x06) && never(byte(0x000BF5) == 0x02) && never(byte(0x00AAEA) < prev(byte(0x00AAEA))) && 
              byte(0x00210D) == 0x00 && once(byte(0x00210D) == 0xFF) && bit2(0x00AB36) == 0x1 && never(bit2(0x00AB36) < prev(bit2(0x00AB36)))
)

achievement(
    title = "Mini Me", description = "Become Minish size", points = 3,
    id = 2064, badge = "02516", published = "8/4/2013 8:02:55 AM", modified = "2/3/2014 11:12:41 PM",
    trigger = byte(0x003FB0) == 0x80
)

achievement(
    title = "Minish Cap", description = "Befriend Ezlo", points = 2,
    id = 2063, badge = "02515", published = "8/4/2013 8:02:51 AM", modified = "8/12/2013 9:52:25 AM",
    trigger = bit4(0x00AC9E) == 0x1
)

achievement(
    title = "The True Hero", description = "Restore peace to Hyrule with three hearts", points = 5,
    id = 37610, badge = "38596", published = "6/24/2016 4:13:36 AM", modified = "6/24/2016 4:17:17 AM",
    trigger = word(0x000BF4) == 0x0081 && byte(0x00AA46) == 0x01 && word(0x00AAEA) == 0x000A
)

achievement(
    title = "No 2nd Quest This Time...", description = "Entered the Princess' name in the file selection.", points = 5,
    id = 37609, badge = "38594", published = "6/24/2016 3:13:32 AM", modified = "6/24/2016 3:48:24 AM",
    trigger = word(0x00AAC0) >= 0x0010 && word(0x00AAC1) >= 0x000A && word(0x00AAC2) >= 0x000A && 
              word(0x00AAC3) >= 0x000A && word(0x00AAC4) >= 0x000A
)

achievement(
    title = "Hyrule Map", description = "Obtain a map of Hyrule", points = 2,
    id = 2032, badge = "02483", published = "8/3/2013 6:22:59 PM", modified = "8/6/2013 4:57:30 AM",
    trigger = bit6(0x00AB43) == 0x1
)

achievement(
    title = "Defense", description = "Obtain a Small Shield", points = 2,
    id = 2030, badge = "02482", published = "8/3/2013 4:36:26 PM", modified = "8/16/2013 12:26:59 AM",
    trigger = bit2(0x00AB35) == 0x1
)

achievement(
    title = "Offense", description = "Obtain the Smith's Sword", points = 2,
    id = 2029, badge = "02481", published = "8/3/2013 4:36:23 PM", modified = "8/6/2013 4:56:52 AM",
    trigger = bit2(0x00AB32) == 0x1
)
