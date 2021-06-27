// Legend of Dragoon, The
// #ID = 11264

// Utilities
function Delta(addr) => prev(addr)

// $052C30: Map ID - 16-bit
function mapId() => word(0x052C30)

// $0BB0F4: Battlefield ID
function battlefieldId() => word(0x0BB0F4)

// $0BB0F8: Enemy ID
function enemyId() => word(0x0BB0F8)

function chapter() => byte(0x0BAC60)

// $0BC920: Gold Prize (32-bit)
function goldPrize() => word(0x0BC920)

// $0BC95C: EXP Prize (32-bit)
function expPrize() => word(0x0BC95C)

function EnteredBattleOnce() => once(Delta(battleMarker()) != battleMarker() && IsInBattle())

// $ccdec:  Misc.
//
//          0x1021 = in battle
//          0x8005 = world map(?)
function battleMarker() => word(0xccdec)
function IsInBattle() => battleMarker() == 0x1021

// $0badae: Total items in inventory
function itemsInInventory() => byte(0x0badae)

// $0bac3c: Tickets earned
function ticketsEarned() => byte(0x0bac3c)

achievement(
    title = "Just One More!", description = "Perform your first Addition.", points = 1,
    id = 94789, badge = "107881", published = "1/15/2020 11:23:20 PM", modified = "2/13/2020 5:18:17 AM",
    trigger = word(0x0CCDEC) == 0x1021 &&
              ((byte(0x0BAF16) == 0x01 && prev(byte(0x0BAF16)) == 0x00) ||
               (byte(0x0BAF17) == 0x01 && prev(byte(0x0BAF17)) == 0x00) ||
               (byte(0x0BAF18) == 0x01 && prev(byte(0x0BAF18)) == 0x00) ||
               (byte(0x0BAF19) == 0x01 && prev(byte(0x0BAF19)) == 0x00) ||
               (byte(0x0BAF1A) == 0x01 && prev(byte(0x0BAF1A)) == 0x00) ||
               (byte(0x0BAF1B) == 0x01 && prev(byte(0x0BAF1B)) == 0x00) ||
               (byte(0x0BAF42) == 0x01 && prev(byte(0x0BAF42)) == 0x00) ||
               (byte(0x0BAF43) == 0x01 && prev(byte(0x0BAF43)) == 0x00) ||
               (byte(0x0BAF44) == 0x01 && prev(byte(0x0BAF44)) == 0x00) ||
               (byte(0x0BAF45) == 0x01 && prev(byte(0x0BAF45)) == 0x00) ||
               (byte(0x0BAF9A) == 0x01 && prev(byte(0x0BAF9A)) == 0x00) ||
               (byte(0x0BAF9B) == 0x01 && prev(byte(0x0BAF9B)) == 0x00) ||
               (byte(0x0BAF9C) == 0x01 && prev(byte(0x0BAF9C)) == 0x00) ||
               (byte(0x0BAFC6) == 0x01 && prev(byte(0x0BAFC6)) == 0x00) ||
               (byte(0x0BAFC7) == 0x01 && prev(byte(0x0BAFC7)) == 0x00) ||
               (byte(0x0BAFC8) == 0x01 && prev(byte(0x0BAFC8)) == 0x00) ||
               (byte(0x0BAFC9) == 0x01 && prev(byte(0x0BAFC9)) == 0x00) ||
               (byte(0x0BAFCA) == 0x01 && prev(byte(0x0BAFCA)) == 0x00) ||
               (byte(0x0BAFF2) == 0x01 && prev(byte(0x0BAFF2)) == 0x00) ||
               (byte(0x0BAFF3) == 0x01 && prev(byte(0x0BAFF3)) == 0x00) ||
               (byte(0x0BAFF4) == 0x01 && prev(byte(0x0BAFF4)) == 0x00) ||
               (byte(0x0BAFF5) == 0x01 && prev(byte(0x0BAFF5)) == 0x00) ||
               (byte(0x0BB01E) == 0x01 && prev(byte(0x0BB01E)) == 0x00) ||
               (byte(0x0BB01F) == 0x01 && prev(byte(0x0BB01F)) == 0x00) ||
               (byte(0x0BB020) == 0x01 && prev(byte(0x0BB020)) == 0x00) ||
               (byte(0x0BB021) == 0x01 && prev(byte(0x0BB021)) == 0x00) ||
               (byte(0x0BB04A) == 0x01 && prev(byte(0x0BB04A)) == 0x00) ||
               (byte(0x0BB04B) == 0x01 && prev(byte(0x0BB04B)) == 0x00))
)

achievement(
    title = "Double Slash Master", description = "Get the Double Slash Addition to Level 5.", points = 5,
    id = 95519, badge = "106755", published = "1/20/2020 9:59:10 PM", modified = "2/3/2020 1:46:31 AM",
    trigger = byte(0x0BAF0E) == 0x05 && prev(byte(0x0BAF0E)) == 0x04 && measured(byte(0x0BAF16) == 0x50)
)

achievement(
    title = "Volcano Master", description = "Get the Volcano Addition to Level 5.", points = 5,
    id = 95520, badge = "106755", published = "1/20/2020 10:01:46 PM", modified = "2/3/2020 1:46:38 AM",
    trigger = byte(0x0BAF0F) == 0x05 && prev(byte(0x0BAF0F)) == 0x04 && measured(byte(0x0BAF17) == 0x50)
)

achievement(
    title = "Burning Rush Master", description = "Get the Burning Rush Addition to Level 5.", points = 5,
    id = 95521, badge = "106755", published = "1/20/2020 10:02:34 PM", modified = "2/3/2020 1:46:50 AM",
    trigger = byte(0x0BAF10) == 0x05 && prev(byte(0x0BAF10)) == 0x04 && measured(byte(0x0BAF18) == 0x50)
)

achievement(
    title = "Crush Dance Master", description = "Get the Crush Dance Addition to Level 5.", points = 5,
    id = 95522, badge = "106755", published = "1/20/2020 10:03:20 PM", modified = "2/3/2020 1:46:58 AM",
    trigger = byte(0x0BAF11) == 0x05 && prev(byte(0x0BAF11)) == 0x04 && measured(byte(0x0BAF19) == 0x50)
)

achievement(
    title = "Madness Hero Master", description = "Get the Madness Hero Addition to Level 5.", points = 5,
    id = 95523, badge = "106755", published = "1/20/2020 10:04:34 PM", modified = "2/3/2020 1:47:15 AM",
    trigger = byte(0x0BAF12) == 0x05 && prev(byte(0x0BAF12)) == 0x04 && measured(byte(0x0BAF1A) == 0x50)
)

achievement(
    title = "Moon Strike Master", description = "Get the Moon Strike Addition to Level 5.", points = 5,
    id = 95524, badge = "106755", published = "1/20/2020 10:05:34 PM", modified = "2/3/2020 1:50:19 AM",
    trigger = byte(0x0BAF13) == 0x05 && prev(byte(0x0BAF13)) == 0x04 && measured(byte(0x0BAF1B) == 0x50)
)

achievement(
    title = "The Flaming Swordsman", description = "Perform the Blazing Dynamo Addition for the first time.", points = 5,
    id = 95525, badge = "106755", published = "1/20/2020 10:18:07 PM", modified = "2/3/2020 1:53:18 AM",
    trigger = prev(byte(0x0BAF1C)) == 0x00 && byte(0x0BAF1C) == 0x01 && word(0x0CCDEC) == 0x1021
)

achievement(
    title = "Harpoon Master", description = "Get the Harpoon Addition to Level 5.", points = 5,
    id = 95526, badge = "106756", published = "1/20/2020 10:31:24 PM", modified = "2/3/2020 1:49:53 AM",
    trigger = ((byte(0x0BAF3A) == 0x05 && prev(byte(0x0BAF3A)) == 0x04 && measured(byte(0x0BAF42) == 0x50)) ||
               (prev(byte(0x0BAFEA)) == 0x04 && byte(0x0BAFEA) == 0x05 && measured(byte(0x0BAFF2) == 0x50)))
)

achievement(
    title = "Spinning Cane Master", description = "Get the Spinning Cane Addition to Level 5.", points = 5,
    id = 95527, badge = "106756", published = "1/20/2020 10:32:09 PM", modified = "2/3/2020 1:49:59 AM",
    trigger = ((byte(0x0BAF3B) == 0x05 && prev(byte(0x0BAF3B)) == 0x04 && measured(byte(0x0BAF43) == 0x50)) ||
               (prev(byte(0x0BAFEB)) == 0x04 && byte(0x0BAFEB) == 0x05 && measured(byte(0x0BAFF3) == 0x50)))
)

achievement(
    title = "Rod Typhoon Master", description = "Get the Rod Typhoon Addition to Level 5.", points = 5,
    id = 95528, badge = "106756", published = "1/20/2020 10:32:55 PM", modified = "2/3/2020 1:50:08 AM",
    trigger = ((prev(byte(0x0BAF3C)) == 0x04 && byte(0x0BAF3C) == 0x05 && measured(byte(0x0BAF44) == 0x50)) ||
               (prev(byte(0x0BAFEC)) == 0x04 && byte(0x0BAFEC) == 0x05 && measured(byte(0x0BAFF4) == 0x50)))
)

achievement(
    title = "Gust of Wind Dance Master", description = "Get the Gust of Wind Dance Addition to Level 5.", points = 5,
    id = 95529, badge = "106756", published = "1/20/2020 10:33:30 PM", modified = "2/3/2020 1:50:15 AM",
    trigger = ((prev(byte(0x0BAF3D)) == 0x04 && byte(0x0BAF3D) == 0x05 && measured(byte(0x0BAF45) == 0x50)) ||
               (prev(byte(0x0BAFED)) == 0x04 && byte(0x0BAFED) == 0x05 && measured(byte(0x0BAFF5) == 0x50)))
)

