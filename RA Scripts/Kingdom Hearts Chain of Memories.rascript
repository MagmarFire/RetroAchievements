// Kingdom Hearts: Chain of Memories
// #ID = 768

// $006C68: System timer (32-bit)
//          
//          Increments by 1 every frame.
// $033190: 0x1 when paused vs. Axel on the first floor (8-bit)
// $034970: == 0x1 when paused against Jafar
// $034988: One of two pointers that appear related to boss information (32-bit)
//          
//          +0x7f28 for boss state (8-bit)
//          +0x7f74 for boss HP (16-bit)
// $0349A8: One of two pointers that appear related to boss information (32-bit)
// $038EA0: Parasite Cage HP (Reverse/Rebirth) (16-bit)
// $039060: Parasite Cage HP (Sora's story) (16-bit)
//          
//          This value is used directly because the boss pointers identified elsewhere are NULL during this fight.
// $039BA8: 1 = manually reloading during Trickmaster battle in Reverse/Rebirth
// $039EA2: Value of the card currently in play
//          
//          May be dynamic.
// $039F50: Marluxia II HP (16-bit)
// $039F52: Marluxia II Max HP (16-bit)
// $03A32C: Guard Armor HP (Reverse/Rebirth) (16-bit)
// $03A628: 1 = is reloading (during Riku's battle with Maleficent) (8-bit)
// $03A650: Oogie Boogie regular cards remaining (Reverse/Rebirth) (16-bit)
//          
//          There's no pointer for this during Oogie Boogie's fight, so we need to take our chances with making this static, sadly.
// $03A656: Oogie Boogie enemy cards remaining (Reverse/Rebirth) (16-bit)
//          
//          There's no pointer for this during Oogie Boogie's fight, so we need to take our chances with making this static, sadly.
// $03A668: 1 = is reloading during Oogie Boogie battle (Reverse/Rebirth) (8-bit)
//          
//          There's no pointer for this during Oogie Boogie's fight, so we need to take our chances with making this static, sadly.
// $03A7B8: Trickmaster HP (Reverse/Rebirth) (16-bit)
// $03A80C: Riku replica HP (Floor B8 and B2) (16-bit)
// $03A92C: Hades HP (Reverse/Rebirth) (16-bit)
// $03A978: Trickmaster HP (16-bit)
// $03A98C: Vexen HP (Reverse/Rebirth) (16-bit)
//          
//          Also Lexaeus's HP (16-bit)
// $03A9AC: Marluxia HP (16-bit)
// $03A9CC: Riku HP (16-bit)
//          
//          Also Ansem HP (B12/B1) (16-bit)
// $03A9EC: Hook HP (Reverse/Rebirth) (16-bit)
// $03AADC: Darkside HP (Reverse/Rebirth) (16-bit)
// $03AAEC: Hades HP (16-bit)
// $03AB2C: Axel II HP (16-bit)
// $03AB4C: Vexen I and II HP (16-bit)
// $03ABAC: Larxene HP (16-bit)
//          
//          Also Hook HP
// $03ABCC: Cloud HP (16-bit)
// $03ABCE: Cloud max HP (16-bit)
// $03ABFC: Jafar HP (16-bit)
// $03ABFE: Jafar Max HP (16-bit)
// $03AC10: Ursula HP (Reverse/Rebirth) (16-bit)
// $03AC14: Maleficent HP (Reverse/Rebirth) (16-bit)
// $03AC2C: Oogie Boogie HP (Reverse/Rebirth) (16-bit)
// $03AC9C: Darkside HP (16-bit)
// $03ADD0: Ursula HP (16-bit)
// $03ADD4: Maleficent HP (16-bit)
// $03AF54: Temp note for Vexen:
//          
//          Bit 0: Player is movement limited (slows to a crawl)
//          Bit 2: Player's horizontal direction (0 = right; 1 = left)
//          Bit 4: There is a card in play
//          Bit 7: Player is intangible, which can be due to differing factors:
//          - In the middle of an attack or is healing
//          - Is in hitstun
//          - Is dodge rolling
// $03B26C: Appears to affect which summon is used during Marluxia II (16-bit)
//          
//          0x8cc4 = Cloud
//          0x8cdc = Bambi
//          0x8cf4 = Tinker Bell
//          0x8d24 = Simba
//          0x8d3c = Mushu
//          0x8d54 = Dumbo
//          0x8d6c = Genie
//          0x8d9c = Donald
//          0x8db4 = Goofy
// $03BBC8: Credits state (32-bit)
//          
//          <garbage; probably 0x21082108> -> 0x0 = transition to credits
//          0x0 -> 0x1 = credits start
//          0x1 -> 0x2 = crawling credits start
//          0x2 -> 0x3 = title drop at the end of the credits
//          0x3 -> 0x5 = sleeping pod still
//          0x5 -> 0x6 = KHII Sora sleeping still
//          0x6 -> 0x4 = poetic blurb
//          0x4 -> 0xa = "The End"
// $03BCF4: ID of Vexen's current enemy card effect (32-bit)
//          
//          0x1b = Auto-Life
// $03BCF8: Number of uses left for Vexen's current enemy card effect (32-bit)
// $03BE70: 0x1 == paused (8-bit)
// $03BFC0: Language (when selecting)
//          
//          0x0 = English
//          0x1 = Italian
//          0x2 = French
//          0x3 = Spanish
//          0x4 = German
// $03BFC2: Appears to affect what screen the game transitions to in certain situations.
//          
//          For instance, it changes from 0 to 1 when loading a game, and if it's frozen at 0 when attempting to load a game, you get booted back to the title screen.
//          
//          Can probably be used for save protection.
// $03BFC6: Used as a timer in between loading animations (16-bit)
//          
//          Can probably be used for save protection.
// $03BFC8: Loading animation ID (16-bit)
//          
//          0x9189 = load menu is static
//          0x9279 = "Load" header moving left
//          0x92b9 = top and bottom borders dilating
//          0x930d = fading out
//          
//          Can probably be used for save protection.
//          
//          Also stores currently-accumulated Dark Points in battle. (16-bit)
// $03C000: Bit 0: A button
//          Bit 1: B button
//          Bit 2: Select button
//          Bit 3: Start button
//          Bit 4: D-pad Right
//          Bit 5: D-pad Left
//          Bit 6: D-pad Up
//          Bit 7: D-pad Down
// $03C001: Bit 0: R button
//          Bit 1: L button
// $03C9F0: One of three pointers that appear to influence battles in some way, like HP and the like. (32-bit)
// $03C9F4: One of three pointers that appear to influence battles in some way, like HP and the like. (32-bit)
// $03CA28: One of three pointers that appear to influence battles in some way, like HP and the like. It's misleading to call it a battle pointer, though, as it does not consistently nullify when in the field. (32-bit)
//          
//          +0x7e58 to get the player's battle state (Sora):
//          0x1 = neutral
//          0x2 - 0x4 = jumping
//          0x6 = using Fire
//          0x7 = using Blizzard
//          0x8 = using Thunder
//          0x9 = using Gravity
//          0xa = using Cure
//          0xb = using Stop
//          0xc = using item
//          0xd = staggering from a hit
//          0xe = dying
//          0x10 = attacking
//          0x12 = Mushu, Bambi, Tinker Bell
//          0x17-0x18 = summoning
//          0x19 = summon active
//          0x1a-0x1b = dismissing summon
//          0x1d = staggered due to card break
//          0x1e = dodge rolling
//          0x21 = staggered due to guard
//          0x24 = slipping on ice
//          0x27 = Trinity Limit
//          0x38 = performing a Sliding Dash
//          0x53 = frozen
//          0x55 = victory
//          0x56 = using Aero
//          
//          +0x7e6c to get the player's vertical acceleration when in battle (32-bit)
//          +0x7e8c to get the player's current (dynamic) HP when in battle (16-bit)
//          
//          +0x7cb0 to get Riku's vertical positioning (32-bit)
//          - 0 when on the ground
//          - Negative (a.k.a. a very large number) when in the air
//          
//          +0x7c9c to get the player's current battle state (Riku):
//          0x1 = neutral
//          0x2 - 0x4 = jumping
//          0x6 = reeling from damage
//          0x9 = attacking
//          0xb = reeling from a card break
//          0x16-0x17 = dodging
//          0x1a = King Mickey active
//          0x20 = Dark Mode activated
//          0x21 = reverting from Dark Mode
//          0x22 = just reverted from Dark Mode
//          0x23 = neutral (Dark Mode)
//          0x24 = reeling from damage (Dark Mode)
//          
//          +0x7ca8 = Riku's x-coordinates
//          
//          +0x7cd0 to get Riku's current (dynamic) HP when in battle (16-bit)
// $03CACC: Currently-equipped deck
// $03D088: Title screen state
//          
//          0x5 = "Press Start" ready
//          0x6 -> 0x8 (final) = "New Game"/"Load"
//          0x9 = Load menu/In game
// $03D0B2: Title screen index
//          
//          0x0 = new game
//          0x1 = load game
//          0x2 = link
//          0x3 = continue
//          0x4 = new game (Sora)
//          0x5 = new game (Riku)
// $03D1A0: Appears to determine game state (unsure if 16-bit or 32-bit, but the former is what we're assuming for the moment)
//          
//          0x6b11 = transitioning between rooms
//          0x6be9 = in battle
//          0x69d1 = in the field
//          0x6c7d = menu
// $0421CC: World
// $0421CD: Battlefield ID (EU)
// $0421CE: Floor (EU) (0-indexed)
//          
//          Add 1 to get the 1-indexed value.
// $0421F2: Current HP (EU) (16-bit)
// $0422B8: Max HP (16-bit)
// $0422BA: Max CP (16-bit)
// $0422BC: Dark Points (16-bit)
// $0422BE: Attack Points (16-bit)
// $0422C0: EXP (32-bit)
// $0422C4: EXP to the next level (32-bit)
// $0422C8: Level
// $0422CC: Bit 0: Sliding Dash learned
//          Bit 1: Blitz learned
//          Bit 2: Stun Impact learned
//          Bit 3: Zantetsuken learned
//          Bit 4: Strike Raid learned
//          Bit 5: Sonic Blade learned
//          Bit 6: Ars Arcanum learned
//          Bit 7: Ragnarok learned
// $0422CD: Bit 0: Trinity Limit learned
//          Bit 1: Fira learned
//          Bit 2: Firaga learned
//          Bit 3: Blizzara learned
//          Bit 4: Blizzaga learned
//          Bit 5: Thundara learned
//          Bit 6: Thundaga learned
//          Bit 7: Cura learned
// $0422CE: Bit 0: Curaga
//          Bit 1: Gravira
//          Bit 2: Graviga
//          Bit 3: Stopra
//          Bit 4: Stopga
//          Bit 5: Aerora
//          Bit 6: Aeroga
//          Bit 7: Fire Raid
// $0422CF: Bit 0: Blizzard Raid
//          Bit 1: Thunder Raid
//          Bit 2: Gravity Raid
//          Bit 3: Stop Raid
//          Bit 4: Judgment
//          Bit 5: Reflect Raid
//          Bit 6: Homing Fira
// $0422D4: Bit 0: Firaga Break
//          Bit 1: Mega Flare
//          Bit 2: Homing Blizzara
//          Bit 3: Aqua Splash
//          Bit 4: Shock Impact
//          Bit 5: Tornado
//          Bit 6: Quake
//          Bit 7: Warpinator
// $0422D5: Bit 0: Warp
//          Bit 1: Bind
//          Bit 2: Confuse
//          Bit 3: Terror
//          Bit 4: Synchro
//          Bit 5: Gifted Miracle
//          Bit 6: Teleport
//          Bit 7: Holy
// $0422D6: Bit 0: Proud Roar
//          Bit 1: Splash
//          Bit 2: Paradise
//          Bit 3: Idyll Romp
//          Bit 4: Flare Breath
//          Bit 5: Showtime
//          Bit 6: Twinkle
//          Bit 7: Cross-slash
// $0422D7: Bit 0: Omnislash unlocked
//          Bit 1: Cross-slash+ unlocked
//          Bit 2: Magic unlocked
//          Bit 3: Blazing Donald unlocked
//          Bit 4: Goofy Charge unlocked
//          Bit 5: Goofy Tornado unlocked
//          Bit 6: Sandstorm unlocked
//          Bit 7: Surprise! unlocked
// $0422F4: Bit 0: Sora's Tale I story entry
//          Bit 1: Sora's Tale II story entry
//          Bit 2: Sora's Tale III story entry
//          Bit 3: Sora's Tale IV story entry
//          Bit 4: Traverse Town story entry
//          Bit 5: Wonderland story entry
//          Bit 6: Olympus Coliseum story entry
//          Bit 7: Agrabah story entry
// $0422F5: Bit 0: Halloween Town story entry
//          Bit 1: Monstro story entry
//          Bit 2: Atlantica story entry
//          Bit 3: Never Land story entry
//          Bit 4: Hollow Bastion story entry
//          Bit 5: 100 Acre Wood story entry
//          Bit 6: Twilight Town story entry
//          Bit 7: Destiny Islands story entry
// $0422F6: Bit 0: Castle Oblivion story entry
// $0422FE: Bit 4: Shadow journal entry
//          Bit 5: Soldier journal entry
//          Bit 6: Large Body journal entry
//          Bit 7: Red Nocturne journal entry
// $042302: Bit 3: Guard Armor enemy entry
// $042303: Bit 0: Three Wishes journal entry
//          Bit 1: Crabclaw journal entry
//          Bit 2: Pumpkinhead journal entry
//          Bit 3: Fairy Harp journal entry
//          Bit 4: Wishing Star journal entry
//          Bit 5: Spellbinder journal entry
//          Bit 6: Metal Chocobo journal entry
//          Bit 7: Olympia journal entry
// $042304: Bit 0: Lionheart journal entry
//          Bit 1: Lady Luck journal entry
//          Bit 2: Divine Rose journal entry
//          Bit 3: Oathkeeper journal entry
//          Bit 4: Oblivion journal entry
//          Bit 5: Ultima Weapon journal entry
//          Bit 6: Diamond Dust journal entry
//          Bit 7: One-Winged Angel journal entry
// $042305: Bit 0: Fire card entry
//          Bit 1: Blizzard card entry
//          Bit 2: Thunder card entry
//          Bit 3: Cure card entry
//          Bit 4: Gravity card entry
//          Bit 5: Stop card entry
//          Bit 6: Aero card entry
//          Bit 7: Simba card entry
// $042306: Bit 0: Genie card entry
//          Bit 1: Bambi card entry
//          Bit 2: Dumbo card entry
//          Bit 3: Tinker Bell card entry
//          Bit 4: Mushu card entry
//          Bit 5: Cloud card entry
//          Bit 6: Potion card entry
//          Bit 7: Hi-Potion card entry
// $042307: Bit 0: Mega-Potion journal entry
//          Bit 1: Ether journal entry
//          Bit 2: Mega-Ether journal entry
//          Bit 3: Elixir journal entry
//          Bit 4: Megalixir journal entry
//          Bit 5: Donald journal entry
//          Bit 6: Goofy journal entry
//          Bit 7: Aladdin journal entry
// $042308: Bit 0: Ariel journal entry
//          Bit 1: Jack journal entry
//          Bit 2: Peter Pan journal entry
//          Bit 3: Beast journal entry
//          Bit 4: Shadow card entry
//          Bit 5: Red Nocturne card entry
//          Bit 6: Blue Rhapsody card entry
//          Bit 7: Yellow Opera card entry
// $042309: Bit 0: Green Requiem card entry
//          Bit 1: Sea Neon card entry
//          Bit 2: White Mushroom card entry
//          Bit 3: Black Fungus card entry
//          Bit 4: Soldier card entry
//          Bit 5: Powerwild card entry
//          Bit 6: Bouncywild card entry
//          Bit 7: Air Soldier card entry
// $04230A: Bit 0: Bandit card entry
//          Bit 1: Barrel Spider card entry
//          Bit 2: Search Ghost card entry
//          Bit 3: Screwdiver card entry
//          Bit 4: Wight Knight card entry
//          Bit 5: Gargoyle card entry
//          Bit 6: Pirate card entry
//          Bit 7: Air Pirate card entry
// $04230B: Bit 0: Darkball card entry
//          Bit 1: Wyvern card entry
//          Bit 2: Wizard card entry
//          Bit 3: Neoshadow card entry
//          Bit 4: Large Body card entry
//          Bit 5: Fat Bandit card entry
//          Bit 6: Aquatank card entry
//          Bit 7: Defender card entry
// $04230C: Bit 0: Tornado Step card entry
//          Bit 1: Crescendo card entry
//          Bit 2: Creeper Plant card entry
//          Bit 3: Guard Armor card entry
//          Bit 4: Hades card entry
//          Bit 5: Trickmaster card entry
//          Bit 6: Jafar card entry
//          Bit 7: Ursula card entry
// $04230D: Bit 0: Ooogie Boogie card entry
//          Bit 1: Parasite Cage card entry
//          Bit 2: Hook card entry
//          Bit 3: Dragon Maleficent card entry
//          Bit 4: Darkside card entry
//          Bit 5: Larxene card entry
//          Bit 6: Axel card entry
//          Bit 7: Vexen card entry
// $04230E: Bit 0: Marluxia card entry
//          Bit 1: Teeming Darkness card entry
//          Bit 2: Tranquil Darkness card entry
//          Bit 3: Guarded Trove card entry
//          Bit 4: Looming Darkness card entry
//          Bit 5: Sleeping Darkness card entry
//          Bit 6: Moment's Reprieve card entry
//          Bit 7: Feeble Darkness card entry
// $04230F: Bit 0: Almighty Darkness card entry
//          Bit 1: Calm Bounty card entry
//          Bit 2: False Bounty card entry
//          Bit 3: Moogle Room card entry
//          Bit 4: Sorcerous Waking card entry
//          Bit 5: Martial Waking card entry
//          Bit 6: Alchemic Waking card entry
//          Bit 7: Meeting Ground card entry
// $042310: Bit 0: Mingling Worlds card entry
//          Bit 1: Strong Initiative card entry
//          Bit 2: Lasting Daze card entry
//          Bit 3: Stagnant Space card entry
//          Bit 4: Premium Room card entry
//          Bit 5: White Room card entry
//          Bit 6: Black Room card entry
//          Bit 7: Key of Beginnings entry
// $042311: Bit 0: Key of Guidance entry
//          Bit 1: Key to Truth entry
//          Bit 2: Key to Rewards entry
// $042312: Bit 6: Card Soldier card entry
//          Bit 7: Riku card entry
// $042313: Bit 0: Lexaeus card entry
//          Bit 1: Ansem card entry
// $042334: Moogle Points (16-bit)
// $04233B: Bit 0: Warp point tutorial
//          Bit 2: "Moving to another floor erases. . . ."
//          Bit 3: Closed deck tutorial for Riku
// $042340: World cards
//          
//          Each bit appears to correspond to a different world.
// $042346: ID of the world on Floor 1
//          
//          This can be used to determine which story is being played out if some sort of bitflag that determines it isn't found, because Traverse Town is always on the first floor for Sora, and Hollow Bastion is always on the first floor for Riku.
// $04234A: ID of the world on Floor 2
// $04234E: ID of the world on Floor 3
// $042352: ID of the world on Floor 4
// $042356: ID of the world on Floor 5
// $04235A: ID of the world on Floor 6
// $04235E: ID of the world on Floor 7
// $042362: ID of the world on Floor 8
// $042366: ID of the world on Floor 9
// $04236A: ID of the world on Floor 10
// $04236E: ID of the world on Floor 11
// $042372: ID of the world on Floor 12
// $04239C: Play time in seconds (32-bit)
// $0423E4: Pointer to battle data. Null when not in battle. (32-bit)
//          
//          +0x80c2 for the value of cards currently in play
//          +0x80de for the number of cards the player currently has stocked
//          +0x80fc for the player's reload counter (16-bit). = the number on the reload card - 1 and becomes 0xffff when a reload happens. After that, increases by 1 for each reload until it reaches a max of 2.
//          +0x80fe for the enemy's reload counter (16-bit)
//          - <anything> -> 0xa = Gimmick Card activated (Guard Armor)
//          
//          +0x8856 for the number of enemy cards remaining (8-bit)
//          +0x8888: 1 = is manually reloading via reload card
// $0423F0: Deck 1, card index 1 (16-bit)
// $0424B4: Deck 1, card index 99 (16-bit)
// $0424B6: Character 1 of Deck 1's name
//          
//          Characters are ASCII encoded.
// $0424BD: Character 8 of Deck 1's name
// $0424CA: Deck 1 - total CP used (16-bit)
// $0424CC: Deck 1 - total cards
// $0424D0: Deck 2, card index 1 (16-bit)
// $042594: Deck 2, slot 99 (16-bit)
// $0425AA: Deck 2 - total CP used (16-bit)
// $0425AC: Deck 2 - total cards
// $0425B0: Deck 3, card index 1 (16-bit)
// $042674: Deck 3, slot 99 (16-bit)
// $04268A: Deck 3 - total CP used (16-bit)
// $04268C: Deck 3 - total cards
// $042690: Card inventory, slot 1 (16-bit)
//          
//          [Bit 15: Is premium][Bits 12-14: Equipped deck][Bits 0-11: Card ID]
//          Nibbles 0-2: Card ID
//          Nibble 3: Equipped to deck
//          - 0 = Unequipped
//          - 1 = Deck 1
//          - 2 = Deck 2
//          - 4 = Deck 3
//          - Bit 3: Is premium
// $042E5C: Card inventory, slot 999 (16-bit)
// $042ED0: Tranquil Darkness, total 0s
// $042ED9: Tranquil Darkness, total 9s
// $042EDA: Teeming Darkness, total 0s
// $042EE3: Teeming Darkness, total 9s
// $042EE4: Feeble Darkness, total 0s
// $042EED: Feeble Darkness, total 9s
// $042EEE: Almighty Darkness, total 0s
// $042EF7: Almighty Darkness, total 9s
// $042EF8: Sleeping Darkness, total 0s
// $042F01: Sleeping Darkness, total 9s
// $042F02: Looming Darkness, total 0s
// $042F0B: Looming Darkness, total 9s
// $042F0C: Premium Room, total 0s
// $042F15: Premium Room, total 9s
// $042F16: White Room, total 0s
// $042F1F: White Room, total 9s
// $042F20: Black Room, total 0s
// $042F29: Black Room, total 9s
// $042F2A: Martial Waking, total 0s
// $042F33: Martial Waking, total 9s
// $042F34: Sorcerous Waking, total 0s
// $042F3D: Sorcerous Waking, total 9s
// $042F3E: Alchemic Waking, total 0s
// $042F47: Alchemic Waking, total 9s
// $042F48: Meeting Ground, total 0s
// $042F51: Meeting Ground, total 9s
// $042F52: Stagnant Space, total 0s
// $042F5B: Stagnant Space, total 9s
// $042F5C: Strong Initiative, total 0s
// $042F65: Strong Initiative, total 9s
// $042F66: Lasting Daze, total 0s
// $042F6F: Lasting Daze, total 9s
// $042F70: Calm Bounty, total 0s
// $042F79: Calm Bounty, total 9s
// $042F7A: Guarded Trove, total 0s
// $042F83: Guarded Trove, total 9s
// $042F84: False Bounty, total 0s
// $042F8D: False Bounty, total 9s
// $042F8E: Moment's Reprieve, total 0s
// $042F97: Moment's Reprieve, total 9s
// $042F98: Mingling Worlds, total 0s
// $042FA1: Mingling Worlds, total 9s
// $042FA2: Moogle Room, total 0s
// $042FAB: Moogle Room, total 9s
// $042FAD: Key of Beginnings
// $042FB7: Key of Guidance
// $042FC1: Keys to Truth
// $042FCB: Key to Rewards
// $0449D0: Pooh subenergy left (16-bit)
//          
//          Goes down by 1 each frame Pooh is extending energy. Max is 0x73b.
// $0449D4: Pooh energy bars left
//          
//          Goes down by 1 each time his subenergy reaches zero, until both are zero.
// $044B84: The world that will load when you enter a door
// $044B85: Number of story rooms passed and closed off
//          
//          2 -> 3 will usually mean you beat the boss in Sora's story.
// $044B86: Room ID (for a given world?)
//          
//          Does not appear to change if you move in between floors.
// $044B87: The entrance you'll emerge from after using a door
//          
//          0 = top right
//          1 = bottom left
//          2 = bottom right
//          3 = top left
// $044B88: Door of Beginnings criteria fulfilled(?)
// $044B8C: Door of Guidance criteria fulfilled(?)

