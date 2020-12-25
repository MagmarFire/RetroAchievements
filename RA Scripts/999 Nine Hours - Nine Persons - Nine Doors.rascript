// 999: Nine Hours - Nine Persons - Nine Doors
// #ID = 999

// $1E06C4: (U) Escape room ID (3 bytes, first 2 appear region-independent, determines the location a player is in after moving the camera)
//          
//          0x3294 - 3rd class cabin
//          0x331D - 2nd class cabin
//          0x331E - kitchen
//          0x33A6 - operating room
//          0x342F - chart room
//          0x3430 - captain's quarters
//          0x34B8 - library
//          0x34B9 - study
//          0x7C6E - 1st class cabin
//          0x7C6F - casino
//          0x7CF7 - laboratory
//          0x7D80 - steam engine room
//          0x7D81 - cargo room
//          0xC648 - shower room
//          0xC6D1 - confinement room
//          0xC6D2 - torture room
//          0xE382 - sudoku
//          0x5AA7 - after clearing the sudoku
function escapeRoomId() => word(0x1E06C4)

// $1E06D1: (U) 0 -> 1 - escape room passed (set to 0 when entering an escape room, when set to 1 triggers the dialogue following the escape)
function escapeRoomCleared() => byte(0x1E06D1)

// $1E09A6: True Ending save file display flag
function trueEnding() => byte(0x1E09A6)

// $1E09A7: Coffin Ending save file display flag
function coffinEnding() => byte(0x1E09A7)

// $1E09A8: Axe Ending save file display flag
function axeEnding() => byte(0x1E09A8)

// $1E09A9: Safe Ending save file display flag
function safeEnding() => byte(0x1E09A9)

// $1E09AA: Knife Ending save file display flag
function knifeEnding() => byte(0x1E09AA)

// $1E09AB: Submarine Ending save file display flag
function submarineEnding() => byte(0x1E09AB)

// $1E51A4: (J) Escape room ID (3 bytes, first 2 appear region-independent)
function escapeRoomIdJP() => word(0x1E51A4)

// $1E51B1: (J) Escape room cleared flag
function escapeRoomClearedJP() => byte(0x1E51B1)

// $1E5486: (J) ending flags?
function endingFlagsJP() => byte(0x1E5486)

// $206352: 16-bit - Bottom screen ID
//          = 0xfff0 when not in an escape room
function bottomScreenId() => word(0x206352)

// $20AC52: (J) Bottom screen ID
function bottomScreenIdJP() => word(0x20AC52)

LocationLookup = {
    0x3294: "the third-class cabin",
    0x7c6e: "the first-class cabin",
    0xc6d2: "the torture room",
    0xc6d1: "the confinement room",
    0xc648: "the shower room",
    0x331e: "the kitchen",
    0x331d: "the second-class cabins",
    0x7d81: "the cargo room",
    0x33a6: "the operating room",
    0x342f: "the wheelhouse",
    0x3430: "the captain's quarters",
    0x34b8: "the library",
    0x34b9: "the study",
    0x7c6f: "the casino",
    0x7cf7: "the laboratory",
    0x7d80: "the engine room",
}

achievement(
    title = "Upgrade from Economy", description = "Escape from the first class cabin.", points = 5,
    id = 99232, badge = "109634", published = "2/16/2020 12:07:22 AM", modified = "2/24/2020 5:05:20 AM",
    trigger = always_true() &&
              ((escapeRoomId() == 0x7C6E && escapeRoomId() == prev(escapeRoomId()) && prev(escapeRoomCleared()) == 0x00 && 
                escapeRoomCleared() == 0x01) ||
               (escapeRoomIdJP() == 0x7C6E && escapeRoomIdJP() == prev(escapeRoomIdJP()) && prev(escapeRoomClearedJP()) == 0x00 && 
                escapeRoomClearedJP() == 0x01))
)

achievement(
    title = "Garns's Inferno", description = "Solve the sudoku puzzle in the incinerator.", points = 1,
    id = 100492, badge = "109636", published = "2/23/2020 6:41:42 PM", modified = "2/24/2020 5:05:21 AM",
    trigger = always_true() &&
              ((prev(escapeRoomId()) == 0xE382 && escapeRoomId() == 0x5AA7 && escapeRoomCleared() == 0x01 && 
                escapeRoomCleared() == prev(escapeRoomCleared())) ||
               (prev(escapeRoomIdJP()) == 0xE382 && escapeRoomIdJP() == 0x5AA7 && escapeRoomClearedJP() == 0x01 && 
                escapeRoomClearedJP() == prev(escapeRoomClearedJP())))
)

