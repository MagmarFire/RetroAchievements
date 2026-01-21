// The Legend of Zelda: Skyward Sword
// #ID = 202

// $955E56: Sword [8-bit]
//          
//          0x01 = Practice Sword
function equippedSword() => byte(0x955E56)

function hp() => word_be(0x0095a76a)
function maxHp() => word_be(0x0095a766)

function Hearts() => maxHp() / 4

// $B7A9C4: Stamina [32-bit BE]
function stamina() => dword_be(0xB7A9C4)

function areaId() => dword_be(0x005b51e0)

function lightingState() => byte(0x00593941)

function dialogueIdAddr() => 0x005a88f4

areas = {
0x46303031: { "name": "Knight Academy", "internalName": "", },0x46303039: { "name": "Sparring Hall", "internalName": "", },0x46303030: { "name": "Skyloft", "internalName": "", },0x44303030: { "name": "Waterfall", "internalName": "", },0x46303230: { "name": "The Sky", "internalName": "", },0x46303038: { "name": "Chamber of the Sword", "internalName": "", },0x46303231: { "name": "Sealed Grounds", "internalName": "", },0x46343031: { "name": "Sealed Grounds", "internalName": "SealedGroundsCutscene", },0x46343032: { "name": "Sealed Temple", "internalName": "", },0x46343030: { "name": "Sealed Grounds", "internalName": "BehindTheTemple", },0x46313030: { "name": "Faron Woods", "internalName": "", },0x46313031: { "name": "Deep Woods", "internalName": "", },0x44313030: { "name": "Skyview Temple", "internalName": "SkyviewTemple", },0x42313030: { "name": "Skyview Temple", "internalName": "STBossRoom", },0x00313031: { "name": "Somewhere in the sky...", "internalName": "SaveAndQuitTransition", },0x46303032: { "name": "Beedle's Airshop", "internalName": "", },0x46323030: { "name": "Eldin Volcano", "internalName": "", },0x46323130: { "name": "Eldin Volcano", "internalName": "EldinVolcanoInterior", },0x46323131: { "name": "Eldin Volcano", "internalName": "EldinThrillDigger", },0x44323030: { "name": "Earth Temple", "internalName": "ETMain", },0x00323030: { "name": "Somewhere in the sky...", "internalName": "GameOverTransition", },0x42323030: { "name": "Earth Temple", "internalName": "ETBossRoom", },0x42323130: { "name": "Earth Spring", "internalName": "", },0x46333030: { "name": "Lanayru Mine", "internalName": "", },
}

rpLookup = {}
    
for id in areas
{
    rpLookup[id] = areas[id]["name"]
}

function Delta(mem) => prev(mem)

function FileIsLoading() => IsInAreaByName("Skyloft") && (lightingState() == 0xc || lightingState() == 0x4)
function UnlessSavingAndQuitting() => disable_when(
    (WasInAreaByInternalName("SaveAndQuitTransition") || WasInAreaByInternalName("GameOverTransition")) && IsInAreaByName("Skyloft"), until = repeated(210, IsInAreaByName("Skyloft")))

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
    trigger = IsInAreaByName("Sparring Hall") && WasBitflagJustSetInGame(equippedSword())
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
achievement(title = "Handle with Care", type = "missable", description = "Defeat Scaldera without pulling out more than six bombs out of your Bomb Bag (no resurrections).", points = 10,
    trigger = ScalderaBattleCheckpointReached()
        && trigger_when(scalderaHp() <= 0 && Delta(scalderaHp()) > 0)
        && never(repeated(7, bombsInBombBag() < Delta(bombsInBombBag())))
)

function amberTablet() => bit3(0x00955e5a)
achievement(title = "Earth Prayers", type = "progression", description = "Obtain the Amber Tablet.", points = 3,
    trigger = WasBitflagJustSetInGame(amberTablet())
)