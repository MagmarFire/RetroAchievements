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
function JustLeftBattle() => !IsInBattle() && Delta(battleMarker()) == 0x1021

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

function urobolusHp() => word(0x1adf44)
function itemsInInventory() => byte(0x0BADAE)
function ItemCountDecreased() => Delta(itemsInInventory()) > itemsInInventory()
function characterObjectWidth() => 0x2c
function characterSlot1Id() => byte(0x0bac50)
function characterSlot2Id() => byte(0x0bac54)
function characterSlot3Id() => byte(0x0bac58)

function Dart() => 0
function Lavitz() => 1
function Shana() => 2
function Haschel() => 4
function Albert() => 5
function Kongol() => 7
function Miranda() => 8

function CharacterIsInParty(id)
{
    return characterSlot1Id() == id || characterSlot2Id() == id || characterSlot3Id() == id
}

function GetCharacterById(id)
{
    characterArrayBaseAddr = 0x0baef4
    addr = characterArrayBaseAddr + id * characterObjectWidth()
    return {
        "exp": dword(addr),
        "statusFlags": byte(addr + 4),
        "hp": word(addr + 8),
        "level": byte(addr + 18),
        "accessoryId": byte(addr + 24)
    }
}

function CharacterWithIdHasItemWithIdEquipped(charId, accessoryId)
{
    character = GetCharacterById(charId)
    return character["accessoryId"] == accessoryId
}

