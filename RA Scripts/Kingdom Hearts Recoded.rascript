// Kingdom Hearts Re:coded
// #ID = 14828

function Delta(addr) => prev(addr)

// $056130: Steps taken (?) (32-bit)

// $0569CC: System timer (32-bit)
//          
//          Increments by 1 every frame.
function systemTimer() => dword(0x0569CC)

// $056E9C: Total time played. Increments by 1 every seven or eight frames (alternates between the two) - 32-bit
//          
//          8 'ticks' ~= 1 second
function playTime() => dword(0x056E9C)

// $0604FC: Button input
//          Bit 0 - A
//          Bit 1 - B
//          Bit 2 - Select
//          Bit 3 - Start
//          Bit 4 - Right
//          Bit 5 - Left
//          Bit 6 - Up
//          Bit 7 - Down
// $0604FD: Button input
//          Bit 0 - R
//          Bit 1 - L
//          Bit 2 - X
//          Bit 3 - Y
// $0608D4: Ability set for clock level 2 - 16-bit
// $0608D6: Ability set for clock level 3 - 16-bit
// $0608D8: Ability set for clock level MAX - 16-bit

// $060B51: < LV PLAYER SORA >
function level() => byte(0x060B51)

// $060B52: < HP PLAYER - SORA >
function hp() => byte(0x060B52)

// $060B54: Sora's max HP - 16-bit
function maxHP() => word(0x060B54)

// $060B56: < STRENGTH STATS - SORA >
function strength() => byte(0x060B56)

// $060B58: < MAGIC  STATS - SORA >
function magic() => byte(0x060B58)

// $060B5A: < DEFENSE STATS - SORA >
function defense() => byte(0x060B5A)

// $060B5C: Sora's Luck - 16-bit
function luck() => word(0x060B5C)