achievement(
    title = "The Howling Lancer", description = "Perform the Flower Storm Addition for the first time.", points = 5,
    id = 95530, badge = "106756", published = "1/20/2020 10:43:41 PM", modified = "2/3/2020 1:55:49 AM",
    trigger = word(0x0CCDEC) == 0x1021 &&
              ((prev(byte(0x0BAF46)) == 0x00 && byte(0x0BAF46) == 0x01) ||
               (prev(byte(0x0BAFF6)) == 0x00 && byte(0x0BAFF6) == 0x01))
)

achievement(
    title = "Whip Smack Master", description = "Get the Whip Smack Addition to Level 5.", points = 5,
    id = 95531, badge = "106729", published = "1/20/2020 10:55:42 PM", modified = "2/3/2020 1:56:04 AM",
    trigger = prev(byte(0x0BAF92)) == 0x04 && byte(0x0BAF92) == 0x05 && measured(byte(0x0BAF9A) == 0x50)
)

achievement(
    title = "More and More Master", description = "Get the More and More Addition to Level 5.", points = 5,
    id = 95532, badge = "106729", published = "1/20/2020 11:05:11 PM", modified = "2/3/2020 1:56:10 AM",
    trigger = prev(byte(0x0BAF93)) == 0x04 && byte(0x0BAF93) == 0x05 && measured(byte(0x0BAF9B) == 0x50)
)

achievement(
    title = "Hard Blade Master", description = "Get the Hard Blade Addition to Level 5.", points = 5,
    id = 95533, badge = "106729", published = "1/20/2020 11:05:48 PM", modified = "2/3/2020 1:56:15 AM",
    trigger = prev(byte(0x0BAF94)) == 0x04 && byte(0x0BAF94) == 0x05 && measured(byte(0x0BAF9C) == 0x50)
)

achievement(
    title = "The Dread Swordswoman", description = "Perform the Demon's Dance Addition for the first time.", points = 5,
    id = 95534, badge = "106729", published = "1/20/2020 11:06:50 PM", modified = "2/3/2020 1:56:28 AM",
    trigger = prev(byte(0x0BAF9D)) == 0x00 && byte(0x0BAF9D) == 0x01 && word(0x0CCDEC) == 0x1021
)

achievement(
    title = "Double Punch Master", description = "Get the Double Punch Addition to Level 5.", points = 5,
    id = 95535, badge = "106699", published = "1/20/2020 11:17:59 PM", modified = "2/3/2020 1:58:39 AM",
    trigger = prev(byte(0x0BAFBE)) == 0x04 && byte(0x0BAFBE) == 0x05 && measured(byte(0x0BAFC6) == 0x50)
)

achievement(
    title = "Flurry of Styx Master", description = "Get the Flurry of Styx Addition to Level 5.", points = 5,
    id = 95536, badge = "106699", published = "1/20/2020 11:19:03 PM", modified = "2/3/2020 1:58:45 AM",
    trigger = prev(byte(0x0BAFBF)) == 0x04 && byte(0x0BAFBF) == 0x05 && measured(byte(0x0BAFC7) == 0x50)
)

achievement(
    title = "Summon Four Gods Master", description = "Get the Summon Four Gods Addition to Level 5.", points = 5,
    id = 95537, badge = "106699", published = "1/20/2020 11:19:37 PM", modified = "2/3/2020 1:58:49 AM",
    trigger = prev(byte(0x0BAFC0)) == 0x04 && byte(0x0BAFC0) == 0x05 && measured(byte(0x0BAFC8) == 0x50)
)

achievement(
    title = "Five-Ring Shattering Master", description = "Get the Five-Ring Shattering Addition to Level 5.", points = 5,
    id = 95538, badge = "106699", published = "1/20/2020 11:20:15 PM", modified = "2/3/2020 1:58:53 AM",
    trigger = prev(byte(0x0BAFC1)) == 0x04 && byte(0x0BAFC1) == 0x05 && measured(byte(0x0BAFC9) == 0x50)
)

achievement(
    title = "Hex Hammer Master", description = "Get the Hex Hammer Addition to Level 5.", points = 5,
    id = 95539, badge = "106699", published = "1/20/2020 11:20:56 PM", modified = "2/3/2020 1:58:58 AM",
    trigger = prev(byte(0x0BAFC2)) == 0x04 && byte(0x0BAFC2) == 0x05 && measured(byte(0x0BAFCA) == 0x50)
)

achievement(
    title = "The Electrifying Martial Artist", description = "Perform the Omni-Sweep Addition for the first time.", points = 5,
    id = 95540, badge = "106699", published = "1/20/2020 11:21:48 PM", modified = "2/3/2020 1:59:10 AM",
    trigger = prev(byte(0x0BAFCB)) == 0x00 && byte(0x0BAFCB) == 0x01 && word(0x0CCDEC) == 0x1021
)

achievement(
    title = "Double Smack Master", description = "Get the Double Smack Addition to Level 5.", points = 5,
    id = 95541, badge = "106743", published = "1/20/2020 11:29:09 PM", modified = "2/3/2020 2:02:29 AM",
    trigger = prev(byte(0x0BB016)) == 0x04 && byte(0x0BB016) == 0x05 && measured(byte(0x0BB01E) == 0x50)
)

achievement(
    title = "Hammer Spin Master", description = "Get the Hammer Spin Addition to Level 5.", points = 5,
    id = 95542, badge = "106743", published = "1/20/2020 11:29:38 PM", modified = "2/3/2020 2:02:34 AM",
    trigger = prev(byte(0x0BB017)) == 0x04 && byte(0x0BB017) == 0x05 && measured(byte(0x0BB01F) == 0x50)
)

achievement(
    title = "Cool Boogie Master", description = "Get the Cool Boogie Addition to Level 5.", points = 5,
    id = 95543, badge = "106743", published = "1/20/2020 11:30:04 PM", modified = "2/3/2020 2:02:39 AM",
    trigger = prev(byte(0x0BB018)) == 0x04 && byte(0x0BB018) == 0x05 && measured(byte(0x0BB020) == 0x50)
)

achievement(
    title = "Cat's Cradle Master", description = "Get the Cat's Cradle Addition to Level 5.", points = 5,
    id = 95544, badge = "106743", published = "1/20/2020 11:30:39 PM", modified = "2/3/2020 2:02:43 AM",
    trigger = prev(byte(0x0BB019)) == 0x04 && byte(0x0BB019) == 0x05 && measured(byte(0x0BB021) == 0x50)
)

achievement(
    title = "The Scalding Warmaiden", description = "Perform the Perky Step Addition for the first time.", points = 5,
    id = 95545, badge = "106743", published = "1/20/2020 11:34:07 PM", modified = "2/3/2020 2:03:00 AM",
    trigger = prev(byte(0x0BB022)) == 0x00 && byte(0x0BB022) == 0x01 && word(0x0CCDEC) == 0x1021
)

achievement(
    title = "Pursuit Master", description = "Get the Pursuit Addition to Level 5.", points = 5,
    id = 95546, badge = "106698", published = "1/20/2020 11:41:38 PM", modified = "2/3/2020 2:10:45 AM",
    trigger = prev(byte(0x0BB042)) == 0x04 && byte(0x0BB042) == 0x05 && measured(byte(0x0BB04A) == 0x50)
)

achievement(
    title = "Inferno Master", description = "Get the Inferno Addition to Level 5.", points = 5,
    id = 95547, badge = "106698", published = "1/20/2020 11:42:12 PM", modified = "2/3/2020 2:10:53 AM",
    trigger = prev(byte(0x0BB043)) == 0x04 && byte(0x0BB043) == 0x05 && measured(byte(0x0BB04B) == 0x50)
)

achievement(
    title = "The Mountainous Berserker", description = "Perform the Bone Crush Addition for the first time.", points = 5,
    id = 95548, badge = "106698", published = "1/20/2020 11:45:31 PM", modified = "2/3/2020 2:13:11 AM",
    trigger = prev(byte(0x0BB04C)) == 0x00 && byte(0x0BB04C) == 0x01 && word(0x0CCDEC) == 0x1021
)

achievement(
    title = "Tears from Above", description = "Find a piece of Stardust for the first time.", points = 5,
    id = 94786, badge = "106754", published = "1/15/2020 11:22:57 PM", modified = "2/3/2020 2:14:48 AM",
    trigger = byte(0x0BAC64) == 0x01 && prev(byte(0x0BAC64)) == 0x00
)

achievement(
    title = "Halfway There", description = "Collect 25 Stardust.", points = 10,
    id = 94787, badge = "106754", published = "1/15/2020 11:23:03 PM", modified = "2/3/2020 2:14:52 AM",
    trigger = byte(0x0BAC64) == 0x19 && prev(byte(0x0BAC64)) == 0x18 && measured(byte(0x0BAC64) == 0x19)
)

achievement(
    title = "Twinkle, Twinkle, Little Stardust", description = "Collect all 50 Stardust.", points = 25,
    id = 94788, badge = "106754", published = "1/15/2020 11:23:14 PM", modified = "2/3/2020 2:14:56 AM",
    trigger = byte(0x0BAC64) == 0x32 && prev(byte(0x0BAC64)) == 0x31
)

achievement(
    title = "The Verdant Knight", description = "Befriend Lavitz.", points = 1,
    id = 96414, badge = "106708", published = "1/28/2020 11:03:09 PM", modified = "2/3/2020 2:16:47 AM",
    trigger = word(0x052C30) == 0x0018 && prev(bit0(0x0BAF24)) == 0x0 && bit0(0x0BAF24) == 0x1
)

achievement(
    title = "Together Once More", description = "Reunite with Shana.", points = 1,
    id = 96415, badge = "106717", published = "1/28/2020 11:23:48 PM", modified = "2/3/2020 2:16:51 AM",
    trigger = bit0(0x0BAF24) == 0x1 &&
              ((prev(bit0(0x0BAF50)) == 0x0 && bit0(0x0BAF50) == 0x1 && word(0x052C30) == 0x0016) ||
               (repeated(400, word(0x052C30) == 0x0283)))
)

achievement(
    title = "A Picture of Health", description = "Get a portrait of Lavitz painted in Bale.", points = 1,
    id = 96511, badge = "106708", published = "1/29/2020 3:02:51 AM", modified = "2/3/2020 2:27:02 AM",
    trigger = bit4(0x0BAD68) == 0x1 && prev(bit4(0x0BAD68)) == 0x0 && word(0x052C30) == 0x0049
)

