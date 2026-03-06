// The Legend of Zelda: Skyward Sword
// #ID = 202

function SecondsToFrames(value) => value * 30
function SecondsToFormat(value)
{
    leadingZero = ""
    if (value % 60 < 10)
    {
        leadingZero = "0"
    }
    return value / 60 + ":" + leadingZero + value % 60
}

function LMeasured(condition) => measured(repeated(0, condition)) // Legacy `measured` polyfill. measured(A && B) is no longer supported as of v1.10.0.
function Delta(mem) => prev(mem)

// $955E56: Sword [8-bit]
//          
//          0x01 = Practice Sword
function equippedSword() => byte(0x955E56)

function hp() => word_be(0x0095a76a)
function maxHp() => word_be(0x0095a766)

function Hearts() => maxHp() / 4

// $B7A9C4: Stamina [32-bit BE]
function stamina() => dword_be(0xB7A9C4)

function areaIdAddr() => 0x005b51e0
function areaId() => dword_be(areaIdAddr())
function topAreaByte() => byte(areaIdAddr())

function lightingState() => byte(0x00593941)

function dialogueIdAddr() => 0x005a88f4

areas = {
0x46303031: { "name": "Knight Academy", "internalName": "", },0x46303039: { "name": "Sparring Hall", "internalName": "", },0x46303030: { "name": "Skyloft", "internalName": "", },0x44303030: { "name": "Waterfall", "internalName": "", },0x46303230: { "name": "The Sky", "internalName": "", },0x46303038: { "name": "Chamber of the Sword", "internalName": "", },0x46303231: { "name": "Sealed Grounds", "internalName": "", },0x46343031: { "name": "Sealed Grounds", "internalName": "SealedGroundsCutscene", },0x46343032: { "name": "Sealed Temple", "internalName": "", },0x46343030: { "name": "Sealed Grounds", "internalName": "BehindTheTemple", },0x46313030: { "name": "Faron Woods", "internalName": "FaronWoods", },0x46313031: { "name": "Deep Woods", "internalName": "", },0x44313030: { "name": "Skyview Temple", "internalName": "SkyviewTemple", },0x42313030: { "name": "Skyview Temple", "internalName": "STBossRoom", },0x00313031: { "name": "Somewhere in the sky...", "internalName": "SaveAndQuitTransition", },0x46303032: { "name": "Beedle's Airshop", "internalName": "", },0x46323030: { "name": "Eldin Volcano", "internalName": "", },0x46323130: { "name": "Eldin Volcano", "internalName": "EldinVolcanoInterior", },0x46323131: { "name": "Eldin Volcano", "internalName": "EldinThrillDigger", },0x44323030: { "name": "Earth Temple", "internalName": "ETMain", },0x00323030: { "name": "Somewhere in the sky...", "internalName": "GameOverTransition", },0x42323030: { "name": "Earth Temple", "internalName": "ETBossRoom", },0x42323130: { "name": "Earth Spring", "internalName": "", },0x46333030: { "name": "Lanayru Desert", "internalName": "", },0x46303034: { "name": "Bazaar", "internalName": "", },0x44333030: { "name": "Lanayru Mining Facility", "internalName": "LMFMain", },0x42333030: { "name": "Lanayru Mining Facility", "internalName": "LMFBossRoom", },0x333030: { "name": "Somewhere in the sky...", "internalName": "SaveAndQuitTransition2", },0x46303037: { "name": "Piper's House", "internalName": "", },0x46303138: { "name": "Peatrice's House", "internalName": "", },0x46303036: { "name": "Kukiel's House", "internalName": "", },0x46303134: { "name": "Bertie's House", "internalName": "", },0x46303135: { "name": "Gondo's House", "internalName": "", },0x46303133: { "name": "Sparrot's House", "internalName": "", },0x46303233: { "name": "Inside the Thunderhead", "internalName": "", },0x46303130: { "name": "Isle of Songs", "internalName": "", },0x53313030: { "name": "Farore's Silent Realm", "internalName": "FaroreSilentRealm", },0x46313032: { "name": "Lake Floria", "internalName": "", },0x44313031: { "name": "Ancient Cistern", "internalName": "ACMain", },0x42313031: { "name": "Ancient Cistern", "internalName": "ACBossRoom", },0x53333030: { "name": "Nayru's Silent Realm", "internalName": "NayruSilentRealm", },0x46333033: { "name": "Lanayru Caves", "internalName": "", },0x46333031: { "name": "Lanayru Sand Sea", "internalName": "", },0x44333031: { "name": "Sandship", "internalName": "SMain", },
}

