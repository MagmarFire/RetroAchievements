// Kingdom Hearts: Chain of Memories
// #ID = 768

// $005B30: Load Menu
// $033190: Otra vida jefe
// $03A9CC: Riku III
// $03B14E: Vida Max Sora (Batalla)
// $03D0B2: Algo???

// $0421CC: World
function worldId() => byte(0x0421CC)

LocationLookup = {
    0: "Castle Oblivion",
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
    13: "100-Acre Wood",
}

// $0421CD: Battlefield ID (EU)
function battlefieldId() => byte(0x0421CD)

// $0421CE: Floor (EU)
function floor() => byte(0x0421CE)

// $0422B8: Max HP (16-bit)
function maxHp() => word(0x0422B8)

// $0422BA: Max CP (16-bit)
function maxCp() => word(0x0422BA)

// $0422BE: Riku
//          Puntos Ataque
function attackPoints() => byte(0x0422BE)

// $0422C8: Level
function level() => byte(0x0422C8)

// $0422CC: ()()()()()()()(Resbal????n)
// $0422CF: ()()()(Jus.Div)(Par????l)(Ag.Neg)(Torm)(Vent)
// $0422D4: (Min.Vort)(Sism)()()()(Tem.L????c)()(Gr.Erup)
// $0422D5: ()()()(Sincr)(Confu)()(Planta)(Exil)
// $0422D6: ()()()()(Eden)()()()
// $0422D7: ()()()()(D. Hume)()(La.Cruz)()
// $0422F7: ()()()()()()()(Dumbo)
// $042303: (Heroi.)(Me.Choc)(Exami)(Est.Fug)
//          (Ha.Ha)(Cal.Mac)(Joy.Mar)(T.Deseos)
// $042304: (Fulgor)(Polvo)(Ulti)(Rec.Lej)()(D.Ros)(Ult.Re)(Lionh)
// $042305: ()(Aero)(Paro)(Grave)()(Truen)()(Fueg)
// $042306: (Ultrap)()(Mushu)()()()(Bamb)()
// $042307: ()()()(Omniel)(Elixi)(OmniE)(Eter)(OnmiP)
// $04230C: (????rsu)(Jaf)(Prest)(Hades)(Armad)()()()
// $04230D: (Vexe)(Axel)(Larx.)(Lad.Osc)(Drag)(Garf)()(Og.Boo)
// $04230E: ()()()()()()()(Marx)
// $042312: ()(Nai.Sol)()()()()()()()
// $042313: ()()()()()()(Anse)(Lexa)
// $042334: Moogle Points (16-bit)
// $0424CC: Baraja 1
//          Total Naipes
// $0425AC: Baraja 2
//          Total Naipes
// $042692: 9c y 06
// $042FCB: Llave Prist????na

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
    trigger = once(byte(0x03B14E) == 0x50) && byte(0x03B14E) == 0x03 && byte(0x042346) == 0x0A
)

achievement(
    title = "The Adventure Begins", description = "Beat the Boss in Traverse Town", points = 10,
    id = 15582, badge = "14839", published = "10/16/2014 6:06:16 AM", modified = "7/7/2020 2:12:27 AM",
    trigger = once(bit3(0x04232C) == 0x0) && bit3(0x04232C) == 0x1 && worldId() == 0x0A && battlefieldId() == 0x0B && 
              byte(0x042346) == 0x0A
)

achievement(
    title = "Hotter Than Fire!!", description = "Defeat Axel in 2nd Floor", points = 10,
    id = 15583, badge = "15002", published = "10/16/2014 6:07:43 AM", modified = "7/7/2020 2:12:51 AM",
    trigger = worldId() == 0x00 && battlefieldId() == 0x0C && once(bit0(0x042325) == 0x0) && bit0(0x042325) == 0x1 && 
              byte(0x042346) == 0x0A
)

achievement(
    title = "A Whole New World", description = "Beat the Boss in Agrabah", points = 10,
    id = 15584, badge = "14870", published = "10/16/2014 6:07:55 AM", modified = "7/7/2020 2:12:56 AM",
    trigger = worldId() == 0x01 && battlefieldId() == 0x03 && once(bit6(0x04230C) == 0x0) && bit6(0x04230C) == 0x1 && 
              bit6(0x04232C) == 0x1 && byte(0x042346) == 0x0A
)

achievement(
    title = "This is Halloween", description = "Beat the Boss in Halloween Town", points = 10,
    id = 15585, badge = "14878", published = "10/16/2014 6:08:08 AM", modified = "7/7/2020 2:13:00 AM",
    trigger = worldId() == 0x06 && battlefieldId() == 0x07 && once(bit0(0x04230D) == 0x0) && bit0(0x04230D) == 0x1 && 
              bit0(0x04232D) == 0x1 && byte(0x042346) == 0x0A
)

achievement(
    title = "Parasite Cage", description = "Beat Parasite Cage in Monstro", points = 10,
    id = 15586, badge = "14881", published = "10/16/2014 6:08:26 AM", modified = "7/7/2020 2:13:04 AM",
    trigger = worldId() == 0x05 && battlefieldId() == 0x05 && once(bit1(0x04230D) == 0x0) && bit1(0x04230D) == 0x1 && 
              bit1(0x04232D) == 0x1 && byte(0x042346) == 0x0A
)

achievement(
    title = "Infinite Heartless", description = "Escape from Monstro", points = 10,
    id = 15587, badge = "14883", published = "10/16/2014 6:08:32 AM", modified = "7/7/2020 2:13:09 AM",
    trigger = worldId() == 0x05 && battlefieldId() == 0x05 && once(bit0(0x0422F7) == 0x0) && bit0(0x0422F7) == 0x1 && 
              bit0(0x042317) == 0x1 && byte(0x042346) == 0x0A
)

