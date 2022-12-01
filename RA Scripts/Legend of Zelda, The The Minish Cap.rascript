// Legend of Zelda, The: The Minish Cap
// #ID = 559

// $000004: X Cam location
// $000005: X Cam Rollover (Room ID?)
// $000006: Y Cam location
// $000007: Y Cam Rollover (Room ID?)
// $000BF4: Main Map Coordinate - 00-00=MinishWoods, 01=MinishVillage, 02=HyruleTown, 03=HyruleField, 03-00=WesternWood, MANY MORE
// $000BF5: Sub Map Coordinate
//          WAY TOO MANY TO NOTE!!
// $000FF0: Button Input Part 1 - bit0=1=A, bit1=1=B, bit2=1=Select, bit3=1=Start, bit4=1=Right, bit5=1=Left, bit6=1=Up, bit7=1=Down
// $000FF1: Button Input Part 2 - bit0=1=R, bit1=1=L
// $001002: 0x2 = game is loaded
//          Setting to 0x1 appears to reload the save file completely.
// $0010A6: Treasure Chest Game - Current Rupees - 16bit
//          0a=10 Rupees, didn't choose chest yet, Becomes 00 when you lose.
//          20 Rupees = 14, 40 Rupees = 28, etc
// $0010D8: Kill Fortess of Winds Boss Mazaal =00
// $00117A: Link's Color - 8bit - 66=Normal
//          6F=FlashingDamageTaken, 6E=Cyan, 6D=DarkBlue, 6c=Pink, 60=Orange, 61=IcyBlue, 62=Watermelon
//          64=Lemon, 67=Brown
// $001184: idk - 4001 normal, 0001=OnStump, c000=MiniLink
// $00118E: X Pos of PLAYER
// $001192: Y Pos of PLAYER
// $00119D: Invincibility Mode? Invincible=0x40
// $0011A5: Changing to 00 'Kills' you
// $0011A8: 16bit Collision Handle - d046=BigLink
//          MiniLink=c8b3 (Can walk closer to boundaries)
// $0015AC: Gyorg Pair Boss
//          09=Killed
//          01=NotFighting
// $0015CE: Vaati1 location 2
// $0015D2: Vaati1 Location
// $0015D6: Vaati1 Visibility? FF=Invisible
// $0015E5: Gleerok Health - FF=MaxHealth, 00=DeadOrNotVisible
//          Mt Crenel Boss for the Fire Element
// $0016F5: Darknut Trio - Red(Left) - Killswitch
//          Max=14, Dead=0
// $00177D: Giant Octorok in Temple of Droplets AND DarknutTrioBlackKnight(1a)
//          Health remaining on current phase of the fight
//          01=Frozen phases, 03=Unfrozen phases, 00=Phase over
// $0017B3: Giant Octorok - Direction it's facing
//          00=Facing down, 80=Facing up
//          other values before this are related
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
// $0019D9: Figurine Shell Trade Count
// $0019DB: Figurine Probability
//          100 Percent = 64
// $001BE2: Cuccoos Caught
//          Appearance 3
//          This can't be changed but the required amount can
// $001BE4: Required Cuccoos to catch
//          Appearance 3
// $001E02: Amount of Cuccoos caught
//          Appearance 1
//          This can't be changed but the required amount can
// $001E04: Cuccoos Required to catch
//          Appearance 1
// $001E8A: Cuccoos Caught
//          Appearance 4
// $001E8C: Cuccoos Required
//          Appearance 4
// $001FFD: Mazaal Right Face Killswitch
//          Why is this a thing?
//          Set to 00 to kill
// $002085: Mazaal Left Face Killswitch
//          Why is this a thing?
//          Set to 00 to kill
// $00210D: Madderpillar Killswitch - FF=Spawned and Alive, 00=OffScreen or Dead
//          Setting to 00 from FF kills.
// $002132: Cuccoos Caught
//          Appearance 2
//          This can't be changed but the required amount can
// $002134: Cuccoos Required to catch
//          Appearance 2
// $002195: Mazaal Right Hand Killswitch - Unknown Part, not whole hand
//          Set to 00 to kill
// $00221D: Mazaal Left Hand Killswitch - unkown part, not whole hand
//          Set to 00 to kill
//          Also used for one Madderpillar during the duo madderpillar fight
// $0022A5: Mazaal Killswitch?
//          Also used for one of the Madderpillars in the fight with 2 Madderpillars
// $00231F: Mazaal Right Hand - Set to 00 to make it disappear
// $0023B5: Mazaal Right Wrist Killswitch
// $0024B7: Mazaal Left Hand - Set to 00 to make it disappear
// $0024C5: Mazaal Left Wrist Killswitch
//          Set to 00 to destroy Left Wrist
// $00254D: Mazaal Left Wrist Killswitch
//          Set to 00 to kill
// $0026E5: Madderpillar Miniboss Health - 00 until entering room
//          0x20 = Max, 1e=HitOnce, 1c=Twice, 1a=Thrice
//          ... The location moves
// $0027F5: Madderpillar Health Location 3
//          Max = 0x20
//          Location moves.
// $002905: Madderpillar Health Location 2
//          It moves around. 0x20=Max HP
// $003FB0: Mini Mode - 08=Normal, 80=Mini
// $004011: Current Movement Direction
//          
//          0 = Not moving 1 = E 2 = W 4 = N 5 = NE 6 = NW 8 = S
//          9 = SE 10 = SW
// $008004: File you are Playing
// $008005: Message Speed, 1 of 2 - 00=Slow, 01=Normal, 02=Fast
// $008006: Brightness, 1 of 2 - 00=Dark, 01=Normal, 02=Bright
// $008007: Language, 1 of 2 - 02=English, 03=Francais, 04=Deutsch, 05=Espanol, 06=Italiano
// $008083: Hovered Location ID - Works on Inventory and Map
// $00808A: 16-bit? Zoomed Map viewing location
// $00808C: 16-bit Screen ID? - 85b8=ZoomedMap, 832c=Inventory, 8338=QuestStatus, 850c=Map
//          0000=InGame
// $008090: 16-bit - Start Menu Page?
//          0001=Inventory, 0100=QuestStatus, ffff=Map, 0000=ZoomedMap
//          Value remains after unpausing the game
// $0080AE: ID for the item you're hovering over in your inventory
// $009A19: Can of Pacci Chest opened, bit1=1=True, bit0=1=False
// $009A21: 8 Spiny Chuchus defeated? 02=False, 01=True
// $00AA46: Game Beaten Status - Makes part of Triforce appear on Save File
//          00=False, 01=True, Becomes 01 the moment Credits start
//          Changing this to 01 will instantly make the final 6 figurines available
// $00AA60: Map Notes
//          16-bit
// $00AA80: Complete Hyrule Map = FFFF
//          16bit
// $00AA83: Wind Crests - bit7=1=MinishWoods, bit6=1=LinksHouse, bit3=1=HyruleTown
//          bit0=1=MtCrenel, bit5=1=CastorWilds, bit1=1=VeilFalls, bit2=1=CloudTops
// $00AA90: 16-bit - Total Kill Count?!?!?
// $00AAC0: File Name - Letter in Slot 1
// $00AAC1: File Name - Letter in Slot 2
// $00AAC2: File Name - Letter in Slot 3
// $00AAC3: File Name - Letter in Slot 4
// $00AAC4: File Name - Letter in Slot 5
// $00AAC5: File Name - Letter in Slot 6
// $00AAE8: Wallet Upgrade Count
//          00=100 Max, 01=300 Max, 02=500 Max, 03=999 Max
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
// $00AAEF: Quiver Upgrade Count
//          00=30 Arrows, 01=50 Arrows, 02=70 Arrows, 03=99 Arrows
// $00AAF0: Figurines - Amount of unique figurines owned
//          Changing this doesn't affect which ones you own.
//          82=130, 88=136(Max with 6 hidden figurines)
// $00AAF2: Charm Effects - 2F=Nayru(IncreaseDefense), 30=Farore(IncreaseDefenseAndOffence), 31=Din(IncreaseOffense)
// $00AAF3: Picolyte Effects - 29=Red, 2A=Orange, 2B=Yellow, 2C=Green, 2D=Blue, 2E=White
// $00AAF4: Item Equipped to A button - 01=SmithSword, 02=WhiteSword, 03=WhiteSword2, 04=WhiteSword3, 06=FourSword, 07=Bomb, 08=RemoteBomb, 09=Bow, 0a=LightArrow
//          0f=Lantern, 11=GustJar, 12=Cane, 13=Claw, 14=Cape, 15=Boots
// $00AAF5: Item Equipped to B button - 01=SmithSword, 02=WhiteSword, 03=WhiteSword2, 04=WhiteSword3, 06=FourSword, 07=Bomb, 08=RemoteBomb, 09=Bow, 0a=LightArrow
//          0f=Lantern, 11=GustJar, 12=Cane, 13=Claw, 14=Cape, 15=Boots
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
// $00AB05: Charm Effects Active Time Countdown
//          16bit
// $00AB07: Picolyte Effects Active Time Countdown
//          16bit
// $00AB0E: Figurines 1-7
//          FF=Have All 7
// $00AB0F: Figurines 8-15
//          FF=Have All 8
// $00AB10: Figurines 16=23
//          FF=Have All 8
// $00AB11: Figurines 24-31
//          FF=Have All 8
// $00AB12: Figurines 32-39
//          FF=Have All 8
// $00AB13: Figurines 40-47
//          FF=Have All 8
// $00AB14: Figurines 48-55
//          FF=Have All 8
// $00AB15: Figurines 56-63
//          FF=Have All 8
// $00AB16: Figurines 64-71
//          FF=Have All 8
// $00AB17: Figurines 72-79
//          FF=Have All 8
// $00AB18: Figurines 80-87
//          FF=Have All 8
// $00AB19: Figurines 88-95
//          FF=Have All 8
// $00AB1A: Figurines 96-103
//          FF=Have All 8
// $00AB1B: Figurines 104-111
//          FF=Have All 8
// $00AB1C: Figurines 112-119
//          FF=Have All 8
// $00AB1D: Figurines 120-127
//          FF=Have All 8
// $00AB1E: Figurines - 128-130
//          07=Have All 3, FF=Have Final 5of6
//          6 more figurines are available after beating the game, and you can't get them if you complete your collection beforehand!
// $00AB1F: Final Figurine, 01=Have
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
// $00AB45: Quest - Tiger Scrolls (2nd half of the 16bit)
//          All Sword Techniques 16bit - 5555=HaveAll
//          bit6=1=PerilBeam, bit0=1=SwordBeam, bit4=1=DownThrust, bit2=1=GreatSpinAttack
// $00AB48: Bit6=1=JabberNut
//          Setting this true (0x50) or (0x54 normally), makes picori use English without Jabber Nut
// $00AB4A: 16bit - Kinstone Bag - 4551=Have
// $00AB4B: Items - Bit6=1=KinstoneBag, Bit0=1=BigWallet
// $00AB4E: Passive Permanent Upgrades (Part 1)
//          bit6=1=ChargeFast, bit4=1=SwimFast
//          bit2=1=DigFast, bit0=1=ShootArrowsFast
// $00AB4F: Passive Permanent Upgrades (Part 2)
//          bit0=1=FastSplitGauge, bit2=1=SpinTimeIncreased
// $00AB56: Kinstones 1 - Try setting 6401
//          16bit
//          Unknown!
// $00AB57: Fused Kinstone Count
// $00AB58: Kinstones Slot 1 - ID for piece (Many values)
// $00AB59: Kinstones Slot 2 - ID for piece (Many values)
// $00AB5A: Kinstones Slot 3 - ID for piece (Many values)
// $00AB5B: Kinstones Slot 4 - ID for piece (Many values)
// $00AB5C: Kinstones Slot 5 - ID for piece (Many values)
// $00AB5D: Kinstones Slot 6 - ID for piece (Many values)
// $00AB5E: Kinstones Slot 7 - ID for piece (Many values)
// $00AB5F: Kinstones Slot 8 - ID for piece (Many values)
// $00AB60: Kinstones Slot 9 - ID for piece (Many values)
// $00AB61: Kinstones Slot 10 - ID for piece (Many values)
// $00AB62: Kinstones Slot 11 - ID for piece (Many values)
// $00AB6A: Kinstones 5 - Try setting 2121
//          16bit
// $00AB6B: Kinstone Piece Amount - Slot 1
// $00AB6C: Kinstone Piece Amount - Slot 2
// $00AB6D: Kinstone Piece Amount - Slot 3
// $00AB6E: Kinstone Piece Amount - Slot 4
// $00AB6F: Kinstone Piece Amount - Slot 5
// $00AB70: Kinstone Piece Amount - Slot 6
// $00AB71: Kinstone Piece Amount - Slot 7
// $00AB72: Kinstone Piece Amount - Slot 8
// $00AB73: Kinstone Piece Amount - Slot 9
// $00AB74: Kinstone Piece Amount - Slot 10
// $00AB75: Kinstone Piece Amount - Slot 11
// $00AC9E: Minish Cap - Bit4=1=Have or 0x38=Have
// $00ACDF: Swordsman Newsletter Issues Part 1 - 8bit
//          bit7=1=1st Issue = 0x80
//          Only the 1st issue is on this address
// $00ACE0: Swordsman Newsletter Issues Part 2 - 8bit
//          bit0=1=2nd, bit1=1=3rd, bit2=1=4th, bit4=1=6th
//          bit6=1=8th, bit5=1=7th, bit3=1=5th - Have All=0x7F
// $00ACED: Swordsman Newsletter - Amount of Tiger Scrolls you have affects how many newsletters you can sub to
//          e0=NotSubbed, e8=WaitingToReceive
//          F0=IssueReceived
// $00AD3C: Doors Open in Deepwood Shrine = FFFD
//          16bit
// $00AD56: 8 Spiny Chuchu miniboss status - Gleerok boss room entered = bit3
//          03=NotKilled, Chest not spawned, door not open
//          63=Door open and chest spawned (bit 6 and 5)
// $00AD72: Dungeon 3 Doors Open
//          bit1=1=DoorAfterBossOpen
// $00AD8C: bit6=1=PulledLever in BigBlueChuChu Boss Room
//          bit7=1=OpenedChest in Big Blue Chuchu Room
// $00AD8D: bit0=1=Chest spawned after Big Blue Chuchu Boss
// $00AD97: Duo Madderpillar Door
//          bit6=1=Open
// $00ADAA: bit0=1=GreenWizzrobesRocsCape Chest Appeared
// $00ADB4: Open Most Dungeon Doors To Dark Hyrule Castle/Kill Vaati
//          16bit Part 1 of 3 - FFFD
//          bit0=1=DarknutTrioEntranceOpen
// $00ADBC: Open Most Dungeon Doors To Dark Hyrule Castle/Kill Vaati
//          16bit Part 2 of 3 - FFFF
// $00ADC0: Lower Stone Block Statues in Dark Hyrule Castle
//          16bit part 2 of 2 = AFFF
//          Use 0x000130 = 01FF to initiate
// $00ADC2: 8a then aa upon dropping down to Vaati 1
//          ea =after beaten vaati3
//          6a=AfterGameBeaten (bit6=1=GameBeaten), still ends at 0xea
// $00ADC3: EndGame status? - 10=AfterBigKeyDoor
//          30=PurpleFoxHall, 70=Darknut Trio Room, 60=Vaati1, 61=Vaati1Fight, 69=Vaati2Dead, 6b,6f=GetawayStart, ef=Vaati3Dead
//          Always 00 before boss key door
// $00AE9D: Dungeon 1 Small Keys
//          0x63=99 Keys
// $00AE9E: Dungeon 2 Small Keys
//          0x63=99 Keys
// $00AE9F: Dungeon 3 Small Keys
//          0x63=99 Keys
// $00AEA0: Dungeon 4 Small Keys
//          0x63=99 Keys
// $00AEA1: Dungeon 5 Small Keys (Not Royal Crypt)
//          0x63=99 Keys
// $00AEA2: Dungeon 6 Small Keys
//          0x63=99 Keys
// $00AEA3: Royal Crypt Small Keys
//          0x63=99 Keys
// $00AEAD: Dungeon 1 Map, Compass, Boss Key
//          bit0=1=Map, bit1=1=Compass, bit2=1=BossKey
//          0x07=Have All 3
// $00AEAE: Dungeon 2 Map, Compass, Boss Key
//          bit0=1=Map, bit1=1=Compass, bit2=1=BossKey
//          0x07=Have All 3
// $00AEAF: Dungeon 3 Map, Compass, Boss Key
//          bit0=1=Map, bit1=1=Compass, bit2=1=BossKey
//          0x07=Have All 3
// $00AEB0: Dungeon 4 Map, Compass, Boss Key
//          bit0=1=Map, bit1=1=Compass, bit2=1=BossKey
//          0x07=Have All 3
// $00AEB1: Dungeon 5 Map, Compass, Boss Key (Not Royal Crypt)
//          bit0=1=Map, bit1=1=Compass, bit2=1=BossKey
//          0x07=Have All 3
// $00AEB2: Dungeon 6 Map, Compass, Boss Key
//          bit0=1=Map, bit1=1=Compass, bit2=1=BossKey
//          0x07=Have All 3
// $00AEBD: oooo What is this?
//          It lines up with each dungeon.
// $00AEC2: oooo What is this?
//          It lines up with each dungeon.
// $00AECC: 16bit Bell Countdown at end game
// $021EE3: Language, 2 of 2 - 02=English, 03=Francais, 04=Deutsch, 05=Espanol, 06=Italiano
// $021EEE: Message Speed, 2 of 2 - 00=Slow, 01=Normal, 02=Fast
// $021EEF: Brightness, 2 of 2 - 00=Dark, 01=Normal, 02=Bright
// $029EF4: Music ID
// $02C5CE: 8 Spiny Chuchu scount left
//          Appearance 2 of 2
// $03BAA8: Stump Warp Availability - 03=Stump is awaiting use(sparkling) (Only when small)
//          02=BigLink standing on stump
// $03BAA9: Inside Stump Status - 01=Inside
//          Can change from 00 to 01 and you get teleported inside.
// $03C364: bit0=1=Door Barrier Up in Big Blue Chuchu Boss Room
//          bit0=0=Door Barrier Down
//          Also spiny chuchus room: 01 when battle begins
// $03ED64: Madderpillar Miniboss Status? - 0xc0=Killed
//          one of 3 appearances, this value is unique
// $03ED78: Madderpillar Miniboss Status? - 0x02=Killed
// $03ED7D: Madderpillar Miniboss Status? - 0x02=Killed
//          2nd appearance