rpLookup = {}
    
for id in areas
{
    rpLookup[id] = areas[id]["name"]
}

function WasTransitioningFromSaveOrQuit() => prior(topAreaByte()) == 0

function FileIsLoading() => IsInAreaByName("Skyloft") && (lightingState() == 0xc || lightingState() == 0x4)
function UnlessSavingAndQuitting() => disable_when(WasTransitioningFromSaveOrQuit() && IsInAreaByName("Skyloft"), until = repeated(300, IsInAreaByName("Skyloft")))
    && never(Delta(areaId()) != areaId())

function WasValueJustChanged(mem, oldValue, newValue)
{
    return Delta(mem) == oldValue && mem == newValue && UnlessSavingAndQuitting() // todo: UnlessSavingAndQuitting() needs to be moved to WasValueChangedInGame() once the RATools bug is fixed.
}

function WasValueJustChangedInGame(mem, oldValue, newValue)
{
    return WasValueJustChanged(mem, oldValue, newValue) && !FileIsLoading()
}

function WasBitflagJustSet(mem)
{
    return WasValueJustChanged(mem, 0, 1)
}

function WasBitflagJustSetInGame(mem)
{
    return WasBitflagJustSet(mem) && !FileIsLoading()
}

function IsInArea(id) => areaId() == id
function IsInAreaByName(name)
{
    for id in areas
    {
        if (rpLookup[id] == name)
        {
            return areaId() == id
        }
    }
}

function IsInAreaByInternalName(name)
{
    for id in areas
    {
        if (areas[id]["internalName"] == name)
        {
            return areaId() == id
        }
    }
}

function WasInAreaByInternalName(name)
{
    for id in areas
    {
        if (areas[id]["internalName"] == name)
        {
            return prior(areaId()) == id
        }
    }
}

function WasJustInAreaByInternalName(name)
{
    for id in areas
    {
        if (areas[id]["internalName"] == name)
        {
            return Delta(areaId()) == id
        }
    }
}

function sessionPlayTime() => dword_be(0x00577e50) / 600
rich_presence_conditional_display(IsInArea(areaId()), "{0} • {1} ❤️ • Session time: {2}",
    rich_presence_lookup("Locations", areaId(), rpLookup, "Somewhere in the sky..."),
    rich_presence_value("Hearts", Hearts()),
    rich_presence_value("Session", sessionPlayTime(), "SECS")
)

//rich_presence_conditional_display(IsOnTitleScreen(), "On the title screen...")
//rich_presence_conditional_display(IsSelectingFile(), "Selecting a file...")
rich_presence_display("Somewhere in the sky...")

achievement(title = "My Body Is Ready", description = "Obtain the Training Sword.", points = 3, type = "progression",
    trigger = IsInAreaByName("Sparring Hall") && WasValueJustChangedInGame(equippedSword(), 0, 1)
)

function descentToTheSurfaceForTheFirstTime() => bit4(0x00955d94)
achievement(title = "To Forgotten Lands", description = "Descend to the surface for the first time.", points = 3, type = "progression",
    trigger = IsInAreaByName("The Sky") && WasBitflagJustSetInGame(descentToTheSurfaceForTheFirstTime())
)

function slingshot() => bit4(0x00955e4a)
achievement(title = "Less Lethal", description = "Obtain the Slingshot.", points = 3, type = "progression",
    trigger = WasBitflagJustSetInGame(slingshot())
)

function animationId() => word_be(0x00b76966)
function JustClankedGivenNumberOfTimes(times)
{
    clankIds = [
        0xc0,
        0xc2,
        0xc4,
        0xc6,
        0xc8,
        0xca,
        0xcc,
        0xce,
        0xd0,
        0xd2
    ]
    
    triggers = []
    
    for id in clankIds
    {
        array_push(triggers, Delta(animationId()) != id && animationId() == id)
    }
    
    return tally(times, triggers)
}