achievement(
    title = "The Mandela Effect", description = "Escape from the study.", points = 5,
    id = 100479, badge = "109635", published = "2/23/2020 4:25:46 PM", modified = "2/24/2020 5:05:23 AM",
    trigger = always_true() &&
              ((escapeRoomId() == 0x34B9 && escapeRoomId() == prev(escapeRoomId()) && prev(escapeRoomCleared()) == 0x00 && 
                escapeRoomCleared() == 0x01) ||
               (escapeRoomIdJP() == 0x34B9 && escapeRoomIdJP() == prev(escapeRoomIdJP()) && prev(escapeRoomClearedJP()) == 0x00 && 
                escapeRoomClearedJP() == 0x01))
)

achievement(
    title = "A Ghost of the Past", description = "Escape from the library.", points = 5,
    id = 100478, badge = "109602", published = "2/23/2020 6:56:29 AM", modified = "2/24/2020 5:05:24 AM",
    trigger = always_true() &&
              ((escapeRoomId() == 0x34B8 && escapeRoomId() == prev(escapeRoomId()) && prev(escapeRoomCleared()) == 0x00 && 
                escapeRoomCleared() == 0x01) ||
               (escapeRoomIdJP() == 0x34B8 && escapeRoomIdJP() == prev(escapeRoomIdJP()) && prev(escapeRoomClearedJP()) == 0x00 && 
                escapeRoomClearedJP() == 0x01))
)

achievement(
    title = "Metzger's Sin", description = "Escape from the torture room.", points = 5,
    id = 99589, badge = "109607", published = "2/18/2020 1:16:53 AM", modified = "2/24/2020 5:05:26 AM",
    trigger = always_true() &&
              ((escapeRoomId() == 0xC6D2 && escapeRoomId() == prev(escapeRoomId()) && prev(escapeRoomCleared()) == 0x00 && 
                escapeRoomCleared() == 0x01) ||
               (escapeRoomIdJP() == 0xC6D2 && escapeRoomIdJP() == prev(escapeRoomIdJP()) && prev(escapeRoomClearedJP()) == 0x00 && 
                escapeRoomClearedJP() == 0x01))
)

achievement(
    title = "Granted Parole", description = "Escape from the confinement room.", points = 5,
    id = 99588, badge = "109608", published = "2/18/2020 12:36:44 AM", modified = "2/24/2020 5:05:27 AM",
    trigger = always_true() &&
              ((escapeRoomId() == 0xC6D1 && escapeRoomId() == prev(escapeRoomId()) && prev(escapeRoomCleared()) == 0x00 && 
                escapeRoomCleared() == 0x01) ||
               (escapeRoomIdJP() == 0xC6D1 && escapeRoomIdJP() == prev(escapeRoomIdJP()) && prev(escapeRoomClearedJP()) == 0x00 && 
                escapeRoomClearedJP() == 0x01))
)

achievement(
    title = "Next to Godliness", description = "Escape from the shower room.", points = 5,
    id = 99583, badge = "109609", published = "2/17/2020 9:11:29 PM", modified = "2/24/2020 5:05:28 AM",
    trigger = always_true() &&
              ((escapeRoomId() == 0xC648 && escapeRoomId() == prev(escapeRoomId()) && prev(escapeRoomCleared()) == 0x00 && 
                escapeRoomCleared() == 0x01) ||
               (escapeRoomIdJP() == 0xC648 && escapeRoomIdJP() == prev(escapeRoomIdJP()) && prev(escapeRoomClearedJP()) == 0x00 && 
                escapeRoomClearedJP() == 0x01))
)

achievement(
    title = "Cat's Cradle", description = "Escape from the kitchen.", points = 5,
    id = 99581, badge = "109612", published = "2/17/2020 7:52:14 PM", modified = "2/24/2020 5:05:29 AM",
    trigger = always_true() &&
              ((escapeRoomId() == 0x331E && escapeRoomId() == prev(escapeRoomId()) && prev(escapeRoomCleared()) == 0x00 && 
                escapeRoomCleared() == 0x01) ||
               (escapeRoomIdJP() == 0x331E && escapeRoomIdJP() == prev(escapeRoomIdJP()) && prev(escapeRoomClearedJP()) == 0x00 && 
                escapeRoomClearedJP() == 0x01))
)