NameLookup = {
    0x0: "",
    0x41: "A",
    0x42: "B",
    0x43: "C",
    0x44: "D",
    0x45: "E",
    0x46: "F",
    0x47: "G",
    0x48: "H",
    0x49: "I",
    0x4a: "J",
    0x4b: "K",
    0x4c: "L",
    0x4d: "M",
    0x4e: "N",
    0x4f: "O",
    0x50: "P",
    0x51: "Q",
    0x52: "R",
    0x53: "S",
    0x54: "T",
    0x55: "U",
    0x56: "V",
    0x57: "W",
    0x58: "X",
    0x59: "Y",
    0x5a: "Z",
    0x27: "'",
    0x2d: "-",
    0x3a: ":",
    0x21: "!",
    0x3f: "?",
    0x2c: ",",
    0x2e: ".",
    0x20: " ",
    0x61: "a",
    0x62: "b",
    0x63: "c",
    0x64: "d",
    0x65: "e",
    0x66: "f",
    0x67: "g",
    0x68: "h",
    0x69: "i",
    0x6a: "j",
    0x6b: "k",
    0x6c: "l",
    0x6d: "m",
    0x6e: "n",
    0x6f: "o",
    0x70: "p",
    0x71: "q",
    0x72: "r",
    0x73: "s",
    0x74: "t",
    0x75: "u",
    0x76: "v",
    0x77: "w",
    0x78: "x",
    0x79: "y",
    0x7a: "z",
    0x30: "0",
    0x31: "1",
    0x32: "2",
    0x33: "3",
    0x34: "4",
    0x35: "5",
    0x36: "6",
    0x37: "7",
    0x38: "8",
    0x39: "9",
    0xc0: "Ã€",
    0xc2: "Ã‚",
    0xc4: "Ã„",
    0xc6: "Ã†",
    0xc7: "Ã‡",
    0xc8: "Ãˆ",
    0xc9: "Ã‰",
    0xca: "ÃŠ",
    0xcb: "Ã‹",
    0xcc: "ÃŒ",
    0xce: "ÃŽ",
    0xcf: "Ã",
    0xd0: "Ã",
    0xd1: "Ã‘",
    0xd2: "Ã’",
    0xd4: "Ã”",
    0xd6: "Ã–",
    0x8c: "Å’",
    0xd9: "Ã™",
    0xdb: "Ã›",
    0xdc: "Ãœ",
    0xe0: "Ã ",
    0xe2: "Ã¢",
    0xe4: "Ã¤",
    0xe6: "Ã¦",
    0xe7: "Ã§",
    0xe8: "Ã¨",
    0xe9: "Ã©",
    0xea: "Ãª",
    0xeb: "Ã«",
    0xec: "Ã¬",
    0xee: "Ã®",
    0xef: "Ã¯",
    0xf0: "Ã°",
    0xf1: "Ã±",
    0xf2: "Ã²",
    0xf4: "Ã´",
    0xf6: "Ã¶",
    0x9c: "Å“",
    0xf9: "Ã¹",
    0xfb: "Ã»",
    0xfc: "Ã¼",
}