LocationLookup = {
    0: "Castle Oblivion, Hall",
    1: "Agrabah",
    2: "Atlantica",
    3: "Olympus Coliseum",
    4: "Wonderland",
    5: "Monstro",
    6: "Halloween Town",
    7: "Never Land",
    8: "Hollow Bastion",
    9: "Destiny Islands",
    10: "Traverse Town",
    11: "Twilight Town",
    12: "Castle Oblivion",
    13: "the Hundred Acre Wood",
}

FloorLookup = {
    0: "1F",
    1: "2F",
    2: "3F",
    3: "4F",
    4: "5F",
    5: "6F",
    6: "7F",
    7: "8F",
    8: "9F",
    9: "10F",
    10: "11F",
    11: "12F",
    12: "13F",
    16: "B12",
    17: "B11",
    18: "B10",
    19: "B9",
    20: "B8",
    21: "B7",
    22: "B6",
    23: "B5",
    24: "B4",
    25: "B3",
    26: "B2",
    27: "B1",
}

achievement(
    title = "Heartless Hunter", description = "The first of many", points = 1,
    id = 15580, badge = "12277", published = "10/16/2014 6:04:37 AM", modified = "11/8/2016 6:46:53 PM",
    trigger = once(byte(0x03B14E) == 80) && byte(0x03B14E) == 3 && byte(0x042346) == 10
)

