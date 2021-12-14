// Mega Man: The Power Battle
// #ID = 11794

// $8100: Game Mode
//        0x00 - Mega Man 1-2
//        0x02 - Mega Man 3-6
//        0x04 - Mega Man 7
function gameMode() => byte(0x008100)

// $8102: Stage
function stageId() => byte(0x008102)

// $8108: Boss
function bossId() => byte(0x008108)

// $8446: Equipped Weapon:
//        00 = Standard Buster
//        01 = Super Arm / Napalm Bomb / Scorch Whell
//        02 = Leaf Shield / Plant Barrier / Slash Claw
//        03 = Atomic Fire / Gyro Attack / Thunder Bolt
//        04 = Rolling Cutter / Magnet Missile / Noise Crush
//        05 = Ice Slasher / Gemini Laser / Freeze Cracker
//        06 = Crash Bomb / Dust Crasher / Junk Shield
function equippedWeapon() => byte(0x008446)

// $D850: Boss Life
function bossLifeAlt() => byte(0x00D850)

// $D851: FF = Boss Defeated (Alt)
function bossDefeatedAlt() => byte(0x00D851)

// $DA50: Boss Life
function bossLife() => byte(0x00DA50)

// $DA51: FF = Boss Defeated
function bossDefeatedAlt() => byte(0x00DA51)

// We need to check if the last value is 1 because only bats will have that much health.
// This does, however, mean that if the boss just so happens to have 1 HP and falls, the achievement won't trigger.
function BossLostAllLife(mem) => mem < prev(mem) && mem == 0 && prev(mem) != 1

achievement(
    title = "Eating the Pumpkin", description = "Defeat VAN Pookin using Thunder Bolt", points = 3,
    id = 65441, badge = "102676", published = "8/30/2018 4:59:13 PM", modified = "1/3/2020 4:27:57 PM",
    trigger = equippedWeapon() == 3 && stageId() == 12 && bossId() == 22 && gameMode() == 4 &&
              (bossDefeatedAlt() > prev(bossDefeatedAlt()) && bossDefeatedAlt() == 0xff ||
               BossLostAllLife(bossLife()) ||
               BossLostAllLife(bossLifeAlt()))
)