HeartsLookup = {
    0x0: "Not Playing",
    0xff: "Not Playing",
    0x8: "1 Heart Container",
    0x10: "2 Heart Containers",
    0x18: "3 Heart Containers",
    0x20: "4 Heart Containers",
    0x28: "5 Heart Containers",
    0x30: "6 Heart Containers",
    0x38: "7 Heart Containers",
    0x40: "8 Heart Containers",
    0x48: "9 Heart Containers",
    0x50: "10 Heart Containers",
    0x58: "11 Heart Containers",
    0x60: "12 Heart Containers",
    0x68: "13 Heart Containers",
    0x70: "14 Heart Containers",
    0x78: "15 Heart Containers",
    0x80: "16 Heart Containers",
    0x88: "17 Heart Containers",
    0x90: "18 Heart Containers",
    0x98: "19 Heart Containers",
    0xa0: "20(all) Heart Containers",
}

function Delta(addr) => prev(addr)

function IsFileLoaded() => byte(0x001002) == 0x2

function IsLoadingSaveFile() => Delta(byte(0x001002)) == 0x1 && IsFileLoaded()

function WasValueJustSet(mem, oldValue, newValue) => Delta(mem) == oldValue && mem == newValue

function WasValueSet(mem, oldValue, newValue)
{
    return once(WasValueJustSet(mem, oldValue, newValue))
}