achievement(
    title = "The Adventure Begins", description = "Beat the Boss in Traverse Town", points = 10,
    id = 15582, badge = "14839", published = "10/16/2014 6:06:16 AM", modified = "7/7/2020 2:12:27 AM",
    trigger = once(bit3(0x04232C) == 0) && bit3(0x04232C) == 1 && byte(0x0421CC) == 10 && byte(0x0421CD) == 11 && 
              byte(0x042346) == 10
)

achievement(
    title = "Hotter Than Fire!!", description = "Defeat Axel in 2nd Floor", points = 10,
    id = 15583, badge = "15002", published = "10/16/2014 6:07:43 AM", modified = "7/7/2020 2:12:51 AM",
    trigger = byte(0x0421CC) == 0 && byte(0x0421CD) == 12 && once(bit0(0x042325) == 0) && bit0(0x042325) == 1 && 
              byte(0x042346) == 10
)

achievement(
    title = "A Whole New World", description = "Beat the Boss in Agrabah", points = 10,
    id = 15584, badge = "14870", published = "10/16/2014 6:07:55 AM", modified = "7/7/2020 2:12:56 AM",
    trigger = byte(0x0421CC) == 1 && byte(0x0421CD) == 3 && once(bit6(0x04230C) == 0) && bit6(0x04230C) == 1 && 
              bit6(0x04232C) == 1 && byte(0x042346) == 10
)