achievement(
    title = "Keyblade vs Buster Sword", description = "Rule 3. You can interfiere with your oponents on the course!", points = 10,
    id = 15593, badge = "14931", published = "10/16/2014 6:10:17 AM", modified = "7/7/2020 2:13:14 AM",
    trigger = worldId() == 0x03 && battlefieldId() == 0x06 && once(bit7(0x042306) == 0x0) && bit7(0x042306) == 0x1 && 
              bit7(0x042326) == 0x1 && byte(0x042346) == 0x0A
)

achievement(
    title = "Junior Hero", description = "Beat the Boss in Olympus Coliseum", points = 10,
    id = 15588, badge = "14912", published = "10/16/2014 6:09:40 AM", modified = "7/7/2020 2:13:21 AM",
    trigger = worldId() == 0x03 && battlefieldId() == 0x06 && once(bit4(0x04230C) == 0x0) && bit4(0x04230C) == 0x1 && 
              bit4(0x04232C) == 0x1 && byte(0x042346) == 0x0A
)

achievement(
    title = "Big Mistake", description = "Against a pack of Card Soldiers", points = 5,
    id = 15589, badge = "14913", published = "10/16/2014 6:09:46 AM", modified = "7/7/2020 2:13:30 AM",
    trigger = worldId() == 0x04 && battlefieldId() == 0x01 && once(bit6(0x042312) == 0x0) && bit6(0x042312) == 0x1 && 
              bit6(0x042332) == 0x1 && byte(0x042346) == 0x0A
)

achievement(
    title = "Alice in Wonderland", description = "Beat the Boss in Wonderland", points = 10,
    id = 15590, badge = "14924", published = "10/16/2014 6:09:55 AM", modified = "7/7/2020 2:13:36 AM",
    trigger = worldId() == 0x04 && battlefieldId() == 0x01 && once(bit5(0x04230C) == 0x0) && bit5(0x04230C) == 0x1 && 
              bit5(0x04232C) == 0x1 && byte(0x042346) == 0x0A
)

achievement(
    title = "Savage Nymph ", description = "Defeat Larxene in 7th Floor", points = 10,
    id = 15591, badge = "14925", published = "10/16/2014 6:10:01 AM", modified = "7/7/2020 2:13:41 AM",
    trigger = worldId() == 0x00 && battlefieldId() == 0x0C && once(bit2(0x042305) == 0x0) && bit2(0x042305) == 0x1 && 
              bit2(0x042325) == 0x1 && byte(0x042346) == 0x0A
)

achievement(
    title = "Friendly Fellows", description = "Get all the upgrades and cards from Pooh friends", points = 10,
    id = 15592, badge = "14926", published = "10/16/2014 6:10:10 AM", modified = "7/7/2020 2:13:48 AM",
    trigger = worldId() <= 0x0D && battlefieldId() == 0x0C && bit2(0x0422D5) == 0x1 && bit5(0x042303) == 0x1 && 
              bit3(0x042307) == 0x1 && bit3(0x0422D6) == 0x1 && bit1(0x0422D5) == 0x1 && bit4(0x0422D5) == 0x1 && bit1(0x042306) == 0x1 && 
              byte(0x042346) == 0x0A
)

achievement(
    title = "Searching for Riku", description = "In the Castle Oblivion...", points = 10,
    id = 15594, badge = "14932", published = "10/16/2014 6:11:05 AM", modified = "7/7/2020 2:13:55 AM",
    trigger = never(worldId() != 0x00) && battlefieldId() == 0x0C && once(bit6(0x042305) == 0x0) && 
              bit6(0x042305) == 0x1 && bit6(0x042325) == 0x1 && byte(0x042346) == 0x0A
)

achievement(
    title = "Under the Sea", description = "Beat the Boss in Atlantica", points = 10,
    id = 15595, badge = "15004", published = "10/16/2014 6:11:11 AM", modified = "7/7/2020 2:16:28 AM",
    trigger = worldId() == 0x02 && battlefieldId() == 0x04 && once(bit7(0x04230C) == 0x0) && bit7(0x04230C) == 0x1 && 
              bit7(0x04232C) == 0x1 && byte(0x042346) == 0x0A
)

achievement(
    title = "Finding for Riku", description = "In the Castle Oblivion...", points = 10,
    id = 15596, badge = "15005", published = "10/16/2014 6:11:18 AM", modified = "7/7/2020 2:16:42 AM",
    trigger = never(worldId() != 0x00) && battlefieldId() == 0x0C && once(bit7(0x0422D4) == 0x0) && 
              bit7(0x0422D4) == 0x1 && bit7(0x0422E4) == 0x1 && byte(0x042346) == 0x0A
)

achievement(
    title = "End of the World", description = "Beat the Boss in Hollow Bastion", points = 10,
    id = 15597, badge = "15011", published = "10/16/2014 6:11:28 AM", modified = "7/7/2020 2:16:37 AM",
    trigger = worldId() == 0x08 && battlefieldId() == 0x0A && once(bit3(0x04230D) == 0x0) && bit3(0x04230D) == 0x1 && 
              bit3(0x04232D) == 0x1 && byte(0x042346) == 0x0A
)

achievement(
    title = "Pixie Dust", description = "Beat the Boss in Neverland", points = 10,
    id = 15598, badge = "15013", published = "10/16/2014 6:11:35 AM", modified = "7/7/2020 2:16:47 AM",
    trigger = worldId() == 0x07 && battlefieldId() == 0x08 && once(bit2(0x04230D) == 0x0) && bit2(0x04230D) == 0x1 && 
              bit2(0x04232D) == 0x1 && byte(0x042346) == 0x0A
)