achievement(
    title = "Duck, Duck, Goose", description = "Catch the strange creature in the Limestone Cave and take the treasure.", points = 5,
    id = 97667, badge = "107870", published = "2/6/2020 3:12:14 AM", modified = "2/16/2020 6:18:26 PM",
    trigger = word(0x052C30) == 0x0032 && bit5(0x0BAD90) == 0x1 && prev(bit5(0x0BAD90)) == 0x0
)

achievement(
    title = "No Ordinary Keepsake", description = "Awaken the Dragoon Spirit of the Red-Eyed Dragon.", points = 5,
    id = 94790, badge = "106752", published = "1/15/2020 11:23:24 PM", modified = "2/3/2020 10:16:19 PM",
    trigger = ((bit0(0x0BAD64) == 0x1 && prev(bit0(0x0BAD64)) == 0x0 && byte(0x052C30) == 0x61) ||
               (repeated(2850, word(0x1AF6A4) == 0x0000) && word(0x0BB0F8) == 0x0184 && word(0x052C30) == 0x0291 && 
                never(word(0x0BB0F8) != 0x0184)))
)

achievement(
    title = "A Humane Execution", description = "Defeat the Wounded Virage without destroying any of its appendages.", points = 10,
    id = 94791, badge = "106751", published = "1/15/2020 11:23:28 PM", modified = "2/3/2020 2:18:54 AM",
    trigger = word(0x0BB0F4) == 0x005B && word(0x0BB0F8) == 0x0198 && word(0x052C30) == 0x0078 && 
              EnteredBattleOnce() && never(!IsInBattle()) &&
              ((repeated(256, word(0x1AC2F4) == 0x0000) && unless(byte(0x0BAC54) == 0x02) && 
                unless(byte(0x0BAC58) == 0x02) && never(word(0x1ABF6C) == 0x0000) && never(word(0x1ABBE4) == 0x0000)) ||
               (repeated(256, word(0x1AC5F4) == 0x0000) && unless(byte(0x0BAC54) == 0x01) && 
                unless(byte(0x0BAC58) == 0x01) && never(word(0x1AC26C) == 0x0000) && never(word(0x1ABEE4) == 0x0000)) ||
               (repeated(256, word(0x1AC894) == 0x0000) && unless(byte(0x0BAC54) == 0x03) && 
                unless(byte(0x0BAC58) == 0x03) && never(word(0x1AC50C) == 0x0000) && never(word(0x1AC184) == 0x0000)))
)

achievement(
    title = "You Killed My Father. Prepare to Die.", description = "Acquire the Dragoon Spirit of the Jade Dragon.", points = 5,
    id = 94793, badge = "106749", published = "1/15/2020 11:26:00 PM", modified = "2/3/2020 2:19:05 AM",
    trigger = word(0x052C30) == 0x0088 && bit2(0x0BAD64) == 0x1 && prev(bit2(0x0BAD64)) == 0x0
)

achievement(
    title = "Capitalist Hijinks", description = "Haggle the price of the Water Bottle to be as low as possible.", points = 1,
    id = 96626, badge = "106707", published = "1/30/2020 5:21:44 AM", modified = "2/3/2020 2:27:06 AM",
    trigger = once(prev(bit6(0x0BAD65)) == 0x0 && bit6(0x0BAD65) == 0x1) && prev(word(0x052C30)) == 0x008D && 
              word(0x052C30) == 0x008C && never(prev(word(0x0BAC5C)) > word(0x0BAC5C))
)

achievement(
    title = "Draconic Medicine", description = "Acquire the Dragoon Spirit of the White Silver Dragon.", points = 5,
    id = 94792, badge = "106750", published = "1/15/2020 11:25:26 PM", modified = "2/3/2020 2:20:22 AM",
    trigger = byte(0x0BAD64) == 0x65 && prev(byte(0x0BAD64)) == 0x45 && byte(0x052C30) == 0xA1
)

achievement(
    title = "Cheaters Never Prosper", description = "Emerge victorious against Gorgaga before succumbing to poison.", points = 5,
    id = 94794, badge = "106748", published = "1/15/2020 11:26:14 PM", modified = "2/3/2020 2:20:57 AM",
    trigger = repeated(300, word(0x0BB0F8) == 0x0194 && word(0x1AE1E0) == 0x0000) && word(0x0BB0F4) == 0x0011 && 
              word(0x052C30) == 0x027E
)

achievement(
    title = "Duel with the Berserker", description = "Emerge victorious against Serfius.", points = 5,
    id = 94795, badge = "106747", published = "1/15/2020 11:26:17 PM", modified = "2/3/2020 2:21:05 AM",
    trigger = repeated(300, word(0x0BB0F8) == 0x0195 && word(0x1AE1BC) == 0x0000) && word(0x0BB0F4) == 0x0011 && 
              word(0x052C30) == 0x027E
)

achievement(
    title = "The Iron Giant", description = "Emerge victorious against Danton.", points = 5,
    id = 94796, badge = "106746", published = "1/15/2020 11:26:21 PM", modified = "2/3/2020 2:21:16 AM",
    trigger = repeated(300, word(0x0BB0F8) == 0x0196 && word(0x1AE05C) == 0x0000) && word(0x0BB0F4) == 0x0011 && 
              word(0x052C30) == 0x027E
)

achievement(
    title = "Simple Geometry", description = "Emerge victorious against Atlow before succumbing to fear.", points = 5,
    id = 94797, badge = "106739", published = "1/15/2020 11:26:24 PM", modified = "2/3/2020 2:21:24 AM",
    trigger = repeated(300, word(0x0BB0F8) == 0x0197 && word(0x1ADF60) == 0x0000) && word(0x0BB0F4) == 0x0011 && 
              word(0x052C30) == 0x027E
)

achievement(
    title = "Monkeyball Master", description = "Get a score of 100 or more in the Monster Conquest Game Stand minigame.", points = 5,
    id = 94798, badge = "106744", published = "1/15/2020 11:26:27 PM", modified = "2/4/2020 10:54:22 PM",
    trigger = word(0x052C30) == 0x0098 && never(word(0x052C30) != 0x0098) &&
              ((dword(0x195DD4) >= 0x00000064 && dword(0x195DD4) != 0xFFFFFFFF && once(word(0x195DD4) == 0xFFFF) && 
                word(0x0BAC60) == 0x0000) ||
               (word(0x0BAC60) > 0x0000 && dword(0x195054) >= 0x00000064 && dword(0x195054) != 0xFFFFFFFF && 
                once(word(0x195054) == 0xFFFF)))
)

achievement(
    title = "You're the Man Now, Dog", description = "Make a correct guess in the \"Who Is the Man?\" Game.", points = 1,
    id = 94799, badge = "106744", published = "1/15/2020 11:26:31 PM", modified = "2/4/2020 11:49:08 PM",
    trigger = word(0x052C30) == 0x027A &&
              ((byte(0x1B9DEC) == 0x01 && word(0x0BAC60) == 0x0000) ||
               (byte(0x1B906C) == 0x01 && word(0x0BAC60) > 0x0000))
)

achievement(
    title = "Three of These Things Don't Belong", description = "Correctly point out the differences in a single game of \"What's Wrong with the Scene?\"", points = 5,
    id = 94800, badge = "106744", published = "1/15/2020 11:26:34 PM", modified = "2/4/2020 11:56:16 PM",
    trigger = word(0x052C30) == 0x027C &&
              ((byte(0x1B8F20) == 0x03 && byte(0x0BAC60) == 0x00) ||
               (byte(0x1B81A0) == 0x03 && byte(0x0BAC60) > 0x00))
)

// Refactored as of 27492
achievement(
    title = "Threading the Needle", description = "Complete the Obstacle Course minigame.", points = 10,
    id = 94801, badge = "106744", published = "1/15/2020 11:26:37 PM", modified = "5/10/2020 01:43:00 AM",
    trigger = mapId() == 0x0000027F && Delta(ticketsEarned()) < ticketsEarned()
)

achievement(
    title = "Lending a Fist", description = "Team up with Haschel.", points = 1,
    id = 96769, badge = "106700", published = "1/31/2020 4:09:20 AM", modified = "2/3/2020 2:25:20 AM",
    trigger = prev(byte(0x0BAFA8)) == 0x00 && byte(0x0BAFA8) == 0x03 && word(0x052C30) == 0x008F
)

achievement(
    title = "Item Miser", description = "Defeat the Jiango without using any items.", points = 10,
    id = 97122, badge = "106706", published = "2/1/2020 3:52:08 PM", modified = "2/3/2020 2:24:37 AM",
    trigger = enemyId() == 0x019D && expPrize() == 0x07D0 && 
              never(itemsInInventory() != Delta(itemsInInventory()))
              && never(!IsInBattle()) && EnteredBattleOnce()
)

// Changed as of 28263
achievement(
    title = "Desertion", description = "Defeat Fruegel before either Guftas or Rodriguez.", points = 10,
    id = 97123, badge = "106705", published = "2/1/2020 4:54:27 PM", modified = "2/22/2020 7:51:34 PM",
    trigger = enemyId() == 0x0183 && never(!IsInBattle()) && EnteredBattleOnce() &&
              never(word(0x052C30) != 0x0024) &&
              ((unless(byte(0x0BAC58) != 0x03) && repeated(450, word(0x1AF0C4) == 0x0000) && 
                never(word(0x1AED3C) == 0x0000) && never(word(0x1AE9B4) == 0x0000)) ||
               (unless(byte(0x0BAC58) != 0x02) && repeated(450, word(0x1AF664) == 0x0000) && 
                never(word(0x1AF2DC) == 0x0000) && never(word(0x1AEF54) == 0x0000)) ||
               (unless(byte(0x0BAC58) != 0x04) && repeated(450, word(0x1AEFA4) == 0x0000) && 
                never(word(0x1AEC1C) == 0x0000) && never(word(0x1AE894) == 0x0000)))
)