achievement(
    title = "This is Halloween", description = "Beat the Boss in Halloween Town", points = 10,
    id = 15585, badge = "14878", published = "10/16/2014 6:08:08 AM", modified = "7/7/2020 2:13:00 AM",
    trigger = byte(0x0421CC) == 6 && byte(0x0421CD) == 7 && once(bit0(0x04230D) == 0) && bit0(0x04230D) == 1 && 
              bit0(0x04232D) == 1 && byte(0x042346) == 10
)

achievement(
    title = "Parasite Cage", description = "Beat Parasite Cage in Monstro", points = 10,
    id = 15586, badge = "14881", published = "10/16/2014 6:08:26 AM", modified = "7/7/2020 2:13:04 AM",
    trigger = byte(0x0421CC) == 5 && byte(0x0421CD) == 5 && once(bit1(0x04230D) == 0) && bit1(0x04230D) == 1 && 
              bit1(0x04232D) == 1 && byte(0x042346) == 10
)

achievement(
    title = "Infinite Heartless", description = "Escape from Monstro", points = 10,
    id = 15587, badge = "14883", published = "10/16/2014 6:08:32 AM", modified = "7/7/2020 2:13:09 AM",
    trigger = byte(0x0421CC) == 5 && byte(0x0421CD) == 5 && once(bit0(0x0422F7) == 0) && bit0(0x0422F7) == 1 && 
              bit0(0x042317) == 1 && byte(0x042346) == 10
)

achievement(
    title = "Keyblade vs Buster Sword", description = "Rule 3. You can interfiere with your oponents on the course!", points = 10,
    id = 15593, badge = "14931", published = "10/16/2014 6:10:17 AM", modified = "7/7/2020 2:13:14 AM",
    trigger = byte(0x0421CC) == 3 && byte(0x0421CD) == 6 && once(bit7(0x042306) == 0) && bit7(0x042306) == 1 && 
              bit7(0x042326) == 1 && byte(0x042346) == 10
)

achievement(
    title = "Junior Hero", description = "Beat the Boss in Olympus Coliseum", points = 10,
    id = 15588, badge = "14912", published = "10/16/2014 6:09:40 AM", modified = "7/7/2020 2:13:21 AM",
    trigger = byte(0x0421CC) == 3 && byte(0x0421CD) == 6 && once(bit4(0x04230C) == 0) && bit4(0x04230C) == 1 && 
              bit4(0x04232C) == 1 && byte(0x042346) == 10
)

achievement(
    title = "Big Mistake", description = "Against a pack of Card Soldiers", points = 5,
    id = 15589, badge = "14913", published = "10/16/2014 6:09:46 AM", modified = "7/7/2020 2:13:30 AM",
    trigger = byte(0x0421CC) == 4 && byte(0x0421CD) == 1 && once(bit6(0x042312) == 0) && bit6(0x042312) == 1 && 
              bit6(0x042332) == 1 && byte(0x042346) == 10
)

achievement(
    title = "Alice in Wonderland", description = "Beat the Boss in Wonderland", points = 10,
    id = 15590, badge = "14924", published = "10/16/2014 6:09:55 AM", modified = "7/7/2020 2:13:36 AM",
    trigger = byte(0x0421CC) == 4 && byte(0x0421CD) == 1 && once(bit5(0x04230C) == 0) && bit5(0x04230C) == 1 && 
              bit5(0x04232C) == 1 && byte(0x042346) == 10
)

achievement(
    title = "Savage Nymph ", description = "Defeat Larxene in 7th Floor", points = 10,
    id = 15591, badge = "14925", published = "10/16/2014 6:10:01 AM", modified = "7/7/2020 2:13:41 AM",
    trigger = byte(0x0421CC) == 0 && byte(0x0421CD) == 12 && once(bit2(0x042305) == 0) && bit2(0x042305) == 1 && 
              bit2(0x042325) == 1 && byte(0x042346) == 10
)

achievement(
    title = "Friendly Fellows", description = "Get all the upgrades and cards from Pooh friends", points = 10,
    id = 15592, badge = "14926", published = "10/16/2014 6:10:10 AM", modified = "7/7/2020 2:13:48 AM",
    trigger = byte(0x0421CC) <= 13 && byte(0x0421CD) == 12 && bit2(0x0422D5) == 1 && bit5(0x042303) == 1 && 
              bit3(0x042307) == 1 && bit3(0x0422D6) == 1 && bit1(0x0422D5) == 1 && bit4(0x0422D5) == 1 && bit1(0x042306) == 1 && 
              byte(0x042346) == 10
)

achievement(
    title = "Searching for Riku", description = "In the Castle Oblivion...", points = 10,
    id = 15594, badge = "14932", published = "10/16/2014 6:11:05 AM", modified = "7/7/2020 2:13:55 AM",
    trigger = never(byte(0x0421CC) != 0) && byte(0x0421CD) == 12 && once(bit6(0x042305) == 0) && bit6(0x042305) == 1 && 
              bit6(0x042325) == 1 && byte(0x042346) == 10
)

achievement(
    title = "Under the Sea", description = "Beat the Boss in Atlantica", points = 10,
    id = 15595, badge = "15004", published = "10/16/2014 6:11:11 AM", modified = "7/7/2020 2:16:28 AM",
    trigger = byte(0x0421CC) == 2 && byte(0x0421CD) == 4 && once(bit7(0x04230C) == 0) && bit7(0x04230C) == 1 && 
              bit7(0x04232C) == 1 && byte(0x042346) == 10
)

achievement(
    title = "Finding for Riku", description = "In the Castle Oblivion...", points = 10,
    id = 15596, badge = "15005", published = "10/16/2014 6:11:18 AM", modified = "7/7/2020 2:16:42 AM",
    trigger = never(byte(0x0421CC) != 0) && byte(0x0421CD) == 12 && once(bit7(0x0422D4) == 0) && bit7(0x0422D4) == 1 && 
              bit7(0x0422E4) == 1 && byte(0x042346) == 10
)

achievement(
    title = "End of the World", description = "Beat the Boss in Hollow Bastion", points = 10,
    id = 15597, badge = "15011", published = "10/16/2014 6:11:28 AM", modified = "7/7/2020 2:16:37 AM",
    trigger = byte(0x0421CC) == 8 && byte(0x0421CD) == 10 && once(bit3(0x04230D) == 0) && bit3(0x04230D) == 1 && 
              bit3(0x04232D) == 1 && byte(0x042346) == 10
)

achievement(
    title = "Pixie Dust", description = "Beat the Boss in Neverland", points = 10,
    id = 15598, badge = "15013", published = "10/16/2014 6:11:35 AM", modified = "7/7/2020 2:16:47 AM",
    trigger = byte(0x0421CC) == 7 && byte(0x0421CD) == 8 && once(bit2(0x04230D) == 0) && bit2(0x04230D) == 1 && 
              bit2(0x04232D) == 1 && byte(0x042346) == 10
)

achievement(
    title = "Chilly Academic", description = "Defeat Vexen in 11th Floor", points = 10,
    id = 15611, badge = "15015", published = "10/16/2014 6:15:04 AM", modified = "7/7/2020 2:16:53 AM",
    trigger = byte(0x0421CC) == 0 && byte(0x0421CD) == 12 && once(bit2(0x042307) == 0) && bit2(0x042307) == 1 && 
              bit2(0x042327) == 1 && byte(0x042346) == 10
)