function poisonGuardId() => 0x67
achievement(title = "Pharmacophobia", points = 5, id = 189207, badge = "209992",
    description = "Defeat the Urobolus without using items and without equipping any Poison Guards.",
    trigger = mapId() == 0x35 && enemyId() == 0x19e && EnteredBattleOnce() && never(!IsInBattle())
        && trigger_when(once(Delta(urobolusHp()) > 0 && urobolusHp() == 0) && repeated(290, urobolusHp() == 0))
        && never(ItemCountDecreased()) && never(CharacterWithIdHasItemWithIdEquipped(Dart(), poisonGuardId()))
        && never(CharacterWithIdHasItemWithIdEquipped(Lavitz(), poisonGuardId()))
        && never(CharacterWithIdHasItemWithIdEquipped(Shana(), poisonGuardId()))
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

function playerSlot1Addr() => 0x0bc1d8
function playerSlot2Addr() => 0x0bc1dc
function playerSlot3Addr() => 0x0bc1e0
function enemySlot1Addr() => 0x0bc1ec
function enemySlot2Addr() => 0x0bc1f0
function enemySlot3Addr() => 0x0bc1f4
function garbagePointer() => 0xbc0c0

function PointerIsValid(addr) => Delta(tbyte(addr)) != garbagePointer()
function GetCombatantInGivenSlotAddr(addr)
{
    return {
        "hp": word(tbyte(addr) + 0x108),
        "mp": word(tbyte(addr) + 0x10c)
    }
}

function CombatantInSlotAddrWasJustDefeated(addr)
{
    combatant = GetCombatantInGivenSlotAddr(addr)
    return PointerIsValid(addr) && Delta(combatant["hp"]) > 0 && combatant["hp"] == 0
}

function CombatantInSlotAddrWasAlreadyDefeated(addr)
{
    combatant = GetCombatantInGivenSlotAddr(addr)
    return PointerIsValid(addr) && Delta(combatant["hp"]) == 0 && combatant["hp"] == 0
}

function AllCombatantsInGivenSlotAddrsWereJustDefeated(slots, useTrigger = true, deferTime = 0)
{
    allGivenCombatantsDefeated = always_true()
    anyGivenCombatantWasJustDefeated = always_false()
    ret = always_false()
    for slot in slots
    {
        combatant = GetCombatantInGivenSlotAddr(slot)
        allGivenCombatantsDefeated = allGivenCombatantsDefeated && combatant["hp"] == 0 && PointerIsValid(slot)
        wasJustDefeated = CombatantInSlotAddrWasJustDefeated(slot)
        
        anyGivenCombatantWasJustDefeated = anyGivenCombatantWasJustDefeated || wasJustDefeated
    }
    
    if (deferTime > 0)
    {
        ret = repeated(deferTime, allGivenCombatantsDefeated) && anyGivenCombatantWasJustDefeated
    }
    else
    {
        ret = allGivenCombatantsDefeated && anyGivenCombatantWasJustDefeated
    }
    
    if (useTrigger == true)
    {
        ret = trigger_when(ret)
    }
    
    return ret
}

function slot1DragoonTurnsRemaining() => byte(0x06e62c)
function slot2DragoonTurnsRemaining() => byte(0x06e630)
function slot3DragoonTurnsRemaining() => byte(0x06e634)

function DragoonTurnConsumedBySlot(slotId)
{
    if (slotId == 1)
    {
        return Delta(slot1DragoonTurnsRemaining()) > slot1DragoonTurnsRemaining()
    }
    else if (slotId == 2)
    {
        return Delta(slot2DragoonTurnsRemaining()) > slot2DragoonTurnsRemaining()
    }
    else
    {
        return Delta(slot3DragoonTurnsRemaining()) > slot3DragoonTurnsRemaining()
    }
}

function turnCounter() => dword(0x0bac80)
function TurnConsumed() => Delta(turnCounter()) < turnCounter()

function GetPlayerAddrFromSlot(slotId)
{
    if (slotId == 1)
    {
        return playerSlot1Addr()
    }
    else if (slotId == 2)
    {
        return playerSlot2Addr()
    }
    else
    {
        return playerSlot3Addr()
    }
}

function PlayerUsedMagicThisTurn()
{
    trigger = always_false()
    for slot in range(1, 3)
    {
        slotAddr = GetPlayerAddrFromSlot(slot)
        combatant = GetCombatantInGivenSlotAddr(slotAddr)
        trigger = trigger || unless(!PointerIsValid(slotAddr)) && trigger_when(once(Delta(combatant["mp"]) > combatant["mp"] && never(TurnConsumed())))
    }
    
    return trigger
}

function PlayerJustUsedMagic()
{
    trigger = always_false()
    for slot in range(1, 3)
    {
        slotAddr = GetPlayerAddrFromSlot(slot)
        combatant = GetCombatantInGivenSlotAddr(slotAddr)
        // todo: use `trigger_when()` around the `once()` statement when https://github.com/Jamiras/RATools/issues/272 is addressed.
        trigger = trigger || PointerIsValid(slotAddr) && once(Delta(combatant["mp"]) > combatant["mp"])
    }
    
    return trigger
}

function Feyrbrand() => enemySlot1Addr()
function Greham() => enemySlot2Addr()
achievement(title = "No Revenge Like Overkill", description = "Finish the battle against Greham and Feyrbrand with a Dragoon spell.", points = 10,
    id = 189209, badge = "209994",
    trigger = mapId() == 0x290 && enemyId() == 0x189 && EnteredBattleOnce() && never(!IsInBattle())
        && AllCombatantsInGivenSlotAddrsWereJustDefeated([ Feyrbrand(), Greham() ], true) && PlayerUsedMagicThisTurn()
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

function monsterConquestAddr() => tbyte(0x0bc1e8)
function monsterConquestScore() => dword(monsterConquestAddr() + 0x7c)
achievement(
    title = "Monkeyball Master", description = "Get a score of 100 or more in the Monster Conquest Game Stand minigame.", points = 5,
    id = 94798, badge = "106744", published = "1/15/2020 11:26:27 PM", modified = "2/4/2020 10:54:22 PM",
    trigger = mapId() == 0x98 && never(mapId() != 0x98) &&
        never(!PointerIsValid(monsterConquestAddr())) && monsterConquestScore() >= 100 && monsterConquestScore() != 0xffffffff
        && once(monsterConquestScore() == 0xffffffff)
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

function Doel() => enemySlot1Addr()
function DragoonDoel() => enemySlot2Addr()
achievement(title = "Electrical Paralysis", points = 5, id = 189208, badge = "209993",
    description = "Defeat Emperor Doel without using Dragoon magic.",
    trigger = mapId() == 0x294 && enemyId() == 0x186 && EnteredBattleOnce() && never(!IsInBattle())
        && AllCombatantsInGivenSlotAddrsWereJustDefeated([ Doel(), DragoonDoel() ], true)
        && never(PlayerJustUsedMagic())
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
    trigger = enemyId() == 0x01E9 && mapId() == 0x0125
        && EnteredBattleOnce() && never(!IsInBattle())
        && CombatantInSlotAddrWasJustDefeated(enemySlot1Addr()) && CombatantInSlotAddrWasJustDefeated(enemySlot2Addr()) && CombatantInSlotAddrWasJustDefeated(enemySlot3Addr())
        && never(!CharacterIsInParty(Albert())) && never(!CharacterIsInParty(Kongol()))
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
    id = 98008, badge = "108035", published = "2/8/2020 11:03:41 PM", modified = "2/13/2020 10:38:26 PM", type = "missable",
    trigger = EnteredBattleOnce() && word(0x0CCDEC) == 0x1021 &&
              ((never(byte(0x06E62C) > 0x00) && never(byte(0x06E630) > 0x00) && never(byte(0x06E634) > 0x00) && 
                unless(byte(0x06E62C) == 0x28) && unless(byte(0x06E630) == 0x2C) && unless(byte(0x06E634) == 0x30) && always_false()) ||
               (prev(word(0x0BC95C)) == 0x1B58 && word(0x0BC95C) == 0x0000))
               && never(!IsInBattle())
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

function slot1DragoonTurnsRemaining() => byte(0x06E62C)
function slot2DragoonTurnsRemaining() => byte(0x06E630)
function slot3DragoonTurnsRemaining() => byte(0x06E634)
function slotIdOfDragoonSpecial() => byte(0x06E648)
function DragoonLloyd() => enemySlot1Addr()

// This achievement needs a rework. We need to ensure the player actually spends at least six turns in a Dragoon Special. The player can simply wait to pop the special until the end, which
// was not intended.
// Additionally, we need to specify 0 HP instead of defeating him because Lloyd will always do an AoE attack when he's brought to 0 HP. This will have to be specified until I can revise this
// further and trigger the achievement after the cutscene like before.
achievement(
    title = "Confidence, or Recklessness?", description = "Bring Lloyd down to 0 HP after triggering at least a second-level Dragoon Special at least once.", points = 10,
    id = 98127, badge = "108055", published = "2/9/2020 9:25:08 PM", modified = "2/13/2020 10:38:38 PM",
    trigger = trigger_when(once(slot1DragoonTurnsRemaining() > 1 && slot2DragoonTurnsRemaining() > 1 && slot3DragoonTurnsRemaining() > 1
              && Delta(slotIdOfDragoonSpecial()) == 0xFF && slotIdOfDragoonSpecial() != 0xFF))
              && never(JustLeftBattle()) && enemyId() == 0x0188
              && AllCombatantsInGivenSlotAddrsWereJustDefeated([ DragoonLloyd() ], true)
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

function DivineDragonSpirit() => enemySlot2Addr()
achievement(
    title = "Ful, Losei Dovahkiin?", description = "Defeat the spirit of the Divine Dragon in Mayfil.", points = 25,
    id = 96124, badge = "106736", published = "1/26/2020 9:17:07 PM", modified = "2/3/2020 2:53:03 AM",
    trigger = mapId() == 0x0222 && enemyId() == 0x01BF && EnteredBattleOnce() && never(!IsInBattle())
        && AllCombatantsInGivenSlotAddrsWereJustDefeated([ DivineDragonSpirit() ], false)
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
    id = 98230, badge = "108084", published = "2/12/2020 12:39:52 AM", modified = "2/13/2020 10:39:00 PM", type = "missable",
    trigger = word(0x0BC95C) == 0x3A98 && word(0x0BB0F8) == 0x019B && never(word(0x052C30) != 0x02DD) &&
              (always_false() || (once(prev(word(0x0BAC80)) != word(0x0BAC80)) && unless(word(0x1AB01C) > 0x0000)))
              && never(!CharacterIsInParty(Haschel())) && never(!CharacterIsInParty(Kongol()))
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

StatusLookup = {
    0: "Exploring",
    1: "Exploring",
    0x19: "Exploring",
    0x2e4: "Exploring",
    0x1021: "Fighting in",
}

ChapterLookup = {
    0: "Chapter 1 - The Serdian War",
    1: "Chapter 2 - Platinum Shadow",
    2: "Chapter 3 - Fate and Soul",
    3: "Chapter 4 - Moon and Fate",
}

LocationLookup = {
    0x5: "the Forest by Seles",
    0x6: "the Forest by Seles",
    0x7: "the Forest by Seles",
    0x8: "Seles",
    0x9: "Seles",
    0xA: "Seles",
    0xB: "Seles",
    0xC: "Seles",
    0xD: "Hellena Prison",
    0xE: "Hellena Prison",
    0xF: "Hellena Prison",
    0x10: "Hellena Prison",
    0x11: "Hellena Prison",
    0x12: "Hellena Prison",
    0x13: "Hellena Prison",
    0x14: "Hellena Prison",
    0x15: "Hellena Prison",
    0x16: "Hellena Prison",
    0x17: "Hellena Prison",
    0x18: "Hellena Prison",
    0x19: "Hellena Prison",
    0x1A: "Hellena Prison",
    0x1B: "Hellena Prison",
    0x1C: "Hellena Prison",
    0x1D: "Hellena Prison",
    0x1E: "Hellena Prison",
    0x1F: "Hellena Prison",
    0x20: "Hellena Prison",
    0x21: "Hellena Prison",
    0x22: "Hellena Prison",
    0x23: "Hellena Prison",
    0x24: "Hellena Prison",
    0x25: "Hellena Prison",
    0x26: "Prairie",
    0x27: "Prairie",
    0x28: "Prairie",
    0x29: "Prairie",
    0x2A: "Prairie",
    0x2B: "Prairie",
    0x2C: "Prairie",
    0x2D: "Limestone Cave",
    0x2E: "Limestone Cave",
    0x2F: "Limestone Cave",
    0x30: "Limestone Cave",
    0x31: "Limestone Cave",
    0x32: "Limestone Cave",
    0x33: "Limestone Cave",
    0x34: "Limestone Cave",
    0x35: "Limestone Cave",
    0x36: "Limestone Cave",
    0x38: "Hellena Prison",
    0x39: "Seles",
    0x41: "Basil",
    0x42: "Basil",
    0x43: "Basil",
    0x44: "Basil",
    0x45: "Basil",
    0x46: "Basil",
    0x47: "Basil",
    0x48: "Basil",
    0x49: "Basil",
    0x4A: "Basil",
    0x4B: "Basil",
    0x4C: "Basil",
    0x4D: "Basil",
    0x4E: "Basil",
    0x4F: "Basil",
    0x50: "Basil",
    0x51: "Basil",
    0x52: "Basil",
    0x53: "Basil",
    0x54: "Basil",
    0x55: "Basil",
    0x56: "Basil",
    0x57: "Basil",
    0x58: "Basil",
    0x59: "Basil",
    0x5A: "Basil",
    0x5B: "Basil",
    0x5C: "Basil",
    0x5D: "Basil",
    0x5E: "Basil",
    0x5F: "Basil",
    0x60: "Hoax",
    0x61: "Hoax",
    0x62: "Hoax",
    0x63: "Hoax",
    0x64: "Hoax",
    0x65: "Hoax",
    0x66: "Hoax",
    0x67: "Hoax",
    0x68: "Hoax",
    0x69: "Hoax",
    0x6A: "Behind Seles",
    0x6B: "Marshland",
    0x6C: "Marshland",
    0x6D: "Marshland",
    0x6E: "Marshland",
    0x6F: "Marshland",
    0x70: "Hoax",
    0x71: "Hoax",
    0x72: "Volcano Villude",
    0x73: "Volcano Villude",
    0x74: "Volcano Villude",
    0x75: "Volcano Villude",
    0x76: "Volcano Villude",
    0x77: "Volcano Villude",
    0x78: "Volcano Villude",
    0x79: "Volcano Villude",
    0x7A: "Volcano Villude",
    0x7B: "Volcano Villude",
    0x82: "the Dragon's Nest",
    0x83: "the Dragon's Nest",
    0x84: "the Dragon's Nest",
    0x85: "the Dragon's Nest",
    0x86: "the Dragon's Nest",
    0x87: "the Dragon's Nest",
    0x88: "the Dragon's Nest",
    0x89: "the Dragon's Nest",
    0x8A: "the Dragon's Nest",
    0x8B: "the Dragon's Nest",
    0x8C: "Lohan ",
    0x8D: "Lohan ",
    0x8E: "Lohan ",
    0x8F: "Lohan ",
    0x90: "Lohan ",
    0x91: "Lohan ",
    0x92: "Lohan ",
    0x93: "Lohan ",
    0x94: "Lohan ",
    0x95: "Lohan ",
    0x96: "Lohan ",
    0x97: "Lohan ",
    0x98: "Monster Conquest",
    0x99: "the Shrine of Shirley",
    0x9A: "the Shrine of Shirley",
    0x9B: "the Shrine of Shirley",
    0x9C: "the Shrine of Shirley",
    0x9D: "the Shrine of Shirley",
    0x9E: "the Shrine of Shirley",
    0x9F: "the Shrine of Shirley",
    0xA0: "the Shrine of Shirley",
    0xA1: "the Shrine of Shirley ",
    0xA2: "the Shrine of Shirley",
    0xA3: "the Shrine of Shirley ",
    0xA4: "the Shrine of Shirley",
    0xA5: "the Shrine of Shirley",
    0xA6: "the Shrine of Shirley ",
    0xAB: "Kazas",
    0xAC: "Kazas",
    0xAD: "Kazas",
    0xAE: "Kazas",
    0xAF: "Kazas",
    0xB0: "Kazas",
    0xB1: "Kazas",
    0xB2: "Kazas",
    0xB3: "Kazas",
    0xB4: "Kazas",
    0xB5: "Kazas",
    0xB6: "Kazas",
    0xB7: "Kazas",
    0xBB: "Kazas",
    0xBC: "Kazas",
    0xBD: "Kazas",
    0xBE: "Kazas",
    0xBF: "Kazas",
    0xC0: "Kazas",
    0xC1: "Kazas",
    0xC2: "Kazas",
    0xC3: "Kazas",
    0xC4: "Kazas",
    0xC5: "Kazas",
    0xC6: "Kazas",
    0xC7: "Kazas",
    0xC8: "Kazas",
    0xC9: "Fletz",
    0xCA: "Fletz",
    0xCB: "Fletz",
    0xCC: "Fletz",
    0xCD: "Fletz",
    0xCE: "Fletz",
    0xCF: "Fletz",
    0xD0: "Fletz",
    0xD1: "Fletz",
    0xD2: "Fletz",
    0xD3: "Fletz",
    0xD4: "Fletz",
    0xD5: "Fletz",
    0xD6: "Fletz",
    0xD7: "Fletz ",
    0xD8: "Fletz",
    0xD9: "Fletz",
    0xDA: "Fletz",
    0xDB: "Fletz",
    0xDC: "Fletz",
    0xDD: "Fletz",
    0xDE: "Fletz",
    0xDF: "Fletz",
    0xE0: "Fletz",
    0xE1: "Fletz",
    0xE2: "Fletz",
    0xE3: "Fletz",
    0xE4: "Fletz",
    0xE5: "Fletz",
    0xE6: "Fletz",
    0xE7: "Barrens",
    0xE8: "Barrens",
    0xE9: "Barrens",
    0xEA: "Fletz",
    0xEB: "Telescope",
    0xEC: "Fletz",
    0xED: "Fletz",
    0xEE: "Fletz",
    0xEF: "Donau",
    0xF0: "Donau",
    0xF1: "Donau",
    0xF2: "Donau",
    0xF3: "Donau",
    0xF4: "Donau",
    0xF5: "Donau",
    0xF6: "Donau",
    0xF7: "Donau",
    0xF8: "Donau",
    0xF9: "Donau",
    0xFA: "Donau",
    0xFB: "the Valley of Corrupted Gravity",
    0xFC: "the Valley of Corrupted Gravity",
    0xFD: "the Valley of Corrupted Gravity",
    0xFE: "the Valley of Corrupted Gravity",
    0xFF: "the Valley of Corrupted Gravity",
    0x100: "the Valley of Corrupted Gravity",
    0x101: "the Valley of Corrupted Gravity",
    0x102: "the Valley of Corrupted Gravity",
    0x103: "Donau",
    0x104: "Fletz",
    0x105: "the Home of Gigantos",
    0x106: "the Home of Gigantos",
    0x107: "the Home of Gigantos",
    0x108: "the Home of Gigantos",
    0x109: "the Home of Gigantos",
    0x10A: "the Home of Gigantos",
    0x10B: "the Home of Gigantos",
    0x10C: "the Home of Gigantos",
    0x114: "the Queen Fury ",
    0x115: "the Queen Fury ",
    0x116: "the Queen Fury ",
    0x117: "the Queen Fury ",
    0x118: "the Queen Fury ",
    0x119: "the Queen Fury ",
    0x11A: "the Queen Fury ",
    0x11B: "the Queen Fury ",
    0x11C: "the Queen Fury ",
    0x11D: "the Queen Fury ",
    0x11E: "the Queen Fury",
    0x11F: "the Queen Fury ",
    0x120: "the Phantom Ship",
    0x121: "the Phantom Ship",
    0x122: "the Phantom Ship",
    0x123: "the Phantom Ship",
    0x124: "the Phantom Ship",
    0x125: "the Phantom Ship",
    0x126: "the Phantom Ship",
    0x127: "the Phantom Ship ",
    0x128: "the Phantom Ship",
    0x129: "Lidiera",
    0x12A: "Lidiera",
    0x12B: "Lidiera",
    0x12C: "Lidiera",
    0x12D: "Entrance to the Cave",
    0x12E: "Entrance to the Cave",
    0x12F: "Cave",
    0x130: "Cave",
    0x131: "Cave",
    0x134: "Cave",
    0x135: "Fueno",
    0x136: "Fueno",
    0x137: "Fueno",
    0x138: "Fueno",
    0x139: "Fueno",
    0x13A: "Fueno",
    0x13B: "Fueno",
    0x13C: "Fueno",
    0x13D: "Fueno",
    0x13E: "Fueno",
    0x13F: "Fueno",
    0x141: "the Phantom Ship",
    0x142: "the Phantom Ship",
    0x143: "Cave",
    0x144: "Cave",
    0x145: "Cave",
    0x147: "Black",
    0x148: "Furni",
    0x149: "Furni",
    0x14A: "Furni",
    0x14B: "Furni",
    0x14C: "Furni",
    0x14D: "Furni",
    0x14E: "Furni",
    0x14F: "Furni",
    0x150: "Furni",
    0x151: "Furni",
    0x152: "Furni",
    0x153: "Evergreen Forest",
    0x154: "Evergreen Forest",
    0x155: "Evergreen Forest",
    0x156: "Evergreen Forest",
    0x157: "Evergreen Forest",
    0x158: "Evergreen Forest",
    0x159: "Evergreen Forest",
    0x15A: "Evergreen Forest",
    0x15B: "Deningrad",
    0x15C: "Deningrad",
    0x15D: "Deningrad",
    0x15E: "Deningrad",
    0x15F: "Deningrad",
    0x160: "Deningrad",
    0x161: "Deningrad",
    0x162: "Deningrad",
    0x163: "Deningrad",
    0x164: "Deningrad",
    0x165: "Deningrad",
    0x166: "Deningrad",
    0x167: "Deningrad",
    0x168: "Deningrad",
    0x169: "Deningrad",
    0x16A: "Deningrad",
    0x16B: "Deningrad",
    0x16C: "Lidiera",
    0x16D: "Lidiera",
    0x16E: "Lidiera",
    0x16F: "the Crystal Palace",
    0x170: "the Crystal Palace",
    0x171: "the Crystal Palace",
    0x172: "the Crystal Palace",
    0x173: "the Crystal Palace",
    0x174: "the Crystal Palace",
    0x175: "the Crystal Palace",
    0x176: "the Crystal Palace",
    0x177: "the Crystal Palace",
    0x178: "the Crystal Palace",
    0x17B: "Neet",
    0x17C: "Neet",
    0x17D: "the Forest of the Winglies",
    0x17E: "the Forest of the Winglies",
    0x17F: "the Forest of the Winglies",
    0x180: "the Forest of the Winglies",
    0x181: "the Forest of the Winglies",
    0x182: "the Forest of the Winglies",
    0x183: "the Forest of the Winglies",
    0x184: "the Forest of the Winglies",
    0x185: "Deningrad",
    0x189: "the Forbidden Land of Kadessa",
    0x18A: "the Forbidden Land of Kadessa",
    0x18B: "the Forbidden Land of Kadessa",
    0x18C: "the Forbidden Land of Kadessa",
    0x18D: "the Forbidden Land of Kadessa",
    0x18E: "the Forbidden Land of Kadessa",
    0x18F: "the Forbidden Land of Kadessa",
    0x190: "the Forbidden Land of Kadessa",
    0x191: "the Forbidden Land of Kadessa",
    0x192: "the Forbidden Land of Kadessa",
    0x193: "the Forbidden Land of Kadessa",
    0x194: "the Forbidden Land of Kadessa",
    0x195: "the Forbidden Land of Kadessa",
    0x19D: "the Mountain of the Mortal Dragon",
    0x19E: "the Mountain of the Mortal Dragon",
    0x19F: "the Mountain of the Mortal Dragon",
    0x1A0: "the Mountain of the Mortal Dragon",
    0x1A1: "the Mountain of the Mortal Dragon",
    0x1A2: "the Mountain of the Mortal Dragon",
    0x1A3: "the Mountain of the Mortal Dragon",
    0x1A4: "the Mountain of the Mortal Dragon",
    0x1A5: "the Mountain of the Mortal Dragon",
    0x1A6: "the Mountain of the Mortal Dragon",
    0x1A7: "the Mountain of the Mortal Dragon",
    0x1A8: "the Mountain of the Mortal Dragon",
    0x1A9: "the Mountain of the Mortal Dragon",
    0x1AA: "the Mountain of the Mortal Dragon",
    0x1AB: "the Mountain of the Mortal Dragon",
    0x1B1: "Kashua Glacier",
    0x1B2: "Kashua Glacier",
    0x1B3: "Kashua Glacier",
    0x1B4: "Kashua Glacier",
    0x1B5: "Kashua Glacier",
    0x1B6: "Kashua Glacier",
    0x1BA: "the Tower of Flanvel",
    0x1BB: "the Tower of Flanvel",
    0x1BC: "the Tower of Flanvel",
    0x1BD: "the Tower of Flanvel",
    0x1BE: "the Tower of Flanvel",
    0x1BF: "the Tower of Flanvel",
    0x1C0: "the Tower of Flanvel",
    0x1C1: "the Tower of Flanvel",
    0x1C2: "the Tower of Flanvel",
    0x1C3: "the Tower of Flanvel",
    0x1C4: "the Tower of Flanvel",
    0x1C9: "Snowfield",
    0x1CA: "Snowfield",
    0x1CB: "Snowfield",
    0x1CC: "Snowfield",
    0x1CD: "Snowfield",
    0x1CE: "Snowfield",
    0x1CF: "the Forbidden Land of Kadessa",
    0x1D1: "Fort Magrad",
    0x1D2: "Fort Magrad",
    0x1D3: "Fort Magrad",
    0x1DD: "Vellweb",
    0x1DE: "Vellweb",
    0x1DF: "Vellweb",
    0x1E0: "Vellweb",
    0x1E1: "Vellweb",
    0x1E2: "Vellweb",
    0x1E3: "Vellweb",
    0x1E4: "Vellweb",
    0x1E5: "Vellweb",
    0x1E6: "Vellweb",
    0x1E7: "Vellweb",
    0x1E8: "Vellweb",
    0x1E9: "Vellweb",
    0x1EA: "Vellweb",
    0x1EB: "Vellweb",
    0x1EC: "Vellweb",
    0x1ED: "Vellweb",
    0x1EE: "Vellweb",
    0x1EF: "Vellweb",
    0x1F0: "Vellweb",
    0x1F1: "Vellweb",
    0x1F2: "Vellweb",
    0x1F3: "Vellweb",
    0x1F4: "Vellweb",
    0x1F5: "Vellweb",
    0x1F6: "Vellweb",
    0x1F7: "Scene",
    0x201: "Ulara",
    0x202: "Ulara",
    0x203: "Ulara",
    0x204: "Ulara",
    0x205: "Ulara",
    0x206: "Ulara",
    0x207: "Ulara",
    0x208: "Ulara",
    0x209: "Ulara",
    0x20A: "Ulara",
    0x20B: "Ulara",
    0x20C: "Ulara",
    0x20D: "Ulara",
    0x20E: "Ulara",
    0x20F: "Ulara",
    0x210: "Zenebatos, the City of Law",
    0x211: "Zenebatos, the City of Law",
    0x212: "Zenebatos, the City of Law",
    0x213: "Zenebatos, the City of Law",
    0x214: "Zenebatos, the City of Law",
    0x215: "Zenebatos, the City of Law",
    0x216: "Zenebatos, the City of Law",
    0x217: "Zenebatos, the City of Law",
    0x218: "Zenebatos, the City of Law",
    0x219: "Zenebatos, the City of Law",
    0x21A: "Zenebatos, the City of Law",
    0x21B: "Mayfil, the City of Death",
    0x21C: "Mayfil, the City of Death",
    0x21D: "Mayfil, the City of Death",
    0x21E: "Mayfil, the City of Death",
    0x21F: "Mayfil, the City of Death",
    0x220: "Mayfil, the City of Death",
    0x221: "Mayfil, the City of Death",
    0x222: "Mayfil, the City of Death",
    0x223: "Mayfil, the City of Death",
    0x224: "Mayfil, the City of Death",
    0x225: "Mayfil, the City of Death",
    0x226: "Mayfil, the City of Death",
    0x227: "Mayfil, the City of Death",
    0x228: "Mayfil, the City of Death",
    0x229: "Mayfil, the City of Death",
    0x231: "the Moon That Never Sets",
    0x233: "Rouge",
    0x234: "Rouge",
    0x235: "Rouge",
    0x236: "Rouge",
    0x237: "Rouge",
    0x238: "Rouge",
    0x239: "Aglis, the City of Magic",
    0x23A: "Aglis, the City of Magic",
    0x23B: "Aglis, the City of Magic",
    0x23C: "Aglis, the City of Magic",
    0x23D: "Aglis, the City of Magic",
    0x23E: "Aglis, the City of Magic",
    0x23F: "Aglis, the City of Magic",
    0x240: "Aglis, the City of Magic",
    0x241: "Aglis, the City of Magic",
    0x242: "Aglis, the City of Magic",
    0x243: "Aglis, the City of Magic",
    0x244: "Aglis, the City of Magic",
    0x245: "Aglis, the City of Magic",
    0x246: "Aglis, the City of Magic",
    0x247: "the Divine Tree",
    0x248: "the Divine Tree",
    0x249: "the Divine Tree",
    0x24A: "the Divine Tree",
    0x24B: "the Divine Tree",
    0x24C: "the Divine Tree",
    0x24D: "the Divine Tree",
    0x24E: "the Divine Tree",
    0x24F: "the Divine Tree",
    0x250: "the Divine Tree",
    0x251: "the Divine Tree",
    0x252: "Aglis, the City of Magic",
    0x253: "Rouge",
    0x254: "Doel’s Throne Room",
    0x255: "the Moon That Never Sets",
    0x256: "the Moon That Never Sets",
    0x257: "the Moon That Never Sets Entrance",
    0x258: "the Moon That Never Sets",
    0x259: "the Moon That Never Sets",
    0x25A: "the Moon That Never Sets",
    0x25B: "the Moon That Never Sets",
    0x25C: "the Moon That Never Sets",
    0x25D: "the Moon That Never Sets",
    0x25E: "the Moon That Never Sets",
    0x25F: "the Moon That Never Sets",
    0x260: "the Moon That Never Sets",
    0x261: "the Moon That Never Sets",
    0x262: "the Moon That Never Sets",
    0x263: "the Moon That Never Sets",
    0x264: "the Moon That Never Sets",
    0x265: "the Moon That Never Sets",
    0x266: "the Moon That Never Sets",
    0x267: "the Moon That Never Sets",
    0x268: "the Moon That Never Sets",
    0x269: "the Moon That Never Sets",
    0x26A: "the Moon That Never Sets",
    0x26B: "the Moon That Never Sets",
    0x26C: "the Moon That Never Sets",
    0x26D: "the Moon That Never Sets",
    0x26E: "the Moon That Never Sets",
    0x26F: "Bale",
    0x270: "the Forest by Seles",
    0x271: "the Forest by Seles",
    0x272: "Hoax",
    0x273: "Hoax",
    0x274: "Bale",
    0x275: "Rouge",
    0x276: "Lidiera",
    0x277: "Bale",
    0x278: "Hoax",
    0x279: "Hoax",
    0x27A: "“Who Is the Man?” Game",
    0x27C: "“What's Wrong with the Scene?”",
    0x27D: "the Hero Competition",
    0x27E: "the Hero Competition",
    0x27F: "Obstacle Course",
    0x280: "Hellena Prison",
    0x281: "Hellena Prison",
    0x282: "Hellena Prison",
    0x283: "Hellena Prison",
    0x284: "Hellena Prison",
    0x285: "Hellena Prison",
    0x286: "Lohan",
    0x287: "Lohan",
    0x288: "Ulara",
    0x289: "Ulara",
    0x290: "the Dragon's Nest",
    0x291: "Hoax",
    0x292: "the Black Castle",
    0x293: "the Black Castle",
    0x294: "the Black Castle",
    0x295: "Rouge",
    0x296: "the Twin Castle",
    0x297: "the Twin Castle",
    0x298: "the Twin Castle",
    0x299: "the Twin Castle",
    0x29A: "the Twin Castle",
    0x29B: "the Twin Castle",
    0x29C: "the Twin Castle",
    0x29D: "the Twin Castle",
    0x29E: "Furni",
    0x29F: "Furni",
    0x2A0: "Ending",
    0x2A1: "Ending",
    0x2A2: "Hoax",
    0x2A3: "Opening",
    0x2A4: "Opening",
    0x2A5: "Opening",
    0x2A6: "Lidiera",
    0x2B4: "Neet",
    0x2B5: "Neet",
    0x2B6: "Hellena Prison",
    0x2B7: "Hellena Prison",
    0x2B8: "the Black Castle",
    0x2B9: "Neet",
    0x2BA: "the Twin Castle",
    0x2BB: "the Moon That Never Sets",
    0x2BC: "Rouge",
    0x2BD: "Aglis, the City of Magic",
    0x2BE: "the Twin Castle",
    0x2BF: "Opening",
    0x2C0: "Opening",
    0x2C1: "Mayfil, the City of Death",
    0x2C2: "Mayfil Stream",
    0x2C3: "Mayfil, the City of Death",
    0x2C4: "Signet",
    0x2C5: "Fletz",
    0x2C6: "Disc 3 Opening",
    0x2C7: "Aglis, the City of Magic",
    0x2C8: "Aglis, the City of Magic",
    0x2C9: "Aglis, the City of Magic",
    0x2CA: "Aglis, the City of Magic",
    0x2CB: "Collin",
    0x2CC: "the Dragon's Nest",
    0x2CD: "Zenebatos",
    0x2CE: "Zenebatos",
    0x2CF: "Signet",
    0x2D0: "Fueno",
    0x2D1: "Mayfil",
    0x2D2: "the Moon That Never Sets Scene",
    0x2D3: "Black Monster",
    0x2D4: "Glitch",
    0x2D5: "Seles",
    0x2D6: "Hoax",
    0x2D7: "the Moon That Never Sets",
    0x2D8: "the Moon That Never Sets",
    0x2D9: "the Moon That Never Sets",
    0x2DA: "the Moon That Never Sets",
    0x2DB: "the Moon That Never Sets",
    0x2DC: "the Moon That Never Sets",
    0x2DD: "the Moon That Never Sets",
    0x2DE: "the Moon That Never Sets",
    0x2DF: "the Moon That Never Sets",
    0x2E0: "the Moon That Never Sets",
    0x2E1: "the Moon That Never Sets (Final)",
    0x2E2: "the Moon That Never Sets",
    0x2E3: "the Moon That Never Sets",
    0x2E4: "Burning Seles",
    0x2E5: "Burnt Seles",
    0x2E6: "Hellena Prison ",
    0x2E7: "the Black Castle",
    0x2E8: "the Twin Castle",
    0x2E9: "the Death Frontier",
    0x2EA: "the Death Frontier",
    0x2EB: "the Death Frontier",
    0x2EC: "the Death Frontier",
    0x2ED: "the Death Frontier",
    0x2EE: "the Death Frontier",
    0x2EF: "the Death Frontier",
    0x2F0: "the Death Frontier",
    0x2F1: "the Death Frontier",
    0x2F2: "the Death Frontier",
    0x2F3: "the Death Frontier",
    0x2F4: "the Death Frontier",
    0x2F5: "the Death Frontier",
    0x2F6: "the Death Frontier",
    0x2F7: "the Death Frontier",
    0x2F8: "the Death Frontier",
    0x2F9: "the Death Frontier",
    0x2FA: "the Death Frontier",
    0x2FB: "the Death Frontier",
    0x2FC: "the Death Frontier",
    0x2FD: "the Death Frontier",
    0x2FE: "the Death Frontier",
    0x2FF: "the Death Frontier",
    0x300: "the Death Frontier",
    0x301: "the Death Frontier",
    0x302: "the Death Frontier",
    0x303: "the Death Frontier",
    0x304: "the Death Frontier",
    0x305: "the Death Frontier",
    0x306: "the Death Frontier",
    0x307: "the Death Frontier",
    0x308: "the Death Frontier",
    0x309: "the Death Frontier",
    0x30A: "the Death Frontier",
    0x30B: "the Death Frontier",
    0x30C: "the Death Frontier",
    0x30D: "the Death Frontier",
    0x30E: "the Death Frontier",
    0x30F: "the Death Frontier",
    0x310: "the Death Frontier",
    0x311: "the Death Frontier",
    0x312: "the Death Frontier",
    0x313: "the Death Frontier",
    0x314: "the Death Frontier",
    0x315: "the Death Frontier",
    0x316: "the Death Frontier",
    0x31A: " Bale",
    0x31E: " Ulara",
}

rich_presence_conditional_display(word(0x052C30) == word(0x0002A3), " ")

rich_presence_display("{0} | {1} {2} | Play Time: {3}",
    rich_presence_lookup("Chapter", byte(0x0BAC60), ChapterLookup),
    rich_presence_lookup("Status", word(0x0CCDEC), StatusLookup),
    rich_presence_lookup("Location", word(0x052C30), LocationLookup),
    rich_presence_value("Time", dword(0x0BAC68), format="FRAMES")
)