achievement(
    title = "Chilly Academic", description = "Defeat Vexen in 11th Floor", points = 10,
    id = 15611, badge = "15015", published = "10/16/2014 6:15:04 AM", modified = "7/7/2020 2:16:53 AM",
    trigger = worldId() == 0x00 && battlefieldId() == 0x0C && once(bit2(0x042307) == 0x0) && bit2(0x042307) == 0x1 && 
              bit2(0x042327) == 0x1 && byte(0x042346) == 0x0A
)

achievement(
    title = "Taste of the Past", description = "Beat the Boss in Twilight Town", points = 10,
    id = 15599, badge = "15017", published = "10/16/2014 6:11:42 AM", modified = "7/7/2020 2:16:58 AM",
    trigger = worldId() == 0x0B && battlefieldId() == 0x0D && once(bit7(0x04230D) == 0x0) && bit7(0x04230D) == 0x1 && 
              bit7(0x04232D) == 0x1 && byte(0x042346) == 0x0A
)

achievement(
    title = "Old Friend", description = "In the Castle Oblivion...", points = 10,
    id = 15619, badge = "15018", published = "10/16/2014 6:17:47 AM", modified = "7/7/2020 2:17:03 AM",
    trigger = never(worldId() != 0x00) && battlefieldId() == 0x0C && once(bit0(0x042307) == 0x0) && 
              bit0(0x042307) == 0x1 && bit0(0x042327) == 0x1 && byte(0x042346) == 0x0A
)

achievement(
    title = "Darkside", description = "Beat the Darkside in Destiny Islands", points = 10,
    id = 15600, badge = "15020", published = "10/16/2014 6:11:58 AM", modified = "7/7/2020 2:17:08 AM",
    trigger = worldId() == 0x09 && battlefieldId() == 0x09 && once(bit4(0x04230D) == 0x0) && bit4(0x04230D) == 0x1 && 
              bit4(0x04232D) == 0x1 && byte(0x042346) == 0x0A
)

achievement(
    title = "Riku, for last time...", description = "In the Castle Oblivion...", points = 10,
    id = 15602, badge = "15022", published = "10/16/2014 6:12:11 AM", modified = "7/7/2020 2:17:13 AM",
    trigger = never(worldId() != 0x00) && battlefieldId() == 0x0C && once(bit7(0x042312) == 0x0) && 
              bit7(0x042312) == 0x1 && bit7(0x042332) == 0x1 && byte(0x042346) == 0x0A
)

achievement(
    title = "Revenge of the Nymph", description = "Floor 12th...", points = 10,
    id = 15601, badge = "15025", published = "10/16/2014 6:12:06 AM", modified = "7/7/2020 2:17:19 AM",
    trigger = worldId() == 0x00 && battlefieldId() == 0x0C && once(bit5(0x04230D) == 0x0) && bit5(0x04230D) == 0x1 && 
              bit5(0x04232D) == 0x1 && byte(0x042346) == 0x0A
)

achievement(
    title = "Extinguish the fire", description = "Floor 13th...", points = 10,
    id = 15603, badge = "15026", published = "10/16/2014 6:12:19 AM", modified = "7/7/2020 2:17:25 AM",
    trigger = worldId() == 0x0C && battlefieldId() == 0x0C && once(bit6(0x04230D) == 0x0) && bit6(0x04230D) == 0x1 && 
              bit6(0x04232D) == 0x1 && byte(0x042346) == 0x0A
)

achievement(
    title = "Final...", description = "Floor...", points = 25,
    id = 15604, badge = "15027", published = "10/16/2014 6:12:29 AM", modified = "7/7/2020 2:17:38 AM",
    trigger = worldId() == 0x00 && battlefieldId() == 0x0C && bit0(0x04230E) == 0x1 && byte(0x042346) == 0x0A
)

achievement(
    title = "Reach Out To The Truth", description = "True Memories...", points = 5,
    id = 15605, badge = "15028", published = "10/16/2014 6:12:38 AM", modified = "7/7/2020 2:17:42 AM",
    trigger = worldId() == 0x00 && battlefieldId() == 0x0C && bit0(0x04230E) == 0x1 && bit6(0x04230D) == 0x1 && 
              byte(0x033190) == 0x08 && byte(0x033191) == 0x21 && word(0x033190) == 0x2108 && once(byte(0x033190) == 0xFD)
)

achievement(
    title = "Moguri ", description = "Have 5,000 Moguri points", points = 5,
    id = 15606, badge = "14847", published = "10/16/2014 6:14:16 AM", modified = "11/8/2016 6:45:42 PM",
    trigger = word(0x042334) >= 0x1388 && word(0x042334) <= 0x1400 && byte(0x042346) == 0x0A
)

achievement(
    title = "A Different Strategy", description = "Put 99 Card in any Deck", points = 1,
    id = 15607, badge = "14851", published = "10/16/2014 6:14:23 AM", modified = "7/7/2020 2:17:55 AM",
    trigger = byte(0x042346) == 0x0A &&
              ((byte(0x0425AC) == 0x63) ||
               (byte(0x04268C) == 0x63) ||
               (byte(0x0424CC) == 0x63))
)

achievement(
    title = "Cura+", description = "Reach 290 HP points", points = 5,
    id = 15608, badge = "14880", published = "10/16/2014 6:14:34 AM", modified = "7/7/2020 2:18:10 AM",
    trigger = once(maxHp() == 0x0113) && maxHp() == 0x0122 && byte(0x042346) == 0x0A
)

achievement(
    title = "Leveling Up", description = "Reach the MAX in Bonus A or Bonus B", points = 10,
    id = 15609, badge = "15007", published = "10/16/2014 6:14:45 AM", modified = "9/26/2019 11:37:01 AM",
    trigger = byte(0x042346) == 0x0A &&
              ((once(maxHp() == 0x0221) && maxHp() == 0x0230) ||
               (once(maxCp() == 0x0753) && maxCp() == 0x076C))
)