achievement(
    title = "Later, Buddy", description = "Suffer a great loss in Hellena Prison.", points = 1,
    id = 94802, badge = "106744", published = "1/15/2020 11:26:40 PM", modified = "2/3/2020 2:24:58 AM",
    trigger = word(0x0BB0F8) == 0x0183 && word(0x0BC95C) == 0x07D0
)

// To make sure the achievement doesn't trigger during a game over while still letting it trigger during the
// transition from the cutscene to the results screen, we're checking to make sure that the map ID changes
// for about a half second before triggering--because, OF COURSE, the map ID changes to the next one for
// a little under a half second before changing back after a game over.
achievement(
    title = "The War's End", description = "Defeat Emperor Doel and finally put an end to the Serdian Civil War.", points = 5,
    id = 94803, badge = "106744", published = "1/15/2020 11:26:43 PM", modified = "2/3/2020 2:30:33 AM",
    trigger = enemyId() == 0x0186 && battlefieldId() == 0x0016 && repeated(30, mapId() == 0x00C8) && 
              expPrize() == 0x0BB8 && goldPrize() == 0x00C8 && never(mapId() != 0x00C8)
)

achievement(
    title = "What's in Your Wallet?", description = "With Shana benched, defeat Mappi while using no more than two items.", points = 5,
    id = 97606, badge = "107872", published = "2/5/2020 1:45:20 AM", modified = "2/13/2020 10:38:00 PM",
    trigger = byte(0x0BAC54) != 0x02 && byte(0x0BAC58) != 0x02 && word(0x052C30) == 0x00E8 && word(0x0BB0F8) == 0x0192 && 
              word(0x0BC95C) == 0x07D0 && never(repeated(3, prev(byte(0x0BADAE)) != byte(0x0BADAE))) && 
              once(word(0x0CCDEC) == 0x1021 && prev(word(0x0CCDEC)) != 0x1021) && never(word(0x0CCDEC) != 0x1021)
)

achievement(
    title = "The Perky Dancer", description = "Befriend Meru.", points = 1,
    id = 94907, badge = "106742", published = "1/16/2020 3:57:24 AM", modified = "2/3/2020 2:32:19 AM",
    trigger = prior(word(0x052C30)) == 0x00FA && word(0x052C30) == 0x00F1 && byte(0x0BB000) == 0x03
)

achievement(
    title = "The Key to a Balanced Attack", description = "With Shana and Meru in your party, defeat the Complete Virage while destroying all of its appendages at once.", points = 25,
    id = 95004, badge = "106741", published = "1/17/2020 5:40:15 AM", modified = "2/3/2020 2:32:38 AM",
    trigger = word(0x052C30) == 0x00FF && word(0x0BB0F8) == 0x0199 && word(0x0BB0F4) == 0x001B && 
              prev(word(0x1AB9AC)) > 0x0000 && prev(word(0x1AAF14)) > 0x0000 && prev(word(0x1AB29C)) > 0x0000 && prev(word(0x1AB624)) > 0x0000 && 
              word(0x1AB9AC) == 0x0000 && word(0x1AAF14) == 0x0000 && word(0x1AB29C) == 0x0000 && word(0x1AB624) == 0x0000 && 
              never(word(0x1AB9AC) > 0x0000) && never(word(0x1AAF14) > 0x0000) && never(word(0x1AB29C) > 0x0000) && never(word(0x1AB624) > 0x0000)
)

achievement(
    title = "No Flinching!", description = "Defeat Gehrich and Mappi without guarding.", points = 10,
    id = 97614, badge = "107873", published = "2/5/2020 3:59:24 AM", modified = "2/13/2020 10:38:06 PM",
    trigger = word(0x0BB0F8) == 0x0193 && word(0x0BC95C) == 0x1388 && 
              once(prev(word(0x0CCDEC)) != 0x1021 && word(0x0CCDEC) == 0x1021) &&
              ((unless(byte(0x0BAC58) != 0x06) && never(byte(0x19E114) == 0x01) && never(byte(0x19DD8C) == 0x01) && 
                never(byte(0x19DA04) == 0x01)) ||
               (unless(byte(0x0BAC58) != 0x02) && never(byte(0x19E5E4) == 0x01) && never(byte(0x19E25C) == 0x01) && 
                never(byte(0x19DED4) == 0x01)) ||
               (unless(byte(0x0BAC58) != 0x03) && never(byte(0x19E044) == 0x01) && never(byte(0x19DCBC) == 0x01) && 
                never(byte(0x19D934) == 0x01)) ||
               (unless(byte(0x0BAC58) != 0x05) && never(byte(0x19E2E4) == 0x01) && never(byte(0x19DF5C) == 0x01) && 
                never(byte(0x19DBD4) == 0x01)))
)

achievement(
    title = "If You Can't Beat 'Em, Save 'Em", description = "Befriend Kongol.", points = 1,
    id = 95194, badge = "106740", published = "1/18/2020 4:56:12 AM", modified = "2/3/2020 2:32:29 AM",
    trigger = word(0x0BB0F4) == 0x001D && word(0x0BB0F8) == 0x0193 &&
              ((word(0x0BC95C) == 0x1388 && word(0x052C30) == 0x010A) ||
               (byte(0x0BB02C) == 0x03 && prior(byte(0x0BB02C)) == 0x00 && word(0x052C30) == 0x0109))
)

achievement(
    title = "My Bride to Be?", description = "Attend Kate and Lynn's wedding and catch the bouquet.", points = 1,
    id = 96272, badge = "106725", published = "1/28/2020 4:15:54 AM", modified = "2/3/2020 2:34:16 AM",
    trigger = word(0x052C30) == 0x0103 && prev(bit6(0x0BAD66)) == 0x0 && bit6(0x0BAD66) == 0x1
)

achievement(
    title = "Tectonic Dominion", description = "Acquire the Dragoon Spirit of the Golden Dragon.", points = 5,
    id = 95426, badge = "106701", published = "1/20/2020 4:00:36 AM", modified = "2/3/2020 2:34:27 AM",
    trigger = ((word(0x052C30) == 0x008D && prev(bit3(0x0BAD64)) == 0x0 && bit3(0x0BAD64) == 0x1) ||
               (word(0x052C30) == 0x0266 && prev(bit3(0x0BAD64)) == 0x0 && bit3(0x0BAD64) == 0x1))
)

// == UPDATED DUE TO 33633 ==
// We're using the display values here, since they appear to be more stable.
function vegetableTimeDisplay() => word(0x0BDF20)
function playerVeggiesChopped() => word(0x0bdf10)
function playerTotalChops() => word(0x0bdf14)
function opponentVeggiesChopped() => word(0x0bdf18)
function opponentTotalChops() => word(0x0bdf1c)

function PlayerHasSameVeggiesButMoreChops()
{
    return playerVeggiesChopped() == opponentVeggiesChopped() // Same veggies
        && (playerTotalChops() - opponentTotalChops()) > 0 // More chops
        && (playerTotalChops() - opponentTotalChops()) < 0x8000 // Check to ensure signed underflow doesn't happen.
}

function PlayerHasMoreVeggies()
{
    return ((playerVeggiesChopped() - opponentVeggiesChopped()) > 0 // More veggies
        && (playerVeggiesChopped() - opponentVeggiesChopped()) < 0x8000) // Check to ensure signed underflow doesn't happen.
}

achievement(
    title = "Slap Chopper", description = "Win the Vegetable Julienne Contest on the Queen Fury.", points = 5,
    id = 95197, badge = "106725", published = "1/18/2020 7:42:37 AM", modified = "2/4/2020 11:11:00 PM",
    trigger = mapId() == 0x0119 && never(vegetableTimeDisplay() > 0) && never(prev(vegetableTimeDisplay()) != 1) &&
              (PlayerHasSameVeggiesButMoreChops() || PlayerHasMoreVeggies())
)

// END SLAP CHOPPER

achievement(
    title = "The Flash", description = "In Fletz, survive against Lenus for ten turns in Dragoon form, and then defeat her.", points = 25,
    id = 97665, badge = "107876", published = "2/5/2020 10:52:32 PM", modified = "2/13/2020 10:38:09 PM",
    trigger = once(word(0x0CCDEC) == 0x1021 && prev(word(0x0CCDEC)) != 0x1021) && word(0x0BB0F8) == 0x018C && 
              word(0x0BB0F4) == 0x001E && repeated(13, prev(byte(0x06E62C)) > byte(0x06E62C) || prev(byte(0x06E630)) > byte(0x06E630) ||
               prev(byte(0x06E634)) > byte(0x06E634)) && word(0x0BC95C) == 0x1770 && never(word(0x052C30) != 0x00EC)
)

achievement(
    title = "Drink Up, Me Hearties, Yo Ho!", description = "Successfully open the locked chest on the Phantom Ship within two attempts.", points = 25,
    id = 95249, badge = "106745", published = "1/18/2020 9:25:14 PM", modified = "2/3/2020 2:39:42 AM",
    trigger = byte(0x052C30) == 0x21 && never(prev(word(0x0BAC28)) != word(0x0BAC28)) &&
              ((prev(byte(0x0BAC25)) == 0x00 && byte(0x0BAC25) == 0x01 && prev(byte(0x0BAC24)) > 0x08) ||
               (prev(byte(0x0BAC25)) == 0x01 && byte(0x0BAC25) == 0x02 && prev(byte(0x0BAC24)) > 0x06) ||
               (prev(byte(0x0BAC25)) == 0x02 && byte(0x0BAC25) == 0x03 && prev(byte(0x0BAC24)) > 0x04) ||
               (prev(byte(0x0BAC25)) == 0x03 && byte(0x0BAC25) == 0x04 && prev(byte(0x0BAC24)) > 0x02) ||
               (prev(byte(0x0BAC25)) == 0x04 && byte(0x0BAC25) == 0x05))
)