function WasValueSetInGame(mem, oldValue, newValue)
{
    return WasValueSet(mem, oldValue, newValue)
        && never(!IsFileLoaded())
}

function WasValueJustSetInGame(mem, oldValue, newValue)
{
    return WasValueJustSet(mem, oldValue, newValue)
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
        conditions[i] = { "countsWhen": (bit(i, addr) == 1), "recalculateWhen": (Delta(bit(i, addr)) == 0 && bit(i, addr) == 1) }
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

    achievement(title = cheevo["name"], description = cheevo["description"], points = cheevo["points"], badge = cheevo["badge"],
        trigger = IsFileLoaded()
            && measured(tally(cheevo["threshold"], totalCounts)) && unless(tally(cheevo["threshold"], loadedCounts))
            && never(resetAlt)
    )
}

function MusicId() => byte(0x029EF4)

function CreditsLoaded() => MusicId() == 0x09 && Delta(MusicId()) == 0x00

function ScreenIdByte() => byte(0x000BF4)
function ScreenIdWord() => word(0x000BF4)

achievement(
    title = "Bested Gyorg Pair[m]", description = "Defeat the Gyorg Pair without taking damage", points = 25,
    id = 2257, badge = "155782", published = "8/16/2013 8:24:47 AM", modified = "1/30/2021 2:29:51 PM",
    trigger = byte(0x0015AC) == 9 && once(byte(0x0015AC) == 1) && once(byte(0x0015AC) == 2) && once(byte(0x0015AC) == 3) && 
              once(byte(0x0015AC) == 4) && once(byte(0x0015AC) == 5) && once(byte(0x0015AC) == 6) && once(byte(0x0015AC) == 7) && 
              once(byte(0x0015AC) == 8) && ScreenIdWord() == 113 && never(byte(0x00AAEA) < Delta(byte(0x00AAEA))) && 
              never(byte(0x0015AC) < Delta(byte(0x0015AC)))
)

achievement(
    title = "Earth", description = "Obtain the Earth Element.", points = 5,
    id = 2034, badge = "155783", published = "8/4/2013 8:00:28 AM", modified = "1/30/2021 2:29:52 PM",
    trigger = ScreenIdWord() == 73 && bit0(0x00AB42) > Delta(bit0(0x00AB42))
)

achievement(
    title = "Fire", description = "Obtain the Fire Element", points = 5,
    id = 2036, badge = "155784", published = "8/4/2013 8:00:34 AM", modified = "8/4/2013 8:10:47 AM",
    trigger = WasBitflagSetInGame(bit2(0x00AB42))
)

achievement(
    title = "Water", description = "Obtain the Water Element", points = 5,
    id = 2035, badge = "155785", published = "8/4/2013 8:00:31 AM", modified = "8/4/2013 8:10:41 AM",
    trigger = WasBitflagSetInGame(bit4(0x00AB42))
)

achievement(
    title = "Wind", description = "Obtain the Wind Element", points = 5,
    id = 2037, badge = "155786", published = "8/4/2013 8:00:38 AM", modified = "8/4/2013 8:10:52 AM",
    trigger = WasBitflagSetInGame(bit6(0x00AB42))
)

achievement(
    title = "Gust Jar", description = "Obtain the Gust Jar.", points = 5,
    id = 2033, badge = "155787", published = "8/4/2013 8:00:23 AM", modified = "1/30/2021 2:29:57 PM",
    trigger = ScreenIdWord() == 72 && bit2(0x00AB36) > Delta(bit2(0x00AB36))
)

achievement(
    title = "Grip Ring", description = "Obtain the Grip Ring.", points = 5,
    id = 2038, badge = "155788", published = "8/4/2013 8:00:45 AM", modified = "1/30/2021 2:29:58 PM",
    trigger = ScreenIdWord() == 1062 && bit0(0x00AB43) > Delta(bit0(0x00AB43))
)

achievement(
    title = "Power Bracelets", description = "Obtain the Power Bracelets", points = 5,
    id = 2039, badge = "155789", published = "8/4/2013 8:00:49 AM", modified = "8/4/2013 8:11:06 AM",
    trigger = WasBitflagSetInGame(bit2(0x00AB43))
)

achievement(
    title = "Going For A Swim", description = "Obtain Flippers", points = 5,
    id = 2040, badge = "155790", published = "8/4/2013 8:00:51 AM", modified = "10/17/2019 3:22:01 PM",
    trigger = WasBitflagSetInGame(bit4(0x00AB43))
)