function JustUsedSpinAttack()
{
    spinIds = [
        0x4f, // Horizontal, counterclockwise
        0x50, // Horizontal, clockwise
        0x51, // Vertical, downward
        0x52, // Vertical, upward
    ]
    
    trigger = always_false()
    
    for id in spinIds
    {
        trigger = trigger || Delta(animationId()) != id && animationId() == id
    }
    
    return trigger
}

function JustSwungSword()
{
    ids = [
        0xbf, // top-right -> bottom-left
        0xc1, // top -> bottom
        0xc3, // top-left -> bottom-right
        0xc5, // left -> right
        0xc7, // bottom -> top
        0xc9, // bottom-right -> top-left
        0xcb, // right -> left
        0xcf // bottom-left -> top-right
    ]
    
    trigger = always_false()
    
    for id in ids
    {
        trigger = trigger || Delta(animationId()) != id && animationId() == id
    }
    
    return trigger || JustUsedSpinAttack()
}

function beetleChestAppeared() => bit6(0x00956f78)
function beetle() => bit5(0x00955e4a)
function xCoordinate() => float_be(0x005a28b8)
function yCoordinate() => float_be(0x005a28bc)
function zCoordinate() => float_be(0x005a28c0)
function BattleCheckpointStarted(when, neverWhen = always_false()) => once(when) && never(hp() <= 0) && never(neverWhen)
achievement(title = "Deft Strikes", type = "missable", points = 5,
    description = "Defeat the Stalfos in the Skyview Temple without clashing more than three times and without using Spin Attacks (no resurrections).",
    trigger = BattleCheckpointStarted(xCoordinate() == 0.0 && yCoordinate() == -60.0 && zCoordinate() == -7765.0 && Delta(animationId()) == 0x12d && animationId() == 0x12,
        neverWhen = !IsInAreaByInternalName("SkyviewTemple"))
        && trigger_when(beetleChestAppeared() == 1)
        && never(beetle() == 1)
        && never(JustClankedGivenNumberOfTimes(4))
        && never(lightingState() != 6)
        && never(JustUsedSpinAttack())
)

achievement(title = "Droning On", description = "Obtain the Beetle.", points = 3, type = "progression",
    trigger = WasBitflagJustSetInGame(beetle())
)

function fieldPointer() => dword_be(0x00ec936c)
function ghirahimIHp() => word_be(0x00b68122)
function activeKunai() => word_be(fieldPointer() - 0x80000000 + 0x29c)
function ghirahimIXCoord() => float_be(0x00b65008)
function ghirahimIZCoord() => float_be(0x00b65010)
function actualXCoord() => float_be(0x00b747c4)
function actualZCoord() => float_be(0x00b747cc)
function GhirahimIBattleCheckpointReached() => BattleCheckpointStarted(xCoordinate() == 0.0 && yCoordinate() == 150.0 && zCoordinate() == -1100.0 && prior(animationId()) == 0xffff
    && animationId() == 0x12,
    neverWhen = !IsInAreaByInternalName("STBossRoom"))
function GhirahimIBattleTriggered() => trigger_when(Delta(activeKunai()) > activeKunai())
        && trigger_when(ghirahimIHp() <= 0 && prior(ghirahimIHp()) > 0)
        && never(repeated(5, GhirahimIBattleCheckpointReached() && ghirahimIHp() == 0)) // His HP drops to zero a frame before his kunai actually disappear from hitting him, so there needs to be
        // a delay to make sure that stray kunai disappearing don't trigger the achievement. And since his HP is at 0 for three frames before the fight starts, we set this to 4 to prevent
        // the achievement from being reset prematurely.
// Limitation: This triggers when his kunai disappear, not just when he's defeated with them. However, the odds of a player finishing him off on the frame that any stray kunai disappear
// are low. But if this ever does become an issue, we can update the description to specify to defeat him right as his kunai disappear, though it'll be a far less elegant description.
achievement(title = "Like a Monk", type = "missable", points = 10,
    description = "Finish off Ghirahim in Skyview Temple with projectiles (no resurrections).",
    trigger = GhirahimIBattleCheckpointReached()
        && GhirahimIBattleTriggered()
        && never(hp() <= 0)
)