achievement(
    title = "Room of Rewards", description = "Special Treasure", points = 5,
    id = 15610, badge = "15008", published = "10/16/2014 6:14:53 AM", modified = "7/7/2020 2:18:19 AM",
    trigger = once(byte(0x042FCB) == 0x00) && byte(0x042FCB) == 0x01 && word(0x042FCA) == 0x0100 && 
              byte(0x042346) == 0x0A
)

achievement(
    title = "All the Rooms", description = "Get all the Map Cards (In the Journal)", points = 10,
    id = 15612, badge = "15228", published = "10/16/2014 6:15:39 AM", modified = "7/7/2020 2:22:16 AM",
    trigger = byte(0x04230F) == 0xFF && byte(0x042310) == 0xFF && bit1(0x04230E) == 0x1 && bit2(0x04230E) == 0x1 && 
              bit3(0x04230E) == 0x1 && bit4(0x04230E) == 0x1 && bit5(0x04230E) == 0x1 && bit6(0x04230E) == 0x1 && bit7(0x04230E) == 0x1 && 
              bit0(0x042311) == 0x1 && bit1(0x042311) == 0x1 && bit2(0x042311) == 0x1
)

achievement(
    title = "Lionheart", description = "Obtain the Lionhearth Keyblade Card", points = 5,
    id = 15581, badge = "14873", published = "10/16/2014 6:05:29 AM", modified = "7/7/2020 2:22:26 AM",
    trigger = worldId() == 0x0A && battlefieldId() == 0x0B && once(bit0(0x042304) == 0x0) && bit0(0x042304) == 0x1 && 
              bit0(0x042324) == 0x1 && byte(0x042346) == 0x0A
)

achievement(
    title = "Three Wishes", description = "Obtain the Three Wishes Keyblade Card", points = 5,
    id = 15627, badge = "14872", published = "10/16/2014 6:18:57 AM", modified = "7/7/2020 2:22:32 AM",
    trigger = bit0(0x042323) == 0x1 && once(bit0(0x042303) == 0x0) && bit0(0x042303) == 0x1 && byte(0x042346) == 0x0A
)

achievement(
    title = "One-Winged Angel", description = "Obtain the One-Winged Angel Keyblade Card", points = 5,
    id = 15628, badge = "15189", published = "10/16/2014 6:19:09 AM", modified = "7/7/2020 2:22:37 AM",
    trigger = once(bit7(0x042304) == 0x0) && bit7(0x042304) == 0x1 && bit7(0x042324) == 0x1 && byte(0x042346) == 0x0A
)

achievement(
    title = "Diamond Dust", description = "Obtain the Diamond Dust Keyblade Card", points = 5,
    id = 15629, badge = "15187", published = "10/16/2014 6:19:25 AM", modified = "7/7/2020 2:22:57 AM",
    trigger = once(bit6(0x042304) == 0x0) && bit6(0x042304) == 0x1 && bit6(0x042324) == 0x1 && byte(0x042346) == 0x0A
)

achievement(
    title = "Ultima Weapon", description = "Obtain the Ultima Weapon Keyblade Card", points = 5,
    id = 15630, badge = "15184", published = "10/16/2014 6:19:36 AM", modified = "9/29/2019 12:07:01 PM",
    trigger = worldId() == 0x0C && battlefieldId() == 0x0C && once(bit5(0x042304) == 0x0) && bit5(0x042304) == 0x1 && 
              bit5(0x042324) == 0x1 && byte(0x042346) == 0x0A
)

achievement(
    title = "Pumpkinhead", description = "Obtain the Pumpkinhead Keyblade Card", points = 5,
    id = 15631, badge = "14874", published = "10/16/2014 6:19:59 AM", modified = "7/7/2020 2:23:04 AM",
    trigger = once(bit2(0x042303) == 0x0) && bit2(0x042303) == 0x1 && bit2(0x042323) == 0x1 && byte(0x042346) == 0x0A
)

achievement(
    title = "Wishing Star", description = "Obtain the Wishing Star Keyblade Card", points = 5,
    id = 15632, badge = "14879", published = "10/16/2014 6:20:07 AM", modified = "7/7/2020 2:23:09 AM",
    trigger = once(bit4(0x042303) == 0x0) && bit4(0x042303) == 0x1 && bit4(0x042323) == 0x1 && byte(0x042346) == 0x0A
)

achievement(
    title = "Olympia", description = "Obtain the Olympia Keyblade Card", points = 5,
    id = 15634, badge = "14908", published = "10/16/2014 6:21:13 AM", modified = "7/7/2020 2:23:14 AM",
    trigger = once(bit7(0x042303) == 0x0) && bit7(0x042303) == 0x1 && bit7(0x042323) == 0x1 && byte(0x042346) == 0x0A
)

achievement(
    title = "Metal Chocobo", description = "Obtain the Metal Chocobo Keyblade Card", points = 5,
    id = 15635, badge = "14910", published = "10/16/2014 6:21:20 AM", modified = "7/7/2020 2:23:19 AM",
    trigger = once(bit6(0x042303) == 0x0) && bit6(0x042303) == 0x1 && bit6(0x042323) == 0x1 && byte(0x042346) == 0x0A
)

achievement(
    title = "Spellbinder", description = "Obtain the Spellbinder Keyblade Card", points = 5,
    id = 15636, badge = "14930", published = "10/16/2014 6:21:25 AM", modified = "7/7/2020 2:23:25 AM",
    trigger = once(bit5(0x042303) == 0x0) && bit5(0x042303) == 0x1 && bit5(0x042323) == 0x1 && worldId() == 0x0D && 
              battlefieldId() == 0x0C && byte(0x042346) == 0x0A
)

