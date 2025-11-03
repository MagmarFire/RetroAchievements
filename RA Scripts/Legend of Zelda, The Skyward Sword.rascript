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

function lightingState() => byte(0x00593941)

areas = {
0x46303031: { "name": "Knight Academy", },0x46303039: { "name": "Sparring Hall", },0x46303030: { "name": "Skyloft", },0x44303030: { "name": "Waterfall", },0x46303230: { "name": "The Sky", },0x46303038: { "name": "Chamber of the Sword", },0x46303231: { "name": "Sealed Grounds", },0x46343031: { "name": "Sealed Grounds", },0x46343032: { "name": "Sealed Temple", },0x46343030: { "name": "Sealed Grounds", },0x46313030: { "name": "Faron Woods", },0x46313031: { "name": "Deep Woods", },0x44313030: { "name": "Skyview Temple", },
}

rpLookup = {}
    
for id in areas
{
    rpLookup[id] = areas[id]["name"]
}

function Delta(mem) => prev(mem)

function FileIsLoading() => IsInAreaByName("Skyloft") && (lightingState() == 0xc || lightingState() == 0x4)

function WasValueJustChanged(mem, oldValue, newValue)
{
    return Delta(mem) == oldValue && mem == newValue
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

rich_presence_conditional_display(IsInArea(areaId()), "{0} • {1} ❤️",
    rich_presence_lookup("Locations", areaId(), rpLookup, "Somewhere in the sky..."),
    rich_presence_value("Hearts", Hearts())
)

//rich_presence_conditional_display(IsOnTitleScreen(), "On the title screen...")
//rich_presence_conditional_display(IsSelectingFile(), "Selecting a file...")
rich_presence_display("Somewhere in the sky...")

achievement(title = "My Body Is Ready", description = "Obtain the Training Sword.", points = 0, type = "progression",
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