leaderboard(title = "Ghirahim I HP Remaining", description = "This leaderboard is for informative purposes only.",
    start = GhirahimIBattleCheckpointReached(),
    cancel = GhirahimIBattleTriggered(),
    submit = always_false(),
    value = ghirahimIHp()
)

function rubyTablet() => bit2(0x00955e5a)
achievement(title = "Skyview Prayers", type = "progression", description = "Obtain the Ruby Tablet.", points = 3,
    trigger = WasBitflagJustSetInGame(rubyTablet())
)

achievement(title = "Heartthrob", description = "Have a total of 20 hearts' worth of life energy.", points = 10,
    trigger = measured(maxHp() == 80, format = "percent") && Delta(maxHp() == 76) && WasValueJustChangedInGame(maxHp(), 76, 80)
)

achievement(title = "Defenestration Shopping", description = "Leave Beedle's Airshop without buying anything.", points = 1,
    trigger = once(ascii_string_equals(dialogueIdAddr(), "TERY_09", 8))
        && once(ascii_string_equals(dialogueIdAddr(), "TERY_10", 8))
        && IsInAreaByName("Skyloft")
)

function bugNet() => bit0(0x00955e4c)
achievement(title = "Swoosh", description = "Purchase the Bug Net.", points = 3,
    trigger = WasBitflagJustSetInGame(bugNet())
)

function moleMitts() => bit6(0x00955e4a)
achievement(title = "Honorary Mole Man", description = "Obtain the Mole Mitts.", points = 3, type = "progression",
    trigger = WasBitflagJustSetInGame(moleMitts())
)

function numberOfPouchUpgrades() => (byte(0x00955eb4) & 0x1c) / 4
achievement(title = "For Every Occasion", description = "Acquire all four Adventure Pouch upgrades.", points = 10,
    trigger = WasValueJustChangedInGame(numberOfPouchUpgrades(), 3, 4)
        && measured(numberOfPouchUpgrades() == 4)
)

achievement(title = "I.O.U.", description = "Pick up a Rupoor.", points = 1,
    trigger = ascii_string_equals(dialogueIdAddr(), "ITEM_034", 9)
        && IsInAreaByInternalName("EldinThrillDigger")
)

function rupees() => word_be(0x00955ec2)
function thrillDiggerRupeeValueCollected() => dword_be(0x00b6c5cc)
function thrillDiggerRupeesCollected() => byte(0x00b6ffda)
function thrillDiggerTotalCollectableRupees() => byte(0x00b6ffdb)
function thrillDiggerUnpickedBombFlowers() => byte(0x00b6ffdc)
function ThrillDiggerStarted() => once(thrillDiggerRupeesCollected() == 0 && Delta(thrillDiggerTotalCollectableRupees()) != thrillDiggerTotalCollectableRupees())
function ThrillDiggerJustRevealedBoard() => Delta(thrillDiggerUnpickedBombFlowers()) == 0 && thrillDiggerUnpickedBombFlowers() > 0
function ThrillDiggerJustEnded() => Delta(thrillDiggerUnpickedBombFlowers()) > 0 && thrillDiggerUnpickedBombFlowers() == 0
function ThrillDiggerChoseBeginner() => once(Delta(rupees()) - rupees() == 30)
function ThrillDiggerChoseIntermediate() => once(Delta(rupees()) - rupees() == 50)
function ThrillDiggerChoseExpert() => once(Delta(rupees()) - rupees() == 70)
achievement(title = "Greenbeard", description = "Win a game of Thrill Digger on Beginner difficulty.", points = 3,
    trigger = ThrillDiggerStarted() && trigger_when(ThrillDiggerJustRevealedBoard() && thrillDiggerRupeesCollected() == thrillDiggerTotalCollectableRupees())
        && ThrillDiggerChoseBeginner()
        && never(ThrillDiggerJustEnded())
)