achievement(
    title = "Divine Rose", description = "Obtain the Divine Rose Keyblade Card", points = 5,
    id = 15637, badge = "15006", published = "10/16/2014 6:21:29 AM", modified = "7/7/2020 2:23:29 AM",
    trigger = worldId() == 0x08 && battlefieldId() == 0x0A && once(bit2(0x042304) == 0x0) && bit2(0x042304) == 0x1 && 
              bit2(0x042324) == 0x1 && byte(0x042346) == 0x0A
)

achievement(
    title = "Crabclaw", description = "Obtain the Crabclaw Keyblade Card", points = 5,
    id = 15638, badge = "14933", published = "10/16/2014 6:21:34 AM", modified = "7/7/2020 2:23:35 AM",
    trigger = worldId() == 0x02 && battlefieldId() == 0x04 && once(bit1(0x042303) == 0x0) && bit1(0x042303) == 0x1 && 
              bit1(0x042323) == 0x1 && byte(0x042346) == 0x0A
)

achievement(
    title = "Fairy Harp", description = "Obtain the Fairy Harp Keyblade Card", points = 5,
    id = 15639, badge = "15012", published = "10/16/2014 6:21:39 AM", modified = "7/7/2020 2:23:40 AM",
    trigger = worldId() == 0x07 && battlefieldId() == 0x08 && once(bit3(0x042303) == 0x0) && bit3(0x042303) == 0x1 && 
              bit3(0x042323) == 0x1 && byte(0x042346) == 0x0A
)

achievement(
    title = "Oathkeeper", description = "Obtain the Oathkeeper Keyblade Card", points = 5,
    id = 15640, badge = "15021", published = "10/16/2014 6:21:43 AM", modified = "7/7/2020 2:23:47 AM",
    trigger = worldId() == 0x09 && battlefieldId() == 0x09 && once(bit3(0x042304) == 0x0) && bit3(0x042304) == 0x1 && 
              bit3(0x042324) == 0x1 && byte(0x042346) == 0x0A
)

achievement(
    title = "Lady Luck", description = "Obtain the Lady Luck Keyblade Card", points = 5,
    id = 15641, badge = "14914", published = "10/16/2014 6:21:50 AM", modified = "7/7/2020 2:23:51 AM",
    trigger = once(bit1(0x042304) == 0x0) && bit1(0x042304) == 0x1 && bit1(0x042324) == 0x1 && byte(0x042346) == 0x0A
)

achievement(
    title = "Oblivion", description = "Obtain the Oblivion Keyblade Card", points = 5,
    id = 15642, badge = "15024", published = "10/16/2014 6:21:56 AM", modified = "7/7/2020 2:23:56 AM",
    trigger = worldId() == 0x00 && battlefieldId() == 0x0C && once(bit4(0x042304) == 0x0) && bit4(0x042304) == 0x1 && 
              bit4(0x042324) == 0x1 && byte(0x042346) == 0x0A
)

achievement(
    title = "This is Only the First", description = "Learn the 'Sliding Dash' Ability", points = 1,
    id = 15613, badge = "15212", published = "10/16/2014 6:15:51 AM", modified = "7/7/2020 2:24:02 AM",
    trigger = once(bit0(0x0422CC) == 0x0) && bit0(0x0422CC) == 0x1 && bit0(0x0422DC) == 0x1 && byte(0x042346) == 0x0A && 
              worldId() == 0x0A && battlefieldId() == 0x0B
)

achievement(
    title = "Blazing Donald", description = "Learn the 'Blazing Donald' Ability", points = 1,
    id = 15614, badge = "14868", published = "10/16/2014 6:16:30 AM", modified = "7/7/2020 2:24:09 AM",
    trigger = worldId() == 0x01 && battlefieldId() == 0x03 && once(bit3(0x0422D7) == 0x0) && bit3(0x0422D7) == 0x1 && 
              bit3(0x0422E7) == 0x1 && byte(0x042346) == 0x0A
)

achievement(
    title = "Stop Raid Sleight", description = "Learn the 'Stop Raid' Ability", points = 3,
    id = 15615, badge = "14915", published = "10/16/2014 6:16:43 AM", modified = "10/16/2014 6:23:10 AM",
    trigger = once(bit3(0x0422CF) == 0x0) && bit3(0x0422CF) == 0x1 && bit3(0x0422DF) == 0x1 && byte(0x042346) == 0x0A
)

achievement(
    title = "Quake Sleight", description = "Learn the 'Quake' Ability", points = 3,
    id = 15616, badge = "15003", published = "10/16/2014 6:17:15 AM", modified = "10/16/2014 6:23:13 AM",
    trigger = once(bit6(0x0422D4) == 0x0) && bit6(0x0422D4) == 0x1 && bit6(0x0422E4) == 0x1 && worldId() == 0x02 && 
              battlefieldId() == 0x04 && byte(0x042346) == 0x0A
)

achievement(
    title = "Thunder Raid Sleight", description = "Learn the 'Thunder Raid' Ability", points = 3,
    id = 15617, badge = "15009", published = "10/16/2014 6:17:24 AM", modified = "10/16/2014 6:23:15 AM",
    trigger = once(bit1(0x0422CF) == 0x0) && bit1(0x0422CF) == 0x1 && bit1(0x0422DF) == 0x1 && worldId() == 0x07 && 
              battlefieldId() == 0x08 && byte(0x042346) == 0x0A
)

achievement(
    title = "Warp Sleight", description = "Learn the 'Warp' Ability", points = 3,
    id = 15618, badge = "15016", published = "10/16/2014 6:17:31 AM", modified = "10/16/2014 6:23:17 AM",
    trigger = once(bit0(0x0422D5) == 0x0) && bit0(0x0422D5) == 0x1 && bit0(0x0422E5) == 0x1 && worldId() == 0x0B && 
              battlefieldId() == 0x0D && byte(0x042346) == 0x0A
)