// $060B6E: Level of current Keyblade?
// $0A04A8: Pointer for the clock gauge
//          {Offset 0x0474} - Clock gauge level
//          - 0x00 - Level 1
//          - 0x01 - Level 2
//          - 0x02 - Level 3
//          - 0x03 - MAX
//          {Offset 0x0476} - Clock gauge meter - 16-bit
//          - 0x0000 through 0x03e8 (1,000) - Level 1
//          - 0x03e8 through 0x0f3c (3,900) - Level 2
//          - 0x0f3c through 0x1b58 (7,000) - Level 3
//          - 0x1b58 through 0x283c (10,300) - MAX
// $0A04B4: Pointer for commands
//          {Offset 0xec} - Index of currently selected command
//          {Offset 0xf0} - Index of last selected command
// $0BEEA8: Start of the rewards items' data for the system sector on Destiny Islands
//          
//          Type of item 1 at the end of the system sector on Destiny Islands - 16-bit
// $0BEEAA: Level of item 1 at the end of the system sector on Destiny Islands
// $0BEEAC: Price of item 1 at the end of the system sector on Destiny Islands - 32-bit
// $0BEEB0: 0x01 - Makes item 1 at the end of the system sector on Destiny Islands purchasable only once
// $0BEEE4: End of the rewards items' data for the system sector on Destiny Islands
// $0BEFA4: Start of the rewards items' data for the system sector in Traverse Town: Second District
// $0BEFE0: End of the rewards items' data for the system sector in Traverse Town: Second District
// $0D18E0: Pointer for cursor coordinates in the Stat Matrix
//          {Offset 0x28} - x position of cursor in the Stat Matrix - 16-bit
//          {Offset 0x2a} - y position of cursor in the Stat Matrix - 16-bit
// $195B3B: Rare prize blox flags
//          Bit 5 - Destiny Islands - Blank Chip
//          Bit 7 - Destiny Islands - HP +2 chip
// $195B4B: Bit 6 - Found the first backdoor on Destiny Islands
// $195B68: Start of defeated enemies in Enemy Profiles. Each enemy's count is represented by a 17-bit (WTF, Square?) value, which means each enemy shares a byte with another.
//          
//          Bit 0 - Darkside - 4
//          Bit 1 - Darkside - 8
//          Bit 2 - Darkside - 16
//          Bit 3 - Darkside - 32
//          Bit 4 - Darkside - 64
//          Bit 5 - Darkside - 128
//          Bit 6 - Darkside - 256
//          Bit 7 - Darkside - 512
// $195B69: Bit 0 - Darkside - 1,024
//          Bit 1 - Darkside - 2,048
//          Bit 2 - Darkside - 4,096
//          Bit 3 - Darkside - 8,192
//          Bit 4 - Darkside - 16,384
//          Bit 5 - Darkside - 32,768
//          Bit 6 - Darkside - 65,536
//          Bit 7 - Shadow - 1
// $195B6A: Bit 0 - Shadow - 2
//          Bit 1 - Shadow - 4
//          Bit 2 - Shadow - 8
//          Bit 3 - Shadow - 16
//          Bit 4 - Shadow - 32
//          Bit 5 - Shadow - 64
//          Bit 6 - Shadow - 128
//          Bit 7 - Shadow - 256
// $195B6B: Bit 0 - Shadow - 512
//          Bit 1 - Shadow - 1,024
//          Bit 2 - Shadow - 2,048
//          Bit 3 - Shadow - 4,096
//          Bit 4 - Shadow - 8,192
//          Bit 5 - Shadow - 16,384
//          Bit 6 - Shadow - 32,768
//          Bit 7 - Shadow - 65,536
// $195B6C: Bit 0 - Soldier - 16
//          Bit 1 - Soldier - 32
//          Bit 2 - Soldier - 64
//          Bit 3 - Soldier - 128
//          Bit 4 - Soldier - 256
//          Bit 5 - Soldier - 512
//          Bit 6 - Soldier - 1,024
//          Bit 7 - Soldier - 2,048
// $195B6D: Bit 0 - Soldier - 4,096
//          Bit 1 - Soldier - 8,192
//          Bit 2 - Soldier - 16,384
//          Bit 3 - Soldier - 32,768
//          Bit 4 - Soldier - 65,536
//          Bit 5 - Tidus - 1
//          Bit 6 - Tidus - 2
//          Bit 7 - Tidus - 4
// $195B6E: Bit 0 - Tidus - 8
//          Bit 1 - Tidus - 16
//          Bit 2 - Tidus - 32
//          Bit 3 - Tidus - 64
//          Bit 4 - Tidus - 128
//          Bit 5 - Tidus - 256
//          Bit 6 - Tidus - 512
//          Bit 7 - Tidus - 1,024
// $195B6F: Bit 0 - Tidus - 2,048
//          Bit 1 - Tidus - 4,096
//          Bit 2 - Tidus - 8,192
//          Bit 3 - Tidus - 16,384
//          Bit 4 - Tidus - 32,768
//          Bit 5 - Tidus - 65,536
//          Bit 6 - Darkside - 1
//          Bit 7 - Darkside - 2
// $195B70: Bit 0 - Red Nocturne - 64
//          Bit 1 - Red Nocturne - 128
//          Bit 2 - Red Nocturne - 256
//          Bit 3 - Red Nocturne - 512
//          Bit 4 - Red Nocturne - 1,024
//          Bit 5 - Red Nocturne - 2,048
//          Bit 6 - Red Nocturne - 4,096
//          Bit 7 - Red Nocturne - 8,192
// $195B71: Bit 0 - Red Nocturne - 16,384
//          Bit 1 - Red Nocturne - 32,768
//          Bit 2 - Red Nocturne - 65,536
//          Bit 3 - Large Body - 1
//          Bit 4 - Large Body - 2
//          Bit 5 - Large Body - 4
//          Bit 6 - Large Body - 8
//          Bit 7 - Large Body - 16
// $195B72: Bit 0 - Large Body - 32
//          Bit 1 - Large Body - 64
//          Bit 2 - Large Body - 128
//          Bit 3 - Large Body - 256
//          Bit 4 - Large Body - 512
//          Bit 5 - Large Body - 1,024
//          Bit 6 - Large Body - 2,048
//          Bit 7 - Large Body - 4,096
// $195B73: Bit 0 - Large Body - 8,192
//          Bit 1 - Large Body - 16,384
//          Bit 2 - Large Body - 32,768
//          Bit 3 - Large Body - 65,536
//          Bit 4 - Soldier - 1
//          Bit 5 - Soldier - 2
//          Bit 6 - Soldier - 4
//          Bit 7 - Soldier - 8
// $195B74: Bit 0 - Yellow Opera - 256
//          Bit 1 - Yellow Opera - 512
//          Bit 2 - Yellow Opera - 1,024
//          Bit 3 - Yellow Opera - 2,048
//          Bit 4 - Yellow Opera - 4,096
//          Bit 5 - Yellow Opera - 8,192
//          Bit 6 - Yellow Opera - 16,384
//          Bit 7 - Yellow Opera - 32,768
// $195B75: Bit 0 - Yellow Opera - 65,536
//          Bit 1 - Guard Armor - 1
//          Bit 2 - Guard Armor - 2
//          Bit 3 - Guard Armor - 4
//          Bit 4 - Guard Armor - 8
//          Bit 5 - Guard Armor - 16
//          Bit 6 - Guard Armor - 32
//          Bit 7 - Guard Armor - 64
// $195B76: Bit 0 - Guard Armor - 128
//          Bit 1 - Guard Armor - 256
//          Bit 2 - Guard Armor - 512
//          Bit 3 - Guard Armor - 1,024
//          Bit 4 - Guard Armor - 2,048
//          Bit 5 - Guard Armor - 4,096
//          Bit 6 - Guard Armor - 8,192
//          Bit 7 - Guard Armor - 16,384
// $195B77: Bit 0 - Guard Armor - 32,768
//          Bit 1 - Guard Armor - 65,536
//          Bit 2 - Red Nocturne - 1
//          Bit 3 - Red Nocturne - 2
//          Bit 4 - Red Nocturne - 4
//          Bit 5 - Red Nocturne - 8
//          Bit 6 - Red Nocturne - 16
//          Bit 7 - Red Nocturne - 32
// $195BDE: Bits 5-7: Worlds completed with 1 HP
// $195BDF: Bits 0-4: Worlds completed with 1 HP cheat
//          Bits 5-7: Worlds completed on Critical
// $195BF8: Bit 0 - Magic casts - 64
//          Bit 1 - Magic casts - 128
//          Bit 2 - Magic casts - 256
//          Bit 3 - Magic casts - 512
//          Bit 4 - Magic casts - 1,024
//          Bit 5 - Magic casts - 2,048
//          Bit 6 - Magic casts - 4,096
//          Bit 7 - Magic casts - 8,192
// $195BF9: Bit 0 - Magic casts - 16,384
//          Bit 1 - Magic casts - 32,768
//          Bit 2 - Magic casts - 65,536
//          Bit 3 - Command conversions - 1
//          Bit 4 - Command conversions - 2
//          Bit 5 - Command conversions - 4
//          Bit 6 - Command conversions - 8
//          Bit 7 - Command conversions - 16
// $195BFA: Bit 0 - Command conversions - 32
//          Bit 1 - Command conversions - 64
//          Bit 2 - Command conversions - 128
//          Bit 3 - Command conversions - 256
//          Bit 4 - Command conversions - 512
//          Bit 5 - Command conversions - 1,024
//          Bit 6 - Command conversions - 2,048
//          Bit 7 - Command conversions - 4,096
// $195BFB: Bit 0 - Command conversions - 8,192
//          Bit 1 - Command conversions - 16,384
//          Bit 2 - Command conversions - 32,768
//          Bit 3 - Command conversions - 65,536
//          Bit 4 - Blox destroyed - 1
//          Bit 5 - Blox destroyed - 2
//          Bit 6 - Blox destroyed - 4
//          Bit 7 - Blox destroyed - 8
// $195BFF: Bit 2 - Magic casts - 1
//          Bit 3 - Magic casts - 2
//          Bit 4 - Magic casts - 4
//          Bit 5 - Magic casts - 8
//          Bit 6 - Magic casts - 16
//          Bit 7 - Magic casts - 32
// $195C15: Amount of chips installed in the Stat Matrix?
// $195C78: Bit 0: Champion Collector trophy
//          Bit 1: Cheater trophy
//          Bit 2: Sultan of Slot trophy
//          Bit 3: Sector Sweeper trophy
//          Bit 4: Lord of Loot trophy
//          Bit 5: Rare Prize Roundup trophy
// $195C7D: Bit 0: W8 Speed Runner trophy
//          Bit 1: W7 Speed Runner trophy
//          Bit 2: W6 Speed Runner trophy
//          Bit 3: W5 Speed Runner trophy
//          Bit 4: W4 Speed Runner trophy
//          Bit 5: W3 Speed Runner trophy
//          Bit 6: W2 Speed Runner trophy
//          Bit 7: W1 Speed Runner trophy
// $195C7E: Bit 0: Technician trophy
//          Bit 1: Fatal Flawless trophy (?)
//          Bit 2: Critical Acclaim trophy
//          Bit 3: Proud Achievement trophy
//          Bit 4: Quest Bester trophy
//          Bit 5: Closed Book trophy
//          Bit 6: Command Master trophy
//          Bit 7: Converter CR LV 100 trophy
// $195C7F: Bit 0: Converter LV 100 trophy
//          Bit 1: Weapon Wizard trophy
//          Bit 2: Justice for All trophy
//          Bit 3: Twilight Triumph trophy
//          Bit 4: Eliminator's End trophy
//          Bit 5: Icer of Titans trophy
//          Bit 6: Avatar Sweeper trophy
//          Bit 7: Avatar Collector trophy
// $195C80: Bit 1 - Viewed Installing Chips tutorial in the Stat Matrix
//          Bit 2 - Viewed The Stat Matrix tutorial in the Stat Matrix
//          Bit 3 - Viewed The Debug Reports tutorial in the Debug Reports
//          Bit 4 - Viewed one of the tutorials on the field (it is not known which)
//          Bit 5 - Viewed one of the tutorials on the field (it is not known which)
//          Bit 6 - Viewed EXP (Experience) tutorial on the field
//          Bit 7 - Viewed Prizes tutorial on the field
// $195C81: Bit 1 - Viewed The Command Deck tutorial on the field
//          Bits 2 and 3 - Viewed The "Attack" Command and The HP Gauge tutorials on the field
//          Bit 4 - Viewed the message telling the player to examine the strange door in the Station of Awakening
//          Bit 6 - Viewed the Controls tutorial on the field
// $195C85: Bit 2 - Viewed Installing Commands tutorial in the Command Matrix
//          Bit 3 - Viewed The Command Matrix tutorial in the Command Matrix
//          Bit 5 - Viewed Auto-Jump tutorial on the field
//          Bit 6 - Viewed The Map tutorial on the field
//          Bit 7 - Viewed Save Points tutorial on the field
// $195C86: Bit 6 - Viewed CPUs tutorial in the Stat Matrix
// $195C87: Bit 1 - Viewed Bonus Boosters tutorial in the Stat Matrix
//          Bit 6 - Viewed The Difficulty Cheat tutorial in the Stat Matrix
// $195C88: Bit 0 - Viewed The Clock Ability Tree tutorial on the field
//          Bit 1 - Viewed Overclocks tutorial on the field
//          Bit 5 - Viewed Accessory Chips tutorial in the Gear Matrix
//          Bit 6 - Viewed Finish Command Chips tutorial in the Gear Matrix
// $195C89: Bit 4 - Viewed Keyblade Chips tutorial in the Gear Matrix
//          Bit 5 - Viewed The Gear Matrix tutorial in the Gear Matrix
// $195C8A: Bit 0 - Viewed Locking On tutorial on the field
//          Bit 3 - Viewed SP (Sector Points) tutorial on the field
//          Bit 7 - Viewed Sector Debug tutorial on the field
// $195C8B: Bit 0 - Viewed System Sectors tutorial on the field
//          Bits 2 and 3 - Viewed Locating Backdoors tutorial on the field
//          Bit 4 - Viewed Stat Chips tutorial on the field
//          Bit 6 - Viewed the Blox Types or Rare Prize Blox tutorial on the field
//          Bit 7 - Viewed Blox tutorial on the field
// $195C8C: Bit 2 - Viewed Adjusting the Camera tutorial on the field
// $195C8E: Bit 7 - Viewed the Blox Types or Rare Prize Blox tutorial on the field
// $195C8F: Bit 1 - Viewed one of the tutorials on the field (it is not known which)
//          Bit 3 - Viewed Links tutorial on the field
//          Bit 4 - Viewed the second part of Finish Commands tutorial on the field
//          Bit 5 - Viewed the first part of Finish Commands tutorial on the field
// $195C97: Bit 0 - Viewed Choosing Abilities tutorial on the field
//          Bit 5 - Viewed Upgrading Keyblades tutorial on the field
// $195C98: Flags for the Tutorials menu
//          Bit 1 - Viewed Installing Chips
//          Bit 2 - Viewed The Stat Matrix
//          Bits 5 and 6 - Viewed EXP (Experience)
//          Bit 7 - Viewed Prizes
// $195C99: Flags for the Tutorials menu
//          Bit 1 - Viewed The Command Deck
//          Bit 2 - Viewed The HP Gauge
//          Bit 3 - Viewed The "Attack" Command
//          Bit 6 - Viewed Controls
// $195C9E: Flags for the Tutorials menu
//          Bit 6 - Viewed CPUs
// $195CA0: Flags for the Tutorials menu
//          Bit 1 - Viewed Overclocks
// $195CA2: Flags for the Tutorials menu
//          Bit 0 - Viewed Locking On
// $195CA4: Flags for the Tutorials menu
//          Bit 2 - Viewed Adjusting the Camera
// $195CA7: Flags for the Tutorials menu
//          Bits 4 and 5 - Viewed Finish Commands tutorial
// $195CB1: Story flags
//          Bit 3 - Entered the Secret Place on Destiny Islands
//          Bit 5 - Examined the strange door in the Station of Awakening that takes the player to Destiny Islands
//          Bit 6 - Viewed the cutscene where Sora finds out he can use the Keyblade
//          Bit 7 - Viewed the opening movies at the beginning of the game
// $195CC5: Bit 5 - Opened the Debug Reports for the first time
// $195CDF: Flags for Enemy Profiles in the Debug Reports
//          Bit 1 - Viewed Large Body
//          Bit 3 - Viewed Tidus
//          Bit 4 - Viewed Darkside
//          Bit 5 - Viewed Shadow
// $195CE4: Flags for Character Files in the Debug Reports
//          Bit 3 - Viewed Tidus
//          Bit 4 - Viewed Wakka
//          Bit 5 - Viewed Selphie
//          Bit 6 - Viewed ? ? ?
//          Bit 7 - Viewed Jiminy Cricket
// $195CE5: Flags for Character Files in the Debug Reports
//          Bit 0 - Viewed Dale
//          Bit 1 - Viewed Chip
//          Bit 2 - Viewed King Mickey
//          Bit 3 - Viewed Goofy
//          Bit 4 - Viewed Donald Duck
//          Bit 5 - Viewed Sora
// $195CE7: Flags for Story in the Debug Reports
//          Bit 5 - Viewed Destiny Islands
// $198310: Bits 1 and 2: Difficulty level (2-bit)
//          - 0x0 = Beginner Mode
//          - 0x1 = Standard Mode
//          - 0x2 = Proud Mode
//          - 0x3 = Critical Mode
//          Bit 5: Camera y-axis is inverted
//          Bit 6: Camera x-axis is inverted
//          Bits 3 and 4: Camera speed
//          - !3 and !4 = slow
//          - 3 and !4 = normal
//          - !3 and 4 = fast
// $198322: Flags for one-time items redeemed in system sectors
//          Bit 0 - Destiny Islands - Power Armlet
//          Bit 1 - Destiny Islands - Strength +1
//          Bit 2 - Destiny Islands - Magic +1
//          Bit 3 - Destiny Islands - Defense +1
//          Bit 4 - Destiny Islands - Blank Chip
// $198328: Flags for one-time items redeemed in system sectors
//          Bit 0 - Traverse Town: Second District - Fire Charm
//          Bit 1 - Traverse Town: Second District - HP +2
//          Bit 2 - Traverse Town: Second District - Magic +1
// $198364: EXP (32-bit)
// $198368: Munny (32-bit)
// $19836D: Music ID(?) (8-bit)
// $198370: Bit 0 - Chose the power of the warrior?
// $198371: Bit 0 - Gave up the power of the guardian?
// $198372: Bit 0 - Chose the power of the guardian?
// $198374: Bit 0 - Gave up the power of the mystic?
// $1983A7: Bit 0 - Chose the power of the mystic?
// $1983B6: Bit 0 - Gave up the power of the warrior?
// $198400: Amount of Level Up chips obtained
// $198401: Amount of Blank Chips obtained
// $198402: Amount of HP +2 chips obtained
// $198403: Amount of HP +4 chips obtained
// $198404: Amount of HP +6 chips obtained
// $198405: Amount of HP +8 chips obtained
// $198406: Amount of Strength +1 chips obtained
// $198407: Amount of Strength +2 chips obtained
// $198408: Amount of Strength +3 chips obtained
// $198409: Amount of Strength +4 chips obtained
// $19840A: Amount of Magic +1 chips obtained
// $19840B: Amount of Magic +2 chips obtained
// $19840C: Amount of Magic +3 chips obtained
// $19840D: Amount of Magic +4 chips obtained
// $19840E: Amount of Defense +1 chips obtained
// $19840F: Amount of Defense +2 chips obtained
// $198410: Amount of Defense +3 chips obtained
// $198411: Amount of Defense +4 chips obtained
// $198412: Amount of Lucky Strike chips obtained
// $1986F0: Active abilities
//          Bit 0 - Dodge Roll
//          Bit 1 - Scan
//          Bit 2 - Combo Plus
//          Bit 3 - Block
//          Bit 4 - High Jump
//          Bit 5 - Aerial Recovery
//          Bit 6 - Air Combo Plus
//          Bit 7 - Air Slide
// $1986F1: Active abilities
//          Bit 0 - Scan
//          Bit 1 - Haste
//          Bit 2 - Leaf Bracer
//          Bit 3 - Combo Plus
//          Bit 4 - Air Combo Plus
//          Bit 5 - Aerial Payback
//          Bit 6 - Dodge Roll
//          Bit 7 - Finishing Plus
// $1986F2: Active abilities
//          Bit 0 - Air Slide
//          Bit 1 - Air Slide
//          Bit 2 - Haste
//          Bit 3 - Scan
//          Bit 4 - Air Combo Plus
//          Bit 5 - Combo Plus
//          Bit 6 - Finishing Plus
//          Bit 7 - Glide
// $1986F3: Active abilities
//          Bit 0 - Scan
//          Bit 1 - Glide
//          Bit 2 - Combo Master
//          Bit 3 - Attack Haste
//          Bit 4 - Targeting Scope
//          Bit 5 - All Critical
//          Bit 6 - Full Swing
//          Bit 7 - Zantetsu Prime
// $1986FA: Difficulty
//          0x00 - Beginner
//          0x01 - Standard
//          0x02 - Proud
//          0x03 - Critical
// $1986FB: Sora's and enemies' HP modifier. 0x64 is 100 percent
// $198704: Bit 0 - The Difficulty Cheat is useable
// $1987B6: Start of chips in the Stat Matrix
//          0x00 - Level Up
//          0x01 - Blank Chip
//          0x02 - HP +2
//          0x03 - HP +4
//          0x04 - HP +6
//          0x05 - HP +8
//          0x06 - Strength +1
//          0x07 - Strength +2
//          0x08 - Strength +3
//          0x09 - Strength +4
//          0x0a - Magic +1
//          0x0b - Magic +2
//          0x0c - Magic +3
//          0x0d - Magic +4
//          0x0e - Defense +1
//          0x0f - Defense +2
//          0x10 - Defense +3
//          0x11 - Defense +4
//          0x12 - Lucky Strike
// $19884C: Current Keyblade. Values left out are higher level versions of the Keyblades - 16-bit
//          0x00d0 - Kingdom Key
//          0x00d5 - Wishing Star
//          0x00da - Lady Luck
//          0x00df - Olympia
//          0x00e4 - Three Wishes
//          0x00e9 - Oblivion
//          0x00ee - Zero/One
//          0x00f3 - Oathkeeper
//          0x00f8 - Metal Chocobo
//          0x00fd - Lionheart
//          0x0102 - Ultima Weapon
// $19884E: Current Finish command - 16-bit
//          0x0110 - Blade Rush
//          0x0111 - Energy Bomb
//          0x0112 - Faith
//          0x0113 - Mega Flare
//          0x0114 - Meteor Rain
//          0x0115 - Zone of Ruin
//          0x0116 - Speed Combo
//          0x0117 - Star Rave
//          0x0118 - Spinner Saw
//          0x0119 - D-Fira
//          0x011a - D-Blizzara
//          0x011b - D-Thundara
//          0x011c - D-Firaga
//          0x011d - D-Blizzaga
//          0x011e - D-Thundaga
// $198850: Accessory 1 - 16-bit
//          0x0120 - Armor Bangle
//          0x0121 - Counter Ring
//          0x0122 - Command Ring
//          0x0123 - Payback Ring
//          0x0124 - Energy Earring
//          0x0125 - Power Armlet
//          0x0126 - Wizard's Armlet
//          0x0127 - Safeguard Armlet
//          0x0128 - Half-moon Armlet
//          0x0129 - Strike Armlet
//          0x012a - CMOS Armlet
//          0x012b - CMOS Necklace
//          0x012c - Immortal Charm
//          0x012d - Eternity Charm
//          0x012e - Fire Charm
//          0x012f - Blizzard Charm
//          0x0130 - Thunder Charm
//          0x0131 - Heavy Chain
//          0x0132 - Zip Watch
//          0x0133 - Compass
//          0x0134 - Feather Chain
//          0x0135 - Night Lenses
//          0x0136 - Adamant Belt
//          0x0137 - Liberty Crown
//          0x0138 - Heat Sink Belt
// $198858: Amount of uses left of the command in slot 1 if it is an item
// $19885C: Amount of uses left of the command in slot 2 if it is an item
// $198860: Amount of uses left of the command in slot 3 if it is an item
// $198878: Keyblade EXP - 16-bit
// $198898: Controls various things about command 1 in the inventory. CP is 11-bit, starting at bit 5
// $19889A: Bit 0 - Command 1 in the inventory is useable
// $19889B: Type of command 1 in the inventory
//          0x00 - Quick Blitz
//          0x01 - Sliding Dash
//          0x02 - Round Blitz
//          0x03 - Strike Raid
//          0x04 - Rising Strike
//          0x05 - Sliding Rush
//          0x06 - Aerial Sweep
//          0x07 - Air Sweep
//          0x08 - Aerial Slam
//          0x09 - Land Crash
//          0x0a - Fire Edge
//          0x0b - Blizzard Edge
//          0x0c - Thunder Edge
//          0x0d - Aero Edge
//          0x0e - Heat Dash
//          0x0f - Ice Dash
//          0x10 - Spark Dash
//          0x11 - Wind Dash
//          0x12 - Fire Blast
//          0x13 - Blizzard Blast
//          0x14 - Thunder Blast
//          0x15 - Aero Blast
//          0x16 - Fire Raid
//          0x17 - Blizzard Raid
//          0x18 - Thunder Raid
//          0x19 - Aero Raid
//          0x1a - Fire Buster
//          0x1b - Blizzard Buster
//          0x1c - Thunder Buster
//          0x1d - Aero Buster
//          0x1e - Heat Sweep
//          0x1f - Ice Sweep
//          0x20 - Spark Sweep
//          0x21 - Wind Sweep
//          0x22 - Heat Storm
//          0x23 - Ice Storm
//          0x24 - Spark Storm
//          0x25 - Wind Storm
//          0x26 - Fire Slam
//          0x27 - Blizzard Slam
//          0x28 - Thunder Slam
//          0x29 - Aero Slam
//          0x2a - Heat Dive
//          0x2b - Ice Dive
//          0x2c - Spark Dive
//          0x2d - Wind Dive
//          0x2e - Stun Impact
//          0x2f - Muscle Strike
//          0x30 - Chain Rave
//          0x31 - Rising Rush
//          0x32 - Zantetsuken
//          0x33 - Eruption
//          0x34 - Gravity Drop
//          0x35 - Shock Fall
//          0x36 - Judgment Triad
//          0x37 - Fire
//          0x38 - Fira
//          0x39 - Firaga
//          0x3a - Blizzard
//          0x3b - Blizzara
//          0x3c - Blizzaga
//          0x3d - Thunder
//          0x3e - Thundara
//          0x3f - Thundaga
//          0x40 - Aero
//          0x41 - Aerora
//          0x42 - Aeroga
//          0x43 - Magnet
//          0x44 - Magnera
//          0x45 - Magnega
//          0x46 - Cure
//          0x47 - Cura
//          0x48 - Curaga
//          0x49 - Slow
//          0x4a - Stop
//          0x4b - Confuse
//          0x4c - Firaga Burst
//          0x4d - Triple Firaga
//          0x4e - Triple Burst
//          0x4f - Blizzaga Pursuit
//          0x50 - Triple Blizzaga
//          0x51 - Triple Pursuit
//          0x52 - Thunder Tracer
//          0x53 - Pulse Tracer
//          0x54 - Tornado Tracer
//          0x55 - Wind Tracer
//          0x56 - Magnet Grab
//          0x57 - Esuna
//          0x58 - Flame Fall
//          0x59 - Icicle Mine
//          0x5a - Exo Spark
//          0x5b - Cyclone
//          0x5c - Quake
// $19C513: Bits 1-7 - Amount of blox destroyed on Destiny Islands for Selphie
// $19C542: Temporary flags for Destiny Islands (only one flag is active at a time)?
//          Bit 6 - Triggered the cutscene where Wakka spots a rare prize blox
//          Bit 7 - Wakka asks Sora to find Tidus
// $19C543: Temporary flags for Destiny Islands (only one flag is active at a time)?
//          Bit 1 - Viewed the cutscene with Selphie when first arriving at Destiny Islands
//          Bit 2 - Selphie asks Sora to get rid of some blox
//          Bit 3 - Destroyed 20 blox for Selphie
// $19ED10: Area ID of some sort?
// $19EDA4: Sector Points. Does not update when redeeming them at the end of a system sector. Caps at 0x98967f (32-bit)
// $19EDA8: Amount of Sector Points acquired on the current floor of a system sector. Caps at 0x98967f - 32-bit
// $19EDAC: Amount of times the player has used action commands. Caps at 0x3e7 - 32-bit
//          
//          Resets under certain conditions.
// $19EDB0: Amount of times the player has used magic. Caps at 0x3e7 - 32-bit
//          
//          Resets under certain conditions.
// $19EDB4: Amount of times the player has used Cure magic or healing items. Caps at 0x3e7 - 32-bit
//          
//          Resets under certain conditions.
// $19EDB8: Amount of times the player has used a Finish command - 32-bit
//          
//          Resets under certain conditions.
// $19EDC0: Amount of critical hits Sora has landed. Caps at 0x3e7 - 32-bit
//          
//          Resets under certain conditions.
// $19EDC4: Amount of times the player has jumped. Caps at 0x3e7 - 32-bit
//          
//          Resets under certain conditions.
// $19EDC8: Amount of items the player has picked up from enemies or blox - 32-bit
//          
//          Resets under certain conditions.
// $19EDCC: Amount of times the player has taken damage. Caps at 0x3e7 - 32-bit
//          
//          Resets under certain conditions.
// $19EDD0: Amount of times the player has used melee attacks. Caps at 0x3e7 - 32-bit
//          
//          Resets under certain conditions.
// $19EDD4: Amount of times the player has missed with melee attacks. Hitting walls and objects does not increment it. Caps at 0x3e7 - 32-bit
//          
//          Resets under certain conditions.
// $19EDD8: Amount of time the player has spent on the ground. Increments by 1 every other frame. Caps at 0xf423f - 32-bit
//          
//          Resets under certain conditions.
// $19EDDC: Amount of time the player has spent in the air. Increments by 1 every other frame. Caps at 0xf423f - 32-bit
//          
//          Resets under certain conditions.
// $19EDE4: Amount of enemies defeated while the clock level is at MAX. Caps at 0x1869f - 32-bit
//          
//          Resets under certain conditions.
// $19EDEC: Enemies defeated. Caps at 0x1869f - 32-bit
//          
//          Resets under certain conditions.
// $19EDF0: Amount of times the player has defeated enemies with Fire magic? Caps at 0x1869f - 32-bit
//          
//          Resets under certain conditions.
// $19EDFC: Amount of times the player has paralyzed enemies with Thunder magic?
//          
//          Resets under certain conditions.
// $19EE0C: Amount of bug baddies defeated. Caps at 0x1869f - 32-bit
//          
//          Resets under certain conditions.
// $19EE10: Amount of blox destroyed. Caps at 0x1869f - 32-bit
//          
//          Resets under certain conditions.
// $1A3AF8: Start of chips in the Stat Matrix
// $1A47B4: Pointer for the player's coordinates ouside of system sectors
//          {Offset 0xb8} - Player's x position - 32-bit
//          {Offset 0xbc} - Player's y position - 32-bit
//          {Offset 0xc0} - Player's z position - 32-bit
// $1A48B4: Pointer for the player's coordinates in system sectors
//          {Offset 0xb8} - Player's x position - 32-bit
//          {Offset 0xbc} - Player's y position - 32-bit
//          {Offset 0xc0} - Player's z position - 32-bit
// $1AB518: x position of one enemy - 32-bit
//          
//          Enemy data like this seems to be about 0x3c8 bytes long, as the same information for the next enemy is that far ahead of the last
// $1AB8E0: x position of one enemy - 32-bit
// $1ABCA8: x position of one enemy - 32-bit
// $1AC070: x position of one enemy - 32-bit
// $1AC438: x position of one enemy - 32-bit
// $1D86D4: Enemy 1's status?
//          0x01 - First loading in when Sora is near
//          0x02 - Appearing animation
//          0x03 - Normal combat behavior
//          0x05 - Taken damage
//          0x06 - Disappearing when Sora gets too far away
//          0x07 - Death animation
//          0x08 - Disappearing due to death
// $1D8744: Enemy 1's HP outside of system sectors - 32-bit
// $1D8874: Time until enemy 1 does an action outside of a system sector. Decrements by 0x1000 every two frames - 32-bit
// $225E48: Index of currently selected command
// $244058: Main menu - Option index
// $2EA17B: Health of one rare prize blox
// $2EB0FB: Health of one rare prize blox
// $3D8034: Scrolling x position for the map - 32-bit
// $3D8038: Scrolling y position for the map - 32-bit
// $3D8055: Player's icon's x position on the map (relative to the screen) - 16-bit
// $3D8059: Player's icon's y position on the map (relative to the screen) - 16-bit
// $3D805C: Bit 3 - Turns on the pointer arrow for the player's icon on the map
// $3DE2AC: Sector Points. Updates when finishing a floor or redeeming them at the end of a system sector - 32-bit
// $3DE2BC: Displayed amount of enemies defeated on the current system sector floor - 16-bit
// $3DE2BE: Display cap for the amount of bug baddies defeated on the current system sector floor - 16-bit