achievement(title = "Longbeard", description = "Win a game of Thrill Digger on Intermediate difficulty.", points = 5,
    trigger = ThrillDiggerStarted() && trigger_when(ThrillDiggerJustRevealedBoard() && thrillDiggerRupeesCollected() == thrillDiggerTotalCollectableRupees())
        && ThrillDiggerChoseIntermediate()
        && never(ThrillDiggerJustEnded())
)

achievement(title = "Lord of the Deep", description = "Win a game of Thrill Digger on Expert difficulty.", points = 10,
    trigger = ThrillDiggerStarted() && trigger_when(ThrillDiggerJustRevealedBoard() && thrillDiggerRupeesCollected() == thrillDiggerTotalCollectableRupees())
        && ThrillDiggerChoseExpert()
        && never(ThrillDiggerJustEnded())
)

function bombBag() => bit2(0x00955e51)
achievement(title = "One Errant Twitch...", description = "Obtain the Bomb Bag.", points = 3, type = "progression",
    trigger = WasBitflagJustSetInGame(bombBag())
)

function dragonSculpture() => bit7(0x00956fab)
function boulderComplete() => bit7(0x00956fa8)
// A "false start" in this case simply means sprinting before the cutscene starts. It's difficult to distinguish between cutscene recovery or Stamina Fruit recovery because both
// fully recover stamina. Therefore, we need the player to jog normally up to the "starting line," so to speak.
achievement(title = "Pace Yourself", description = "Escape the rolling boulder in the Earth Temple without recovering stamina with Stamina Fruit (no resurrections; no false starts).", points = 3,
    type = "missable",
    trigger = once(dragonSculpture() == 1 && Delta(dragonSculpture()) == 0 && IsInAreaByInternalName("ETMain"))
        && trigger_when(boulderComplete() == 1)
        && never(hp() <= 0)
        && never(stamina() > Delta(stamina()) + 12000)
)

function ScalderaBattleCheckpointReached() => BattleCheckpointStarted(WasJustInAreaByInternalName("ETMain") && IsInAreaByInternalName("ETBossRoom"),
    neverWhen = !IsInAreaByInternalName("ETBossRoom"))
function scalderaHp() => byte(0x00b4dc63)
function bombsInBombBag() => byte(0x00955ec6) * 2 + bit7(0x00955ec7)
// This achievement can be done in as few as five bombs, perhaps fewer. However, hitting Scaldera's weak point can be quite finicky, and it's randomly predetermined what parts of its shell
// will break off first, limiting predictability. May want to consider increasing the point value to 25 to make up for the considerable iteration time, too.
achievement(title = "Handle with Care", type = "missable", description = "Defeat Scaldera without pulling more than six bombs out of your Bomb Bag (no resurrections).", points = 10,
    trigger = ScalderaBattleCheckpointReached()
        && trigger_when(scalderaHp() <= 0 && Delta(scalderaHp()) > 0)
        && never(repeated(7, bombsInBombBag() < Delta(bombsInBombBag())))
)

function amberTablet() => bit3(0x00955e5a)
achievement(title = "Earth Prayers", type = "progression", description = "Obtain the Amber Tablet.", points = 3,
    trigger = WasBitflagJustSetInGame(amberTablet())
)

function extraWalletsObtained() => byte(0x00955ec6) / 64
achievement(title = "I Don't NEED Credit", description = "Obtain a wallet maximum of 9,900 Rupees.", points = 5,
    trigger = always_false()
)

function hookBeetle() => bit1(0x00955e4f)
achievement(title = "Death from Above", type = "progression", description = "Upgrade the Beetle into the Hook Beetle.", points = 3,
    trigger = WasBitflagJustSetInGame(hookBeetle())
)

function gustBellows() => bit1(0x00955e4a)
achievement(title = "Wonderful Rush", type = "progression", description = "Obtain the Gust Bellows.", points = 3,
    trigger = WasBitflagJustSetInGame(gustBellows())
)