achievement(
    title = "But I Can Walk Just Fine!", description = "Obtain the Cane of Pacci.", points = 5,
    id = 2041, badge = "155791", published = "8/4/2013 8:00:54 AM", modified = "1/30/2021 2:30:02 PM",
    trigger = ScreenIdWord() == 336 && bit4(0x00AB36) > Delta(bit4(0x00AB36))
)

achievement(
    title = "Light It Up", description = "Obtain the Lantern", points = 5,
    id = 2042, badge = "155792", published = "8/4/2013 8:00:57 AM", modified = "8/4/2013 8:11:22 AM",
    trigger = WasBitflagSetInGame(bit6(0x00AB35))
)

function graveyardKeyUsed() => bit1(0x00AB41)
achievement(
    title = "Graveyard", description = "Obtain the Graveyard Key and use it", points = 5,
    id = 2043, badge = "155794", published = "8/4/2013 8:01:00 AM", modified = "8/4/2019 9:04:58 PM",
    trigger = once(Delta(graveyardKeyUsed()) == 0 && graveyardKeyUsed() == 1 && ScreenIdWord() == 0x9) && never(ScreenIdWord() != 0x9)
)

achievement(
    title = "A New Quest", description = "Obtain the Broken Picori Blade.", points = 5,
    id = 2031, badge = "155797", published = "8/3/2013 6:22:56 PM", modified = "1/30/2021 2:30:05 PM",
    trigger = ScreenIdWord() == 640 && bit2(0x00AB3F) > Delta(bit2(0x00AB3F))
)

achievement(
    title = "White Sword", description = "Obtain the White Sword", points = 5,
    id = 2044, badge = "155798", published = "8/4/2013 8:01:02 AM", modified = "8/4/2013 8:11:27 AM",
    trigger = WasBitflagSetInGame(bit4(0x00AB32))
)

achievement(
    title = "White Sword 2", description = "Infuse your sword with Earth and Fire elements", points = 10,
    id = 2045, badge = "155799", published = "8/4/2013 8:01:05 AM", modified = "8/4/2019 9:04:45 PM",
    trigger = WasBitflagSetInGame(bit6(0x00AB32))
)

achievement(
    title = "White Sword 3", description = "Infuse your sword with the third element - Water", points = 10,
    id = 2046, badge = "155800", published = "8/4/2013 8:01:29 AM", modified = "9/26/2019 10:32:01 AM",
    trigger = WasBitflagSetInGame(bit0(0x00AB33))
)

achievement(
    title = "Four Sword", description = "Infuse your sword with the fourth element - Wind", points = 10,
    id = 2047, badge = "155801", published = "8/4/2013 8:01:40 AM", modified = "8/4/2019 9:04:50 PM",
    trigger = WasBitflagSetInGame(bit4(0x00AB33))
)

achievement(
    title = "Wake Up", description = "Obtain the Wake-Up Mushroom", points = 5,
    id = 2048, badge = "155802", published = "8/4/2013 8:01:43 AM", modified = "8/4/2019 9:04:52 PM",
    trigger = WasBitflagSetInGame(bit0(0x00AB40))
)

achievement(
    title = "Shiny!", description = "Obtain the Mirror Shield", points = 5,
    id = 2049, badge = "155803", published = "8/4/2013 8:01:46 AM", modified = "8/4/2013 8:11:43 AM",
    trigger = WasBitflagSetInGame(bit4(0x00AB35))
)

achievement(
    title = "Bow Down", description = "Obtain a Bow", points = 5,
    id = 2057, badge = "155804", published = "8/4/2013 8:02:34 AM", modified = "8/4/2013 8:12:06 AM",
    trigger = WasBitflagSetInGame(bit2(0x00AB34))
)

achievement(
    title = "It Doesn't Feel Lighter [m]", description = "Obtain Light Arrows", points = 10,
    id = 2059, badge = "155805", published = "8/4/2013 8:02:40 AM", modified = "8/4/2019 9:04:41 PM",
    trigger = WasBitflagSetInGame(bit4(0x00AB34))
)

achievement(
    title = "Where's The Boom?", description = "Obtain a Boomerang", points = 5,
    id = 2058, badge = "155807", published = "8/4/2013 8:02:37 AM", modified = "8/4/2013 8:12:10 AM",
    trigger = WasBitflagSetInGame(bit6(0x00AB34))
)

achievement(
    title = "Magic Trick", description = "Obtain the Magical Boomerang", points = 10,
    id = 2050, badge = "155808", published = "8/4/2013 8:01:48 AM", modified = "8/4/2019 9:04:28 PM",
    trigger = WasBitflagSetInGame(bit0(0x00AB35))
)

achievement(
    title = "Hyrulean Bestiary", description = "Obtain the Library Book - A Hyrulean Bestiary", points = 5,
    id = 2051, badge = "155809", published = "8/4/2013 8:02:07 AM", modified = "8/4/2019 9:04:30 PM",
    trigger = WasBitflagSetInGame(bit2(0x00ab40))
)

achievement(
    title = "Legend of the Picori", description = "Obtain the Library Book - Legend of the Picori", points = 5,
    id = 2052, badge = "155810", published = "8/4/2013 8:02:14 AM", modified = "8/4/2019 9:04:32 PM",
    trigger = WasBitflagSetInGame(bit4(0x00AB40))
)

achievement(
    title = "History of Masks", description = "Obtain the Library Book - A History of Masks", points = 5,
    id = 2053, badge = "155811", published = "8/4/2013 8:02:22 AM", modified = "8/4/2019 9:04:36 PM",
    trigger = WasBitflagSetInGame(bit6(0x00AB40))
)

function bombs() => bit6(0x00AB33)
function remoteBombs() => bit0(0x00ab34)
achievement(
    title = "Don't Hurt Yourself", description = "Obtain a Bomb Bag.", points = 5,
    id = 2056, badge = "155812", published = "8/4/2013 8:02:32 AM", modified = "1/30/2021 2:30:23 PM",
    trigger = WasValueJustSetInGame(bombs(), 0, 1) && Delta(remoteBombs()) == 0
)

achievement(
    title = "Set Up Us The Bomb", description = "Obtain a Remote Bomb", points = 5,
    id = 2055, badge = "155813", published = "8/4/2013 8:02:30 AM", modified = "8/4/2013 8:11:59 AM",
    trigger = WasBitflagSetInGame(bit0(0x00AB34))
)

achievement(
    title = "Dig Dug", description = "Obtain Mole Mitts", points = 5,
    id = 2054, badge = "155814", published = "8/4/2013 8:02:26 AM", modified = "8/4/2013 8:11:55 AM",
    trigger = WasBitflagSetInGame(bit6(0x00AB36))
)

achievement(
    title = "I Can Fly!", description = "Obtain Roc's Cape", points = 5,
    id = 2060, badge = "155815", published = "8/4/2013 8:02:43 AM", modified = "8/4/2013 8:12:17 AM",
    trigger = WasBitflagSetInGame(bit0(0x00AB37))
)

achievement(
    title = "Pegasus Boots", description = "Obtain Pegasus Boots", points = 5,
    id = 2061, badge = "155816", published = "8/4/2013 8:02:46 AM", modified = "8/4/2013 8:12:22 AM",
    trigger = WasBitflagSetInGame(bit2(0x00AB37))
)