achievement(
    title = "Magician's Hat-Trick", description = "With Albert and Kongol in your party, defeat the Magician Bogy Trio simultaneously.", points = 5,
    id = 97752, badge = "107878", published = "2/7/2020 5:10:49 AM", modified = "2/13/2020 10:38:15 PM",
    trigger = word(0x0BB0F8) == 0x01E9 && word(0x052C30) == 0x0125 && word(0x0CCDEC) == 0x1021 && 
              prev(word(0x1AD694)) > 0x0000 && word(0x1AD694) == 0x0000 && prev(word(0x1AD30C)) > 0x0000 && word(0x1AD30C) == 0x0000 && 
              prev(word(0x1ACF84)) > 0x0000 && word(0x1ACF84) == 0x0000
)

achievement(
    title = "Everything but the Kitchen Sink", description = "With Haschel and Meru in your party, defeat the Ghost Commander by only using items.", points = 10,
    id = 97753, badge = "107880", published = "2/7/2020 5:37:26 AM", modified = "2/13/2020 10:38:17 PM",
    trigger = word(0x0BB0F8) == 0x01A1 && once(prev(byte(0x06E648)) == 0x00 && byte(0x06E648) == 0xFF) && 
              word(0x0BC95C) == 0x1770 && never(word(0x052C30) != 0x0126) && never(byte(0x1A0394) == 0x01) && never(byte(0x1A071C) == 0x01) && 
              never(byte(0x1A0AA4) == 0x01) && never(byte(0x06E618) > 0x00) && never(byte(0x06E62C) > 0x00) && never(byte(0x06E630) > 0x00) && 
              never(byte(0x06E634) > 0x00)
)

achievement(
    title = "The Band Gets Back Together", description = "Reunite with the group after a plunge into the depths.", points = 1,
    id = 97974, badge = "106725", published = "2/8/2020 8:30:47 PM", modified = "2/13/2020 10:38:22 PM",
    trigger = byte(0x0BB000) == 0x03 && prev(word(0x052C30)) == 0x013A && word(0x052C30) == 0x0138
)

achievement(
    title = "Muggles Do It Better", description = "Defeat Lenus and Regole without using Dragoon transformations.", points = 5,
    id = 98008, badge = "108035", published = "2/8/2020 11:03:41 PM", modified = "2/13/2020 10:38:26 PM",
    trigger = once(prev(byte(0x06E648)) != 0xFF && byte(0x06E648) == 0xFF) && word(0x0CCDEC) == 0x1021 &&
              ((never(byte(0x06E62C) > 0x00) && never(byte(0x06E630) > 0x00) && never(byte(0x06E634) > 0x00) && 
                unless(byte(0x06E62C) == 0x28) && unless(byte(0x06E630) == 0x2C) && unless(byte(0x06E634) == 0x30) && always_false()) ||
               (prev(word(0x0BC95C)) == 0x1B58 && word(0x0BC95C) == 0x0000))
)

achievement(
    title = "Swift as a Coursing River", description = "Acquire the Dragoon Spirit of the Blue Sea Dragon.", points = 5,
    id = 95316, badge = "106777", published = "1/19/2020 5:07:07 AM", modified = "2/5/2020 10:36:43 PM",
    trigger = word(0x052C30) == 0x0145 && word(0x0BB0F8) == 0x018D && repeated(1300, bit1(0x0BAD64) == 0x1) && 
              prior(bit1(0x0BAD64)) == 0x0
)

achievement(
    title = "And Thus, Boy Met Girl", description = "Finish off Chapter 2 with a romantic night under the stars.", points = 1,
    id = 95317, badge = "106778", published = "1/19/2020 6:47:43 AM", modified = "2/3/2020 2:40:07 AM",
    trigger = word(0x052C30) == 0x02BA && 
              repeated(454, word(0x0BAD04) == 0x3C0F && word(0x0BAD06) == 0xC070 && word(0x0BAD08) == 0x0103)
)

achievement(
    title = "The Boy Who Cried \"Kamuy!\"", description = "Defeat Kamuy.", points = 10,
    id = 95427, badge = "106763", published = "1/20/2020 4:49:08 AM", modified = "2/3/2020 2:44:48 AM",
    trigger = word(0x052C30) == 0x0157 && word(0x0BB0F8) == 0x01A2 && word(0x0BB0F4) == 0x0029 && 
              word(0x0BC95C) == 0x1F40
)

achievement(
    title = "Passing the Torch", description = "Befriend Miranda.", points = 1,
    id = 95431, badge = "106757", published = "1/20/2020 7:09:27 AM", modified = "2/3/2020 2:44:52 AM",
    trigger = word(0x052C30) == 0x0172 && byte(0x0BB058) == 0x03 && byte(0x0BAF50) == 0x00
)

// Tag, You're It
// Fixes introduced by Bug 38983 and 39009.

panels = [
    bit4(0x0bacd5), // top-left
    bit5(0x0bacd5), // bottom-left
    bit6(0x0bacd5), // center
    bit7(0x0bacd5), // top-right
    bit0(0x0bacd6) // bottom-right
]

function AllPanelsSet()
{
    trigger = always_true()
    for panel in panels
    {
        trigger = trigger && once(Delta(panel) == 0 && panel == 1) 
    }
    return trigger
}

function isInSealRoom() => word(0x052C30) == 0x193
achievement(
    title = "Tag, You're It", description = "Open the sealed teleporter in Kadessa without getting caught by any of the Spinningheads.", points = 5,
    id = 98011, badge = "108037", published = "2/9/2020 2:04:19 AM", modified = "2/13/2020 10:38:29 PM",
    trigger = AllPanelsSet()
              && unless(isInSealRoom() && EnteredBattleOnce()) // Don't enter the infinite pauselock if you've somehow entered battle before entering the room.
              && unless(!isInSealRoom()) // Don't check for bit changes if you're not in the seal room; this is for save protection primarily.
)

// /Tag, You're It

achievement(
    title = "The Final Countdown", description = "Destroy the head of the Super Virage in Kadessa before its lives reach zero.", points = 25,
    id = 96038, badge = "106677", published = "1/25/2020 9:49:36 PM", modified = "2/3/2020 2:45:05 AM",
    trigger = word(0x052C30) == 0x0195 && word(0x0BB0F8) == 0x019A && word(0x0BC95C) == 0x0FA0 && 
              word(0x0CCDEC) == 0x1021 &&
              ((word(0x1AC51C) == 0x0000 && prior(word(0x1AC51C)) > 0x0000) ||
               (word(0x1AC70C) == 0x0000 && prior(word(0x1AC70C)) > 0x0000) ||
               (word(0x1AC8DC) == 0x0000 && prior(word(0x1AC8DC)) > 0x0000) ||
               (word(0x1AC76C) == 0x0000 && prior(word(0x1AC76C)) > 0x0000) ||
               (word(0x1ACBDC) == 0x0000 && prior(word(0x1ACBDC)) > 0x0000) ||
               (word(0x1AC5EC) == 0x0000 && prior(word(0x1AC5EC)) > 0x0000) ||
               (word(0x1AC9AC) == 0x0000 && prior(word(0x1AC9AC)) > 0x0000) ||
               (word(0x1AC83C) == 0x0000 && prior(word(0x1AC83C)) > 0x0000) ||
               (word(0x1ACCAC) == 0x0000 && prior(word(0x1ACCAC)) > 0x0000) ||
               (word(0x1AC7BC) == 0x0000 && prior(word(0x1AC7BC)) > 0x0000) ||
               (word(0x1AC64C) == 0x0000 && prior(word(0x1AC64C)) > 0x0000) ||
               (word(0x1ACABC) == 0x0000 && prior(word(0x1ACABC)) > 0x0000) ||
               (word(0x1ACA0C) == 0x0000 && prior(word(0x1ACA0C)) > 0x0000) ||
               (word(0x1ACE7C) == 0x0000 && prior(word(0x1ACE7C)) > 0x0000) ||
               (word(0x1ACD0C) == 0x0000 && prior(word(0x1ACD0C)) > 0x0000))
)

achievement(
    title = "Only the Dauntless May Wield Me", description = "With Albert and Miranda in your party, defeat the Grand Jewel while guarding no more than five times.", points = 50,
    id = 98039, badge = "108038", published = "2/9/2020 7:16:59 AM", modified = "2/13/2020 10:38:32 PM",
    trigger = word(0x052C30) == 0x0192 && word(0x0BB0F8) == 0x01A0 && word(0x0BC95C) == 0x2328 && 
              once(prev(word(0x0CCDEC)) != 0x1021 && word(0x0CCDEC) == 0x1021) && never(repeated(6, byte(0x1A89C4) == 0x01 || byte(0x1A90D4) == 0x01 || byte(0x1A8D4C) == 0x01)) && 
              never(word(0x0CCDEC) != 0x1021) && unless(word(0x0BB0F8) != 0x01A0)
)

achievement(
    title = "Considerate Regicide", description = "With Rose and Haschel in your party, defeat the Divine Dragon without destroying any of its appendages.", points = 25,
    id = 95549, badge = "106697", published = "1/21/2020 5:14:28 AM", modified = "2/16/2020 5:39:32 PM",
    trigger = never(word(0x1AF280) == 0x0000) && never(word(0x1AEEF8) == 0x0000) && 
              repeated(300, word(0x1AF608) == 0x0000) && word(0x0BB0F8) == 0x018A && word(0x052C30) == 0x01A7 && word(0x0BB0F4) == 0x0028 && 
              never(prev(word(0x052C30)) != 0x01A7) && never(prev(word(0x0CCDEC)) != 0x1021)
)

// Fixed as of 28918
achievement(
    title = "One Spirit to Rule Them All", description = "Witness the birth of a new Dragoon Spirit.", points = 1,
    id = 98040, badge = "106779", published = "2/9/2020 7:39:10 AM", modified = "2/13/2020 10:38:34 PM",
    trigger = prev(mapId()) == 0x01A7 && mapId() == 0x01A8 && goldPrize() > 0
)