// Game status(?) (Changes depending on game state and appears to have a detrimental effect when frozen)
//
// 0x0 = various; also seems to be a value this address flickers to when transitioning between some game states
// 0x3 = on the Title Screen
// 0x7 = text cutscene
// 0xc = Menu
// 0xf = in the field
function status() => word(0x056f50)

// Menu ID (?) (16-bit)
// 
// 0xffff = transitioning/not in menu
// 0x0 = Main Menu
// 0x1 = Stat Matrix
// 0x2 = Command Matrix
// 0x3 = Gear Matrix
// 0x5 = Config
// 0x6 = Save/Load Menu
// 0xb = Debug Reports
// 0xc = Trophies
// 0xd = Collection
// 0xe = Story
// 0xf = Enemy Profiles
// 0x10 = Character Files
// 0x12 = Tutorials
function menuId() => word(0x0bea84)

// Title screen status
// 
// 0 = Licensed by Nintendo
// 1 = Square Enix
// 2 = h.a.n.d.
// 3 = lawyer stuff lol
// 4 = Kingdom Hearts animation
// 5 = Title Screen almost ready
// 6 = Title Screen ready
// 8 = Load Menu
function titleScreenStatus() => byte(0x19c494)

function IsFileLoaded() => status() != 0x0 && status() != 0x3 && !IsOnSaveOrLoadMenu()