achievement(
    title = "Taste of the Past", description = "Beat the Boss in Twilight Town", points = 10,
    id = 15599, badge = "15017", published = "10/16/2014 6:11:42 AM", modified = "7/7/2020 2:16:58 AM",
    trigger = byte(0x0421CC) == 11 && byte(0x0421CD) == 13 && once(bit7(0x04230D) == 0) && bit7(0x04230D) == 1 && 
              bit7(0x04232D) == 1 && byte(0x042346) == 10
)

achievement(
    title = "Old Friend", description = "In the Castle Oblivion...", points = 10,
    id = 15619, badge = "15018", published = "10/16/2014 6:17:47 AM", modified = "7/7/2020 2:17:03 AM",
    trigger = never(byte(0x0421CC) != 0) && byte(0x0421CD) == 12 && once(bit0(0x042307) == 0) && bit0(0x042307) == 1 && 
              bit0(0x042327) == 1 && byte(0x042346) == 10
)

achievement(
    title = "Darkside", description = "Beat the Darkside in Destiny Islands", points = 10,
    id = 15600, badge = "15020", published = "10/16/2014 6:11:58 AM", modified = "7/7/2020 2:17:08 AM",
    trigger = byte(0x0421CC) == 9 && byte(0x0421CD) == 9 && once(bit4(0x04230D) == 0) && bit4(0x04230D) == 1 && 
              bit4(0x04232D) == 1 && byte(0x042346) == 10
)

achievement(
    title = "Riku, for last time...", description = "In the Castle Oblivion...", points = 10,
    id = 15602, badge = "15022", published = "10/16/2014 6:12:11 AM", modified = "7/7/2020 2:17:13 AM",
    trigger = never(byte(0x0421CC) != 0) && byte(0x0421CD) == 12 && once(bit7(0x042312) == 0) && bit7(0x042312) == 1 && 
              bit7(0x042332) == 1 && byte(0x042346) == 10
)

achievement(
    title = "Revenge of the Nymph", description = "Floor 12th...", points = 10,
    id = 15601, badge = "15025", published = "10/16/2014 6:12:06 AM", modified = "7/7/2020 2:17:19 AM",
    trigger = byte(0x0421CC) == 0 && byte(0x0421CD) == 12 && once(bit5(0x04230D) == 0) && bit5(0x04230D) == 1 && 
              bit5(0x04232D) == 1 && byte(0x042346) == 10
)

achievement(
    title = "Extinguish the fire", description = "Floor 13th...", points = 10,
    id = 15603, badge = "15026", published = "10/16/2014 6:12:19 AM", modified = "7/7/2020 2:17:25 AM",
    trigger = byte(0x0421CC) == 12 && byte(0x0421CD) == 12 && once(bit6(0x04230D) == 0) && bit6(0x04230D) == 1 && 
              bit6(0x04232D) == 1 && byte(0x042346) == 10
)

achievement(
    title = "Final...", description = "Floor...", points = 25,
    id = 15604, badge = "15027", published = "10/16/2014 6:12:29 AM", modified = "7/7/2020 2:17:38 AM",
    trigger = byte(0x0421CC) == 0 && byte(0x0421CD) == 12 && bit0(0x04230E) == 1 && byte(0x042346) == 10
)

achievement(
    title = "Reach Out To The Truth", description = "True Memories...", points = 5,
    id = 15605, badge = "15028", published = "10/16/2014 6:12:38 AM", modified = "7/7/2020 2:17:42 AM",
    trigger = byte(0x0421CC) == 0 && byte(0x0421CD) == 12 && bit0(0x04230E) == 1 && bit6(0x04230D) == 1 && 
              byte(0x033190) == 8 && byte(0x033191) == 33 && word(0x033190) == 8456 && once(byte(0x033190) == 253)
)

achievement(
    title = "Moguri ", description = "Have 5,000 Moguri points", points = 5,
    id = 15606, badge = "14847", published = "10/16/2014 6:14:16 AM", modified = "11/8/2016 6:45:42 PM",
    trigger = word(0x042334) >= 5000 && word(0x042334) <= 5120 && byte(0x042346) == 10
)

achievement(
    title = "A Different Strategy", description = "Put 99 Card in any Deck", points = 1,
    id = 15607, badge = "14851", published = "10/16/2014 6:14:23 AM", modified = "7/7/2020 2:17:55 AM",
    trigger = byte(0x042346) == 10 &&
              ((byte(0x0425AC) == 99) ||
               (byte(0x04268C) == 99) ||
               (byte(0x0424CC) == 99))
)

achievement(
    title = "Cura+", description = "Reach 290 HP points", points = 5,
    id = 15608, badge = "14880", published = "10/16/2014 6:14:34 AM", modified = "7/7/2020 2:18:10 AM",
    trigger = once(word(0x0422B8) == 275) && word(0x0422B8) == 290 && byte(0x042346) == 10
)

achievement(
    title = "Leveling Up", description = "Reach the MAX in Bonus A or Bonus B", points = 10,
    id = 15609, badge = "15007", published = "10/16/2014 6:14:45 AM", modified = "9/26/2019 11:37:01 AM",
    trigger = byte(0x042346) == 10 &&
              ((once(word(0x0422B8) == 545) && word(0x0422B8) == 560) ||
               (once(word(0x0422BA) == 1875) && word(0x0422BA) == 1900))
)

achievement(
    title = "Room of Rewards", description = "Special Treasure", points = 5,
    id = 15610, badge = "15008", published = "10/16/2014 6:14:53 AM", modified = "7/7/2020 2:18:19 AM",
    trigger = once(byte(0x042FCB) == 0) && byte(0x042FCB) == 1 && word(0x042FCA) == 256 && byte(0x042346) == 10
)

achievement(
    title = "All the Rooms", description = "Get all the Map Cards (In the Journal)", points = 10,
    id = 15612, badge = "15228", published = "10/16/2014 6:15:39 AM", modified = "7/7/2020 2:22:16 AM",
    trigger = byte(0x04230F) == 255 && byte(0x042310) == 255 && bit1(0x04230E) == 1 && bit2(0x04230E) == 1 && 
              bit3(0x04230E) == 1 && bit4(0x04230E) == 1 && bit5(0x04230E) == 1 && bit6(0x04230E) == 1 && bit7(0x04230E) == 1 && 
              bit0(0x042311) == 1 && bit1(0x042311) == 1 && bit2(0x042311) == 1
)

achievement(
    title = "Lionheart", description = "Obtain the Lionhearth Keyblade Card", points = 5,
    id = 15581, badge = "14873", published = "10/16/2014 6:05:29 AM", modified = "7/7/2020 2:22:26 AM",
    trigger = byte(0x0421CC) == 10 && byte(0x0421CD) == 11 && once(bit0(0x042304) == 0) && bit0(0x042304) == 1 && 
              bit0(0x042324) == 1 && byte(0x042346) == 10
)

achievement(
    title = "Three Wishes", description = "Obtain the Three Wishes Keyblade Card", points = 5,
    id = 15627, badge = "14872", published = "10/16/2014 6:18:57 AM", modified = "7/7/2020 2:22:32 AM",
    trigger = bit0(0x042323) == 1 && once(bit0(0x042303) == 0) && bit0(0x042303) == 1 && byte(0x042346) == 10
)

achievement(
    title = "One-Winged Angel", description = "Obtain the One-Winged Angel Keyblade Card", points = 5,
    id = 15628, badge = "15189", published = "10/16/2014 6:19:09 AM", modified = "7/7/2020 2:22:37 AM",
    trigger = once(bit7(0x042304) == 0) && bit7(0x042304) == 1 && bit7(0x042324) == 1 && byte(0x042346) == 10
)

achievement(
    title = "Diamond Dust", description = "Obtain the Diamond Dust Keyblade Card", points = 5,
    id = 15629, badge = "15187", published = "10/16/2014 6:19:25 AM", modified = "7/7/2020 2:22:57 AM",
    trigger = once(bit6(0x042304) == 0) && bit6(0x042304) == 1 && bit6(0x042324) == 1 && byte(0x042346) == 10
)

achievement(
    title = "Ultima Weapon", description = "Obtain the Ultima Weapon Keyblade Card", points = 5,
    id = 15630, badge = "15184", published = "10/16/2014 6:19:36 AM", modified = "9/29/2019 12:07:01 PM",
    trigger = byte(0x0421CC) == 12 && byte(0x0421CD) == 12 && once(bit5(0x042304) == 0) && bit5(0x042304) == 1 && 
              bit5(0x042324) == 1 && byte(0x042346) == 10
)