achievement(
    title = "Boom, Butterfly Effect", description = "Destroy the Windigo's heart in a single hit.", points = 10,
    id = 95620, badge = "106695", published = "1/22/2020 3:15:38 AM", modified = "2/3/2020 2:48:22 AM",
    trigger = word(0x0BB0F8) == 0x01A6 && word(0x052C30) == 0x01B5 && word(0x0BB0F4) == 0x002A && 
              word(0x0CCDEC) == 0x1021 &&
              ((word(0x1AD224) == 0x0000 && prev(word(0x1AD224)) == 0x0003) ||
               (word(0x1AD034) == 0x0000 && prev(word(0x1AD034)) == 0x0003) ||
               (word(0x1AD3F4) == 0x0000 && prev(word(0x1AD3F4)) == 0x0003) ||
               (word(0x1AD284) == 0x0000 && prev(word(0x1AD284)) == 0x0003) ||
               (word(0x1AD6F4) == 0x0000 && prev(word(0x1AD6F4)) == 0x0003) ||
               (word(0x1AD104) == 0x0000 && prev(word(0x1AD104)) == 0x0003) ||
               (word(0x1AD4C4) == 0x0000 && prev(word(0x1AD4C4)) == 0x0003) ||
               (word(0x1AD354) == 0x0000 && prev(word(0x1AD354)) == 0x0003) ||
               (word(0x1AD7C4) == 0x0000 && prev(word(0x1AD7C4)) == 0x0003) ||
               (word(0x1AD2D4) == 0x0000 && prev(word(0x1AD2D4)) == 0x0003) ||
               (word(0x1AD164) == 0x0000 && prev(word(0x1AD164)) == 0x0003) ||
               (word(0x1AD5D4) == 0x0000 && prev(word(0x1AD5D4)) == 0x0003) ||
               (word(0x1AD524) == 0x0000 && prev(word(0x1AD524)) == 0x0003) ||
               (word(0x1AD994) == 0x0000 && prev(word(0x1AD994)) == 0x0003) ||
               (word(0x1AD824) == 0x0000 && prev(word(0x1AD824)) == 0x0003))
)

achievement(
    title = "Confidence, or Recklessness?", description = "Defeat Lloyd after triggering at least a second-level Dragoon Special at least once.", points = 10,
    id = 98127, badge = "108055", published = "2/9/2020 9:25:08 PM", modified = "2/13/2020 10:38:38 PM",
    trigger = word(0x0BC95C) == 0x2EE0 && once(byte(0x06E62C) > 0x01 && byte(0x06E630) > 0x01 && byte(0x06E634) > 0x01
               && prev(byte(0x06E648)) == 0xFF && byte(0x06E648) != 0xFF) && 
              never(prev(word(0x0CCDEC)) != 0x1021 && word(0x0CCDEC) == 0x1021) && word(0x0BB0F8) == 0x0188
)

achievement(
    title = "Vengeance Begets Vengeance", description = "Spare the life of the one who's caused your company much suffering.", points = 1,
    id = 98128, badge = "106779", published = "2/9/2020 10:00:37 PM", modified = "2/20/2020 4:47:53 AM",
    trigger = repeated(2, prev(word(0x052C30)) == 0x01BF && word(0x052C30) == 0x01BE) && word(0x0BB0F8) == 0x0188 && 
              never(word(0x0CCDEC) == 0x1021 && prev(word(0x0CCDEC)) != 0x1021) && unless(word(0x0BB0F8) != 0x0188)
)

achievement(
    title = "The Will of the Fallen", description = "Defeat the Polter Armor.", points = 25,
    id = 95621, badge = "106693", published = "1/22/2020 4:32:52 AM", modified = "2/3/2020 2:48:30 AM",
    trigger = word(0x0BB0F4) == 0x002F && word(0x0BB0F8) == 0x01A7 && word(0x052C30) == 0x01D3 && 
              dword(0x0BC95C) == 0x00001770 && dword(0x0BC920) == 0x000000C8
)

achievement(
    title = "The Tale That Time Forgot", description = "Learn the awful truth about your journey and finish Chapter 3.", points = 5,
    id = 95655, badge = "106779", published = "1/23/2020 4:26:17 AM", modified = "2/3/2020 2:48:41 AM",
    trigger = word(0x052C30) == 0x01F0 && prev(word(0x0BAD04)) == 0x1C00 && prev(word(0x0BAD06)) == 0x8000 && 
              prev(word(0x0BAD08)) == 0x3F7F && prev(word(0x0BAD0A)) == 0xE000 && prev(word(0x0BAD0C)) == 0x000F && prev(word(0x0BAD0E)) == 0x040F && 
              word(0x0BAD04) == 0x0000 && word(0x0BAD06) == 0x0000 && word(0x0BAD08) == 0x0000 && word(0x0BAD0A) == 0x0000 && 
              word(0x0BAD0C) == 0x0000 && word(0x0BAD0E) == 0x0000
)

achievement(
    title = "Courage Need Not Be Remembered", description = "Acquire Psychedelic Bomb X.", points = 5,
    id = 96073, badge = "106676", published = "1/26/2020 6:52:16 AM", modified = "2/7/2020 4:10:07 AM",
    trigger = word(0x052C30) == 0x02C7 &&
              ((word(0x0BC928) == 0x00FA) ||
               (byte(byte(0x0BADAE) + 0x0BAEB0) == 0xFA))
)

achievement(
    title = "Last Calamari", description = "Defeat Last Kraken without items or Dragoon transformations.", points = 10,
    id = 98138, badge = "108079", published = "2/10/2020 4:36:00 AM", modified = "2/13/2020 10:38:43 PM",
    trigger = word(0x0BB0F8) == 0x01B0 && word(0x0CCDEC) == 0x1021 && word(0x0BC95C) == 0x2EE0 && 
              once(prev(byte(0x06E648)) != 0xFF && byte(0x06E648) == 0xFF) && unless(word(0x052C30) != 0x02CA) && never(byte(0x06E62C) != 0x00) && never(byte(0x06E630) != 0x00) && 
              never(byte(0x06E634) != 0x00) && never(prev(byte(0x0BADAE)) > byte(0x0BADAE))
)

achievement(
    title = "Savan's Final Hope", description = "Carry on in lieu of the one who wished to protect the world.", points = 1,
    id = 98140, badge = "106726", published = "2/10/2020 5:10:15 AM", modified = "2/13/2020 10:38:46 PM",
    trigger = prev(word(0x052C30)) == 0x023C && word(0x052C30) == 0x0210
)

achievement(
    title = "Protectionist Parliamentarian", description = "Repeal the law permitting use of the shop next to the Law Factory in Zenebatos.", points = 1,
    id = 96106, badge = "106738", published = "1/26/2020 7:52:18 PM", modified = "2/3/2020 2:50:34 AM",
    trigger = word(0x052C30) == 0x0218 && prev(bit0(0x0BAD68)) == 0x1 && bit0(0x0BAD68) == 0x0 && bit0(0x0BACDA) == 0x1 && 
              prev(bit0(0x0BACDA)) == 0x0
)

achievement(
    title = "Trespassers Will Be Ignored", description = "Prohibit the Zenebatos guards from arresting you by changing the law.", points = 1,
    id = 96108, badge = "106738", published = "1/26/2020 8:05:07 PM", modified = "2/3/2020 2:50:37 AM",
    trigger = word(0x052C30) == 0x0218 && prev(bit0(0x0BAD68)) == 0x1 && bit0(0x0BAD68) == 0x0 && bit5(0x0BACD9) == 0x1 && 
              prev(bit5(0x0BACD9)) == 0x0
)

achievement(
    title = "No Lines, No Waiting", description = "Repeal the law in Zenebatos requiring the need to queue at the Legislation Center.", points = 1,
    id = 96111, badge = "106738", published = "1/26/2020 8:13:46 PM", modified = "2/3/2020 2:50:30 AM",
    trigger = word(0x052C30) == 0x0218 && prev(bit0(0x0BAD68)) == 0x1 && bit0(0x0BAD68) == 0x0 && bit4(0x0BACD9) == 0x1 && 
              prev(bit4(0x0BACD9)) == 0x0
)

achievement(
    title = "Jury Nullification", description = "With Meru and Miranda in your party, defeat Kubila, Selebus, and Vector simultaneously.", points = 10,
    id = 98143, badge = "108080", published = "2/11/2020 1:16:21 AM", modified = "2/25/2020 10:08:04 PM",
    trigger = word(0x0BB0F8) == 0x01AE && word(0x052C30) == 0x02CE && word(0x0BC95C) == 0x2EE0 && 
              once(prev(word(0x1AEA58)) > 0x0000 && word(0x1AEA58) == 0x0000 && prev(word(0x1AE6D0)) > 0x0000 &&
               word(0x1AE6D0) == 0x0000 && prev(word(0x1AE348)) > 0x0000 && word(0x1AE348) == 0x0000) && 
              repeated(1350, word(0x1AE348) == 0x0000) && never(prev(word(0x0CCDEC)) == 0x0000 && word(0x0CCDEC) == 0x1021)
)

achievement(
    title = "What Happens After Death?", description = "Defeat Syuveil.", points = 10,
    id = 96126, badge = "106734", published = "1/26/2020 10:21:23 PM", modified = "2/3/2020 2:52:25 AM",
    trigger = word(0x0BB0F4) == 0x0032 && word(0x0BB0F8) == 0x018F && word(0x052C30) == 0x01F4 && 
              dword(0x0BC95C) == 0x00001770
)

achievement(
    title = "Lonely No More", description = "Defeat Damia.", points = 10,
    id = 96127, badge = "106733", published = "1/26/2020 10:32:46 PM", modified = "2/3/2020 2:52:29 AM",
    trigger = word(0x0BB0F4) == 0x0032 && word(0x0BB0F8) == 0x018E && word(0x052C30) == 0x01F3 && 
              word(0x0BC95C) == 0x1770
)

achievement(
    title = "The Protector", description = "Defeat Belzac.", points = 10,
    id = 96137, badge = "106732", published = "1/27/2020 4:34:06 AM", modified = "2/3/2020 2:52:33 AM",
    trigger = word(0x0BB0F4) == 0x0032 && word(0x0BB0F8) == 0x0190 && word(0x052C30) == 0x01F6 && 
              word(0x0BC95C) == 0x1770
)