function IsLoadingSaveFile() => prior(titleScreenStatus()) == 0x8 && titleScreenStatus() == 0

function IsOnSaveOrLoadMenu() => menuId() == 0x6

function IsOnLoadMenu() => titleScreenStatus() == 8

function TitleScreenAlmostReady() => titleScreenStatus() == 5

function TitleScreenReady() => titleScreenStatus() == 6

function IsOnTitleScreen() => TitleScreenAlmostReady() || TitleScreenReady()

function IsAlwaysInGame() => !IsOnSaveOrLoadMenu() && never(IsOnLoadMenu()) && never(IsOnTitleScreen())

function WasValueSet(mem, oldValue, newValue)
{
    return once(Delta(mem) == oldValue && mem == newValue)
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
        trigger = IsAlwaysInGame()
            && measured(tally(cheevo["threshold"], totalCounts)) && unless(tally(cheevo["threshold"], loadedCounts))
            && never(resetAlt) && (always_false() || never(IsOnTitleScreen()))
    )
}

function ShadowCountsWhen()
{
    return bit7(0x195b69) == 1 || byte(0x195b6a) > 0 || byte(0x195b6b) > 0
}

function ShadowRecalculateWhen()
{
    return Delta(bit7(0x195b69)) != bit7(0x195b69) || Delta(byte(0x195b6a)) != byte(0x195b6a) || Delta(byte(0x195b6b)) != byte(0x195b6b)
}