achievement(
    title = "Ocarina of Wind", description = "Obtain the Ocarina of Wind", points = 5,
    id = 2062, badge = "155817", published = "8/4/2013 8:02:49 AM", modified = "8/4/2013 8:12:25 AM",
    trigger = WasBitflagSetInGame(bit6(0x00AB37))
)

achievement(
    title = "Jibber-Jabber", description = "Obtain the Jabber Nut.", points = 5,
    id = 2065, badge = "155818", published = "8/4/2013 6:20:26 PM", modified = "1/30/2021 2:30:31 PM",
    trigger = ScreenIdWord() == 2336 && bit6(0x00AB48) > Delta(bit6(0x00AB48))
)

achievement(
    title = "Lon Lon Ranch", description = "Find and return the Lon Lon Ranch Key", points = 3,
    id = 2089, badge = "155819", published = "8/7/2013 9:49:34 PM", modified = "8/4/2019 9:04:16 PM",
    trigger = WasBitflagSetInGame(bit7(0x00AB3F))
)

achievement(
    title = "Red Picolyte", description = "Use a Red Picolyte to find a heart and refill your health", points = 1,
    id = 2169, badge = "155820", published = "8/12/2013 10:21:31 AM", modified = "1/30/2021 2:30:33 PM",
    trigger = byte(0x00AAF3) == 41 && byte(0x00AAEA) > Delta(byte(0x00AAEA)) && byte(0x00AAE9) == Delta(byte(0x00AAE9)) && 
              byte(0x00AAEB) == Delta(byte(0x00AAEB)) && never(byte(0x00AAEB) != Delta(byte(0x00AAEB))) && never(byte(0x00AAE9) != Delta(byte(0x00AAE9)))
)

achievement(
    title = "Orange Picolyte", description = "Use an Orange Picolyte to find and bottle a fairy in your bottle", points = 1,
    id = 2170, badge = "155821", published = "8/12/2013 10:21:34 AM", modified = "1/30/2021 2:30:35 PM",
    trigger = byte(0x00AAF3) == 42 &&
              ((Delta(byte(0x00AAF6)) == 32 && byte(0x00AAF6) == 40) ||
               (Delta(byte(0x00AAF7)) == 32 && byte(0x00AAF7) == 40) ||
               (Delta(byte(0x00AAF8)) == 32 && byte(0x00AAF8) == 40) ||
               (Delta(byte(0x00AAF9)) == 32 && byte(0x00AAF9) == 40))
)

achievement(
    title = "Yellow Picolyte", description = "Use a Yellow Picolyte to find Rupees", points = 1,
    id = 2171, badge = "155822", published = "8/12/2013 10:21:40 AM", modified = "1/30/2021 2:30:36 PM",
    trigger = byte(0x00AAF3) == 43 && word(0x00AB00) > Delta(word(0x00AB00))
)

achievement(
    title = "Green Picolyte", description = "Use a Green Picolyte to find a Mysterious Shell", points = 1,
    id = 2172, badge = "155823", published = "8/12/2013 10:21:44 AM", modified = "1/30/2021 2:30:37 PM",
    trigger = byte(0x00AAF3) == 44 && word(0x00AB02) > Delta(word(0x00AB02))
)

achievement(
    title = "Blue Picolyte", description = "Use a Blue Picolyte to find Bombs or Arrows", points = 1,
    id = 2173, badge = "155824", published = "8/12/2013 10:21:47 AM", modified = "1/30/2021 2:30:39 PM",
    trigger = byte(0x00AAF3) == 45 && word(0x00AAEE) == Delta(word(0x00AAEE)) && 
              never(word(0x00AAEE) != Delta(word(0x00AAEE))) &&
              ((word(0x00AAEC) > Delta(word(0x00AAEC))) ||
               (word(0x00AAED) > Delta(word(0x00AAED))))
)

achievement(
    title = "White Picolyte", description = "Use a White Picolyte for an increased chance of finding Kinstones", points = 1,
    id = 2174, badge = "155825", published = "8/12/2013 10:21:51 AM", modified = "1/30/2021 2:30:40 PM",
    trigger = byte(0x00AAF3) == 46
)

achievement(
    title = "Din's Charm [m]", description = "Use Din's Charm for increased attack power", points = 5,
    id = 2175, badge = "155826", published = "8/12/2013 10:22:03 AM", modified = "1/30/2021 2:30:40 PM",
    trigger = repeated(200, byte(0x00AAF2) == 49)
)

achievement(
    title = "Farore's Charm [m]", description = "Use Farore's Charm for increased attack and defense power", points = 5,
    id = 2176, badge = "155827", published = "8/12/2013 10:22:06 AM", modified = "1/30/2021 2:30:42 PM",
    trigger = repeated(200, byte(0x00AAF2) == 48)
)

achievement(
    title = "Nayru's Charm [m]", description = "Use Nayru's Charm for increased defense power", points = 5,
    id = 2177, badge = "155828", published = "8/12/2013 10:22:09 AM", modified = "1/30/2021 2:30:43 PM",
    trigger = repeated(200, byte(0x00AAF2) == 47)
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

GenerateSaveProtectedAchievementFromConditions({
    "name": "Swordsman Newsletter",
    "description": "Subscribe to Swordsman Newsletter and collect all issues",
    "points": 10,
    "threshold": 8,
    "badge": "155829"
}, newsletterConditions)


achievement(
    title = "Miracle Maker", description = "Fuse at least 50 Kinstones", points = 10,
    id = 2347, badge = "155830", published = "8/20/2013 5:26:51 AM", modified = "8/4/2019 9:03:45 PM",
    trigger = WasValueSetInGame(byte(0x00AB57), 0x31, 0x32)
)

achievement(
    title = "Tingle Trophy [m]", description = "Complete all Kinstone Fusions", points = 25,
    id = 2349, badge = "155831", published = "8/20/2013 5:40:45 AM", modified = "3/30/2020 2:40:29 PM",
    trigger = WasBitflagSetInGame(bit2(0x00AB41)) && byte(0x00AB57) >= 0x63
)

function rupees() => word(0x00AB00)
achievement(title = "Rupee Accumulator", description = "Accumulate 100 Rupees", points = 1,
    id = 1473, badge = "155833",
    trigger = rupees() >= 0x64 && Delta(rupees()) < 0x64 && IsFileLoaded())

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


GenerateSaveProtectedAchievementFromConditions({
    "name": "Dexterous",
    "description": "Learn all 6 abilities speeding up various actions",
    "points": 10,
    "threshold": 6,
    "badge": "155832"
}, dexterousConditions)

achievement(
    title = "Rupee Gatherer", description = "Gather 300 Rupees", points = 5,
    id = 1474, badge = "155835", published = "5/31/2013 4:40:39 AM", modified = "8/4/2019 9:03:49 PM",
    trigger = rupees() >= 0x012C && Delta(rupees()) < 0x12c && IsFileLoaded()
)

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
    "threshold": 25,
    "badge": "155834"
}, navigatorConditions)