achievement(
    title = "A Bloodlust Slaked", description = "Defeat Kanzas.", points = 25,
    id = 96138, badge = "106731", published = "1/27/2020 4:39:51 AM", modified = "2/3/2020 2:52:37 AM",
    trigger = word(0x0BB0F4) == 0x0032 && word(0x0BB0F8) == 0x0191 && word(0x052C30) == 0x01F5 && 
              word(0x0BC95C) == 0x1770
)

achievement(
    title = "Just Petals in the Wind", description = "Defeat the spirit of Feyrbrand in Mayfil.", points = 5,
    id = 96122, badge = "106735", published = "1/26/2020 9:01:34 PM", modified = "2/3/2020 2:52:57 AM",
    trigger = word(0x0BB0F8) == 0x01C1 && word(0x052C30) == 0x021E && word(0x0BB0F4) == 0x0044 &&
              ((prev(word(0x0BC95C)) == 0x0FA0 && word(0x0BC95C) == 0x0000) ||
               (word(0x0CCDEC) == 0x0000 && word(0x0BC95C) == 0x0FA0 && word(0x0BC920) == 0x00C8))
)

achievement(
    title = "A Watery Grave at Last", description = "Defeat the spirit of Regole in Mayfil.", points = 10,
    id = 96123, badge = "106737", published = "1/26/2020 9:10:01 PM", modified = "2/3/2020 2:53:00 AM",
    trigger = word(0x0BB0F8) == 0x01C0 && word(0x052C30) == 0x0220 && word(0x0BB0F4) == 0x0044 &&
              ((prev(word(0x0BC95C)) == 0x1770 && word(0x0BC95C) == 0x0000) ||
               (word(0x0CCDEC) == 0x0000 && word(0x0BC95C) == 0x1770 && word(0x0BC920) == 0x012C))
)

achievement(
    title = "Ful, Losei Dovahkiin?", description = "Defeat the spirit of the Divine Dragon in Mayfil.", points = 25,
    id = 96124, badge = "106736", published = "1/26/2020 9:17:07 PM", modified = "2/3/2020 2:53:03 AM",
    trigger = word(0x0BB0F8) == 0x01BF && word(0x052C30) == 0x0222 && word(0x0BB0F4) == 0x0044 &&
              ((prev(word(0x0BC95C)) == 0x1F40 && word(0x0BC95C) == 0x0000) ||
               (word(0x0CCDEC) == 0x0000 && word(0x0BC95C) == 0x1F40 && word(0x0BC920) == 0x0190))
)

achievement(
    title = "A Dealer with the Devil", description = "Defeat Magician Faust.", points = 50,
    id = 96139, badge = "106730", published = "1/27/2020 4:58:09 AM", modified = "2/3/2020 2:53:08 AM",
    trigger = word(0x0BB0F4) == 0x002C && word(0x0BB0F8) == 0x01A4 && word(0x052C30) == 0x01C4 && 
              word(0x0BC95C) == 0x4E20
)

achievement(
    title = "The Power of Soa Compels You!", description = "Defeat Zackwell within thirty moves.", points = 25,
    id = 98164, badge = "108081", published = "2/11/2020 2:34:48 AM", modified = "2/13/2020 10:38:51 PM",
    trigger = once(prev(word(0x0CCDEC)) != 0x1021 && word(0x0CCDEC) == 0x1021) && 
              prev(word(0x0BC95C)) == 0x2EE0 && word(0x0BC95C) == 0x0000 && never(repeated(32, prev(word(0x0BAC80)) != word(0x0BAC80))) && 
              never(word(0x052C30) != 0x02C1 && word(0x052C30) != 0x02D1)
)

achievement(
    title = "This Time, It's Really Goodbye", description = "Save an old friend from the chains of devilry.", points = 1,
    id = 96125, badge = "106726", published = "1/26/2020 10:00:09 PM", modified = "2/3/2020 2:54:44 AM",
    trigger = word(0x0BB0F8) == 0x01AF && word(0x052C30) == 0x02D1 && prev(word(0x052C30)) == 0x02C1 && 
              word(0x0BB0F4) == 0x0036
)

achievement(
    title = "Pesticide Embargo", description = "Defeat the Imago without using any items.", points = 10,
    id = 98165, badge = "108082", published = "2/11/2020 3:21:05 AM", modified = "2/13/2020 10:38:54 PM",
    trigger = word(0x052C30) == 0x0250 && word(0x0BB0F8) == 0x01B1 && 
              prev(word(0x0BC95C)) == 0x32C8 && word(0x0BC95C) == 0x0000 && never(once(prev(byte(0x0BADAE)) != byte(0x0BADAE))) && 
              once(word(0x0CCDEC) == 0x1021 && prev(word(0x0CCDEC)) != 0x1021) && never(word(0x052C30) != 0x0250)
)

achievement(
    title = "The Power of Two", description = "Defeat Indora while already in possession of the Dragoon Spirit of the Golden Dragon.", points = 1,
    id = 96230, badge = "106701", published = "1/28/2020 12:36:03 AM", modified = "2/3/2020 2:54:51 AM",
    trigger = word(0x0BB0F4) == 0x0052 && word(0x0BB0F8) == 0x01B4 && word(0x052C30) == 0x0266 && 
              word(0x0BC95C) == 0x1770 && bit3(0x0BAD64) == 0x1
)

achievement(
    title = "If Only He Never Had a Name...", description = "Defeat Michael without guarding.", points = 10,
    id = 98229, badge = "108083", published = "2/11/2020 10:50:48 PM", modified = "2/13/2020 10:38:57 PM",
    trigger = once(prev(word(0x0CCDEC)) != 0x1021 && word(0x0CCDEC) == 0x1021) && word(0x0BC95C) == 0x2EE0 && 
              never(byte(0x1A042C) == 0x01) && never(byte(0x1A07B4) == 0x01) && unless(word(0x052C30) != 0x026A) && never(word(0x0CCDEC) != 0x1021)
)

achievement(
    title = "Leave No Trace", description = "With Kongol and Haschel in your party, destroy the arm of the Super Virage on the Moon before either its head or its body.", points = 5,
    id = 98230, badge = "108084", published = "2/12/2020 12:39:52 AM", modified = "2/13/2020 10:39:00 PM",
    trigger = word(0x0BC95C) == 0x3A98 && word(0x0BB0F8) == 0x019B && never(word(0x052C30) != 0x02DD) &&
              (always_false() || (once(prev(word(0x0BAC80)) != word(0x0BAC80)) && unless(word(0x1AB01C) > 0x0000)))
)