function DarksideCountsWhen()
{
    return (bit6(0x195b6f) == 1 || bit7(0x195b6f) == 1 || byte(0x195b68) > 0 || bit0(0x195b69) == 1 || bit1(0x195b69) == 1
        || bit2(0x195b69) == 1 || bit3(0x195b69) == 1 || bit4(0x195b69) == 1 || bit5(0x195b69) == 1 || bit6(0x195b69) == 1)
}

function DarksideRecalculateWhen()
{
    return (Delta(bit6(0x195b6f)) != bit6(0x195b6f) || Delta(bit7(0x195b6f)) != bit7(0x195b6f)
        || Delta(byte(0x195b68)) != byte(0x195b68) || Delta(bit0(0x195b69)) != bit0(0x195b69) || Delta(bit1(0x195b69)) != bit1(0x195b69)
        || Delta(bit2(0x195b69)) != bit2(0x195b69) || Delta(bit3(0x195b69)) != bit3(0x195b69) || Delta(bit4(0x195b69)) != bit4(0x195b69)
        || Delta(bit5(0x195b69)) != bit5(0x195b69) || Delta(bit6(0x195b69)) != bit6(0x195b69))
}

enemiesConditions = {
    0: { "countsWhen": ShadowCountsWhen(), "recalculateWhen": ShadowRecalculateWhen() }, // Shadow
    1: { "countsWhen": DarksideCountsWhen(), "recalculateWhen": DarksideRecalculateWhen() } // Darkside
}
GenerateSaveProtectedAchievementFromConditions({
    "name": "Enemies Test",
    "description": "Defeat two types of enemies.",
    "points": 0,
    "threshold": 2
}, enemiesConditions)