achievement(
    title = "Firaga Break", description = "Learn the 'Firaga Break' Ability", points = 3,
    id = 15620, badge = "15221", published = "10/16/2014 6:17:58 AM", modified = "10/16/2014 6:23:21 AM",
    trigger = once(bit0(0x0422D4) == 0x0) && bit0(0x0422D4) == 0x1 && bit0(0x0422E4) == 0x1 && byte(0x042346) == 0x0A && 
              worldId() == 0x0B && battlefieldId() == 0x0D
)

achievement(
    title = "Burner", description = "Learn the 'Fire Raid' Ability", points = 3,
    id = 15621, badge = "15218", published = "10/16/2014 6:18:02 AM", modified = "10/16/2014 6:23:24 AM",
    trigger = once(bit7(0x0422CE) == 0x0) && bit7(0x0422CE) == 0x1 && bit7(0x0422DE) == 0x1 && byte(0x042346) == 0x0A && 
              worldId() == 0x05 && battlefieldId() == 0x05
)

achievement(
    title = "Cross-Whip", description = "Learn the 'Cross-Slash [plus]' Ability", points = 3,
    id = 15622, badge = "15213", published = "10/16/2014 6:18:08 AM", modified = "8/14/2018 12:38:08 PM",
    trigger = once(bit1(0x0422D7) == 0x0) && bit1(0x0422D7) == 0x1 && bit1(0x0422E7) == 0x1 && byte(0x042346) == 0x0A && 
              worldId() == 0x08 && battlefieldId() == 0x0A
)

achievement(
    title = "Divine Justice", description = "Learn the 'Judgment' Ability", points = 3,
    id = 15623, badge = "15210", published = "10/16/2014 6:18:13 AM", modified = "10/16/2014 6:23:28 AM",
    trigger = once(bit4(0x0422CF) == 0x0) && bit4(0x0422CF) == 0x1 && bit4(0x0422DF) == 0x1 && byte(0x042346) == 0x0A && 
              worldId() == 0x09 && battlefieldId() == 0x09
)

achievement(
    title = "Blizzard Raid ", description = "Learn the 'Blizzard Raid' Ability", points = 3,
    id = 15624, badge = "15209", published = "10/16/2014 6:18:20 AM", modified = "10/16/2014 6:23:31 AM",
    trigger = once(bit0(0x0422CF) == 0x0) && bit0(0x0422CF) == 0x1 && bit0(0x0422DF) == 0x1 && byte(0x042346) == 0x0A && 
              worldId() == 0x03 && battlefieldId() == 0x06
)

achievement(
    title = "Homing Blizzara", description = "Learn the 'Homing Blizzara'' Ability", points = 3,
    id = 15625, badge = "15207", published = "10/16/2014 6:18:24 AM", modified = "10/16/2014 6:23:33 AM",
    trigger = once(bit2(0x0422D4) == 0x0) && bit2(0x0422D4) == 0x1 && bit2(0x0422E4) == 0x1 && byte(0x042346) == 0x0A && 
              worldId() == 0x02 && battlefieldId() == 0x04
)

achievement(
    title = "More Than the Half", description = "Reach Level 50 (Reb)", points = 10,
    id = 15626, badge = "15193", published = "10/16/2014 6:18:37 AM", modified = "7/7/2020 2:24:33 AM",
    trigger = byte(0x042346) == 0x08 && once(level() == 0x31) && level() == 0x32 && 
              word(0x0422C8) == 0x0032
)

achievement(
    title = "Gravity Raid", description = "Learn the 'Gravity Raid' Ability", points = 3,
    id = 15633, badge = "14876", published = "10/16/2014 6:21:08 AM", modified = "10/16/2014 6:23:50 AM",
    trigger = worldId() == 0x06 && battlefieldId() == 0x07 && once(bit2(0x0422CF) == 0x0) && bit2(0x0422CF) == 0x1 && 
              bit2(0x0422DF) == 0x1 && byte(0x042346) == 0x0A
)

achievement(
    title = "Magic Refill", description = "Obtain the 'Ether' Card", points = 3,
    id = 15643, badge = "14875", published = "10/16/2014 6:22:07 AM", modified = "10/16/2014 6:24:14 AM",
    trigger = worldId() == 0x01 && battlefieldId() == 0x03 && once(bit1(0x042307) == 0x0) && bit1(0x042307) == 0x1 && 
              bit1(0x042327) == 0x1 && byte(0x042346) == 0x0A
)

achievement(
    title = "Megalixir", description = "Obtain the 'Megalixir' Card", points = 3,
    id = 15647, badge = "15019", published = "10/16/2014 6:22:45 AM", modified = "11/8/2016 6:44:41 PM",
    trigger = worldId() == 0x09 && battlefieldId() == 0x09 && once(bit4(0x042307) == 0x0) && bit4(0x042307) == 0x1 && 
              bit4(0x042327) == 0x1 && byte(0x042346) == 0x0A
)

achievement(
    title = "Time Stop", description = "Obtain the 'Stop' Card", points = 3,
    id = 15645, badge = "15204", published = "10/16/2014 6:22:27 AM", modified = "10/16/2014 6:24:18 AM",
    trigger = worldId() == 0x04 && battlefieldId() == 0x01 && once(bit5(0x042305) == 0x0) && bit5(0x042305) == 0x1 && 
              bit5(0x042325) == 0x1 && byte(0x042346) == 0x0A
)

achievement(
    title = "Always Down", description = "Obtain the 'Gravity' Card", points = 3,
    id = 15646, badge = "15205", published = "10/16/2014 6:22:35 AM", modified = "10/16/2014 6:24:21 AM",
    trigger = worldId() == 0x01 && battlefieldId() == 0x03 && once(bit4(0x042305) == 0x0) && bit4(0x042305) == 0x1 && 
              bit4(0x042325) == 0x1 && byte(0x042346) == 0x0A
)