achievement(
    title = "Measure Twice, Cut Once", description = "Finish off Zieg with an attack item, and it must be the only item you use.", points = 10,
    id = 98232, badge = "108085", published = "2/12/2020 2:07:41 AM", modified = "2/13/2020 10:39:04 PM",
    trigger = word(0x0BC95C) == 0x4E20 && word(0x0BB0F8) == 0x01BA && never(word(0x052C30) != 0x02DF) &&
              ((once(byte(0x0BADAE) == 0x20 && prev(word(0x0CCDEC)) != 0x1021 && word(0x0CCDEC) == 0x1021) && 
                once(prev(byte(0x0BADAE)) != byte(0x0BADAE)) && unless(once(byte(0x0BADAE) == 0x1F && prev(word(0x0BAC80)) != word(0x0BAC80)))) ||
               (once(byte(0x0BADAE) == 0x1F && prev(word(0x0CCDEC)) != 0x1021 && word(0x0CCDEC) == 0x1021) && 
                once(prev(byte(0x0BADAE)) != byte(0x0BADAE)) && unless(once(byte(0x0BADAE) == 0x1E && prev(word(0x0BAC80)) != word(0x0BAC80)))) ||
               (once(byte(0x0BADAE) == 0x1E && prev(word(0x0CCDEC)) != 0x1021 && word(0x0CCDEC) == 0x1021) && 
                once(prev(byte(0x0BADAE)) != byte(0x0BADAE)) && unless(once(byte(0x0BADAE) == 0x1D && prev(word(0x0BAC80)) != word(0x0BAC80)))) ||
               (once(byte(0x0BADAE) == 0x1D && prev(word(0x0CCDEC)) != 0x1021 && word(0x0CCDEC) == 0x1021) && 
                once(prev(byte(0x0BADAE)) != byte(0x0BADAE)) && unless(once(byte(0x0BADAE) == 0x1C && prev(word(0x0BAC80)) != word(0x0BAC80)))) ||
               (once(byte(0x0BADAE) == 0x1C && prev(word(0x0CCDEC)) != 0x1021 && word(0x0CCDEC) == 0x1021) && 
                once(prev(byte(0x0BADAE)) != byte(0x0BADAE)) && unless(once(byte(0x0BADAE) == 0x1B && prev(word(0x0BAC80)) != word(0x0BAC80)))) ||
               (once(byte(0x0BADAE) == 0x1B && prev(word(0x0CCDEC)) != 0x1021 && word(0x0CCDEC) == 0x1021) && 
                once(prev(byte(0x0BADAE)) != byte(0x0BADAE)) && unless(once(byte(0x0BADAE) == 0x1A && prev(word(0x0BAC80)) != word(0x0BAC80)))) ||
               (once(byte(0x0BADAE) == 0x1A && prev(word(0x0CCDEC)) != 0x1021 && word(0x0CCDEC) == 0x1021) && 
                once(prev(byte(0x0BADAE)) != byte(0x0BADAE)) && unless(once(byte(0x0BADAE) == 0x19 && prev(word(0x0BAC80)) != word(0x0BAC80)))) ||
               (once(byte(0x0BADAE) == 0x19 && prev(word(0x0CCDEC)) != 0x1021 && word(0x0CCDEC) == 0x1021) && 
                once(prev(byte(0x0BADAE)) != byte(0x0BADAE)) && unless(once(byte(0x0BADAE) == 0x18 && prev(word(0x0BAC80)) != word(0x0BAC80)))) ||
               (once(byte(0x0BADAE) == 0x18 && prev(word(0x0CCDEC)) != 0x1021 && word(0x0CCDEC) == 0x1021) && 
                once(prev(byte(0x0BADAE)) != byte(0x0BADAE)) && unless(once(byte(0x0BADAE) == 0x17 && prev(word(0x0BAC80)) != word(0x0BAC80)))) ||
               (once(byte(0x0BADAE) == 0x17 && prev(word(0x0CCDEC)) != 0x1021 && word(0x0CCDEC) == 0x1021) && 
                once(prev(byte(0x0BADAE)) != byte(0x0BADAE)) && unless(once(byte(0x0BADAE) == 0x16 && prev(word(0x0BAC80)) != word(0x0BAC80)))) ||
               (once(byte(0x0BADAE) == 0x16 && prev(word(0x0CCDEC)) != 0x1021 && word(0x0CCDEC) == 0x1021) && 
                once(prev(byte(0x0BADAE)) != byte(0x0BADAE)) && unless(once(byte(0x0BADAE) == 0x15 && prev(word(0x0BAC80)) != word(0x0BAC80)))) ||
               (once(byte(0x0BADAE) == 0x15 && prev(word(0x0CCDEC)) != 0x1021 && word(0x0CCDEC) == 0x1021) && 
                once(prev(byte(0x0BADAE)) != byte(0x0BADAE)) && unless(once(byte(0x0BADAE) == 0x14 && prev(word(0x0BAC80)) != word(0x0BAC80)))) ||
               (once(byte(0x0BADAE) == 0x14 && prev(word(0x0CCDEC)) != 0x1021 && word(0x0CCDEC) == 0x1021) && 
                once(prev(byte(0x0BADAE)) != byte(0x0BADAE)) && unless(once(byte(0x0BADAE) == 0x13 && prev(word(0x0BAC80)) != word(0x0BAC80)))) ||
               (once(byte(0x0BADAE) == 0x13 && prev(word(0x0CCDEC)) != 0x1021 && word(0x0CCDEC) == 0x1021) && 
                once(prev(byte(0x0BADAE)) != byte(0x0BADAE)) && unless(once(byte(0x0BADAE) == 0x12 && prev(word(0x0BAC80)) != word(0x0BAC80)))) ||
               (once(byte(0x0BADAE) == 0x12 && prev(word(0x0CCDEC)) != 0x1021 && word(0x0CCDEC) == 0x1021) && 
                once(prev(byte(0x0BADAE)) != byte(0x0BADAE)) && unless(once(byte(0x0BADAE) == 0x11 && prev(word(0x0BAC80)) != word(0x0BAC80)))) ||
               (once(byte(0x0BADAE) == 0x11 && prev(word(0x0CCDEC)) != 0x1021 && word(0x0CCDEC) == 0x1021) && 
                once(prev(byte(0x0BADAE)) != byte(0x0BADAE)) && unless(once(byte(0x0BADAE) == 0x10 && prev(word(0x0BAC80)) != word(0x0BAC80)))) ||
               (once(byte(0x0BADAE) == 0x10 && prev(word(0x0CCDEC)) != 0x1021 && word(0x0CCDEC) == 0x1021) && 
                once(prev(byte(0x0BADAE)) != byte(0x0BADAE)) && unless(once(byte(0x0BADAE) == 0x0F && prev(word(0x0BAC80)) != word(0x0BAC80)))) ||
               (once(byte(0x0BADAE) == 0x0F && prev(word(0x0CCDEC)) != 0x1021 && word(0x0CCDEC) == 0x1021) && 
                once(prev(byte(0x0BADAE)) != byte(0x0BADAE)) && unless(once(byte(0x0BADAE) == 0x0E && prev(word(0x0BAC80)) != word(0x0BAC80)))) ||
               (once(byte(0x0BADAE) == 0x0E && prev(word(0x0CCDEC)) != 0x1021 && word(0x0CCDEC) == 0x1021) && 
                once(prev(byte(0x0BADAE)) != byte(0x0BADAE)) && unless(once(byte(0x0BADAE) == 0x0D && prev(word(0x0BAC80)) != word(0x0BAC80)))) ||
               (once(byte(0x0BADAE) == 0x0D && prev(word(0x0CCDEC)) != 0x1021 && word(0x0CCDEC) == 0x1021) && 
                once(prev(byte(0x0BADAE)) != byte(0x0BADAE)) && unless(once(byte(0x0BADAE) == 0x0C && prev(word(0x0BAC80)) != word(0x0BAC80))) && 
                once(byte(0x0BADAE) == 0x10 && prev(word(0x0CCDEC)) != 0x1021 && word(0x0CCDEC) == 0x1021) && once(prev(byte(0x0BADAE)) != byte(0x0BADAE)) && 
                unless(once(byte(0x0BADAE) == 0x0F && prev(word(0x0BAC80)) != word(0x0BAC80)))) ||
               (once(byte(0x0BADAE) == 0x0C && prev(word(0x0CCDEC)) != 0x1021 && word(0x0CCDEC) == 0x1021) && 
                once(prev(byte(0x0BADAE)) != byte(0x0BADAE)) && unless(once(byte(0x0BADAE) == 0x0B && prev(word(0x0BAC80)) != word(0x0BAC80)))) ||
               (once(byte(0x0BADAE) == 0x0B && prev(word(0x0CCDEC)) != 0x1021 && word(0x0CCDEC) == 0x1021) && 
                once(prev(byte(0x0BADAE)) != byte(0x0BADAE)) && unless(once(byte(0x0BADAE) == 0x0A && prev(word(0x0BAC80)) != word(0x0BAC80)))) ||
               (once(byte(0x0BADAE) == 0x0A && prev(word(0x0CCDEC)) != 0x1021 && word(0x0CCDEC) == 0x1021) && 
                once(prev(byte(0x0BADAE)) != byte(0x0BADAE)) && unless(once(byte(0x0BADAE) == 0x09 && prev(word(0x0BAC80)) != word(0x0BAC80)))) ||
               (once(byte(0x0BADAE) == 0x09 && prev(word(0x0CCDEC)) != 0x1021 && word(0x0CCDEC) == 0x1021) && 
                once(prev(byte(0x0BADAE)) != byte(0x0BADAE)) && unless(once(byte(0x0BADAE) == 0x08 && prev(word(0x0BAC80)) != word(0x0BAC80)))) ||
               (once(byte(0x0BADAE) == 0x08 && prev(word(0x0CCDEC)) != 0x1021 && word(0x0CCDEC) == 0x1021) && 
                once(prev(byte(0x0BADAE)) != byte(0x0BADAE)) && unless(once(byte(0x0BADAE) == 0x07 && prev(word(0x0BAC80)) != word(0x0BAC80)))) ||
               (once(byte(0x0BADAE) == 0x07 && prev(word(0x0CCDEC)) != 0x1021 && word(0x0CCDEC) == 0x1021) && 
                once(prev(byte(0x0BADAE)) != byte(0x0BADAE)) && unless(once(byte(0x0BADAE) == 0x06 && prev(word(0x0BAC80)) != word(0x0BAC80)))) ||
               (once(byte(0x0BADAE) == 0x06 && prev(word(0x0CCDEC)) != 0x1021 && word(0x0CCDEC) == 0x1021) && 
                once(prev(byte(0x0BADAE)) != byte(0x0BADAE)) && unless(once(byte(0x0BADAE) == 0x05 && prev(word(0x0BAC80)) != word(0x0BAC80)))) ||
               (once(byte(0x0BADAE) == 0x05 && prev(word(0x0CCDEC)) != 0x1021 && word(0x0CCDEC) == 0x1021) && 
                once(prev(byte(0x0BADAE)) != byte(0x0BADAE)) && unless(once(byte(0x0BADAE) == 0x04 && prev(word(0x0BAC80)) != word(0x0BAC80)))) ||
               (once(byte(0x0BADAE) == 0x04 && prev(word(0x0CCDEC)) != 0x1021 && word(0x0CCDEC) == 0x1021) && 
                once(prev(byte(0x0BADAE)) != byte(0x0BADAE)) && unless(once(byte(0x0BADAE) == 0x03 && prev(word(0x0BAC80)) != word(0x0BAC80)))) ||
               (once(byte(0x0BADAE) == 0x03 && prev(word(0x0CCDEC)) != 0x1021 && word(0x0CCDEC) == 0x1021) && 
                once(prev(byte(0x0BADAE)) != byte(0x0BADAE)) && unless(once(byte(0x0BADAE) == 0x02 && prev(word(0x0BAC80)) != word(0x0BAC80)))) ||
               (once(byte(0x0BADAE) == 0x02 && prev(word(0x0CCDEC)) != 0x1021 && word(0x0CCDEC) == 0x1021) && 
                once(prev(byte(0x0BADAE)) != byte(0x0BADAE)) && unless(once(byte(0x0BADAE) == 0x01 && prev(word(0x0BAC80)) != word(0x0BAC80)))) ||
               (once(byte(0x0BADAE) == 0x01 && prev(word(0x0CCDEC)) != 0x1021 && word(0x0CCDEC) == 0x1021) && 
                once(prev(byte(0x0BADAE)) != byte(0x0BADAE)) && unless(once(byte(0x0BADAE) == 0x00 && prev(word(0x0BAC80)) != word(0x0BAC80)))))
)

achievement(
    title = "King of Dragoons", description = "Acquire the Dragoon Spirit of the Divine Dragon.", points = 5,
    id = 96231, badge = "106727", published = "1/28/2020 1:28:05 AM", modified = "2/3/2020 2:54:55 AM",
    trigger = bit7(0x0BAD64) == 0x1 && prev(bit7(0x0BAD64)) == 0x0 && word(0x052C30) == 0x02E0
)

achievement(
    title = "Severing the Chains of Fate", description = "Complete Chapter 4 and forever alter the course of the world.", points = 25,
    id = 96267, badge = "106726", published = "1/28/2020 2:53:28 AM", modified = "2/27/2020 1:39:07 AM",
    trigger = ((repeated(1288, word(0x052C30) == 0x02A1)) ||
               (word(0x0BB0F8) == 0x01BB && word(0x0CCDEC) == 0x0000 && repeated(33300, word(0x052C30) == 0x02A0) && 
                never(word(0x052C30) != prev(word(0x052C30)))))
)