function shieldSlotIndex() => byte(0x0095a815)
function ShieldIsEquipped() => shieldSlotIndex() != 8
function moldarachHp() => byte(0x00b6d9e5)
achievement(title = "Fleet-footed", description = "Defeat Moldarach in the Lanayru Mining Facility without having a shield equipped and without recovering life energy.", points = 5,
    type = "missable",
    trigger = BattleCheckpointStarted(WasJustInAreaByInternalName("LMFMain") && IsInAreaByInternalName("LMFBossRoom"),
    neverWhen = !IsInAreaByInternalName("LMFBossRoom"))
        && never(Delta(hp()) < hp())
        && never(ShieldIsEquipped())
        && trigger_when(moldarachHp() <= 0 && Delta(moldarachHp()) > 0)
)

function goddessHarp() => bit1(0x00955e58)
achievement(title = "In Harmonia", type = "progression", description = "Obtain the Goddess's Harp.", points = 3,
    trigger = WasBitflagJustSetInGame(goddessHarp())
)

function balladOfTheGoddess() => bit5(0x00955e5f)
achievement(title = "Canon Cancrizans", description = "Learn the Ballad of the Goddess.", points = 3, type = "progression",
    trigger = WasBitflagJustSetInGame(balladOfTheGoddess())
)

function playerSealPromptI() => bit1(0x00956f6b)
function imprisonedBaseAddr() => 0x00b19b65
function imprisonedIHp() => byte(imprisonedBaseAddr())

function ImprisonedToeWasJustAttacked()
{
    trigger = always_false()
    for i in range(1, 8)
    {
        toeHp = byte(imprisonedBaseAddr() + 12 * i)
        trigger = trigger || Delta(toeHp) > toeHp
    }
    
    return trigger
}

function ImprisonedICheckpointReached() => BattleCheckpointStarted(once(ascii_string_equals(dialogueIdAddr(), "CF_05", 6))
    && once(ascii_string_equals(dialogueIdAddr(), "CF_05", 6))
    && IsInAreaByInternalName("SealedGroundsCutscene"), neverWhen = !IsInAreaByInternalName("SealedGroundsCutscene")
        || ascii_string_equals(dialogueIdAddr(), "CF_47", 6)) // Nonstandard game over dialogue
achievement(title = "What Am I, A Podiatrist?", description = "Defeat the Imprisoned I without attacking its toes (no resurrections).", points = 5, type = "missable",
    trigger = ImprisonedICheckpointReached() && never(playerSealPromptI() == 1)
        && never(ImprisonedToeWasJustAttacked())
        && trigger_when(imprisonedIHp() == 0 && Delta(imprisonedIHp()) == 1)
)

function faroresCourage() => bit6(0x00955e5f)
achievement(title = "The Melody of Valor", description = "Learn Farore's Courage.", type = "progression", points = 3,
    trigger = WasBitflagJustSetInGame(faroresCourage())
)

function tearsCollected() => byte(0x0097bbb3)
function silentRealmTimeRemaining() => dword_be(0x0097b46c)
function SilentRealmFrameElapsed() => silentRealmTimeRemaining() < Delta(silentRealmTimeRemaining())
function SilentRealmFramesElapsed30FPS() => tally(0, [ SilentRealmFrameElapsed(), SilentRealmFrameElapsed() ])
function faroreWiltlessTimeLimit() => 45
function TearsWereReset() => Delta(tearsCollected()) > 0 && tearsCollected() == 0
function SilentRealmCompleted() => tearsCollected() == 15 && (Delta(silentRealmTimeRemaining()) == 0 || Delta(silentRealmTimeRemaining()) == 91000) && silentRealmTimeRemaining() == 1000
function LeftFaroresSilentRealm() => !IsInAreaByInternalName("FaroreSilentRealm")
function FaroresSilentRealmCheckpointReached() => once(Delta(tearsCollected()) == 0 && tearsCollected() == 1)
    && never(LeftFaroresSilentRealm())
    && disable_when(repeated(SecondsToFrames(faroreWiltlessTimeLimit()), SilentRealmFrameElapsed()), TearsWereReset())

leaderboard(title = "Wiltless Courage", description = "Complete Farore's Silent Realm while spending as little Spirit Vessel time as possible.",
    start = FaroresSilentRealmCheckpointReached() && never(LeftFaroresSilentRealm()),
    cancel = LeftFaroresSilentRealm(),
    submit = SilentRealmCompleted(),
    value = SilentRealmFramesElapsed30FPS() && never(TearsWereReset()),
    format = "FRAMES",
    lower_is_better = true
)