function rarePrizeRoundup() => bit5(0x195c78)
achievement(title = "Rare Prize Roundup", description = "Collect all items from every rare prize blox in the game.", points = 10,
    trigger = WasBitflagSetInGame(rarePrizeRoundup())
)

function lordOfLoot() => bit4(0x195c78)
achievement(title = "Lord of Loot", description = "Collect at least 80% of enemy item drops.", points = 10,
    trigger = WasBitflagSetInGame(lordOfLoot())
)

// todo: add more sector achievements for completion purposes

function sectorSweeper() => bit3(0x195c78)
achievement(title = "Sector Sweeper", description = "Complete all system sectors.", points = 10,
    trigger = WasBitflagSetInGame(sectorSweeper())
)

function sultanOfSlot() => bit2(0x195c78)
achievement(title = "Sultan of Slot", description = "Install chips in every slot in the Stat Matrix.", points = 10,
    trigger = WasBitflagSetInGame(sultanOfSlot())
)

function cheater() => bit1(0x195c78)
achievement(title = "Cheater", description = "Use every kind of cheat.", points = 5,
    trigger = WasBitflagSetInGame(cheater())
)

function championCollector() => bit0(0x195c78)
achievement(title = "Champion Collector", description = "Collect 70% of all abilities, chips, cheats, weapons, and items.", points = 10,
    trigger = WasBitflagSetInGame(championCollector())
)