achievement(
    title = "Mushu", description = "Get the 'Mushu' Card", points = 3,
    id = 15644, badge = "15010", published = "10/16/2014 6:22:17 AM", modified = "10/16/2014 6:24:16 AM",
    trigger = once(bit4(0x042306) == 0x0) && bit4(0x042306) == 0x1 && bit4(0x042326) == 0x1 && worldId() == 0x08 && 
              battlefieldId() == 0x0A && byte(0x042346) == 0x0A
)

achievement(
    title = "Lexaeus", description = "Obtain the 'Lexaeus' Card", points = 5,
    id = 15650, badge = "15185", published = "10/16/2014 6:26:31 AM", modified = "11/8/2016 5:30:58 PM",
    trigger = worldId() == 0x0C && battlefieldId() == 0x0C && once(bit0(0x042313) == 0x0) && bit0(0x042313) == 0x1 && 
              bit0(0x042333) == 0x1 && byte(0x042346) == 0x0A
)

achievement(
    title = "Reverse Rebirth", description = "Another Story, Same Castle (Reb)", points = 2,
    id = 15648, badge = "15029", published = "10/16/2014 6:22:53 AM", modified = "11/8/2016 6:44:21 PM",
    trigger = once(byte(0x005B30) == 0x20) && byte(0x005B30) == 0x00 && byte(0x03D0B2) == 0x05 && byte(0x042692) == 0x9C
)

achievement(
    title = "Ansem", description = "Obtain the 'Ansem' Card", points = 5,
    id = 15649, badge = "15186", published = "10/16/2014 6:26:26 AM", modified = "10/16/2014 6:48:37 AM",
    trigger = worldId() == 0x0C && battlefieldId() == 0x0C && once(bit1(0x042313) == 0x0) && bit1(0x042313) == 0x1 && 
              bit1(0x042333) == 0x1 && byte(0x042346) == 0x0A
)

achievement(
    title = "Critical Competitor", description = "Beat the game with Sora without never upgrade the Vitality bar", points = 50,
    id = 41892, badge = "43183", published = "11/8/2016 6:47:54 PM", modified = "7/7/2020 2:25:02 AM",
    trigger = worldId() == 0x00 && battlefieldId() == 0x0C && bit0(0x04230E) == 0x1 && bit6(0x04230D) == 0x1 && 
              byte(0x033190) == 0x08 && byte(0x033191) == 0x21 && word(0x033190) == 0x2108 && once(byte(0x033190) == 0xFD) && 
              maxHp() == 0x0050
)

achievement(
    title = "Around Green Flames", description = "Floor 1st... (Reb)", points = 10,
    id = 15651, badge = "15121", published = "10/16/2014 6:27:09 AM", modified = "7/7/2020 2:26:33 AM",
    trigger = worldId() == 0x08 && battlefieldId() == 0x0A && once(bit3(0x04230D) == 0x0) && bit3(0x04230D) == 0x1 && 
              bit3(0x04232D) == 0x1 && byte(0x042692) == 0x9C && byte(0x042346) == 0x08
)

achievement(
    title = "Darkness...", description = "Floor 1st... (Reb)", points = 10,
    id = 15652, badge = "15104", published = "10/16/2014 6:27:15 AM", modified = "7/7/2020 2:26:27 AM",
    trigger = worldId() == 0x00 && battlefieldId() == 0x0C && once(floor() == 0x00) && floor() == 0x01 && 
              word(0x0421CE) == 0xFF01 && byte(0x042346) == 0x08
)

achievement(
    title = "In the Sea of Fire", description = "Floor... (Reb)", points = 10,
    id = 15653, badge = "15126", published = "10/16/2014 6:27:21 AM", modified = "7/7/2020 2:26:20 AM",
    trigger = worldId() == 0x01 && battlefieldId() == 0x03 && once(bit6(0x04230C) == 0x0) && bit6(0x04230C) == 0x1 && 
              bit6(0x04232C) == 0x1 && byte(0x042346) == 0x08
)

achievement(
    title = "More Parasites", description = "Floor... (Reb)", points = 10,
    id = 15654, badge = "15130", published = "10/16/2014 6:27:28 AM", modified = "7/7/2020 2:26:13 AM",
    trigger = worldId() == 0x05 && battlefieldId() == 0x05 && once(bit1(0x04230D) == 0x0) && bit1(0x04230D) == 0x1 && 
              bit1(0x04232D) == 0x1 && byte(0x042346) == 0x08
)

achievement(
    title = "One More...", description = "Basement 12th... (Reb)", points = 10,
    id = 15655, badge = "15144", published = "10/16/2014 6:27:34 AM", modified = "7/7/2020 2:26:08 AM",
    trigger = worldId() == 0x00 && battlefieldId() == 0x0C && once(floor() == 0x02) && floor() == 0x03 && 
              word(0x0421CE) == 0xFF03 && byte(0x042346) == 0x08
)

achievement(
    title = "You can Fly", description = "Floor... (Reb)", points = 10,
    id = 15656, badge = "15145", published = "10/16/2014 6:27:38 AM", modified = "7/7/2020 2:26:03 AM",
    trigger = worldId() == 0x07 && battlefieldId() == 0x08 && once(bit2(0x04230D) == 0x0) && bit2(0x04230D) == 0x1 && 
              bit2(0x04232D) == 0x1 && byte(0x042346) == 0x08
)

achievement(
    title = "Armors", description = "Floor... (Reb)", points = 10,
    id = 15657, badge = "15149", published = "10/16/2014 6:27:45 AM", modified = "7/7/2020 2:25:58 AM",
    trigger = once(bit3(0x04230C) == 0x0) && bit3(0x04230C) == 0x1 && worldId() == 0x0A && battlefieldId() == 0x0B && 
              bit3(0x04232C) == 0x1 && byte(0x042346) == 0x08
)