achievement(
    title = "Time for Checkout", description = "Escape from Rooms 92 and 93.", points = 5,
    id = 99580, badge = "109626", published = "2/17/2020 6:59:21 PM", modified = "2/24/2020 5:05:31 AM",
    trigger = always_true() &&
              ((escapeRoomId() == 0x331D && escapeRoomId() == prev(escapeRoomId()) && prev(escapeRoomCleared()) == 0x00 && 
                escapeRoomCleared() == 0x01) ||
               (escapeRoomIdJP() == 0x331D && escapeRoomIdJP() == prev(escapeRoomIdJP()) && prev(escapeRoomClearedJP()) == 0x00 && 
                escapeRoomClearedJP() == 0x01))
)

achievement(
    title = "Taken out of Storage", description = "Escape from the cargo room.", points = 5,
    id = 99512, badge = "109603", published = "2/17/2020 5:56:19 AM", modified = "2/24/2020 5:05:33 AM",
    trigger = always_true() &&
              ((escapeRoomId() == 0x7D81 && escapeRoomId() == prev(escapeRoomId()) && prev(escapeRoomCleared()) == 0x00 && 
                escapeRoomCleared() == 0x01) ||
               (escapeRoomIdJP() == 0x7D81 && escapeRoomIdJP() == prev(escapeRoomIdJP()) && prev(escapeRoomClearedJP()) == 0x00 && 
                escapeRoomClearedJP() == 0x01))
)

achievement(
    title = "The Ancient Engine", description = "Escape from the engine room.", points = 5,
    id = 99450, badge = "109628", published = "2/17/2020 5:21:33 AM", modified = "2/24/2020 5:05:34 AM",
    trigger = always_true() &&
              ((escapeRoomId() == 0x7D80 && escapeRoomId() == prev(escapeRoomId()) && prev(escapeRoomCleared()) == 0x00 && 
                escapeRoomCleared() == 0x01) ||
               (escapeRoomIdJP() == 0x7D80 && escapeRoomIdJP() == prev(escapeRoomIdJP()) && prev(escapeRoomClearedJP()) == 0x00 && 
                escapeRoomClearedJP() == 0x01))
)

achievement(
    title = "Primum Non Nocere", description = "Escape from the operating room.", points = 5,
    id = 99427, badge = "109629", published = "2/16/2020 7:58:13 PM", modified = "2/24/2020 5:05:36 AM",
    trigger = always_true() &&
              ((escapeRoomId() == 0x33A6 && escapeRoomId() == prev(escapeRoomId()) && prev(escapeRoomCleared()) == 0x00 && 
                escapeRoomCleared() == 0x01) ||
               (escapeRoomIdJP() == 0x33A6 && escapeRoomIdJP() == prev(escapeRoomIdJP()) && prev(escapeRoomClearedJP()) == 0x00 && 
                escapeRoomClearedJP() == 0x01))
)

achievement(
    title = "Our Fearful Trip Is Done", description = "Escape from the captain's quarters.", points = 5,
    id = 99302, badge = "109630", published = "2/16/2020 4:18:17 AM", modified = "2/24/2020 5:05:37 AM",
    trigger = always_true() &&
              ((escapeRoomId() == 0x3430 && escapeRoomId() == prev(escapeRoomId()) && prev(escapeRoomCleared()) == 0x00 && 
                escapeRoomCleared() == 0x01) ||
               (escapeRoomIdJP() == 0x3430 && escapeRoomIdJP() == prev(escapeRoomIdJP()) && prev(escapeRoomClearedJP()) == 0x00 && 
                escapeRoomClearedJP() == 0x01))
)

achievement(
    title = "Onward to Treacherous Waters", description = "Escape from the wheelhouse.", points = 5,
    id = 99301, badge = "109631", published = "2/16/2020 3:53:58 AM", modified = "2/24/2020 5:05:38 AM",
    trigger = always_true() &&
              ((escapeRoomId() == 0x342F && escapeRoomId() == prev(escapeRoomId()) && prev(escapeRoomCleared()) == 0x00 && 
                escapeRoomCleared() == 0x01) ||
               (escapeRoomIdJP() == 0x342F && escapeRoomIdJP() == prev(escapeRoomIdJP()) && prev(escapeRoomClearedJP()) == 0x00 && 
                escapeRoomClearedJP() == 0x01))
)

achievement(
    title = "Explanatory Gap", description = "Escape from the laboratory.", points = 5,
    id = 99239, badge = "109632", published = "2/16/2020 2:10:07 AM", modified = "2/24/2020 5:05:40 AM",
    trigger = always_true() &&
              ((escapeRoomId() == 0x7CF7 && escapeRoomId() == prev(escapeRoomId()) && prev(escapeRoomCleared()) == 0x00 && 
                escapeRoomCleared() == 0x01) ||
               (escapeRoomIdJP() == 0x7CF7 && escapeRoomIdJP() == prev(escapeRoomIdJP()) && prev(escapeRoomClearedJP()) == 0x00 && 
                escapeRoomClearedJP() == 0x01))
)