achievement(
    title = "Rupee Collector", description = "Collect 500 Rupees", points = 5,
    id = 2179, badge = "155837", published = "8/12/2013 1:13:56 PM", modified = "8/4/2019 9:03:51 PM",
    trigger = rupees() >= 0x01F4 && Delta(rupees()) < 0x1f4 && IsFileLoaded()
)

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

GenerateSaveProtectedAchievementFromConditions({
    "name": "Crouching Tiger",
    "description": "Obtain all Tiger Scrolls",
    "points": 10,
    "threshold": 8,
    "badge": "155836"
}, scrollConditions)

achievement(
    title = "Rupee Hoarder", description = "Hoard 999 Rupees", points = 10,
    id = 2180, badge = "155838", published = "8/12/2013 1:13:59 PM", modified = "8/4/2019 9:03:55 PM",
    trigger = rupees() >= 0x03E7 && Delta(rupees()) < 0x3e7 && IsFileLoaded()
)

function bombUpgradesObtained() => byte(0x00AAEE)
function quiverUpgradesObtained() => byte(0x00aaef)
achievement(
    title = "Packing Heat", description = "Fully upgrade your Quiver and Bomb Bag", points = 10,
    id = 2259, badge = "155839", published = "8/16/2013 10:43:54 AM", modified = "1/30/2021 2:30:58 PM",
    trigger = WasValueJustSetInGame(bombUpgradesObtained(), 2, 3) && quiverUpgradesObtained() == 3
        || WasValueJustSetInGame(quiverUpgradesObtained(), 2, 3) && bombUpgradesObtained() == 3
)

achievement(
    title = "Putting The Pieces Together", description = "Assemble 4 Pieces of Heart.", points = 5,
    id = 1475, badge = "155840", published = "5/31/2013 4:40:43 AM", modified = "1/30/2021 2:30:59 PM",
    trigger = byte(0x00AAE9) < Delta(byte(0x00AAE9)) && byte(0x00AAEB) > Delta(byte(0x00AAEB))
)

bottleConditions = {
    1: { "countsWhen": (bit0(0x00AB39) == 1), "recalculateWhen": (Delta(bit0(0x00AB39)) == 0) },
    2: { "countsWhen": (bit2(0x00AB39) == 1), "recalculateWhen": (Delta(bit2(0x00AB39)) == 0) },
    3: { "countsWhen": (bit4(0x00AB39) == 1), "recalculateWhen": (Delta(bit4(0x00AB39)) == 0) },
    4: { "countsWhen": (bit6(0x00AB39) == 1), "recalculateWhen": (Delta(bit6(0x00AB39)) == 0) },
}

GenerateSaveProtectedAchievementFromConditions({
    "name": "Resourceful",
    "description": "Obtain all four Bottles",
    "points": 25,
    "threshold": 4,
    "badge": "155841"
}, bottleConditions)

achievement(
    title = "Stayin' Alive", description = "Have 20 Heart Containers", points = 25,
    id = 1496, badge = "155843", published = "5/31/2013 5:40:11 PM", modified = "9/29/2019 11:02:03 AM",
    trigger = Delta(byte(0x00AAEB)) < 0xA0 && byte(0x00AAEB) == 0xa0 && IsFileLoaded()
)

figurineConditionsArr = [
    {
        1: { "countsWhen": (bit1(0x00ab0e) == 1), "recalculateWhen": (Delta(bit1(0x00ab0e)) == 0 && bit1(0x00ab0e) == 1) },
        2: { "countsWhen": (bit2(0x00ab0e) == 1), "recalculateWhen": (Delta(bit2(0x00ab0e)) == 0 && bit2(0x00ab0e) == 1) },
        3: { "countsWhen": (bit3(0x00ab0e) == 1), "recalculateWhen": (Delta(bit3(0x00ab0e)) == 0 && bit3(0x00ab0e) == 1) },
        4: { "countsWhen": (bit4(0x00ab0e) == 1), "recalculateWhen": (Delta(bit4(0x00ab0e)) == 0 && bit4(0x00ab0e) == 1) },
        5: { "countsWhen": (bit5(0x00ab0e) == 1), "recalculateWhen": (Delta(bit5(0x00ab0e)) == 0 && bit5(0x00ab0e) == 1) },
        6: { "countsWhen": (bit6(0x00ab0e) == 1), "recalculateWhen": (Delta(bit6(0x00ab0e)) == 0 && bit6(0x00ab0e) == 1) },
        7: { "countsWhen": (bit7(0x00ab0e) == 1), "recalculateWhen": (Delta(bit7(0x00ab0e)) == 0 && bit7(0x00ab0e) == 1) },
    },
    GenerateConditionsForByte(0x00ab0f),
    GenerateConditionsForByte(0x00ab10),
    GenerateConditionsForByte(0x00ab11),
    GenerateConditionsForByte(0x00ab12),
    GenerateConditionsForByte(0x00ab13),
    GenerateConditionsForByte(0x00ab14),
    GenerateConditionsForByte(0x00ab15),
    GenerateConditionsForByte(0x00ab16),
    GenerateConditionsForByte(0x00ab17),
    GenerateConditionsForByte(0x00ab18),
    GenerateConditionsForByte(0x00ab19),
    GenerateConditionsForByte(0x00ab1a),
    GenerateConditionsForByte(0x00ab1b),
    GenerateConditionsForByte(0x00ab1c),
    GenerateConditionsForByte(0x00ab1d),
    GenerateConditionsForByte(0x00ab1e)
]


figurineConditions = {}
count = 0
for element in figurineConditionsArr
{
    for i in element
    {
        figurineConditions[count] = element[i]
        count = count + 1
    }
}

figurineConditions[count] = { "countsWhen": (bit0(0x00ab1f) == 1), "recalculateWhen": (Delta(bit0(0x00ab1f)) == 0 && bit0(0x00ab1f) == 1) }

GenerateSaveProtectedAchievementFromConditions({
    "name": "Carlov Medal",
    "description": "Collect all 136 Figurines",
    "points": 25,
    "threshold": 136,
    "badge": "155842",
    "id": 2310
}, figurineConditions)

achievement(
    title = "Bested Big Green Chuchu [m]", description = "Defeat the Big Green Chuchu without taking damage", points = 10,
    id = 2078, badge = "155845", published = "8/5/2013 5:15:22 AM", modified = "8/5/2013 5:31:38 AM",
    trigger = once(ScreenIdByte() == 0x48) && once(byte(0x000BF5) == 0x17) && never(byte(0x000BF5) == 0x0B) && 
              ScreenIdWord() == 0x0049 && never(byte(0x00AAEA) < Delta(byte(0x00AAEA))) && once(byte(0x00188D) == 0xFF) && trigger_when(byte(0x00188D) == 0x00) && 
              never(bit0(0x00AB42) < Delta(bit0(0x00AB42))) && bit0(0x00AB42) == 0x1
)