achievement(
    title = "And Another...", description = "Basement 7th... (Reb)", points = 10,
    id = 15658, badge = "15152", published = "10/16/2014 6:27:52 AM", modified = "7/7/2020 2:25:53 AM",
    trigger = worldId() == 0x00 && battlefieldId() == 0x0C && once(floor() == 0x04) && floor() == 0x05 && 
              word(0x0421CE) == 0xFF05 && byte(0x042346) == 0x08
)

achievement(
    title = "Tentacles...", description = "Floor... (Reb)", points = 10,
    id = 15659, badge = "15153", published = "10/16/2014 6:27:57 AM", modified = "7/7/2020 2:25:48 AM",
    trigger = worldId() == 0x02 && battlefieldId() == 0x04 && once(bit7(0x04230C) == 0x0) && bit7(0x04230C) == 0x1 && 
              bit7(0x04232C) == 0x1 && byte(0x042346) == 0x08
)

achievement(
    title = "Trick or Treat", description = "Floor... (Reb)", points = 10,
    id = 15660, badge = "15154", published = "10/16/2014 6:28:03 AM", modified = "7/7/2020 2:25:43 AM",
    trigger = worldId() == 0x06 && battlefieldId() == 0x07 && once(bit0(0x04230D) == 0x0) && bit0(0x04230D) == 0x1 && 
              bit0(0x04232D) == 0x1 && byte(0x042346) == 0x08
)

achievement(
    title = "Hero Test", description = "Floor... (Reb)", points = 10,
    id = 15661, badge = "15159", published = "10/16/2014 6:28:08 AM", modified = "7/7/2020 2:25:39 AM",
    trigger = worldId() == 0x03 && battlefieldId() == 0x06 && once(bit4(0x04230C) == 0x0) && bit4(0x04230C) == 0x1 && 
              bit4(0x04232C) == 0x1 && byte(0x042346) == 0x08
)

achievement(
    title = "The Rabbit Hole", description = "Floor... (Reb)", points = 10,
    id = 15662, badge = "15164", published = "10/16/2014 6:28:12 AM", modified = "7/7/2020 2:25:35 AM",
    trigger = worldId() == 0x04 && battlefieldId() == 0x01 && once(bit5(0x04230C) == 0x0) && bit5(0x04230C) == 0x1 && 
              bit5(0x04232C) == 0x1 && byte(0x042346) == 0x08
)

achievement(
    title = "Power...", description = "Basement 4th... (Reb)", points = 10,
    id = 15663, badge = "15166", published = "10/16/2014 6:28:17 AM", modified = "7/7/2020 2:25:27 AM",
    trigger = worldId() == 0x00 && battlefieldId() == 0x0C && once(bit0(0x042313) == 0x0) && bit0(0x042313) == 0x1 && 
              bit0(0x042333) == 0x1 && byte(0x042346) == 0x08
)

achievement(
    title = "Darker...", description = "Basement 3rd... (Reb)", points = 10,
    id = 15664, badge = "15174", published = "10/16/2014 6:28:24 AM", modified = "7/7/2020 2:25:23 AM",
    trigger = worldId() == 0x09 && battlefieldId() == 0x09 && once(bit4(0x04230D) == 0x0) && bit4(0x04230D) == 0x1 && 
              bit4(0x04232D) == 0x1 && byte(0x042346) == 0x08
)

achievement(
    title = "Light and Dark", description = "Basement 2nd... (Reb)", points = 10,
    id = 15665, badge = "15178", published = "10/16/2014 6:28:32 AM", modified = "7/7/2020 2:25:18 AM",
    trigger = worldId() == 0x00 && battlefieldId() == 0x0C && once(floor() == 0x0A) && floor() == 0x0B && 
              word(0x0421CE) == 0xFF0B && byte(0x042346) == 0x08
)

achievement(
    title = "Final II...", description = "Floor... (Reb)", points = 25,
    id = 15666, badge = "15179", published = "10/16/2014 6:28:40 AM", modified = "7/7/2020 2:25:14 AM",
    trigger = worldId() == 0x0C && battlefieldId() == 0x0C && once(byte(0x03A9CC) == 0x20) && byte(0x03A9CC) == 0x00 && 
              once(byte(0x03A9CD) == 0x08) && byte(0x03A9CD) == 0x00 && once(word(0x03A9CE) == 0x0820) && word(0x03A9CE) == 0x0000 && 
              bit4(0x04230D) == 0x1
)

achievement(
    title = "Level Boost", description = "Reach the MAX in Bonus A or Bonus B (Reb)", points = 10,
    id = 15667, badge = "15030", published = "10/16/2014 6:39:25 AM", modified = "10/8/2019 2:07:01 PM",
    trigger = byte(0x042346) == 0x08 &&
              ((once(maxHp() == 0x0221) && maxHp() == 0x0230) ||
               (once(attackPoints() == 0x1D) && attackPoints() == 0x1E))
)

achievement(
    title = "The Final Floor", description = "Floor...", points = 5,
    id = 41891, badge = "43185", published = "11/8/2016 6:47:41 PM", modified = "11/8/2016 6:47:41 PM",
    trigger = worldId() == 0x00 && battlefieldId() == 0x0C && once(bit0(0x04230E) == 0x0) && bit0(0x04230E) == 0x1 && 
              bit6(0x04232E) == 0x1 && bit6(0x04230D) == 0x1 && byte(0x042346) == 0x0A
)

rich_presence_display("Level {0} in {1} ({2})",
    rich_presence_value("Level", level()),
    rich_presence_lookup("Location", byte(0x0421CC), LocationLookup),
    rich_presence_lookup("Floor", byte(0x0421CE) + bit7(0x042692) * 16, FloorLookup)
)