achievement(
    title = "Pumpkinhead", description = "Obtain the Pumpkinhead Keyblade Card", points = 5,
    id = 15631, badge = "14874", published = "10/16/2014 6:19:59 AM", modified = "7/7/2020 2:23:04 AM",
    trigger = once(bit2(0x042303) == 0) && bit2(0x042303) == 1 && bit2(0x042323) == 1 && byte(0x042346) == 10
)

achievement(
    title = "Wishing Star", description = "Obtain the Wishing Star Keyblade Card", points = 5,
    id = 15632, badge = "14879", published = "10/16/2014 6:20:07 AM", modified = "7/7/2020 2:23:09 AM",
    trigger = once(bit4(0x042303) == 0) && bit4(0x042303) == 1 && bit4(0x042323) == 1 && byte(0x042346) == 10
)

achievement(
    title = "Olympia", description = "Obtain the Olympia Keyblade Card", points = 5,
    id = 15634, badge = "14908", published = "10/16/2014 6:21:13 AM", modified = "7/7/2020 2:23:14 AM",
    trigger = once(bit7(0x042303) == 0) && bit7(0x042303) == 1 && bit7(0x042323) == 1 && byte(0x042346) == 10
)

achievement(
    title = "Metal Chocobo", description = "Obtain the Metal Chocobo Keyblade Card", points = 5,
    id = 15635, badge = "14910", published = "10/16/2014 6:21:20 AM", modified = "7/7/2020 2:23:19 AM",
    trigger = once(bit6(0x042303) == 0) && bit6(0x042303) == 1 && bit6(0x042323) == 1 && byte(0x042346) == 10
)

achievement(
    title = "Spellbinder", description = "Obtain the Spellbinder Keyblade Card", points = 5,
    id = 15636, badge = "14930", published = "10/16/2014 6:21:25 AM", modified = "7/7/2020 2:23:25 AM",
    trigger = once(bit5(0x042303) == 0) && bit5(0x042303) == 1 && bit5(0x042323) == 1 && byte(0x0421CC) == 13 && 
              byte(0x0421CD) == 12 && byte(0x042346) == 10
)

achievement(
    title = "Divine Rose", description = "Obtain the Divine Rose Keyblade Card", points = 5,
    id = 15637, badge = "15006", published = "10/16/2014 6:21:29 AM", modified = "7/7/2020 2:23:29 AM",
    trigger = byte(0x0421CC) == 8 && byte(0x0421CD) == 10 && once(bit2(0x042304) == 0) && bit2(0x042304) == 1 && 
              bit2(0x042324) == 1 && byte(0x042346) == 10
)

achievement(
    title = "Crabclaw", description = "Obtain the Crabclaw Keyblade Card", points = 5,
    id = 15638, badge = "14933", published = "10/16/2014 6:21:34 AM", modified = "7/7/2020 2:23:35 AM",
    trigger = byte(0x0421CC) == 2 && byte(0x0421CD) == 4 && once(bit1(0x042303) == 0) && bit1(0x042303) == 1 && 
              bit1(0x042323) == 1 && byte(0x042346) == 10
)

achievement(
    title = "Fairy Harp", description = "Obtain the Fairy Harp Keyblade Card", points = 5,
    id = 15639, badge = "15012", published = "10/16/2014 6:21:39 AM", modified = "7/7/2020 2:23:40 AM",
    trigger = byte(0x0421CC) == 7 && byte(0x0421CD) == 8 && once(bit3(0x042303) == 0) && bit3(0x042303) == 1 && 
              bit3(0x042323) == 1 && byte(0x042346) == 10
)

achievement(
    title = "Oathkeeper", description = "Obtain the Oathkeeper Keyblade Card", points = 5,
    id = 15640, badge = "15021", published = "10/16/2014 6:21:43 AM", modified = "7/7/2020 2:23:47 AM",
    trigger = byte(0x0421CC) == 9 && byte(0x0421CD) == 9 && once(bit3(0x042304) == 0) && bit3(0x042304) == 1 && 
              bit3(0x042324) == 1 && byte(0x042346) == 10
)

achievement(
    title = "Lady Luck", description = "Obtain the Lady Luck Keyblade Card", points = 5,
    id = 15641, badge = "14914", published = "10/16/2014 6:21:50 AM", modified = "7/7/2020 2:23:51 AM",
    trigger = once(bit1(0x042304) == 0) && bit1(0x042304) == 1 && bit1(0x042324) == 1 && byte(0x042346) == 10
)

achievement(
    title = "Oblivion", description = "Obtain the Oblivion Keyblade Card", points = 5,
    id = 15642, badge = "15024", published = "10/16/2014 6:21:56 AM", modified = "7/7/2020 2:23:56 AM",
    trigger = byte(0x0421CC) == 0 && byte(0x0421CD) == 12 && once(bit4(0x042304) == 0) && bit4(0x042304) == 1 && 
              bit4(0x042324) == 1 && byte(0x042346) == 10
)

achievement(
    title = "This is Only the First", description = "Learn the 'Sliding Dash' Ability", points = 1,
    id = 15613, badge = "15212", published = "10/16/2014 6:15:51 AM", modified = "7/7/2020 2:24:02 AM",
    trigger = once(bit0(0x0422CC) == 0) && bit0(0x0422CC) == 1 && bit0(0x0422DC) == 1 && byte(0x042346) == 10 && 
              byte(0x0421CC) == 10 && byte(0x0421CD) == 11
)

achievement(
    title = "Blazing Donald", description = "Learn the 'Blazing Donald' Ability", points = 1,
    id = 15614, badge = "14868", published = "10/16/2014 6:16:30 AM", modified = "7/7/2020 2:24:09 AM",
    trigger = byte(0x0421CC) == 1 && byte(0x0421CD) == 3 && once(bit3(0x0422D7) == 0) && bit3(0x0422D7) == 1 && 
              bit3(0x0422E7) == 1 && byte(0x042346) == 10
)

achievement(
    title = "Stop Raid Sleight", description = "Learn the 'Stop Raid' Ability", points = 3,
    id = 15615, badge = "14915", published = "10/16/2014 6:16:43 AM", modified = "10/16/2014 6:23:10 AM",
    trigger = once(bit3(0x0422CF) == 0) && bit3(0x0422CF) == 1 && bit3(0x0422DF) == 1 && byte(0x042346) == 10
)

achievement(
    title = "Quake Sleight", description = "Learn the 'Quake' Ability", points = 3,
    id = 15616, badge = "15003", published = "10/16/2014 6:17:15 AM", modified = "10/16/2014 6:23:13 AM",
    trigger = once(bit6(0x0422D4) == 0) && bit6(0x0422D4) == 1 && bit6(0x0422E4) == 1 && byte(0x0421CC) == 2 && 
              byte(0x0421CD) == 4 && byte(0x042346) == 10
)

achievement(
    title = "Thunder Raid Sleight", description = "Learn the 'Thunder Raid' Ability", points = 3,
    id = 15617, badge = "15009", published = "10/16/2014 6:17:24 AM", modified = "10/16/2014 6:23:15 AM",
    trigger = once(bit1(0x0422CF) == 0) && bit1(0x0422CF) == 1 && bit1(0x0422DF) == 1 && byte(0x0421CC) == 7 && 
              byte(0x0421CD) == 8 && byte(0x042346) == 10
)

achievement(
    title = "Warp Sleight", description = "Learn the 'Warp' Ability", points = 3,
    id = 15618, badge = "15016", published = "10/16/2014 6:17:31 AM", modified = "10/16/2014 6:23:17 AM",
    trigger = once(bit0(0x0422D5) == 0) && bit0(0x0422D5) == 1 && bit0(0x0422E5) == 1 && byte(0x0421CC) == 11 && 
              byte(0x0421CD) == 13 && byte(0x042346) == 10
)

achievement(
    title = "Firaga Break", description = "Learn the 'Firaga Break' Ability", points = 3,
    id = 15620, badge = "15221", published = "10/16/2014 6:17:58 AM", modified = "10/16/2014 6:23:21 AM",
    trigger = once(bit0(0x0422D4) == 0) && bit0(0x0422D4) == 1 && bit0(0x0422E4) == 1 && byte(0x042346) == 10 && 
              byte(0x0421CC) == 11 && byte(0x0421CD) == 13
)

achievement(
    title = "Burner", description = "Learn the 'Fire Raid' Ability", points = 3,
    id = 15621, badge = "15218", published = "10/16/2014 6:18:02 AM", modified = "10/16/2014 6:23:24 AM",
    trigger = once(bit7(0x0422CE) == 0) && bit7(0x0422CE) == 1 && bit7(0x0422DE) == 1 && byte(0x042346) == 10 && 
              byte(0x0421CC) == 5 && byte(0x0421CD) == 5
)