function FirstTimeGameBeaten() => bit0(0x00AA46) > Delta(bit0(0x00AA46))

achievement(
    title = "Courage", description = "Restore peace to Hyrule with only 3 Heart Containers", points = 50,
    id = 2311, badge = "155844", published = "8/19/2013 10:10:52 PM", modified = "8/16/2021 2:20:45 AM",
    trigger = ScreenIdWord() == 129 && byte(0x00AAEB) == 24 &&
              (trigger_when(FirstTimeGameBeaten()) || trigger_when(CreditsLoaded()))
)

achievement(
    title = "Hero of Hyrule", description = "Restore peace to Hyrule", points = 25,
    id = 2312, badge = "155846", published = "8/19/2013 10:11:40 PM", modified = "1/30/2021 2:31:07 PM",
    trigger = ScreenIdWord() == 129 && (FirstTimeGameBeaten() || CreditsLoaded())
)

achievement(
    title = "Bested Gleerok [m]", description = "Defeat Gleerok without taking damage", points = 25,
    id = 2086, badge = "155847", published = "8/7/2013 9:26:09 AM", modified = "8/16/2021 2:22:15 AM",
    trigger = never(byte(0x00AAEA) < Delta(byte(0x00AAEA))) && once(byte(0x0015E5) == 255) && 
              trigger_when(byte(0x0015E5) == 0) && never(byte(0x000BF5) == 23) && once(byte(0x000BF5) == 18) && once(ScreenIdByte() == 80) && 
              ScreenIdByte() == 81 && byte(0x000BF5) == 0 && once(bit2(0x00AB42) > Delta(bit2(0x00AB42))) && 
              never(bit2(0x00AB42) < Delta(bit2(0x00AB42))) && never(ScreenIdByte() == 6)
)

achievement(
    title = "Bested Mazaal [m]", description = "Defeat Mazaal without taking damage", points = 25,
    id = 2188, badge = "155849", published = "8/12/2013 7:16:01 PM", modified = "1/30/2021 2:31:16 PM",
    trigger = once(ScreenIdWord() == 344) && once(ScreenIdWord() == 346) && once(ScreenIdWord() == 90) && 
              ScreenIdWord() == 89 && once(ScreenIdWord() == 5720) && never(ScreenIdWord() == 1112) && 
              never(byte(0x00AAEA) < Delta(byte(0x00AAEA))) && once(bit6(0x00AB37) > Delta(bit6(0x00AB37))) && never(bit6(0x00AB37) < Delta(bit6(0x00AB37)))
)

achievement(
    title = "Gambler", description = "Win 270 Rupees or more at the Chest Mini-Game Shop", points = 25,
    id = 2344, badge = "155848", published = "8/20/2013 4:22:53 AM", modified = "1/30/2021 2:31:13 PM",
    trigger = word(0x0010A6) >= 270 && ScreenIdWord() == 1571
)

achievement(
    title = "Bested Big Blue Chuchu [m]", description = "Defeat the Big Blue Chuchu without taking damage", points = 25,
    id = 2198, badge = "155850", published = "8/14/2013 8:36:42 PM", modified = "8/16/2021 2:24:31 AM",
    trigger = bit6(0x00AD8C) == 1 && once(bit6(0x00AD8C) > Delta(bit6(0x00AD8C))) && 
              never(bit6(0x00AD8C) < Delta(bit6(0x00AD8C))) && ScreenIdWord() == 4192 && once(byte(0x00188D) == 255) && trigger_when(byte(0x00188D) == 0) && 
              trigger_when(bit0(0x03C364) == 0) &&
              trigger_when(once(bit0(0x03C364) < Delta(bit0(0x03C364)))) &&
              never(byte(0x000BF5) == 15) && 
              never(byte(0x00AAEA) < Delta(byte(0x00AAEA)))
)

achievement(
    title = "Bested Big Octorok [m]", description = "Defeat the Big Octorok without taking damage", points = 25,
    id = 2245, badge = "155851", published = "8/15/2013 10:33:00 AM", modified = "1/30/2021 2:31:18 PM",
    trigger = never(ScreenIdWord() == 1888) && never(ScreenIdWord() == 2912) && never(ScreenIdWord() == 2400) && 
              never(ScreenIdWord() == 864) && once(ScreenIdWord() == 2144) && ScreenIdWord() == 3680 && bit4(0x00AB42) == 1 && 
              once(bit4(0x00AB42) > Delta(bit4(0x00AB42))) && never(bit4(0x00AB42) < Delta(bit4(0x00AB42))) && never(byte(0x00AAEB) > Delta(byte(0x00AAEB))) && 
              once(byte(0x0017B4) == 1) && once(byte(0x0017B4) == 2) && once(byte(0x0017B4) == 3) && once(byte(0x0017B4) == 4) && 
              byte(0x0017B4) == 0 && byte(0x00177D) == 0 && never(byte(0x00AAEA) < Delta(byte(0x00AAEA)))
)

achievement(
    title = "Bested Vaati", description = "Defeat Vaati without taking damage", points = 100,
    id = 2313, badge = "155853", published = "8/19/2013 11:38:00 PM", modified = "1/30/2021 2:31:20 PM",
    trigger = once(ScreenIdWord() == 1672) && once(byte(0x00ADC3) == 96) && once(byte(0x00ADC3) == 97) && 
              once(byte(0x00ADC3) == 105) && once(byte(0x00ADC3) == 107) && once(byte(0x00ADC3) == 111) && byte(0x00ADC3) == 239 && 
              never(byte(0x00ADC3) < Delta(byte(0x00ADC3))) && repeated(5, byte(0x00ADC3) > Delta(byte(0x00ADC3))) && never(byte(0x00ADC3) < 96) && 
              never(byte(0x00AAEA) < Delta(byte(0x00AAEA))) && ScreenIdWord() == 393
)

rich_presence_conditional_display(((byte(0x00AAEB) == 0 && prior(byte(0x00AAEB)) == 0) ||
     (byte(0x00AAEB) == 255) ||
     (word(0x00AAC0) == 0 && word(0x00AAC2) == 0)), "In the Titlescreen")

rich_presence_display("{0}{1}{2}{3}{4}{5} [❤️{6}] [🗽{7}] [🧿{8}]",
    rich_presence_lookup("Name", byte(0x00AAC0), NameLookup),
    rich_presence_lookup("Name", byte(0x00AAC1), NameLookup),
    rich_presence_lookup("Name", byte(0x00AAC2), NameLookup),
    rich_presence_lookup("Name", byte(0x00AAC3), NameLookup),
    rich_presence_lookup("Name", byte(0x00AAC4), NameLookup),
    rich_presence_lookup("Name", byte(0x00AAC5), NameLookup),
    rich_presence_lookup("Hearts", byte(0x00AAEB), HeartsLookup),
    rich_presence_value("Figurines", byte(0x00AAF0)),
    rich_presence_value("Fusions", byte(0x00AB57))
)