achievement(title = "Wiltless Courage", description = "Complete Farore's Silent Realm before a total of " + faroreWiltlessTimeLimit() + " seconds passes from your Spirit Vessel.", points = 25,
    trigger = FaroresSilentRealmCheckpointReached() && trigger_when(SilentRealmCompleted())
)

function waterDragonsScale() => bit5(0x00955e4d)
achievement(title = "Swimming Phenom", description = "Obtain the Water Dragon's Scale.", type = "progression", points = 3,
    trigger = WasBitflagJustSetInGame(waterDragonsScale())
)

function tripleStalfosVictory() => bit0(0x00956f87)
function TripleStalfosCheckpointReached() => BattleCheckpointStarted(xCoordinate() == 0.0 && yCoordinate() == 150.0 && zCoordinate() == -1600.0 && prior(animationId()) == 0x12d
    && animationId() == 0x12 && tripleStalfosVictory() == 0 && waterDragonsScale() == 1,
    neverWhen = !IsInAreaByInternalName("STBossRoom"))
achievement(title = "Respect for the Undead", type = "missable", points = 5,
    description = "Defeat the Stalfos trio in the Skyview Temple without pulling out a bomb (no resurrections).",
    trigger = TripleStalfosCheckpointReached()
        && trigger_when(WasBitflagJustSet(tripleStalfosVictory()))
        && never(bombsInBombBag() < Delta(bombsInBombBag()))
)

function CreateChain(permutation, predicate = a => a)
{
    trigger = always_true()
    
    for condition in permutation
    {
        trigger = predicate(trigger && condition)
    }
    
    return trigger
}

function guardState() => byte(0x00b7689b)
function ShieldHitboxWasJustActive() => Delta(guardState()) == 0x49
function JustSuccessfullyParried() => ShieldHitboxWasJustActive() && guardState() != Delta(guardState()) && animationId() == 0xe1
function JustUsedAttack(id) => animationId() == id && Delta(animationId()) != animationId()
function always_truthy() => byte(0) == 0x53

neverUsedAttackTrigger = always_false()
attackIds = [
    0xbf, // top-right -> bottom-left
    0xc1, // top -> bottom
    0xc3, // top-left -> bottom-right
    0xc5, // left -> right
    0xc7, // bottom -> top
    0xc9, // bottom-right -> top-left
    0xcb, // right -> left
    0xcf, // bottom-left -> top-right
    0x4f, // Horizontal, counterclockwise
    0x50, // Horizontal, clockwise
    0x51, // Vertical, downward
    0x52, // Vertical, upward
    0xd1 // Stab
]

for id in attackIds
{
    neverUsedAttackTrigger = neverUsedAttackTrigger || never(CreateChain([ repeated(90, always_truthy() && never(JustSuccessfullyParried())), JustUsedAttack(id), always_true() ]))
}

function stalmasterVictoryAncientCistern() => bit1(0x00956f94)
achievement(title = "Stunlocked in Combat", points = 10,
    description = "Defeat the Stalmaster in the Ancient Cistern using only follow-up attacks within three seconds of a parry (no resurrections).", type = "missable",
    trigger = BattleCheckpointStarted(xCoordinate() == 0.0 && yCoordinate() == -2250.0 && zCoordinate() == 350.0 && prior(animationId()) == 0x12d
            && animationId() == 0x12 && stalmasterVictoryAncientCistern() == 0,
            neverWhen = !IsInAreaByInternalName("ACMain"))
        && trigger_when(stalmasterVictoryAncientCistern() == 1)
        && neverUsedAttackTrigger
)

function whip() => bit4(0x00955e57)
achievement(title = "You Can Whip It!", description = "Obtain the Whip.", type = "progression", points = 3,
    trigger = WasBitflagJustSetInGame(whip())
)