achievement(
    title = "Cross-Whip", description = "Learn the 'Cross-Slash [plus]' Ability", points = 3,
    id = 15622, badge = "15213", published = "10/16/2014 6:18:08 AM", modified = "8/14/2018 12:38:08 PM",
    trigger = once(bit1(0x0422D7) == 0) && bit1(0x0422D7) == 1 && bit1(0x0422E7) == 1 && byte(0x042346) == 10 && 
              byte(0x0421CC) == 8 && byte(0x0421CD) == 10
)

achievement(
    title = "Divine Justice", description = "Learn the 'Judgment' Ability", points = 3,
    id = 15623, badge = "15210", published = "10/16/2014 6:18:13 AM", modified = "10/16/2014 6:23:28 AM",
    trigger = once(bit4(0x0422CF) == 0) && bit4(0x0422CF) == 1 && bit4(0x0422DF) == 1 && byte(0x042346) == 10 && 
              byte(0x0421CC) == 9 && byte(0x0421CD) == 9
)

achievement(
    title = "Blizzard Raid ", description = "Learn the 'Blizzard Raid' Ability", points = 3,
    id = 15624, badge = "15209", published = "10/16/2014 6:18:20 AM", modified = "10/16/2014 6:23:31 AM",
    trigger = once(bit0(0x0422CF) == 0) && bit0(0x0422CF) == 1 && bit0(0x0422DF) == 1 && byte(0x042346) == 10 && 
              byte(0x0421CC) == 3 && byte(0x0421CD) == 6
)

achievement(
    title = "Homing Blizzara", description = "Learn the 'Homing Blizzara'' Ability", points = 3,
    id = 15625, badge = "15207", published = "10/16/2014 6:18:24 AM", modified = "10/16/2014 6:23:33 AM",
    trigger = once(bit2(0x0422D4) == 0) && bit2(0x0422D4) == 1 && bit2(0x0422E4) == 1 && byte(0x042346) == 10 && 
              byte(0x0421CC) == 2 && byte(0x0421CD) == 4
)

achievement(
    title = "More Than the Half", description = "Reach Level 50 (Reb)", points = 10,
    id = 15626, badge = "15193", published = "10/16/2014 6:18:37 AM", modified = "7/7/2020 2:24:33 AM",
    trigger = byte(0x042346) == 8 && once(byte(0x0422C8) == 49) && byte(0x0422C8) == 50 && word(0x0422C8) == 50
)

achievement(
    title = "Gravity Raid", description = "Learn the 'Gravity Raid' Ability", points = 3,
    id = 15633, badge = "14876", published = "10/16/2014 6:21:08 AM", modified = "10/16/2014 6:23:50 AM",
    trigger = byte(0x0421CC) == 6 && byte(0x0421CD) == 7 && once(bit2(0x0422CF) == 0) && bit2(0x0422CF) == 1 && 
              bit2(0x0422DF) == 1 && byte(0x042346) == 10
)

achievement(
    title = "Magic Refill", description = "Obtain the 'Ether' Card", points = 3,
    id = 15643, badge = "14875", published = "10/16/2014 6:22:07 AM", modified = "10/16/2014 6:24:14 AM",
    trigger = byte(0x0421CC) == 1 && byte(0x0421CD) == 3 && once(bit1(0x042307) == 0) && bit1(0x042307) == 1 && 
              bit1(0x042327) == 1 && byte(0x042346) == 10
)

achievement(
    title = "Megalixir", description = "Obtain the 'Megalixir' Card", points = 3,
    id = 15647, badge = "15019", published = "10/16/2014 6:22:45 AM", modified = "11/8/2016 6:44:41 PM",
    trigger = byte(0x0421CC) == 9 && byte(0x0421CD) == 9 && once(bit4(0x042307) == 0) && bit4(0x042307) == 1 && 
              bit4(0x042327) == 1 && byte(0x042346) == 10
)

achievement(
    title = "Time Stop", description = "Obtain the 'Stop' Card", points = 3,
    id = 15645, badge = "15204", published = "10/16/2014 6:22:27 AM", modified = "10/16/2014 6:24:18 AM",
    trigger = byte(0x0421CC) == 4 && byte(0x0421CD) == 1 && once(bit5(0x042305) == 0) && bit5(0x042305) == 1 && 
              bit5(0x042325) == 1 && byte(0x042346) == 10
)

achievement(
    title = "Always Down", description = "Obtain the 'Gravity' Card", points = 3,
    id = 15646, badge = "15205", published = "10/16/2014 6:22:35 AM", modified = "10/16/2014 6:24:21 AM",
    trigger = byte(0x0421CC) == 1 && byte(0x0421CD) == 3 && once(bit4(0x042305) == 0) && bit4(0x042305) == 1 && 
              bit4(0x042325) == 1 && byte(0x042346) == 10
)

achievement(
    title = "Mushu", description = "Get the 'Mushu' Card", points = 3,
    id = 15644, badge = "15010", published = "10/16/2014 6:22:17 AM", modified = "10/16/2014 6:24:16 AM",
    trigger = once(bit4(0x042306) == 0) && bit4(0x042306) == 1 && bit4(0x042326) == 1 && byte(0x0421CC) == 8 && 
              byte(0x0421CD) == 10 && byte(0x042346) == 10
)

achievement(
    title = "Lexaeus", description = "Obtain the 'Lexaeus' Card", points = 5,
    id = 15650, badge = "15185", published = "10/16/2014 6:26:31 AM", modified = "11/8/2016 5:30:58 PM",
    trigger = byte(0x0421CC) == 12 && byte(0x0421CD) == 12 && once(bit0(0x042313) == 0) && bit0(0x042313) == 1 && 
              bit0(0x042333) == 1 && byte(0x042346) == 10
)

achievement(
    title = "Ansem", description = "Obtain the 'Ansem' Card", points = 5,
    id = 15649, badge = "15186", published = "10/16/2014 6:26:26 AM", modified = "10/16/2014 6:48:37 AM",
    trigger = byte(0x0421CC) == 12 && byte(0x0421CD) == 12 && once(bit1(0x042313) == 0) && bit1(0x042313) == 1 && 
              bit1(0x042333) == 1 && byte(0x042346) == 10
)

achievement(
    title = "Reverse Rebirth", description = "Another Story, Same Castle (Reb)", points = 2,
    id = 15648, badge = "15029", published = "10/16/2014 6:22:53 AM", modified = "11/8/2016 6:44:21 PM",
    trigger = once(byte(0x005B30) == 32) && byte(0x005B30) == 0 && byte(0x03D0B2) == 5 && byte(0x042692) == 156
)

achievement(
    title = "Critical Competitor", description = "Beat the game with Sora without never upgrade the Vitality bar", points = 50,
    id = 41892, badge = "43183", published = "11/8/2016 6:47:54 PM", modified = "7/7/2020 2:25:02 AM",
    trigger = byte(0x0421CC) == 0 && byte(0x0421CD) == 12 && bit0(0x04230E) == 1 && bit6(0x04230D) == 1 && 
              byte(0x033190) == 8 && byte(0x033191) == 33 && word(0x033190) == 8456 && once(byte(0x033190) == 253) && word(0x0422B8) == 80
)

achievement(
    title = "Around Green Flames", description = "Floor 1st... (Reb)", points = 10,
    id = 15651, badge = "15121", published = "10/16/2014 6:27:09 AM", modified = "7/7/2020 2:26:33 AM",
    trigger = byte(0x0421CC) == 8 && byte(0x0421CD) == 10 && once(bit3(0x04230D) == 0) && bit3(0x04230D) == 1 && 
              bit3(0x04232D) == 1 && byte(0x042692) == 156 && byte(0x042346) == 8
)

achievement(
    title = "Darkness...", description = "Floor 1st... (Reb)", points = 10,
    id = 15652, badge = "15104", published = "10/16/2014 6:27:15 AM", modified = "7/7/2020 2:26:27 AM",
    trigger = byte(0x0421CC) == 0 && byte(0x0421CD) == 12 && once(byte(0x0421CE) == 0) && byte(0x0421CE) == 1 && 
              word(0x0421CE) == 65281 && byte(0x042346) == 8
)

achievement(
    title = "In the Sea of Fire", description = "Floor... (Reb)", points = 10,
    id = 15653, badge = "15126", published = "10/16/2014 6:27:21 AM", modified = "7/7/2020 2:26:20 AM",
    trigger = byte(0x0421CC) == 1 && byte(0x0421CD) == 3 && once(bit6(0x04230C) == 0) && bit6(0x04230C) == 1 && 
              bit6(0x04232C) == 1 && byte(0x042346) == 8
)