achievement(
    title = "Baby Needs a New Pair of Shoes", description = "Escape from the casino.", points = 5,
    id = 99234, badge = "109633", published = "2/16/2020 12:35:03 AM", modified = "2/24/2020 5:05:42 AM",
    trigger = always_true() &&
              ((escapeRoomId() == 0x7C6F && escapeRoomId() == prev(escapeRoomId()) && prev(escapeRoomCleared()) == 0x00 && 
                escapeRoomCleared() == 0x01) ||
               (escapeRoomIdJP() == 0x7C6F && escapeRoomIdJP() == prev(escapeRoomIdJP()) && prev(escapeRoomClearedJP()) == 0x00 && 
                escapeRoomClearedJP() == 0x01))
)

achievement(
    title = "Let Our Game Begin", description = "Escape from the room you woke up in.", points = 5,
    id = 99139, badge = "109584", published = "2/15/2020 4:48:12 PM", modified = "2/24/2020 5:05:43 AM",
    trigger = always_true() &&
              ((escapeRoomId() == 0x3294 && escapeRoomId() == prev(escapeRoomId()) && prev(escapeRoomCleared()) == 0x00 && 
                escapeRoomCleared() == 0x01) ||
               (escapeRoomIdJP() == 0x3294 && escapeRoomIdJP() == prev(escapeRoomIdJP()) && prev(escapeRoomClearedJP()) == 0x00 && 
                escapeRoomClearedJP() == 0x01))
)

achievement(
    title = "Slaughterhouse-Nine", description = "Unlock the Knife Ending and save your game.", points = 10,
    id = 99531, badge = "109627", published = "2/17/2020 7:30:27 AM", modified = "2/24/2020 5:05:44 AM",
    trigger = always_true() &&
              ((prev(knifeEnding()) == 0x00 && knifeEnding() == 0x01 && escapeRoomCleared() == 0x01 && 
                escapeRoomCleared() == prev(escapeRoomCleared()) && axeEnding() == prev(axeEnding()) && safeEnding() == prev(safeEnding()) && 
                submarineEnding() == prev(submarineEnding())) ||
               (prev(byte(0x1E548A)) == 0x00 && byte(0x1E548A) == 0x01 && escapeRoomClearedJP() == 0x01 && 
                escapeRoomClearedJP() == prev(escapeRoomClearedJP()) && byte(0x1E5488) == prev(byte(0x1E5488)) && byte(0x1E5489) == prev(byte(0x1E5489)) && 
                byte(0x1E548B) == prev(byte(0x1E548B))))
)

achievement(
    title = "Et Tu, Amica?", description = "Unlock the Axe Ending and save your game.", points = 10,
    id = 99315, badge = "109639", published = "2/16/2020 5:36:12 AM", modified = "2/24/2020 5:05:46 AM",
    trigger = always_true() &&
              ((prev(axeEnding()) == 0x00 && axeEnding() == 0x01 && escapeRoomCleared() == 0x01 && 
                escapeRoomCleared() == prev(escapeRoomCleared()) && safeEnding() == prev(safeEnding()) && knifeEnding() == prev(knifeEnding()) && 
                submarineEnding() == prev(submarineEnding())) ||
               (prev(byte(0x1E5488)) == 0x00 && byte(0x1E5488) == 0x01 && escapeRoomClearedJP() == 0x01 && 
                escapeRoomClearedJP() == prev(escapeRoomClearedJP()) && byte(0x1E5489) == prev(byte(0x1E5489)) && byte(0x1E548A) == prev(byte(0x1E548A)) && 
                byte(0x1E548B) == prev(byte(0x1E548B))))
)

achievement(
    title = "Face to Face with Futility", description = "Unlock the Submarine Ending and save your game.", points = 10,
    id = 99591, badge = "109606", published = "2/18/2020 1:55:38 AM", modified = "2/24/2020 5:05:48 AM",
    trigger = always_true() &&
              ((prev(submarineEnding()) == 0x00 && submarineEnding() == 0x01 && escapeRoomCleared() == 0x01 && 
                escapeRoomCleared() == prev(escapeRoomCleared()) && axeEnding() == prev(axeEnding()) && safeEnding() == prev(safeEnding()) && 
                knifeEnding() == prev(knifeEnding())) ||
               (prev(byte(0x1E548B)) == 0x00 && byte(0x1E548B) == 0x01 && escapeRoomClearedJP() == 0x01 && 
                escapeRoomClearedJP() == prev(escapeRoomClearedJP()) && byte(0x1E5488) == prev(byte(0x1E5488)) && byte(0x1E5489) == prev(byte(0x1E5489)) && 
                byte(0x1E548A) == prev(byte(0x1E548A))))
)