function koloktosVictory() => bit4(0x00956f90)
function JustUsedTheWhip()
{
    trigger = always_false()
    drawIds = [
        0xf7,
        0xf8, // From top
        0xf9, // From top-left
        0xfa, // From left
        0xfb, // From bottom
        0xfc,
        0xfd
    ]
    
    for id in drawIds
    {
        trigger = trigger || Delta(animationId()) == id && animationId() != Delta(animationId())
    }
    
    return trigger
}

achievement(title = "Getting Right to the Stabbing", type = "missable", description = "Defeat Koloktos without whipping more than eight times (no resurrections).", points = 5,
    trigger = BattleCheckpointStarted(xCoordinate() == 0.0 && yCoordinate() == 150.0 && zCoordinate() == 850.0 && prior(animationId()) == 0x26
            && animationId() == 0x12 && koloktosVictory() == 0,
            neverWhen = !IsInAreaByInternalName("ACBossRoom"))
        && trigger_when(koloktosVictory() == 1)
        && never(repeated(9, JustUsedTheWhip()))
)

function goddessLongsword() => bit1(0x00955e48)
achievement(title = "Towards Mastery", type = "progression", points = 3, description = "Forge the Goddess Longsword.",
    trigger = WasBitflagJustSetInGame(goddessLongsword())
)

function nayrusWisdom() => bit7(0x00955e5f)
achievement(title = "The Melody of Percipience", description = "Learn Nayru's Wisdom.", type = "progression", points = 3,
    trigger = WasBitflagJustSetInGame(nayrusWisdom())
)

// My record: 1:42.50
function LeftNayrusSilentRealm() => !IsInAreaByInternalName("NayruSilentRealm")
function nayruWiltlessTimeLimit() => 110
function NayrusSilentRealmCheckpointReached() => once(Delta(tearsCollected()) == 0 && tearsCollected() == 1)
    && never(LeftNayrusSilentRealm())
    && disable_when(repeated(SecondsToFrames(nayruWiltlessTimeLimit()), SilentRealmFrameElapsed()), TearsWereReset())

leaderboard(title = "Wiltless Wisdom", description = "Complete Nayru's Silent Realm while spending as little Spirit Vessel time as possible.",
    start = NayrusSilentRealmCheckpointReached() && never(LeftNayrusSilentRealm()),
    cancel = LeftNayrusSilentRealm(),
    submit = SilentRealmCompleted(),
    value = SilentRealmFramesElapsed30FPS() && never(TearsWereReset()),
    format = "FRAMES",
    lower_is_better = true
)

achievement(title = "Wiltless Wisdom", description = "Complete Nayru's Silent Realm before a total of " + SecondsToFormat(nayruWiltlessTimeLimit())
    + " passes from your Spirit Vessel.", points = 25,
    trigger = NayrusSilentRealmCheckpointReached() && trigger_when(SilentRealmCompleted())
)

function clawshots() => bit5(0x00955e48)
achievement(title = "Skulltula-Man", description = "Obtain the Clawshots.", type = "progression", points = 3,
    trigger = WasBitflagJustSetInGame(clawshots())
)

function scervoVictory() => bit1(0x00956fef)
achievement(title = "Three Strikes, And...", description = "Defeat LD-002G Scervo without getting hit more than twice (no resurrections).", type = "missable", points = 10,
    trigger = BattleCheckpointStarted(prior(animationId()) == 0x10c && animationId() == 0x26 && scervoVictory() == 0,
            neverWhen = !IsInAreaByInternalName("SMain"))
        && trigger_when(WasBitflagJustSet(scervoVictory()))
        && never(repeated(3, Delta(hp()) > hp()))
)

function bow() => bit4(0x00955e48)
achievement(title = "Piercer", description = "Obtain the Bow.", type = "progression", points = 3,
    trigger = WasBitflagJustSetInGame(bow())
)

function dinsPower() => bit0(0x00955e5e)
achievement(title = "The Melody of Might", description = "Learn Din's Power.", type = "progression", points = 3,
    trigger = WasBitflagJustSetInGame(dinsPower())
)

function songOfTheHero() => bit4(0x00955e5e)
achievement(title = "The Melody of Legend", description = "Learn the Song of the Hero.", type = "progression", points = 3,
    trigger = WasBitflagJustSetInGame(songOfTheHero())
)