function avatarCollector() => bit7(0x195c7f)
achievement(title = "Avatar Collector (?)", description = "Collect 50% avatar parts.", points = 10,
    trigger = WasBitflagSetInGame(avatarCollector())
)

function avatarSweeper() => bit6(0x195c7f)
achievement(title = "Avatar Sweeper (?)", description = "Complete all 100 floors of the Avatar Sector.", points = 25,
    trigger = WasBitflagSetInGame(avatarSweeper())
)

function icerOfTitans() => bit5(0x195c7f)
achievement(title = "Icer of Titans", description = "Defeat the Ice Titan.", points = 10,
    trigger = WasBitflagSetInGame(icerOfTitans())
)

function eliminatorsEnd() => bit4(0x195c7f)
achievement(title = "Eliminator's End", description = "Defeat an Eliminator.", points = 10,
    trigger = WasBitflagSetInGame(eliminatorsEnd())
)

function twilightTriumph() => bit3(0x195c7f)
achievement(title = "Twilight Triumph", description = "Defeat Data-Roxas.", points = 5,
    trigger = WasBitflagSetInGame(twilightTriumph())
)

// todo: implement more enemy type cheevos

function justiceForAll() => bit2(0x195c7f)
achievement(title = "Justice for All", description = "Defeat all enemy types.", points = 25,
    trigger = WasBitflagSetInGame(justiceForAll())
)