achievement(
    title = "More Parasites", description = "Floor... (Reb)", points = 10,
    id = 15654, badge = "15130", published = "10/16/2014 6:27:28 AM", modified = "7/7/2020 2:26:13 AM",
    trigger = byte(0x0421CC) == 5 && byte(0x0421CD) == 5 && once(bit1(0x04230D) == 0) && bit1(0x04230D) == 1 && 
              bit1(0x04232D) == 1 && byte(0x042346) == 8
)

achievement(
    title = "One More...", description = "Basement 12th... (Reb)", points = 10,
    id = 15655, badge = "15144", published = "10/16/2014 6:27:34 AM", modified = "7/7/2020 2:26:08 AM",
    trigger = byte(0x0421CC) == 0 && byte(0x0421CD) == 12 && once(byte(0x0421CE) == 2) && byte(0x0421CE) == 3 && 
              word(0x0421CE) == 65283 && byte(0x042346) == 8
)

achievement(
    title = "You can Fly", description = "Floor... (Reb)", points = 10,
    id = 15656, badge = "15145", published = "10/16/2014 6:27:38 AM", modified = "7/7/2020 2:26:03 AM",
    trigger = byte(0x0421CC) == 7 && byte(0x0421CD) == 8 && once(bit2(0x04230D) == 0) && bit2(0x04230D) == 1 && 
              bit2(0x04232D) == 1 && byte(0x042346) == 8
)

achievement(
    title = "Armors", description = "Floor... (Reb)", points = 10,
    id = 15657, badge = "15149", published = "10/16/2014 6:27:45 AM", modified = "7/7/2020 2:25:58 AM",
    trigger = once(bit3(0x04230C) == 0) && bit3(0x04230C) == 1 && byte(0x0421CC) == 10 && byte(0x0421CD) == 11 && 
              bit3(0x04232C) == 1 && byte(0x042346) == 8
)

achievement(
    title = "And Another...", description = "Basement 7th... (Reb)", points = 10,
    id = 15658, badge = "15152", published = "10/16/2014 6:27:52 AM", modified = "7/7/2020 2:25:53 AM",
    trigger = byte(0x0421CC) == 0 && byte(0x0421CD) == 12 && once(byte(0x0421CE) == 4) && byte(0x0421CE) == 5 && 
              word(0x0421CE) == 65285 && byte(0x042346) == 8
)

achievement(
    title = "Tentacles...", description = "Floor... (Reb)", points = 10,
    id = 15659, badge = "15153", published = "10/16/2014 6:27:57 AM", modified = "7/7/2020 2:25:48 AM",
    trigger = byte(0x0421CC) == 2 && byte(0x0421CD) == 4 && once(bit7(0x04230C) == 0) && bit7(0x04230C) == 1 && 
              bit7(0x04232C) == 1 && byte(0x042346) == 8
)

achievement(
    title = "Trick or Treat", description = "Floor... (Reb)", points = 10,
    id = 15660, badge = "15154", published = "10/16/2014 6:28:03 AM", modified = "7/7/2020 2:25:43 AM",
    trigger = byte(0x0421CC) == 6 && byte(0x0421CD) == 7 && once(bit0(0x04230D) == 0) && bit0(0x04230D) == 1 && 
              bit0(0x04232D) == 1 && byte(0x042346) == 8
)

achievement(
    title = "Hero Test", description = "Floor... (Reb)", points = 10,
    id = 15661, badge = "15159", published = "10/16/2014 6:28:08 AM", modified = "7/7/2020 2:25:39 AM",
    trigger = byte(0x0421CC) == 3 && byte(0x0421CD) == 6 && once(bit4(0x04230C) == 0) && bit4(0x04230C) == 1 && 
              bit4(0x04232C) == 1 && byte(0x042346) == 8
)

achievement(
    title = "The Rabbit Hole", description = "Floor... (Reb)", points = 10,
    id = 15662, badge = "15164", published = "10/16/2014 6:28:12 AM", modified = "7/7/2020 2:25:35 AM",
    trigger = byte(0x0421CC) == 4 && byte(0x0421CD) == 1 && once(bit5(0x04230C) == 0) && bit5(0x04230C) == 1 && 
              bit5(0x04232C) == 1 && byte(0x042346) == 8
)

achievement(
    title = "Power...", description = "Basement 4th... (Reb)", points = 10,
    id = 15663, badge = "15166", published = "10/16/2014 6:28:17 AM", modified = "7/7/2020 2:25:27 AM",
    trigger = byte(0x0421CC) == 0 && byte(0x0421CD) == 12 && once(bit0(0x042313) == 0) && bit0(0x042313) == 1 && 
              bit0(0x042333) == 1 && byte(0x042346) == 8
)

achievement(
    title = "Darker...", description = "Basement 3rd... (Reb)", points = 10,
    id = 15664, badge = "15174", published = "10/16/2014 6:28:24 AM", modified = "7/7/2020 2:25:23 AM",
    trigger = byte(0x0421CC) == 9 && byte(0x0421CD) == 9 && once(bit4(0x04230D) == 0) && bit4(0x04230D) == 1 && 
              bit4(0x04232D) == 1 && byte(0x042346) == 8
)

achievement(
    title = "Light and Dark", description = "Basement 2nd... (Reb)", points = 10,
    id = 15665, badge = "15178", published = "10/16/2014 6:28:32 AM", modified = "7/7/2020 2:25:18 AM",
    trigger = byte(0x0421CC) == 0 && byte(0x0421CD) == 12 && once(byte(0x0421CE) == 10) && byte(0x0421CE) == 11 && 
              word(0x0421CE) == 65291 && byte(0x042346) == 8
)

achievement(
    title = "Final II...", description = "Floor... (Reb)", points = 25,
    id = 15666, badge = "15179", published = "10/16/2014 6:28:40 AM", modified = "7/7/2020 2:25:14 AM",
    trigger = byte(0x0421CC) == 12 && byte(0x0421CD) == 12 && once(byte(0x03A9CC) == 32) && byte(0x03A9CC) == 0 && 
              once(byte(0x03A9CD) == 8) && byte(0x03A9CD) == 0 && once(word(0x03A9CE) == 2080) && word(0x03A9CE) == 0 && bit4(0x04230D) == 1
)

achievement(
    title = "Level Boost", description = "Reach the MAX in Bonus A or Bonus B (Reb)", points = 10,
    id = 15667, badge = "15030", published = "10/16/2014 6:39:25 AM", modified = "10/8/2019 2:07:01 PM",
    trigger = byte(0x042346) == 8 &&
              ((once(word(0x0422B8) == 545) && word(0x0422B8) == 560) ||
               (once(byte(0x0422BE) == 29) && byte(0x0422BE) == 30))
)

achievement(
    title = "A World of Combinations", description = "Reach 1900 Capacity Points", points = 3,
    id = 15572, badge = "14906", published = "10/16/2014 5:20:45 AM", modified = "10/16/2014 5:20:45 AM",
    trigger = once(word(0x0422BA) == 975) && word(0x0422BA) == 1000
)

achievement(
    title = "Rookie Collector [STUB]", description = "", points = 5,
    id = 156793, badge = "00000", published = "6/4/2021 5:19:52 AM", modified = "6/4/2021 5:19:52 AM",
    trigger = 0
)

achievement(
    title = "The Final Floor", description = "Floor...", points = 5,
    id = 41891, badge = "43185", published = "11/8/2016 6:47:41 PM", modified = "11/8/2016 6:47:41 PM",
    trigger = byte(0x0421CC) == 0 && byte(0x0421CD) == 12 && once(bit0(0x04230E) == 0) && bit0(0x04230E) == 1 && 
              bit6(0x04232E) == 1 && bit6(0x04230D) == 1 && byte(0x042346) == 10
)

achievement(
    title = "Corroded by Darkness", description = "Reach Level 99 with Riku (Reb)", points = 15,
    id = 41893, badge = "43184", published = "11/8/2016 6:47:56 PM", modified = "10/5/2019 1:25:01 PM",
    trigger = byte(0x042346) == 8 && once(byte(0x0422C8) == 98) && byte(0x0422C8) == 99
)

rich_presence_conditional_display(byte(0x042346) == 8, "Riku is in {0} ({1}) | Play Time: {2}",
    rich_presence_lookup("Location", byte(0x0421CC), LocationLookup),
    rich_presence_lookup("Floor", byte(0x0421CE) + 16, FloorLookup),
    rich_presence_value("PlayTime", dword(0x04239C), format="SECS")
)

rich_presence_display("Sora is in {0} ({1}) | Play Time: {2}",
    rich_presence_lookup("Location", byte(0x0421CC), LocationLookup),
    rich_presence_lookup("Floor", byte(0x0421CE), FloorLookup),
    rich_presence_value("PlayTime", dword(0x04239C), format="SECS")
)