achievement(
    title = "Gateway to the Truth", description = "Unlock the Safe Ending and save your game.", points = 10,
    id = 99606, badge = "109605", published = "2/18/2020 11:23:57 PM", modified = "2/24/2020 5:05:50 AM",
    trigger = always_true() &&
              ((prev(safeEnding()) == 0x00 && safeEnding() == 0x01 && escapeRoomCleared() == 0x01 && 
                escapeRoomCleared() == prev(escapeRoomCleared()) && axeEnding() == prev(axeEnding()) && knifeEnding() == prev(knifeEnding()) && 
                submarineEnding() == prev(submarineEnding())) ||
               (prev(byte(0x1E5489)) == 0x00 && byte(0x1E5489) == 0x01 && escapeRoomClearedJP() == 0x01 && 
                escapeRoomClearedJP() == prev(escapeRoomClearedJP()) && byte(0x1E5488) == prev(byte(0x1E5488)) && byte(0x1E548A) == prev(byte(0x1E548A)) && 
                byte(0x1E548B) == prev(byte(0x1E548B))))
)

achievement(
    title = "A Corpse in the Dark", description = "Unlock the Coffin Ending and save your game.", points = 10,
    id = 100527, badge = "109637", published = "2/23/2020 7:27:23 PM", modified = "2/24/2020 5:05:51 AM",
    trigger = always_true() &&
              ((prev(coffinEnding()) == 0x00 && coffinEnding() == 0x01 && escapeRoomCleared() == 0x01 && 
                escapeRoomCleared() == prev(escapeRoomCleared()) && axeEnding() == prev(axeEnding()) && safeEnding() == prev(safeEnding()) && 
                knifeEnding() == prev(knifeEnding()) && submarineEnding() == prev(submarineEnding())) ||
               (prev(byte(0x1E5487)) == 0x00 && byte(0x1E5487) == 0x01 && escapeRoomClearedJP() == 0x01 && 
                escapeRoomClearedJP() == prev(escapeRoomClearedJP()) && byte(0x1E5488) == prev(byte(0x1E5488)) && byte(0x1E5489) == prev(byte(0x1E5489)) && 
                byte(0x1E548A) == prev(byte(0x1E548A)) && byte(0x1E548B) == prev(byte(0x1E548B))))
)

achievement(
    title = "Plaudite! Acta Est Fabula!", description = "Unlock the True Ending and save your game.", points = 25,
    id = 100493, badge = "109638", published = "2/23/2020 7:14:12 PM", modified = "2/24/2020 5:05:52 AM",
    trigger = always_true() &&
              ((prev(trueEnding()) == 0x00 && trueEnding() == 0x01 && escapeRoomCleared() == 0x01 && 
                escapeRoomCleared() == prev(escapeRoomCleared()) && axeEnding() == prev(axeEnding()) && safeEnding() == prev(safeEnding()) && 
                knifeEnding() == prev(knifeEnding()) && submarineEnding() == prev(submarineEnding())) ||
               (prev(endingFlagsJP()) == 0x00 && endingFlagsJP() == 0x01 && escapeRoomClearedJP() == 0x01 && 
                escapeRoomClearedJP() == prev(escapeRoomClearedJP()) && byte(0x1E5488) == prev(byte(0x1E5488)) && byte(0x1E5489) == prev(byte(0x1E5489)) && 
                byte(0x1E548A) == prev(byte(0x1E548A)) && byte(0x1E548B) == prev(byte(0x1E548B))))
)

rich_presence_conditional_display(bottomScreenIdJP() == 0xFFF0, "Exploring the ship...")

rich_presence_conditional_display(bottomScreenId() == 0xFFF0, "Exploring the ship...")

rich_presence_conditional_display(escapeRoomClearedJP() == 0x00, "Seeking a way out of {0}!",
    rich_presence_lookup("Location", word(0x1E51A4), LocationLookup, fallback="a room")
)

rich_presence_display("Seeking a way out of {0}!",
    rich_presence_lookup("Location", word(0x1E06C4), LocationLookup, fallback="a room")
)
