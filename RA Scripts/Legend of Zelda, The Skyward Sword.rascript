// The Legend of Zelda: Skyward Sword
// #ID = 202

// $955E56: Sword [8-bit]
//          
//          0x01 = Practice Sword
function equippedSword() => byte(0x955E56)

// $95A766: Current HP [16-bit BE]
//          
//          Every 4 = 1 heart container, maximum of 80.
function hp() => word_be(0x95A766)

// $95A768: Maximum HP [16-bit BE]
//          
//          Every 4 = 1 heart container, maximum of 80.
function maxHp() => word_be(0x95A768)

function Hearts() => maxHp() / 4

// $B7A9C4: Stamina [32-bit BE]
function stamina() => dword_be(0xB7A9C4)

function areaId() => dword_be(0x005b51e0)

areas = {
    0x46303031: { "name": "Knight Academy", },0x46303039: { "name": "Sparring Hall", },0x46303030: { "name": "Skyloft", },0x44303030: { "name": "Waterfall", },
}

rpLookup = {}
    
for id in areas
{
    rpLookup[id] = areas[id]["name"]
}

function Delta(mem) => prev(mem)

function WasValueJustChanged(mem, oldValue, newValue)
{
    return Delta(mem) == oldValue && mem == newValue
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

rich_presence_conditional_display(IsInArea(areaId()), "{0} • {1} ❤️",
    rich_presence_lookup("Locations", areaId(), rpLookup, "Somewhere in the sky..."),
    rich_presence_value("Hearts", Hearts())
)

//rich_presence_conditional_display(IsOnTitleScreen(), "On the title screen...")
//rich_presence_conditional_display(IsSelectingFile(), "Selecting a file...")
rich_presence_display("Somewhere in the sky...")

achievement(title = "My Body Is Ready", description = "Obtain the Training Sword.", points = 0,
    trigger = IsInAreaByName("Sparring Hall") && WasValueJustChanged(equippedSword(), 0, 1)
)