function weaponWizard() => bit1(0x195c7f)
achievement(title = "Weapon Wizard", description = "Completely power up every type of Keyblade.", points = 25,
    trigger = WasBitflagSetInGame(weaponWizard())
)

function converterLv100() => bit0(0x195c7f)
achievement(title = "Converter LV 100", description = "Level up a command to Level 100.", points = 5,
    trigger = WasBitflagSetInGame(converterLv100())
)

function converterCRLv100() => bit7(0x195c7e)
achievement(title = "Converter CR LV 100", description = "Level up a command to CR Level 100.", points = 10,
    trigger = WasBitflagSetInGame(converterCRLv100())
)

function commandMaster() => bit6(0x195c7e)
achievement(title = "Command Master", description = "Upgrade every type of attack and magic command to CR.", points = 25,
    trigger = WasBitflagSetInGame(commandMaster())
)

function closedBook() => bit5(0x195c7e)
achievement(title = "Closed Book", description = "Complete the story.", points = 25,
    trigger = WasBitflagSetInGame(closedBook())
)

function questBester() => bit4(0x195c7e)
achievement(title = "Quest Bester", description = "Complete all quests.", points = 25,
    trigger = WasBitflagSetInGame(questBester())
)

function proudAchievement() => bit3(0x195c7e)
achievement(title = "Proud Achievement", description = "Replay and complete every world on Proud Mode.", points = 10,
    trigger = WasBitflagSetInGame(proudAchievement())
)

function criticalAcclaim() => bit2(0x195c7e)
achievement(title = "Critical Acclaim", description = "Replay and complete every world on Critical Mode.", points = 25,
    trigger = WasBitflagSetInGame(criticalAcclaim())
)

function fatalFlawless() => bit1(0x195c7e)
achievement(title = "Fatal Flawless", description = "Replay and complete an episode with the HP Cheat set to 0%.", points = 10,
    trigger = WasBitflagSetInGame(fatalFlawless())
)

function technician() => bit0(0x195c7e)
achievement(title = "Technician", description = "Replay and complete every world at Level 15 or lower.", points = 10,
    trigger = WasBitflagSetInGame(technician())
)

speedrunnerTrophies = {
    1: { "bit": 7, "timeLimit": 5 },
    2: { "bit": 6, "timeLimit": 15 },
    3: { "bit": 5, "timeLimit": 15 },
    4: { "bit": 4, "timeLimit": 10 },
    5: { "bit": 3, "timeLimit": 15 },
    6: { "bit": 2, "timeLimit": 15 },
    7: { "bit": 1, "timeLimit": 30 },
    8: { "bit": 0, "timeLimit": 10 },
}

for i in speedrunnerTrophies
{
    trophy = speedrunnerTrophies[i]
    achievement(title = "W" + i + " Speed Runner", description = "Finish World " + i + " in " + trophy["timeLimit"] + ":00 or less.", points = 10,
        trigger = WasBitflagSetInGame(bit(trophy["bit"], 0x195c7d))
    )
}
