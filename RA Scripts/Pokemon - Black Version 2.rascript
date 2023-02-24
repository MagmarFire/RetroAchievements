// Pokemon - Black Version 2
// #ID = 5853

// $14111E: Party Slot 1
// $1418E4: Current Hour
// $1418E8: Current Minute
// $21D9E4: Items Pocket - Item 1
// $21D9E6: Items Pocket - Item 1 amnt
// $21E008: TM Pocket - Slot 1
// $21E00C: TM Pocket - Slot 2
// $2266E4: money (32bit)
// $23B474: Trainer ID
// $23B476: Secret Trainer ID
// $23B481: Gender
// $23B4F8: Season
//          0 = Spring
//          1 = Summer
//          2 = Autumn
//          3 = Winter
// $23E4EA: X Coord
// $23E4F2: Y Coord
// $24279E: Minutes played
// $24279F: Seconds played
// $2A3698: Opposing mon current HP

function Delta(mem) => prev(mem)

TRUE = 1
FALSE = 0

function Debug(string)
{
    achievement(title = string + "", description = "", points = 0, trigger = always_false())
}

function MergeArrays(arr1, arr2)
{
    ret = []
    for e1 in arr1
    {
        array_push(ret, e1)
    }
    
    for e2 in arr2
    {
        array_push(ret, e2)
    }
    
    return ret
}

function CreateHitTargetedAndNextChain(permutation)
{
    trigger = always_true()
    
    for condition in permutation
    {
        trigger = once(trigger && once(condition))
    }
    
    return trigger
}



function systemTimer() => dword(0x3ffc3c)
function FrameHasAdvanced() => Delta(systemTimer()) != systemTimer()
function SecondsToFrames(seconds) => seconds * 60

pokemon = {
1: { "number": 1, "address":  0x2269ec, "bit": 0, "name": "Bulbasaur", "obtainable": 0, "type1": "Grass", "type2": "Poison", },2: { "number": 2, "address":  0x2269ec, "bit": 1, "name": "Ivysaur", "obtainable": 0, "type1": "Grass", "type2": "Poison", },3: { "number": 3, "address":  0x2269ec, "bit": 2, "name": "Venusaur", "obtainable": 0, "type1": "Grass", "type2": "Poison", },4: { "number": 4, "address":  0x2269ec, "bit": 3, "name": "Charmander", "obtainable": 0, "type1": "Fire", "type2": "", },5: { "number": 5, "address":  0x2269ec, "bit": 4, "name": "Charmeleon", "obtainable": 0, "type1": "Fire", "type2": "", },6: { "number": 6, "address":  0x2269ec, "bit": 5, "name": "Charizard", "obtainable": 0, "type1": "Fire", "type2": "Flying", },7: { "number": 7, "address":  0x2269ec, "bit": 6, "name": "Squirtle", "obtainable": 0, "type1": "Water", "type2": "", },8: { "number": 8, "address":  0x2269ec, "bit": 7, "name": "Wartortle", "obtainable": 0, "type1": "Water", "type2": "", },9: { "number": 9, "address":  0x2269ed, "bit": 0, "name": "Blastoise", "obtainable": 0, "type1": "Water", "type2": "", },10: { "number": 10, "address":  0x2269ed, "bit": 1, "name": "Caterpie", "obtainable": 0, "type1": "Bug", "type2": "", },11: { "number": 11, "address":  0x2269ed, "bit": 2, "name": "Metapod", "obtainable": 0, "type1": "Bug", "type2": "", },12: { "number": 12, "address":  0x2269ed, "bit": 3, "name": "Butterfree", "obtainable": 0, "type1": "Bug", "type2": "Flying", },13: { "number": 13, "address":  0x2269ed, "bit": 4, "name": "Weedle", "obtainable": 1, "type1": "Bug", "type2": "Poison", },14: { "number": 14, "address":  0x2269ed, "bit": 5, "name": "Kakuna", "obtainable": 1, "type1": "Bug", "type2": "Poison", },15: { "number": 15, "address":  0x2269ed, "bit": 6, "name": "Beedrill", "obtainable": 1, "type1": "Bug", "type2": "Poison", },16: { "number": 16, "address":  0x2269ed, "bit": 7, "name": "Pidgey", "obtainable": 0, "type1": "Normal", "type2": "Flying", },17: { "number": 17, "address":  0x2269ee, "bit": 0, "name": "Pidgeotto", "obtainable": 0, "type1": "Normal", "type2": "Flying", },18: { "number": 18, "address":  0x2269ee, "bit": 1, "name": "Pidgeot", "obtainable": 0, "type1": "Normal", "type2": "Flying", },19: { "number": 19, "address":  0x2269ee, "bit": 2, "name": "Rattata", "obtainable": 1, "type1": "Normal", "type2": "", },20: { "number": 20, "address":  0x2269ee, "bit": 3, "name": "Raticate", "obtainable": 1, "type1": "Normal", "type2": "", },21: { "number": 21, "address":  0x2269ee, "bit": 4, "name": "Spearow", "obtainable": 1, "type1": "Normal", "type2": "Flying", },22: { "number": 22, "address":  0x2269ee, "bit": 5, "name": "Fearow", "obtainable": 1, "type1": "Normal", "type2": "Flying", },23: { "number": 23, "address":  0x2269ee, "bit": 6, "name": "Ekans", "obtainable": 0, "type1": "Poison", "type2": "", },24: { "number": 24, "address":  0x2269ee, "bit": 7, "name": "Arbok", "obtainable": 0, "type1": "Poison", "type2": "", },25: { "number": 25, "address":  0x2269ef, "bit": 0, "name": "Pikachu", "obtainable": 0, "type1": "Electric", "type2": "", },26: { "number": 26, "address":  0x2269ef, "bit": 1, "name": "Raichu", "obtainable": 0, "type1": "Electric", "type2": "", },27: { "number": 27, "address":  0x2269ef, "bit": 2, "name": "Sandshrew", "obtainable": 1, "type1": "Ground", "type2": "", },28: { "number": 28, "address":  0x2269ef, "bit": 3, "name": "Sandslash", "obtainable": 1, "type1": "Ground", "type2": "", },29: { "number": 29, "address":  0x2269ef, "bit": 4, "name": "Nidoran", "obtainable": 1, "type1": "Poison", "type2": "", },30: { "number": 30, "address":  0x2269ef, "bit": 5, "name": "Nidorina", "obtainable": 1, "type1": "Poison", "type2": "", },31: { "number": 31, "address":  0x2269ef, "bit": 6, "name": "Nidoqueen", "obtainable": 1, "type1": "Poison", "type2": "Ground", },32: { "number": 32, "address":  0x2269ef, "bit": 7, "name": "Nidoran", "obtainable": 1, "type1": "Poison", "type2": "", },33: { "number": 33, "address":  0x2269f0, "bit": 0, "name": "Nidorino", "obtainable": 1, "type1": "Poison", "type2": "", },34: { "number": 34, "address":  0x2269f0, "bit": 1, "name": "Nidoking", "obtainable": 1, "type1": "Poison", "type2": "Ground", },35: { "number": 35, "address":  0x2269f0, "bit": 2, "name": "Clefairy", "obtainable": 1, "type1": "Normal", "type2": "", },36: { "number": 36, "address":  0x2269f0, "bit": 3, "name": "Clefable", "obtainable": 1, "type1": "Normal", "type2": "", },37: { "number": 37, "address":  0x2269f0, "bit": 4, "name": "Vulpix", "obtainable": 1, "type1": "Fire", "type2": "", },38: { "number": 38, "address":  0x2269f0, "bit": 5, "name": "Ninetales", "obtainable": 1, "type1": "Fire", "type2": "", },39: { "number": 39, "address":  0x2269f0, "bit": 6, "name": "Jigglypuff", "obtainable": 1, "type1": "Normal", "type2": "", },40: { "number": 40, "address":  0x2269f0, "bit": 7, "name": "Wigglytuff", "obtainable": 1, "type1": "Normal", "type2": "", },41: { "number": 41, "address":  0x2269f1, "bit": 0, "name": "Zubat", "obtainable": 1, "type1": "Poison", "type2": "Flying", },42: { "number": 42, "address":  0x2269f1, "bit": 1, "name": "Golbat", "obtainable": 1, "type1": "Poison", "type2": "Flying", },43: { "number": 43, "address":  0x2269f1, "bit": 2, "name": "Oddish", "obtainable": 0, "type1": "Grass", "type2": "Poison", },44: { "number": 44, "address":  0x2269f1, "bit": 3, "name": "Gloom", "obtainable": 0, "type1": "Grass", "type2": "Poison", },45: { "number": 45, "address":  0x2269f1, "bit": 4, "name": "Vileplume", "obtainable": 0, "type1": "Grass", "type2": "Poison", },46: { "number": 46, "address":  0x2269f1, "bit": 5, "name": "Paras", "obtainable": 0, "type1": "Bug", "type2": "Grass", },47: { "number": 47, "address":  0x2269f1, "bit": 6, "name": "Parasect", "obtainable": 0, "type1": "Bug", "type2": "Grass", },48: { "number": 48, "address":  0x2269f1, "bit": 7, "name": "Venonat", "obtainable": 1, "type1": "Bug", "type2": "Poison", },49: { "number": 49, "address":  0x2269f2, "bit": 0, "name": "Venomoth", "obtainable": 1, "type1": "Bug", "type2": "Poison", },50: { "number": 50, "address":  0x2269f2, "bit": 1, "name": "Diglett", "obtainable": 0, "type1": "Ground", "type2": "", },51: { "number": 51, "address":  0x2269f2, "bit": 2, "name": "Dugtrio", "obtainable": 0, "type1": "Ground", "type2": "", },52: { "number": 52, "address":  0x2269f2, "bit": 3, "name": "Meowth", "obtainable": 1, "type1": "Normal", "type2": "", },53: { "number": 53, "address":  0x2269f2, "bit": 4, "name": "Persian", "obtainable": 1, "type1": "Normal", "type2": "", },54: { "number": 54, "address":  0x2269f2, "bit": 5, "name": "Psyduck", "obtainable": 1, "type1": "Water", "type2": "", },55: { "number": 55, "address":  0x2269f2, "bit": 6, "name": "Golduck", "obtainable": 1, "type1": "Water", "type2": "", },56: { "number": 56, "address":  0x2269f2, "bit": 7, "name": "Mankey", "obtainable": 1, "type1": "Fighting", "type2": "", },57: { "number": 57, "address":  0x2269f3, "bit": 0, "name": "Primeape", "obtainable": 1, "type1": "Fighting", "type2": "", },58: { "number": 58, "address":  0x2269f3, "bit": 1, "name": "Growlithe", "obtainable": 1, "type1": "Fire", "type2": "", },59: { "number": 59, "address":  0x2269f3, "bit": 2, "name": "Arcanine", "obtainable": 1, "type1": "Fire", "type2": "", },60: { "number": 60, "address":  0x2269f3, "bit": 3, "name": "Poliwag", "obtainable": 1, "type1": "Water", "type2": "", },61: { "number": 61, "address":  0x2269f3, "bit": 4, "name": "Poliwhirl", "obtainable": 1, "type1": "Water", "type2": "", },62: { "number": 62, "address":  0x2269f3, "bit": 5, "name": "Poliwrath", "obtainable": 1, "type1": "Water", "type2": "Fighting", },63: { "number": 63, "address":  0x2269f3, "bit": 6, "name": "Abra", "obtainable": 1, "type1": "Psychic", "type2": "", },64: { "number": 64, "address":  0x2269f3, "bit": 7, "name": "Kadabra", "obtainable": 1, "type1": "Psychic", "type2": "", },65: { "number": 65, "address":  0x2269f4, "bit": 0, "name": "Alakazam", "obtainable": 1, "type1": "Psychic", "type2": "", },66: { "number": 66, "address":  0x2269f4, "bit": 1, "name": "Machop", "obtainable": 0, "type1": "Fighting", "type2": "", },67: { "number": 67, "address":  0x2269f4, "bit": 2, "name": "Machoke", "obtainable": 0, "type1": "Fighting", "type2": "", },68: { "number": 68, "address":  0x2269f4, "bit": 3, "name": "Machamp", "obtainable": 0, "type1": "Fighting", "type2": "", },69: { "number": 69, "address":  0x2269f4, "bit": 4, "name": "Bellsprout", "obtainable": 0, "type1": "Grass", "type2": "Poison", },70: { "number": 70, "address":  0x2269f4, "bit": 5, "name": "Weepinbell", "obtainable": 0, "type1": "Grass", "type2": "Poison", },71: { "number": 71, "address":  0x2269f4, "bit": 6, "name": "Victreebel", "obtainable": 0, "type1": "Grass", "type2": "Poison", },72: { "number": 72, "address":  0x2269f4, "bit": 7, "name": "Tentacool", "obtainable": 0, "type1": "Water", "type2": "Poison", },73: { "number": 73, "address":  0x2269f5, "bit": 0, "name": "Tentacruel", "obtainable": 0, "type1": "Water", "type2": "Poison", },74: { "number": 74, "address":  0x2269f5, "bit": 1, "name": "Geodude", "obtainable": 0, "type1": "Rock", "type2": "Ground", },75: { "number": 75, "address":  0x2269f5, "bit": 2, "name": "Graveler", "obtainable": 0, "type1": "Rock", "type2": "Ground", },76: { "number": 76, "address":  0x2269f5, "bit": 3, "name": "Golem", "obtainable": 0, "type1": "Rock", "type2": "Ground", },77: { "number": 77, "address":  0x2269f5, "bit": 4, "name": "Ponyta", "obtainable": 0, "type1": "Fire", "type2": "", },78: { "number": 78, "address":  0x2269f5, "bit": 5, "name": "Rapidash", "obtainable": 0, "type1": "Fire", "type2": "", },79: { "number": 79, "address":  0x2269f5, "bit": 6, "name": "Slowpoke", "obtainable": 1, "type1": "Water", "type2": "Psychic", },80: { "number": 80, "address":  0x2269f5, "bit": 7, "name": "Slowbro", "obtainable": 1, "type1": "Water", "type2": "Psychic", },81: { "number": 81, "address":  0x2269f6, "bit": 0, "name": "Magnemite", "obtainable": 1, "type1": "Electric", "type2": "Steel", },82: { "number": 82, "address":  0x2269f6, "bit": 1, "name": "Magneton", "obtainable": 1, "type1": "Electric", "type2": "Steel", },83: { "number": 83, "address":  0x2269f6, "bit": 2, "name": "Farfetch", "obtainable": 1, "type1": "Normal", "type2": "Flying", },84: { "number": 84, "address":  0x2269f6, "bit": 3, "name": "Doduo", "obtainable": 1, "type1": "Normal", "type2": "Flying", },85: { "number": 85, "address":  0x2269f6, "bit": 4, "name": "Dodrio", "obtainable": 1, "type1": "Normal", "type2": "Flying", },86: { "number": 86, "address":  0x2269f6, "bit": 5, "name": "Seel", "obtainable": 1, "type1": "Water", "type2": "", },87: { "number": 87, "address":  0x2269f6, "bit": 6, "name": "Dewgong", "obtainable": 1, "type1": "Water", "type2": "Ice", },88: { "number": 88, "address":  0x2269f6, "bit": 7, "name": "Grimer", "obtainable": 1, "type1": "Poison", "type2": "", },89: { "number": 89, "address":  0x2269f7, "bit": 0, "name": "Muk", "obtainable": 1, "type1": "Poison", "type2": "", },90: { "number": 90, "address":  0x2269f7, "bit": 1, "name": "Shellder", "obtainable": 1, "type1": "Water", "type2": "", },91: { "number": 91, "address":  0x2269f7, "bit": 2, "name": "Cloyster", "obtainable": 1, "type1": "Water", "type2": "Ice", },92: { "number": 92, "address":  0x2269f7, "bit": 3, "name": "Gastly", "obtainable": 0, "type1": "Ghost", "type2": "Poison", },93: { "number": 93, "address":  0x2269f7, "bit": 4, "name": "Haunter", "obtainable": 0, "type1": "Ghost", "type2": "Poison", },94: { "number": 94, "address":  0x2269f7, "bit": 5, "name": "Gengar", "obtainable": 0, "type1": "Ghost", "type2": "Poison", },95: { "number": 95, "address":  0x2269f7, "bit": 6, "name": "Onix", "obtainable": 1, "type1": "Rock", "type2": "Ground", },96: { "number": 96, "address":  0x2269f7, "bit": 7, "name": "Drowzee", "obtainable": 1, "type1": "Psychic", "type2": "", },97: { "number": 97, "address":  0x2269f8, "bit": 0, "name": "Hypno", "obtainable": 1, "type1": "Psychic", "type2": "", },98: { "number": 98, "address":  0x2269f8, "bit": 1, "name": "Krabby", "obtainable": 1, "type1": "Water", "type2": "", },99: { "number": 99, "address":  0x2269f8, "bit": 2, "name": "Kingler", "obtainable": 1, "type1": "Water", "type2": "", },100: { "number": 100, "address":  0x2269f8, "bit": 3, "name": "Voltorb", "obtainable": 0, "type1": "Electric", "type2": "", },101: { "number": 101, "address":  0x2269f8, "bit": 4, "name": "Electrode", "obtainable": 0, "type1": "Electric", "type2": "", },102: { "number": 102, "address":  0x2269f8, "bit": 5, "name": "Exeggcute", "obtainable": 0, "type1": "Grass", "type2": "Psychic", },103: { "number": 103, "address":  0x2269f8, "bit": 6, "name": "Exeggutor", "obtainable": 0, "type1": "Grass", "type2": "Psychic", },104: { "number": 104, "address":  0x2269f8, "bit": 7, "name": "Cubone", "obtainable": 0, "type1": "Ground", "type2": "", },105: { "number": 105, "address":  0x2269f9, "bit": 0, "name": "Marowak", "obtainable": 0, "type1": "Ground", "type2": "", },106: { "number": 106, "address":  0x2269f9, "bit": 1, "name": "Hitmonlee", "obtainable": 0, "type1": "Fighting", "type2": "", },107: { "number": 107, "address":  0x2269f9, "bit": 2, "name": "Hitmonchan", "obtainable": 0, "type1": "Fighting", "type2": "", },108: { "number": 108, "address":  0x2269f9, "bit": 3, "name": "Lickitung", "obtainable": 1, "type1": "Normal", "type2": "", },109: { "number": 109, "address":  0x2269f9, "bit": 4, "name": "Koffing", "obtainable": 1, "type1": "Poison", "type2": "", },110: { "number": 110, "address":  0x2269f9, "bit": 5, "name": "Weezing", "obtainable": 1, "type1": "Poison", "type2": "", },111: { "number": 111, "address":  0x2269f9, "bit": 6, "name": "Rhyhorn", "obtainable": 1, "type1": "Ground", "type2": "Rock", },112: { "number": 112, "address":  0x2269f9, "bit": 7, "name": "Rhydon", "obtainable": 1, "type1": "Ground", "type2": "Rock", },113: { "number": 113, "address":  0x2269fa, "bit": 0, "name": "Chansey", "obtainable": 1, "type1": "Normal", "type2": "", },114: { "number": 114, "address":  0x2269fa, "bit": 1, "name": "Tangela", "obtainable": 1, "type1": "Grass", "type2": "", },115: { "number": 115, "address":  0x2269fa, "bit": 2, "name": "Kangaskhan", "obtainable": 0, "type1": "Normal", "type2": "", },116: { "number": 116, "address":  0x2269fa, "bit": 3, "name": "Horsea", "obtainable": 1, "type1": "Water", "type2": "", },117: { "number": 117, "address":  0x2269fa, "bit": 4, "name": "Seadra", "obtainable": 1, "type1": "Water", "type2": "", },118: { "number": 118, "address":  0x2269fa, "bit": 5, "name": "Goldeen", "obtainable": 1, "type1": "Water", "type2": "", },119: { "number": 119, "address":  0x2269fa, "bit": 6, "name": "Seaking", "obtainable": 1, "type1": "Water", "type2": "", },120: { "number": 120, "address":  0x2269fa, "bit": 7, "name": "Staryu", "obtainable": 1, "type1": "Water", "type2": "", },121: { "number": 121, "address":  0x2269fb, "bit": 0, "name": "Starmie", "obtainable": 1, "type1": "Water", "type2": "Psychic", },122: { "number": 122, "address":  0x2269fb, "bit": 1, "name": "Mr.Mime", "obtainable": 0, "type1": "Psychic", "type2": "", },123: { "number": 123, "address":  0x2269fb, "bit": 2, "name": "Scyther", "obtainable": 0, "type1": "Bug", "type2": "Flying", },124: { "number": 124, "address":  0x2269fb, "bit": 3, "name": "Jynx", "obtainable": 0, "type1": "Ice", "type2": "Psychic", },125: { "number": 125, "address":  0x2269fb, "bit": 4, "name": "Electabuzz", "obtainable": 0, "type1": "Electric", "type2": "", },126: { "number": 126, "address":  0x2269fb, "bit": 5, "name": "Magmar", "obtainable": 1, "type1": "Fire", "type2": "", },127: { "number": 127, "address":  0x2269fb, "bit": 6, "name": "Pinsir", "obtainable": 1, "type1": "Bug", "type2": "", },128: { "number": 128, "address":  0x2269fb, "bit": 7, "name": "Tauros", "obtainable": 0, "type1": "Normal", "type2": "", },129: { "number": 129, "address":  0x2269fc, "bit": 0, "name": "Magikarp", "obtainable": 1, "type1": "Water", "type2": "", },130: { "number": 130, "address":  0x2269fc, "bit": 1, "name": "Gyarados", "obtainable": 1, "type1": "Water", "type2": "Flying", },131: { "number": 131, "address":  0x2269fc, "bit": 2, "name": "Lapras", "obtainable": 1, "type1": "Water", "type2": "Ice", },132: { "number": 132, "address":  0x2269fc, "bit": 3, "name": "Ditto", "obtainable": 1, "type1": "Normal", "type2": "", },133: { "number": 133, "address":  0x2269fc, "bit": 4, "name": "Eevee", "obtainable": 1, "type1": "Normal", "type2": "", },134: { "number": 134, "address":  0x2269fc, "bit": 5, "name": "Vaporeon", "obtainable": 1, "type1": "Water", "type2": "", },135: { "number": 135, "address":  0x2269fc, "bit": 6, "name": "Jolteon", "obtainable": 1, "type1": "Electric", "type2": "", },136: { "number": 136, "address":  0x2269fc, "bit": 7, "name": "Flareon", "obtainable": 1, "type1": "Fire", "type2": "", },137: { "number": 137, "address":  0x2269fd, "bit": 0, "name": "Porygon", "obtainable": 0, "type1": "Normal", "type2": "", },138: { "number": 138, "address":  0x2269fd, "bit": 1, "name": "Omanyte", "obtainable": 1, "type1": "Rock", "type2": "Water", },139: { "number": 139, "address":  0x2269fd, "bit": 2, "name": "Omastar", "obtainable": 1, "type1": "Rock", "type2": "Water", },140: { "number": 140, "address":  0x2269fd, "bit": 3, "name": "Kabuto", "obtainable": 1, "type1": "Rock", "type2": "Water", },141: { "number": 141, "address":  0x2269fd, "bit": 4, "name": "Kabutops", "obtainable": 1, "type1": "Rock", "type2": "Water", },142: { "number": 142, "address":  0x2269fd, "bit": 5, "name": "Aerodactyl", "obtainable": 1, "type1": "Rock", "type2": "Flying", },143: { "number": 143, "address":  0x2269fd, "bit": 6, "name": "Snorlax", "obtainable": 1, "type1": "Normal", "type2": "", },144: { "number": 144, "address":  0x2269fd, "bit": 7, "name": "Articuno", "obtainable": 0, "type1": "Ice", "type2": "Flying", },145: { "number": 145, "address":  0x2269fe, "bit": 0, "name": "Zapdos", "obtainable": 0, "type1": "Electric", "type2": "Flying", },146: { "number": 146, "address":  0x2269fe, "bit": 1, "name": "Moltres", "obtainable": 0, "type1": "Fire", "type2": "Flying", },147: { "number": 147, "address":  0x2269fe, "bit": 2, "name": "Dratini", "obtainable": 1, "type1": "Dragon", "type2": "", },148: { "number": 148, "address":  0x2269fe, "bit": 3, "name": "Dragonair", "obtainable": 1, "type1": "Dragon", "type2": "", },149: { "number": 149, "address":  0x2269fe, "bit": 4, "name": "Dragonite", "obtainable": 1, "type1": "Dragon", "type2": "Flying", },150: { "number": 150, "address":  0x2269fe, "bit": 5, "name": "Mewtwo", "obtainable": 0, "type1": "Psychic", "type2": "", },151: { "number": 151, "address":  0x2269fe, "bit": 6, "name": "Mew", "obtainable": 0, "type1": "Psychic", "type2": "", },152: { "number": 152, "address":  0x2269fe, "bit": 7, "name": "Chikorita", "obtainable": 0, "type1": "Grass", "type2": "", },153: { "number": 153, "address":  0x2269ff, "bit": 0, "name": "Bayleef", "obtainable": 0, "type1": "Grass", "type2": "", },154: { "number": 154, "address":  0x2269ff, "bit": 1, "name": "Meganium", "obtainable": 0, "type1": "Grass", "type2": "", },155: { "number": 155, "address":  0x2269ff, "bit": 2, "name": "Cyndaquil", "obtainable": 0, "type1": "Fire", "type2": "", },156: { "number": 156, "address":  0x2269ff, "bit": 3, "name": "Quilava", "obtainable": 0, "type1": "Fire", "type2": "", },157: { "number": 157, "address":  0x2269ff, "bit": 4, "name": "Typhlosion", "obtainable": 0, "type1": "Fire", "type2": "", },158: { "number": 158, "address":  0x2269ff, "bit": 5, "name": "Totodile", "obtainable": 0, "type1": "Water", "type2": "", },159: { "number": 159, "address":  0x2269ff, "bit": 6, "name": "Croconaw", "obtainable": 0, "type1": "Water", "type2": "", },160: { "number": 160, "address":  0x2269ff, "bit": 7, "name": "Feraligatr", "obtainable": 0, "type1": "Water", "type2": "", },161: { "number": 161, "address":  0x226a00, "bit": 0, "name": "Sentret", "obtainable": 1, "type1": "Normal", "type2": "", },162: { "number": 162, "address":  0x226a00, "bit": 1, "name": "Furret", "obtainable": 1, "type1": "Normal", "type2": "", },163: { "number": 163, "address":  0x226a00, "bit": 2, "name": "Hoothoot", "obtainable": 1, "type1": "Normal", "type2": "Flying", },164: { "number": 164, "address":  0x226a00, "bit": 3, "name": "Noctowl", "obtainable": 1, "type1": "Normal", "type2": "Flying", },165: { "number": 165, "address":  0x226a00, "bit": 4, "name": "Ledyba", "obtainable": 0, "type1": "Bug", "type2": "Flying", },166: { "number": 166, "address":  0x226a00, "bit": 5, "name": "Ledian", "obtainable": 0, "type1": "Bug", "type2": "Flying", },167: { "number": 167, "address":  0x226a00, "bit": 6, "name": "Spinarak", "obtainable": 1, "type1": "Bug", "type2": "Poison", },168: { "number": 168, "address":  0x226a00, "bit": 7, "name": "Ariados", "obtainable": 1, "type1": "Bug", "type2": "Poison", },169: { "number": 169, "address":  0x226a01, "bit": 0, "name": "Crobat", "obtainable": 1, "type1": "Poison", "type2": "Flying", },170: { "number": 170, "address":  0x226a01, "bit": 1, "name": "Chinchou", "obtainable": 1, "type1": "Water", "type2": "Electric", },171: { "number": 171, "address":  0x226a01, "bit": 2, "name": "Lanturn", "obtainable": 1, "type1": "Water", "type2": "Electric", },172: { "number": 172, "address":  0x226a01, "bit": 3, "name": "Pichu", "obtainable": 0, "type1": "Electric", "type2": "", },173: { "number": 173, "address":  0x226a01, "bit": 4, "name": "Cleffa", "obtainable": 1, "type1": "Normal", "type2": "", },174: { "number": 174, "address":  0x226a01, "bit": 5, "name": "Igglybuff", "obtainable": 1, "type1": "Normal", "type2": "", },175: { "number": 175, "address":  0x226a01, "bit": 6, "name": "Togepi", "obtainable": 1, "type1": "Normal", "type2": "", },176: { "number": 176, "address":  0x226a01, "bit": 7, "name": "Togetic", "obtainable": 1, "type1": "Normal", "type2": "Flying", },177: { "number": 177, "address":  0x226a02, "bit": 0, "name": "Natu", "obtainable": 1, "type1": "Psychic", "type2": "Flying", },178: { "number": 178, "address":  0x226a02, "bit": 1, "name": "Xatu", "obtainable": 1, "type1": "Psychic", "type2": "Flying", },179: { "number": 179, "address":  0x226a02, "bit": 2, "name": "Mareep", "obtainable": 1, "type1": "Electric", "type2": "", },180: { "number": 180, "address":  0x226a02, "bit": 3, "name": "Flaaffy", "obtainable": 1, "type1": "Electric", "type2": "", },181: { "number": 181, "address":  0x226a02, "bit": 4, "name": "Ampharos", "obtainable": 1, "type1": "Electric", "type2": "", },182: { "number": 182, "address":  0x226a02, "bit": 5, "name": "Bellossom", "obtainable": 0, "type1": "Grass", "type2": "", },183: { "number": 183, "address":  0x226a02, "bit": 6, "name": "Marill", "obtainable": 1, "type1": "Water", "type2": "", },184: { "number": 184, "address":  0x226a02, "bit": 7, "name": "Azumarill", "obtainable": 1, "type1": "Water", "type2": "", },185: { "number": 185, "address":  0x226a03, "bit": 0, "name": "Sudowoodo", "obtainable": 1, "type1": "Rock", "type2": "", },186: { "number": 186, "address":  0x226a03, "bit": 1, "name": "Politoed", "obtainable": 1, "type1": "Water", "type2": "", },187: { "number": 187, "address":  0x226a03, "bit": 2, "name": "Hoppip", "obtainable": 1, "type1": "Grass", "type2": "Flying", },188: { "number": 188, "address":  0x226a03, "bit": 3, "name": "Skiploom", "obtainable": 1, "type1": "Grass", "type2": "Flying", },189: { "number": 189, "address":  0x226a03, "bit": 4, "name": "Jumpluff", "obtainable": 1, "type1": "Grass", "type2": "Flying", },190: { "number": 190, "address":  0x226a03, "bit": 5, "name": "Aipom", "obtainable": 1, "type1": "Normal", "type2": "", },191: { "number": 191, "address":  0x226a03, "bit": 6, "name": "Sunkern", "obtainable": 1, "type1": "Grass", "type2": "", },192: { "number": 192, "address":  0x226a03, "bit": 7, "name": "Sunflora", "obtainable": 1, "type1": "Grass", "type2": "", },193: { "number": 193, "address":  0x226a04, "bit": 0, "name": "Yanma", "obtainable": 1, "type1": "Bug", "type2": "Flying", },194: { "number": 194, "address":  0x226a04, "bit": 1, "name": "Wooper", "obtainable": 1, "type1": "Water", "type2": "Ground", },195: { "number": 195, "address":  0x226a04, "bit": 2, "name": "Quagsire", "obtainable": 1, "type1": "Water", "type2": "Ground", },196: { "number": 196, "address":  0x226a04, "bit": 3, "name": "Espeon", "obtainable": 1, "type1": "Psychic", "type2": "", },197: { "number": 197, "address":  0x226a04, "bit": 4, "name": "Umbreon", "obtainable": 1, "type1": "Dark", "type2": "", },198: { "number": 198, "address":  0x226a04, "bit": 5, "name": "Murkrow", "obtainable": 1, "type1": "Dark", "type2": "Flying", },199: { "number": 199, "address":  0x226a04, "bit": 6, "name": "Slowking", "obtainable": 1, "type1": "Water", "type2": "Psychic", },200: { "number": 200, "address":  0x226a04, "bit": 7, "name": "Misdreavus", "obtainable": 0, "type1": "Ghost", "type2": "", },201: { "number": 201, "address":  0x226a05, "bit": 0, "name": "Unown", "obtainable": 0, "type1": "Psychic", "type2": "", },202: { "number": 202, "address":  0x226a05, "bit": 1, "name": "Wobbuffet", "obtainable": 1, "type1": "Psychic", "type2": "", },203: { "number": 203, "address":  0x226a05, "bit": 2, "name": "Girafarig", "obtainable": 1, "type1": "Normal", "type2": "Psychic", },204: { "number": 204, "address":  0x226a05, "bit": 3, "name": "Pineco", "obtainable": 1, "type1": "Bug", "type2": "", },205: { "number": 205, "address":  0x226a05, "bit": 4, "name": "Forretress", "obtainable": 1, "type1": "Bug", "type2": "Steel", },206: { "number": 206, "address":  0x226a05, "bit": 5, "name": "Dunsparce", "obtainable": 1, "type1": "Normal", "type2": "", },207: { "number": 207, "address":  0x226a05, "bit": 6, "name": "Gligar", "obtainable": 1, "type1": "Ground", "type2": "Flying", },208: { "number": 208, "address":  0x226a05, "bit": 7, "name": "Steelix", "obtainable": 1, "type1": "Steel", "type2": "Ground", },209: { "number": 209, "address":  0x226a06, "bit": 0, "name": "Snubbull", "obtainable": 1, "type1": "Normal", "type2": "", },210: { "number": 210, "address":  0x226a06, "bit": 1, "name": "Granbull", "obtainable": 1, "type1": "Normal", "type2": "", },211: { "number": 211, "address":  0x226a06, "bit": 2, "name": "Qwilfish", "obtainable": 1, "type1": "Water", "type2": "Poison", },212: { "number": 212, "address":  0x226a06, "bit": 3, "name": "Scizor", "obtainable": 0, "type1": "Bug", "type2": "Steel", },213: { "number": 213, "address":  0x226a06, "bit": 4, "name": "Shuckle", "obtainable": 1, "type1": "Bug", "type2": "Rock", },214: { "number": 214, "address":  0x226a06, "bit": 5, "name": "Heracross", "obtainable": 1, "type1": "Bug", "type2": "Fighting", },215: { "number": 215, "address":  0x226a06, "bit": 6, "name": "Sneasel", "obtainable": 1, "type1": "Dark", "type2": "Ice", },216: { "number": 216, "address":  0x226a06, "bit": 7, "name": "Teddiursa", "obtainable": 1, "type1": "Normal", "type2": "", },217: { "number": 217, "address":  0x226a07, "bit": 0, "name": "Ursaring", "obtainable": 1, "type1": "Normal", "type2": "", },218: { "number": 218, "address":  0x226a07, "bit": 1, "name": "Slugma", "obtainable": 0, "type1": "Fire", "type2": "", },219: { "number": 219, "address":  0x226a07, "bit": 2, "name": "Magcargo", "obtainable": 0, "type1": "Fire", "type2": "Rock", },220: { "number": 220, "address":  0x226a07, "bit": 3, "name": "Swinub", "obtainable": 1, "type1": "Ice", "type2": "Ground", },221: { "number": 221, "address":  0x226a07, "bit": 4, "name": "Piloswine", "obtainable": 1, "type1": "Ice", "type2": "Ground", },222: { "number": 222, "address":  0x226a07, "bit": 5, "name": "Corsola", "obtainable": 1, "type1": "Water", "type2": "Rock", },223: { "number": 223, "address":  0x226a07, "bit": 6, "name": "Remoraid", "obtainable": 1, "type1": "Water", "type2": "", },224: { "number": 224, "address":  0x226a07, "bit": 7, "name": "Octillery", "obtainable": 1, "type1": "Water", "type2": "", },225: { "number": 225, "address":  0x226a08, "bit": 0, "name": "Delibird", "obtainable": 1, "type1": "Ice", "type2": "Flying", },226: { "number": 226, "address":  0x226a08, "bit": 1, "name": "Mantine", "obtainable": 1, "type1": "Water", "type2": "Flying", },227: { "number": 227, "address":  0x226a08, "bit": 2, "name": "Skarmory", "obtainable": 1, "type1": "Steel", "type2": "Flying", },228: { "number": 228, "address":  0x226a08, "bit": 3, "name": "Houndour", "obtainable": 0, "type1": "Dark", "type2": "Fire", },229: { "number": 229, "address":  0x226a08, "bit": 4, "name": "Houndoom", "obtainable": 0, "type1": "Dark", "type2": "Fire", },230: { "number": 230, "address":  0x226a08, "bit": 5, "name": "Kingdra", "obtainable": 1, "type1": "Water", "type2": "Dragon", },231: { "number": 231, "address":  0x226a08, "bit": 6, "name": "Phanpy", "obtainable": 1, "type1": "Ground", "type2": "", },232: { "number": 232, "address":  0x226a08, "bit": 7, "name": "Donphan", "obtainable": 1, "type1": "Ground", "type2": "", },233: { "number": 233, "address":  0x226a09, "bit": 0, "name": "Porygon2", "obtainable": 0, "type1": "Normal", "type2": "", },234: { "number": 234, "address":  0x226a09, "bit": 1, "name": "Stantler", "obtainable": 0, "type1": "Normal", "type2": "", },235: { "number": 235, "address":  0x226a09, "bit": 2, "name": "Smeargle", "obtainable": 0, "type1": "Normal", "type2": "", },236: { "number": 236, "address":  0x226a09, "bit": 3, "name": "Tyrogue", "obtainable": 0, "type1": "Fighting", "type2": "", },237: { "number": 237, "address":  0x226a09, "bit": 4, "name": "Hitmontop", "obtainable": 0, "type1": "Fighting", "type2": "", },238: { "number": 238, "address":  0x226a09, "bit": 5, "name": "Smoochum", "obtainable": 0, "type1": "Ice", "type2": "Psychic", },239: { "number": 239, "address":  0x226a09, "bit": 6, "name": "Elekid", "obtainable": 0, "type1": "Electric", "type2": "", },240: { "number": 240, "address":  0x226a09, "bit": 7, "name": "Magby", "obtainable": 1, "type1": "Fire", "type2": "", },241: { "number": 241, "address":  0x226a0a, "bit": 0, "name": "Miltank", "obtainable": 0, "type1": "Normal", "type2": "", },242: { "number": 242, "address":  0x226a0a, "bit": 1, "name": "Blissey", "obtainable": 1, "type1": "Normal", "type2": "", },243: { "number": 243, "address":  0x226a0a, "bit": 2, "name": "Raikou", "obtainable": 0, "type1": "Electric", "type2": "", },244: { "number": 244, "address":  0x226a0a, "bit": 3, "name": "Entei", "obtainable": 0, "type1": "Fire", "type2": "", },245: { "number": 245, "address":  0x226a0a, "bit": 4, "name": "Suicune", "obtainable": 0, "type1": "Water", "type2": "", },246: { "number": 246, "address":  0x226a0a, "bit": 5, "name": "Larvitar", "obtainable": 1, "type1": "Rock", "type2": "Ground", },247: { "number": 247, "address":  0x226a0a, "bit": 6, "name": "Pupitar", "obtainable": 1, "type1": "Rock", "type2": "Ground", },248: { "number": 248, "address":  0x226a0a, "bit": 7, "name": "Tyranitar", "obtainable": 1, "type1": "Rock", "type2": "Dark", },249: { "number": 249, "address":  0x226a0b, "bit": 0, "name": "Lugia", "obtainable": 0, "type1": "Psychic", "type2": "Flying", },250: { "number": 250, "address":  0x226a0b, "bit": 1, "name": "Ho-Oh", "obtainable": 0, "type1": "Fire", "type2": "Flying", },251: { "number": 251, "address":  0x226a0b, "bit": 2, "name": "Celebi", "obtainable": 0, "type1": "Psychic", "type2": "Grass", },252: { "number": 252, "address":  0x226a0b, "bit": 3, "name": "Treecko", "obtainable": 0, "type1": "Grass", "type2": "", },253: { "number": 253, "address":  0x226a0b, "bit": 4, "name": "Grovyle", "obtainable": 0, "type1": "Grass", "type2": "", },254: { "number": 254, "address":  0x226a0b, "bit": 5, "name": "Sceptile", "obtainable": 0, "type1": "Grass", "type2": "", },255: { "number": 255, "address":  0x226a0b, "bit": 6, "name": "Torchic", "obtainable": 0, "type1": "Fire", "type2": "", },256: { "number": 256, "address":  0x226a0b, "bit": 7, "name": "Combusken", "obtainable": 0, "type1": "Fire", "type2": "Fighting", },257: { "number": 257, "address":  0x226a0c, "bit": 0, "name": "Blaziken", "obtainable": 0, "type1": "Fire", "type2": "Fighting", },258: { "number": 258, "address":  0x226a0c, "bit": 1, "name": "Mudkip", "obtainable": 0, "type1": "Water", "type2": "", },259: { "number": 259, "address":  0x226a0c, "bit": 2, "name": "Marshtomp", "obtainable": 0, "type1": "Water", "type2": "Ground", },260: { "number": 260, "address":  0x226a0c, "bit": 3, "name": "Swampert", "obtainable": 0, "type1": "Water", "type2": "Ground", },261: { "number": 261, "address":  0x226a0c, "bit": 4, "name": "Poochyena", "obtainable": 0, "type1": "Dark", "type2": "", },262: { "number": 262, "address":  0x226a0c, "bit": 5, "name": "Mightyena", "obtainable": 0, "type1": "Dark", "type2": "", },263: { "number": 263, "address":  0x226a0c, "bit": 6, "name": "Zigzagoon", "obtainable": 0, "type1": "Normal", "type2": "", },264: { "number": 264, "address":  0x226a0c, "bit": 7, "name": "Linoone", "obtainable": 0, "type1": "Normal", "type2": "", },265: { "number": 265, "address":  0x226a0d, "bit": 0, "name": "Wurmple", "obtainable": 0, "type1": "Bug", "type2": "", },266: { "number": 266, "address":  0x226a0d, "bit": 1, "name": "Silcoon", "obtainable": 0, "type1": "Bug", "type2": "", },267: { "number": 267, "address":  0x226a0d, "bit": 2, "name": "Beautifly", "obtainable": 0, "type1": "Bug", "type2": "Flying", },268: { "number": 268, "address":  0x226a0d, "bit": 3, "name": "Cascoon", "obtainable": 0, "type1": "Bug", "type2": "", },269: { "number": 269, "address":  0x226a0d, "bit": 4, "name": "Dustox", "obtainable": 0, "type1": "Bug", "type2": "Poison", },270: { "number": 270, "address":  0x226a0d, "bit": 5, "name": "Lotad", "obtainable": 1, "type1": "Water", "type2": "Grass", },271: { "number": 271, "address":  0x226a0d, "bit": 6, "name": "Lombre", "obtainable": 1, "type1": "Water", "type2": "Grass", },272: { "number": 272, "address":  0x226a0d, "bit": 7, "name": "Ludicolo", "obtainable": 1, "type1": "Water", "type2": "Grass", },273: { "number": 273, "address":  0x226a0e, "bit": 0, "name": "Seedot", "obtainable": 1, "type1": "Grass", "type2": "", },274: { "number": 274, "address":  0x226a0e, "bit": 1, "name": "Nuzleaf", "obtainable": 1, "type1": "Grass", "type2": "Dark", },275: { "number": 275, "address":  0x226a0e, "bit": 2, "name": "Shiftry", "obtainable": 1, "type1": "Grass", "type2": "Dark", },276: { "number": 276, "address":  0x226a0e, "bit": 3, "name": "Taillow", "obtainable": 1, "type1": "Normal", "type2": "Flying", },277: { "number": 277, "address":  0x226a0e, "bit": 4, "name": "Swellow", "obtainable": 1, "type1": "Normal", "type2": "Flying", },278: { "number": 278, "address":  0x226a0e, "bit": 5, "name": "Wingull", "obtainable": 1, "type1": "Water", "type2": "Flying", },279: { "number": 279, "address":  0x226a0e, "bit": 6, "name": "Pelipper", "obtainable": 1, "type1": "Water", "type2": "Flying", },280: { "number": 280, "address":  0x226a0e, "bit": 7, "name": "Ralts", "obtainable": 1, "type1": "Psychic", "type2": "", },281: { "number": 281, "address":  0x226a0f, "bit": 0, "name": "Kirlia", "obtainable": 1, "type1": "Psychic", "type2": "", },282: { "number": 282, "address":  0x226a0f, "bit": 1, "name": "Gardevoir", "obtainable": 1, "type1": "Psychic", "type2": "", },283: { "number": 283, "address":  0x226a0f, "bit": 2, "name": "Surskit", "obtainable": 1, "type1": "Bug", "type2": "Water", },284: { "number": 284, "address":  0x226a0f, "bit": 3, "name": "Masquerain", "obtainable": 1, "type1": "Bug", "type2": "Flying", },285: { "number": 285, "address":  0x226a0f, "bit": 4, "name": "Shroomish", "obtainable": 1, "type1": "Grass", "type2": "", },286: { "number": 286, "address":  0x226a0f, "bit": 5, "name": "Breloom", "obtainable": 1, "type1": "Grass", "type2": "Fighting", },287: { "number": 287, "address":  0x226a0f, "bit": 6, "name": "Slakoth", "obtainable": 1, "type1": "Normal", "type2": "", },288: { "number": 288, "address":  0x226a0f, "bit": 7, "name": "Vigoroth", "obtainable": 1, "type1": "Normal", "type2": "", },289: { "number": 289, "address":  0x226a10, "bit": 0, "name": "Slaking", "obtainable": 1, "type1": "Normal", "type2": "", },290: { "number": 290, "address":  0x226a10, "bit": 1, "name": "Nincada", "obtainable": 0, "type1": "Bug", "type2": "Ground", },291: { "number": 291, "address":  0x226a10, "bit": 2, "name": "Ninjask", "obtainable": 0, "type1": "Bug", "type2": "Flying", },292: { "number": 292, "address":  0x226a10, "bit": 3, "name": "Shedinja", "obtainable": 0, "type1": "Bug", "type2": "Ghost", },293: { "number": 293, "address":  0x226a10, "bit": 4, "name": "Whismur", "obtainable": 0, "type1": "Normal", "type2": "", },294: { "number": 294, "address":  0x226a10, "bit": 5, "name": "Loudred", "obtainable": 0, "type1": "Normal", "type2": "", },295: { "number": 295, "address":  0x226a10, "bit": 6, "name": "Exploud", "obtainable": 0, "type1": "Normal", "type2": "", },296: { "number": 296, "address":  0x226a10, "bit": 7, "name": "Makuhita", "obtainable": 1, "type1": "Fighting", "type2": "", },297: { "number": 297, "address":  0x226a11, "bit": 0, "name": "Hariyama", "obtainable": 1, "type1": "Fighting", "type2": "", },298: { "number": 298, "address":  0x226a11, "bit": 1, "name": "Azurill", "obtainable": 1, "type1": "Normal", "type2": "", },299: { "number": 299, "address":  0x226a11, "bit": 2, "name": "Nosepass", "obtainable": 1, "type1": "Rock", "type2": "", },300: { "number": 300, "address":  0x226a11, "bit": 3, "name": "Skitty", "obtainable": 0, "type1": "Normal", "type2": "", },301: { "number": 301, "address":  0x226a11, "bit": 4, "name": "Delcatty", "obtainable": 0, "type1": "Normal", "type2": "", },302: { "number": 302, "address":  0x226a11, "bit": 5, "name": "Sableye", "obtainable": 1, "type1": "Dark", "type2": "Ghost", },303: { "number": 303, "address":  0x226a11, "bit": 6, "name": "Mawile", "obtainable": 1, "type1": "Steel", "type2": "", },304: { "number": 304, "address":  0x226a11, "bit": 7, "name": "Aron", "obtainable": 1, "type1": "Steel", "type2": "Rock", },305: { "number": 305, "address":  0x226a12, "bit": 0, "name": "Lairon", "obtainable": 1, "type1": "Steel", "type2": "Rock", },306: { "number": 306, "address":  0x226a12, "bit": 1, "name": "Aggron", "obtainable": 1, "type1": "Steel", "type2": "Rock", },307: { "number": 307, "address":  0x226a12, "bit": 2, "name": "Meditite", "obtainable": 1, "type1": "Fighting", "type2": "Psychic", },308: { "number": 308, "address":  0x226a12, "bit": 3, "name": "Medicham", "obtainable": 1, "type1": "Fighting", "type2": "Psychic", },309: { "number": 309, "address":  0x226a12, "bit": 4, "name": "Electrike", "obtainable": 1, "type1": "Electric", "type2": "", },310: { "number": 310, "address":  0x226a12, "bit": 5, "name": "Manectric", "obtainable": 1, "type1": "Electric", "type2": "", },311: { "number": 311, "address":  0x226a12, "bit": 6, "name": "Plusle", "obtainable": 1, "type1": "Electric", "type2": "", },312: { "number": 312, "address":  0x226a12, "bit": 7, "name": "Minun", "obtainable": 1, "type1": "Electric", "type2": "", },313: { "number": 313, "address":  0x226a13, "bit": 0, "name": "Volbeat", "obtainable": 1, "type1": "Bug", "type2": "", },314: { "number": 314, "address":  0x226a13, "bit": 1, "name": "Illumise", "obtainable": 1, "type1": "Bug", "type2": "", },315: { "number": 315, "address":  0x226a13, "bit": 2, "name": "Roselia", "obtainable": 1, "type1": "Grass", "type2": "Poison", },316: { "number": 316, "address":  0x226a13, "bit": 3, "name": "Gulpin", "obtainable": 1, "type1": "Poison", "type2": "", },317: { "number": 317, "address":  0x226a13, "bit": 4, "name": "Swalot", "obtainable": 1, "type1": "Poison", "type2": "", },318: { "number": 318, "address":  0x226a13, "bit": 5, "name": "Carvanha", "obtainable": 1, "type1": "Water", "type2": "Dark", },319: { "number": 319, "address":  0x226a13, "bit": 6, "name": "Sharpedo", "obtainable": 1, "type1": "Water", "type2": "Dark", },320: { "number": 320, "address":  0x226a13, "bit": 7, "name": "Wailmer", "obtainable": 1, "type1": "Water", "type2": "", },321: { "number": 321, "address":  0x226a14, "bit": 0, "name": "Wailord", "obtainable": 1, "type1": "Water", "type2": "", },322: { "number": 322, "address":  0x226a14, "bit": 1, "name": "Numel", "obtainable": 0, "type1": "Fire", "type2": "Ground", },323: { "number": 323, "address":  0x226a14, "bit": 2, "name": "Camerupt", "obtainable": 0, "type1": "Fire", "type2": "Ground", },324: { "number": 324, "address":  0x226a14, "bit": 3, "name": "Torkoal", "obtainable": 0, "type1": "Fire", "type2": "", },325: { "number": 325, "address":  0x226a14, "bit": 4, "name": "Spoink", "obtainable": 1, "type1": "Psychic", "type2": "", },326: { "number": 326, "address":  0x226a14, "bit": 5, "name": "Grumpig", "obtainable": 1, "type1": "Psychic", "type2": "", },327: { "number": 327, "address":  0x226a14, "bit": 6, "name": "Spinda", "obtainable": 1, "type1": "Normal", "type2": "", },328: { "number": 328, "address":  0x226a14, "bit": 7, "name": "Trapinch", "obtainable": 1, "type1": "Ground", "type2": "", },329: { "number": 329, "address":  0x226a15, "bit": 0, "name": "Vibrava", "obtainable": 1, "type1": "Ground", "type2": "Dragon", },330: { "number": 330, "address":  0x226a15, "bit": 1, "name": "Flygon", "obtainable": 1, "type1": "Ground", "type2": "Dragon", },331: { "number": 331, "address":  0x226a15, "bit": 2, "name": "Cacnea", "obtainable": 1, "type1": "Grass", "type2": "", },332: { "number": 332, "address":  0x226a15, "bit": 3, "name": "Cacturne", "obtainable": 1, "type1": "Grass", "type2": "Dark", },333: { "number": 333, "address":  0x226a15, "bit": 4, "name": "Swablu", "obtainable": 1, "type1": "Normal", "type2": "Flying", },334: { "number": 334, "address":  0x226a15, "bit": 5, "name": "Altaria", "obtainable": 1, "type1": "Dragon", "type2": "Flying", },335: { "number": 335, "address":  0x226a15, "bit": 6, "name": "Zangoose", "obtainable": 1, "type1": "Normal", "type2": "", },336: { "number": 336, "address":  0x226a15, "bit": 7, "name": "Seviper", "obtainable": 1, "type1": "Poison", "type2": "", },337: { "number": 337, "address":  0x226a16, "bit": 0, "name": "Lunatone", "obtainable": 1, "type1": "Rock", "type2": "Psychic", },338: { "number": 338, "address":  0x226a16, "bit": 1, "name": "Solrock", "obtainable": 1, "type1": "Rock", "type2": "Psychic", },339: { "number": 339, "address":  0x226a16, "bit": 2, "name": "Barboach", "obtainable": 1, "type1": "Water", "type2": "Ground", },340: { "number": 340, "address":  0x226a16, "bit": 3, "name": "Whiscash", "obtainable": 1, "type1": "Water", "type2": "Ground", },341: { "number": 341, "address":  0x226a16, "bit": 4, "name": "Corphish", "obtainable": 1, "type1": "Water", "type2": "", },342: { "number": 342, "address":  0x226a16, "bit": 5, "name": "Crawdaunt", "obtainable": 1, "type1": "Water", "type2": "Dark", },343: { "number": 343, "address":  0x226a16, "bit": 6, "name": "Baltoy", "obtainable": 1, "type1": "Ground", "type2": "Psychic", },344: { "number": 344, "address":  0x226a16, "bit": 7, "name": "Claydol", "obtainable": 1, "type1": "Ground", "type2": "Psychic", },345: { "number": 345, "address":  0x226a17, "bit": 0, "name": "Lileep", "obtainable": 1, "type1": "Rock", "type2": "Grass", },346: { "number": 346, "address":  0x226a17, "bit": 1, "name": "Cradily", "obtainable": 1, "type1": "Rock", "type2": "Grass", },347: { "number": 347, "address":  0x226a17, "bit": 2, "name": "Anorith", "obtainable": 1, "type1": "Rock", "type2": "Bug", },348: { "number": 348, "address":  0x226a17, "bit": 3, "name": "Armaldo", "obtainable": 1, "type1": "Rock", "type2": "Bug", },349: { "number": 349, "address":  0x226a17, "bit": 4, "name": "Feebas", "obtainable": 1, "type1": "Water", "type2": "", },350: { "number": 350, "address":  0x226a17, "bit": 5, "name": "Milotic", "obtainable": 1, "type1": "Water", "type2": "", },351: { "number": 351, "address":  0x226a17, "bit": 6, "name": "Castform", "obtainable": 1, "type1": "Normal", "type2": "", },352: { "number": 352, "address":  0x226a17, "bit": 7, "name": "Kecleon", "obtainable": 1, "type1": "Normal", "type2": "", },353: { "number": 353, "address":  0x226a18, "bit": 0, "name": "Shuppet", "obtainable": 1, "type1": "Ghost", "type2": "", },354: { "number": 354, "address":  0x226a18, "bit": 1, "name": "Banette", "obtainable": 1, "type1": "Ghost", "type2": "", },355: { "number": 355, "address":  0x226a18, "bit": 2, "name": "Duskull", "obtainable": 0, "type1": "Ghost", "type2": "", },356: { "number": 356, "address":  0x226a18, "bit": 3, "name": "Dusclops", "obtainable": 0, "type1": "Ghost", "type2": "", },357: { "number": 357, "address":  0x226a18, "bit": 4, "name": "Tropius", "obtainable": 1, "type1": "Grass", "type2": "Flying", },358: { "number": 358, "address":  0x226a18, "bit": 5, "name": "Chimecho", "obtainable": 0, "type1": "Psychic", "type2": "", },359: { "number": 359, "address":  0x226a18, "bit": 6, "name": "Absol", "obtainable": 1, "type1": "Dark", "type2": "", },360: { "number": 360, "address":  0x226a18, "bit": 7, "name": "Wynaut", "obtainable": 1, "type1": "Psychic", "type2": "", },361: { "number": 361, "address":  0x226a19, "bit": 0, "name": "Snorunt", "obtainable": 0, "type1": "Ice", "type2": "", },362: { "number": 362, "address":  0x226a19, "bit": 1, "name": "Glalie", "obtainable": 0, "type1": "Ice", "type2": "", },363: { "number": 363, "address":  0x226a19, "bit": 2, "name": "Spheal", "obtainable": 1, "type1": "Ice", "type2": "Water", },364: { "number": 364, "address":  0x226a19, "bit": 3, "name": "Sealeo", "obtainable": 1, "type1": "Ice", "type2": "Water", },365: { "number": 365, "address":  0x226a19, "bit": 4, "name": "Walrein", "obtainable": 1, "type1": "Ice", "type2": "Water", },366: { "number": 366, "address":  0x226a19, "bit": 5, "name": "Clamperl", "obtainable": 1, "type1": "Water", "type2": "", },367: { "number": 367, "address":  0x226a19, "bit": 6, "name": "Huntail", "obtainable": 1, "type1": "Water", "type2": "", },368: { "number": 368, "address":  0x226a19, "bit": 7, "name": "Gorebyss", "obtainable": 1, "type1": "Water", "type2": "", },369: { "number": 369, "address":  0x226a1a, "bit": 0, "name": "Relicanth", "obtainable": 1, "type1": "Water", "type2": "Rock", },370: { "number": 370, "address":  0x226a1a, "bit": 1, "name": "Luvdisc", "obtainable": 1, "type1": "Water", "type2": "", },371: { "number": 371, "address":  0x226a1a, "bit": 2, "name": "Bagon", "obtainable": 1, "type1": "Dragon", "type2": "", },372: { "number": 372, "address":  0x226a1a, "bit": 3, "name": "Shelgon", "obtainable": 1, "type1": "Dragon", "type2": "", },373: { "number": 373, "address":  0x226a1a, "bit": 4, "name": "Salamence", "obtainable": 1, "type1": "Dragon", "type2": "Flying", },374: { "number": 374, "address":  0x226a1a, "bit": 5, "name": "Beldum", "obtainable": 1, "type1": "Steel", "type2": "Psychic", },375: { "number": 375, "address":  0x226a1a, "bit": 6, "name": "Metang", "obtainable": 1, "type1": "Steel", "type2": "Psychic", },376: { "number": 376, "address":  0x226a1a, "bit": 7, "name": "Metagross", "obtainable": 1, "type1": "Steel", "type2": "Psychic", },377: { "number": 377, "address":  0x226a1b, "bit": 0, "name": "Regirock", "obtainable": 1, "type1": "Rock", "type2": "", },378: { "number": 378, "address":  0x226a1b, "bit": 1, "name": "Regice", "obtainable": 0, "type1": "Ice", "type2": "", },379: { "number": 379, "address":  0x226a1b, "bit": 2, "name": "Registeel", "obtainable": 1, "type1": "Steel", "type2": "", },380: { "number": 380, "address":  0x226a1b, "bit": 3, "name": "Latias", "obtainable": 0, "type1": "Dragon", "type2": "Psychic", },381: { "number": 381, "address":  0x226a1b, "bit": 4, "name": "Latios", "obtainable": 1, "type1": "Dragon", "type2": "Psychic", },382: { "number": 382, "address":  0x226a1b, "bit": 5, "name": "Kyogre", "obtainable": 0, "type1": "Water", "type2": "", },383: { "number": 383, "address":  0x226a1b, "bit": 6, "name": "Groudon", "obtainable": 0, "type1": "Ground", "type2": "", },384: { "number": 384, "address":  0x226a1b, "bit": 7, "name": "Rayquaza", "obtainable": 0, "type1": "Dragon", "type2": "Flying", },385: { "number": 385, "address":  0x226a1c, "bit": 0, "name": "Jirachi", "obtainable": 0, "type1": "Steel", "type2": "Psychic", },386: { "number": 386, "address":  0x226a1c, "bit": 1, "name": "Deoxys", "obtainable": 0, "type1": "Psychic", "type2": "", },387: { "number": 387, "address":  0x226a1c, "bit": 2, "name": "Turtwig", "obtainable": 0, "type1": "Grass", "type2": "", },388: { "number": 388, "address":  0x226a1c, "bit": 3, "name": "Grotle", "obtainable": 0, "type1": "Grass", "type2": "", },389: { "number": 389, "address":  0x226a1c, "bit": 4, "name": "Torterra", "obtainable": 0, "type1": "Grass", "type2": "Ground", },390: { "number": 390, "address":  0x226a1c, "bit": 5, "name": "Chimchar", "obtainable": 0, "type1": "Fire", "type2": "", },391: { "number": 391, "address":  0x226a1c, "bit": 6, "name": "Monferno", "obtainable": 0, "type1": "Fire", "type2": "Fighting", },392: { "number": 392, "address":  0x226a1c, "bit": 7, "name": "Infernape", "obtainable": 0, "type1": "Fire", "type2": "Fighting", },393: { "number": 393, "address":  0x226a1d, "bit": 0, "name": "Piplup", "obtainable": 0, "type1": "Water", "type2": "", },394: { "number": 394, "address":  0x226a1d, "bit": 1, "name": "Prinplup", "obtainable": 0, "type1": "Water", "type2": "", },395: { "number": 395, "address":  0x226a1d, "bit": 2, "name": "Empoleon", "obtainable": 0, "type1": "Water", "type2": "Steel", },396: { "number": 396, "address":  0x226a1d, "bit": 3, "name": "Starly", "obtainable": 0, "type1": "Normal", "type2": "Flying", },397: { "number": 397, "address":  0x226a1d, "bit": 4, "name": "Staravia", "obtainable": 0, "type1": "Normal", "type2": "Flying", },398: { "number": 398, "address":  0x226a1d, "bit": 5, "name": "Staraptor", "obtainable": 0, "type1": "Normal", "type2": "Flying", },399: { "number": 399, "address":  0x226a1d, "bit": 6, "name": "Bidoof", "obtainable": 1, "type1": "Normal", "type2": "", },400: { "number": 400, "address":  0x226a1d, "bit": 7, "name": "Bibarel", "obtainable": 1, "type1": "Normal", "type2": "Water", },401: { "number": 401, "address":  0x226a1e, "bit": 0, "name": "Kricketot", "obtainable": 0, "type1": "Bug", "type2": "", },402: { "number": 402, "address":  0x226a1e, "bit": 1, "name": "Kricketune", "obtainable": 0, "type1": "Bug", "type2": "", },403: { "number": 403, "address":  0x226a1e, "bit": 2, "name": "Shinx", "obtainable": 0, "type1": "Electric", "type2": "", },404: { "number": 404, "address":  0x226a1e, "bit": 3, "name": "Luxio", "obtainable": 0, "type1": "Electric", "type2": "", },405: { "number": 405, "address":  0x226a1e, "bit": 4, "name": "Luxray", "obtainable": 0, "type1": "Electric", "type2": "", },406: { "number": 406, "address":  0x226a1e, "bit": 5, "name": "Budew", "obtainable": 1, "type1": "Grass", "type2": "Poison", },407: { "number": 407, "address":  0x226a1e, "bit": 6, "name": "Roserade", "obtainable": 1, "type1": "Grass", "type2": "Poison", },408: { "number": 408, "address":  0x226a1e, "bit": 7, "name": "Cranidos", "obtainable": 1, "type1": "Rock", "type2": "", },409: { "number": 409, "address":  0x226a1f, "bit": 0, "name": "Rampardos", "obtainable": 1, "type1": "Rock", "type2": "", },410: { "number": 410, "address":  0x226a1f, "bit": 1, "name": "Shieldon", "obtainable": 1, "type1": "Rock", "type2": "Steel", },411: { "number": 411, "address":  0x226a1f, "bit": 2, "name": "Bastiodon", "obtainable": 1, "type1": "Rock", "type2": "Steel", },412: { "number": 412, "address":  0x226a1f, "bit": 3, "name": "Burmy", "obtainable": 0, "type1": "Bug", "type2": "", },413: { "number": 413, "address":  0x226a1f, "bit": 4, "name": "Wormadam", "obtainable": 0, "type1": "Bug", "type2": "Grass", },414: { "number": 414, "address":  0x226a1f, "bit": 5, "name": "Mothim", "obtainable": 0, "type1": "Bug", "type2": "Flying", },415: { "number": 415, "address":  0x226a1f, "bit": 6, "name": "Combee", "obtainable": 1, "type1": "Bug", "type2": "Flying", },416: { "number": 416, "address":  0x226a1f, "bit": 7, "name": "Vespiquen", "obtainable": 1, "type1": "Bug", "type2": "Flying", },417: { "number": 417, "address":  0x226a20, "bit": 0, "name": "Pachirisu", "obtainable": 1, "type1": "Electric", "type2": "", },418: { "number": 418, "address":  0x226a20, "bit": 1, "name": "Buizel", "obtainable": 1, "type1": "Water", "type2": "", },419: { "number": 419, "address":  0x226a20, "bit": 2, "name": "Floatzel", "obtainable": 1, "type1": "Water", "type2": "", },420: { "number": 420, "address":  0x226a20, "bit": 3, "name": "Cherubi", "obtainable": 0, "type1": "Grass", "type2": "", },421: { "number": 421, "address":  0x226a20, "bit": 4, "name": "Cherrim", "obtainable": 0, "type1": "Grass", "type2": "", },422: { "number": 422, "address":  0x226a20, "bit": 5, "name": "Shellos", "obtainable": 1, "type1": "Water", "type2": "", },423: { "number": 423, "address":  0x226a20, "bit": 6, "name": "Gastrodon", "obtainable": 1, "type1": "Water", "type2": "Ground", },424: { "number": 424, "address":  0x226a20, "bit": 7, "name": "Ambipom", "obtainable": 1, "type1": "Normal", "type2": "", },425: { "number": 425, "address":  0x226a21, "bit": 0, "name": "Drifloon", "obtainable": 1, "type1": "Ghost", "type2": "Flying", },426: { "number": 426, "address":  0x226a21, "bit": 1, "name": "Drifblim", "obtainable": 1, "type1": "Ghost", "type2": "Flying", },427: { "number": 427, "address":  0x226a21, "bit": 2, "name": "Buneary", "obtainable": 1, "type1": "Normal", "type2": "", },428: { "number": 428, "address":  0x226a21, "bit": 3, "name": "Lopunny", "obtainable": 1, "type1": "Normal", "type2": "", },429: { "number": 429, "address":  0x226a21, "bit": 4, "name": "Mismagius", "obtainable": 0, "type1": "Ghost", "type2": "", },430: { "number": 430, "address":  0x226a21, "bit": 5, "name": "Honchkrow", "obtainable": 1, "type1": "Dark", "type2": "Flying", },431: { "number": 431, "address":  0x226a21, "bit": 6, "name": "Glameow", "obtainable": 0, "type1": "Normal", "type2": "", },432: { "number": 432, "address":  0x226a21, "bit": 7, "name": "Purugly", "obtainable": 0, "type1": "Normal", "type2": "", },433: { "number": 433, "address":  0x226a22, "bit": 0, "name": "Chingling", "obtainable": 0, "type1": "Psychic", "type2": "", },434: { "number": 434, "address":  0x226a22, "bit": 1, "name": "Stunky", "obtainable": 1, "type1": "Poison", "type2": "Dark", },435: { "number": 435, "address":  0x226a22, "bit": 2, "name": "Skuntank", "obtainable": 1, "type1": "Poison", "type2": "Dark", },436: { "number": 436, "address":  0x226a22, "bit": 3, "name": "Bronzor", "obtainable": 1, "type1": "Steel", "type2": "Psychic", },437: { "number": 437, "address":  0x226a22, "bit": 4, "name": "Bronzong", "obtainable": 1, "type1": "Steel", "type2": "Psychic", },438: { "number": 438, "address":  0x226a22, "bit": 5, "name": "Bonsly", "obtainable": 1, "type1": "Rock", "type2": "", },439: { "number": 439, "address":  0x226a22, "bit": 6, "name": "MimeJr.", "obtainable": 0, "type1": "Psychic", "type2": "", },440: { "number": 440, "address":  0x226a22, "bit": 7, "name": "Happiny", "obtainable": 1, "type1": "Normal", "type2": "", },441: { "number": 441, "address":  0x226a23, "bit": 0, "name": "Chatot", "obtainable": 1, "type1": "Normal", "type2": "Flying", },442: { "number": 442, "address":  0x226a23, "bit": 1, "name": "Spiritomb", "obtainable": 1, "type1": "Ghost", "type2": "Dark", },443: { "number": 443, "address":  0x226a23, "bit": 2, "name": "Gible", "obtainable": 1, "type1": "Dragon", "type2": "Ground", },444: { "number": 444, "address":  0x226a23, "bit": 3, "name": "Gabite", "obtainable": 1, "type1": "Dragon", "type2": "Ground", },445: { "number": 445, "address":  0x226a23, "bit": 4, "name": "Garchomp", "obtainable": 1, "type1": "Dragon", "type2": "Ground", },446: { "number": 446, "address":  0x226a23, "bit": 5, "name": "Munchlax", "obtainable": 1, "type1": "Normal", "type2": "", },447: { "number": 447, "address":  0x226a23, "bit": 6, "name": "Riolu", "obtainable": 1, "type1": "Fighting", "type2": "", },448: { "number": 448, "address":  0x226a23, "bit": 7, "name": "Lucario", "obtainable": 1, "type1": "Fighting", "type2": "Steel", },449: { "number": 449, "address":  0x226a24, "bit": 0, "name": "Hippopotas", "obtainable": 1, "type1": "Ground", "type2": "", },450: { "number": 450, "address":  0x226a24, "bit": 1, "name": "Hippowdon", "obtainable": 1, "type1": "Ground", "type2": "", },451: { "number": 451, "address":  0x226a24, "bit": 2, "name": "Skorupi", "obtainable": 1, "type1": "Poison", "type2": "Bug", },452: { "number": 452, "address":  0x226a24, "bit": 3, "name": "Drapion", "obtainable": 1, "type1": "Poison", "type2": "Dark", },453: { "number": 453, "address":  0x226a24, "bit": 4, "name": "Croagunk", "obtainable": 1, "type1": "Poison", "type2": "Fighting", },454: { "number": 454, "address":  0x226a24, "bit": 5, "name": "Toxicroak", "obtainable": 1, "type1": "Poison", "type2": "Fighting", },455: { "number": 455, "address":  0x226a24, "bit": 6, "name": "Carnivine", "obtainable": 1, "type1": "Grass", "type2": "", },456: { "number": 456, "address":  0x226a24, "bit": 7, "name": "Finneon", "obtainable": 1, "type1": "Water", "type2": "", },457: { "number": 457, "address":  0x226a25, "bit": 0, "name": "Lumineon", "obtainable": 1, "type1": "Water", "type2": "", },458: { "number": 458, "address":  0x226a25, "bit": 1, "name": "Mantyke", "obtainable": 1, "type1": "Water", "type2": "Flying", },459: { "number": 459, "address":  0x226a25, "bit": 2, "name": "Snover", "obtainable": 0, "type1": "Grass", "type2": "Ice", },460: { "number": 460, "address":  0x226a25, "bit": 3, "name": "Abomasnow", "obtainable": 0, "type1": "Grass", "type2": "Ice", },461: { "number": 461, "address":  0x226a25, "bit": 4, "name": "Weavile", "obtainable": 1, "type1": "Dark", "type2": "Ice", },462: { "number": 462, "address":  0x226a25, "bit": 5, "name": "Magnezone", "obtainable": 1, "type1": "Electric", "type2": "Steel", },463: { "number": 463, "address":  0x226a25, "bit": 6, "name": "Lickilicky", "obtainable": 1, "type1": "Normal", "type2": "", },464: { "number": 464, "address":  0x226a25, "bit": 7, "name": "Rhyperior", "obtainable": 1, "type1": "Ground", "type2": "Rock", },465: { "number": 465, "address":  0x226a26, "bit": 0, "name": "Tangrowth", "obtainable": 1, "type1": "Grass", "type2": "", },466: { "number": 466, "address":  0x226a26, "bit": 1, "name": "Electivire", "obtainable": 0, "type1": "Electric", "type2": "", },467: { "number": 467, "address":  0x226a26, "bit": 2, "name": "Magmortar", "obtainable": 1, "type1": "Fire", "type2": "", },468: { "number": 468, "address":  0x226a26, "bit": 3, "name": "Togekiss", "obtainable": 1, "type1": "Normal", "type2": "Flying", },469: { "number": 469, "address":  0x226a26, "bit": 4, "name": "Yanmega", "obtainable": 1, "type1": "Bug", "type2": "Flying", },470: { "number": 470, "address":  0x226a26, "bit": 5, "name": "Leafeon", "obtainable": 1, "type1": "Grass", "type2": "", },471: { "number": 471, "address":  0x226a26, "bit": 6, "name": "Glaceon", "obtainable": 1, "type1": "Ice", "type2": "", },472: { "number": 472, "address":  0x226a26, "bit": 7, "name": "Gliscor", "obtainable": 1, "type1": "Ground", "type2": "Flying", },473: { "number": 473, "address":  0x226a27, "bit": 0, "name": "Mamoswine", "obtainable": 1, "type1": "Ice", "type2": "Ground", },474: { "number": 474, "address":  0x226a27, "bit": 1, "name": "Porygon-Z", "obtainable": 0, "type1": "Normal", "type2": "", },475: { "number": 475, "address":  0x226a27, "bit": 2, "name": "Gallade", "obtainable": 1, "type1": "Psychic", "type2": "Fighting", },476: { "number": 476, "address":  0x226a27, "bit": 3, "name": "Probopass", "obtainable": 1, "type1": "Rock", "type2": "Steel", },477: { "number": 477, "address":  0x226a27, "bit": 4, "name": "Dusknoir", "obtainable": 0, "type1": "Ghost", "type2": "", },478: { "number": 478, "address":  0x226a27, "bit": 5, "name": "Froslass", "obtainable": 0, "type1": "Ice", "type2": "Ghost", },479: { "number": 479, "address":  0x226a27, "bit": 6, "name": "Rotom", "obtainable": 1, "type1": "Electric", "type2": "Ghost", },480: { "number": 480, "address":  0x226a27, "bit": 7, "name": "Uxie", "obtainable": 1, "type1": "Psychic", "type2": "", },481: { "number": 481, "address":  0x226a28, "bit": 0, "name": "Mesprit", "obtainable": 1, "type1": "Psychic", "type2": "", },482: { "number": 482, "address":  0x226a28, "bit": 1, "name": "Azelf", "obtainable": 1, "type1": "Psychic", "type2": "", },483: { "number": 483, "address":  0x226a28, "bit": 2, "name": "Dialga", "obtainable": 0, "type1": "Steel", "type2": "Dragon", },484: { "number": 484, "address":  0x226a28, "bit": 3, "name": "Palkia", "obtainable": 0, "type1": "Water", "type2": "Dragon", },485: { "number": 485, "address":  0x226a28, "bit": 4, "name": "Heatran", "obtainable": 1, "type1": "Fire", "type2": "Steel", },486: { "number": 486, "address":  0x226a28, "bit": 5, "name": "Regigigas", "obtainable": 0, "type1": "Normal", "type2": "", },487: { "number": 487, "address":  0x226a28, "bit": 6, "name": "Giratina", "obtainable": 0, "type1": "Ghost", "type2": "Dragon", },488: { "number": 488, "address":  0x226a28, "bit": 7, "name": "Cresselia", "obtainable": 1, "type1": "Psychic", "type2": "", },489: { "number": 489, "address":  0x226a29, "bit": 0, "name": "Phione", "obtainable": 0, "type1": "Water", "type2": "", },490: { "number": 490, "address":  0x226a29, "bit": 1, "name": "Manaphy", "obtainable": 0, "type1": "Water", "type2": "", },491: { "number": 491, "address":  0x226a29, "bit": 2, "name": "Darkrai", "obtainable": 0, "type1": "Dark", "type2": "", },492: { "number": 492, "address":  0x226a29, "bit": 3, "name": "Shaymin", "obtainable": 0, "type1": "Grass", "type2": "", },493: { "number": 493, "address":  0x226a29, "bit": 4, "name": "Arceus", "obtainable": 0, "type1": "Normal", "type2": "", },494: { "number": 494, "address":  0x226a29, "bit": 5, "name": "Victini", "obtainable": 0, "type1": "Psychic", "type2": "Fire", },495: { "number": 495, "address":  0x226a29, "bit": 6, "name": "Snivy", "obtainable": 1, "type1": "Grass", "type2": "", },496: { "number": 496, "address":  0x226a29, "bit": 7, "name": "Servine", "obtainable": 1, "type1": "Grass", "type2": "", },497: { "number": 497, "address":  0x226a2a, "bit": 0, "name": "Serperior", "obtainable": 1, "type1": "Grass", "type2": "", },498: { "number": 498, "address":  0x226a2a, "bit": 1, "name": "Tepig", "obtainable": 1, "type1": "Fire", "type2": "Fighting", },499: { "number": 499, "address":  0x226a2a, "bit": 2, "name": "Pignite", "obtainable": 1, "type1": "Fire", "type2": "Fighting", },500: { "number": 500, "address":  0x226a2a, "bit": 3, "name": "Emboar", "obtainable": 1, "type1": "Fire", "type2": "Fighting", },501: { "number": 501, "address":  0x226a2a, "bit": 4, "name": "Oshawott", "obtainable": 1, "type1": "Water", "type2": "", },502: { "number": 502, "address":  0x226a2a, "bit": 5, "name": "Dewott", "obtainable": 1, "type1": "Water", "type2": "", },503: { "number": 503, "address":  0x226a2a, "bit": 6, "name": "Samurott", "obtainable": 1, "type1": "Water", "type2": "", },504: { "number": 504, "address":  0x226a2a, "bit": 7, "name": "Patrat", "obtainable": 1, "type1": "Normal", "type2": "", },505: { "number": 505, "address":  0x226a2b, "bit": 0, "name": "Watchog", "obtainable": 1, "type1": "Normal", "type2": "", },506: { "number": 506, "address":  0x226a2b, "bit": 1, "name": "Lillipup", "obtainable": 1, "type1": "Normal", "type2": "", },507: { "number": 507, "address":  0x226a2b, "bit": 2, "name": "Herdier", "obtainable": 1, "type1": "Normal", "type2": "", },508: { "number": 508, "address":  0x226a2b, "bit": 3, "name": "Stoutland", "obtainable": 1, "type1": "Normal", "type2": "", },509: { "number": 509, "address":  0x226a2b, "bit": 4, "name": "Purrloin", "obtainable": 1, "type1": "Dark", "type2": "", },510: { "number": 510, "address":  0x226a2b, "bit": 5, "name": "Liepard", "obtainable": 1, "type1": "Dark", "type2": "", },511: { "number": 511, "address":  0x226a2b, "bit": 6, "name": "Pansage", "obtainable": 1, "type1": "Grass", "type2": "", },512: { "number": 512, "address":  0x226a2b, "bit": 7, "name": "Simisage", "obtainable": 1, "type1": "Grass", "type2": "", },513: { "number": 513, "address":  0x226a2c, "bit": 0, "name": "Pansear", "obtainable": 1, "type1": "Fire", "type2": "", },514: { "number": 514, "address":  0x226a2c, "bit": 1, "name": "Simisear", "obtainable": 1, "type1": "Fire", "type2": "", },515: { "number": 515, "address":  0x226a2c, "bit": 2, "name": "Panpour", "obtainable": 1, "type1": "Water", "type2": "", },516: { "number": 516, "address":  0x226a2c, "bit": 3, "name": "Simipour", "obtainable": 1, "type1": "Water", "type2": "", },517: { "number": 517, "address":  0x226a2c, "bit": 4, "name": "Munna", "obtainable": 1, "type1": "Psychic", "type2": "", },518: { "number": 518, "address":  0x226a2c, "bit": 5, "name": "Musharna", "obtainable": 1, "type1": "Psychic", "type2": "", },519: { "number": 519, "address":  0x226a2c, "bit": 6, "name": "Pidove", "obtainable": 1, "type1": "Normal", "type2": "Flying", },520: { "number": 520, "address":  0x226a2c, "bit": 7, "name": "Tranquil", "obtainable": 1, "type1": "Normal", "type2": "Flying", },521: { "number": 521, "address":  0x226a2d, "bit": 0, "name": "Unfezant", "obtainable": 1, "type1": "Normal", "type2": "Flying", },522: { "number": 522, "address":  0x226a2d, "bit": 1, "name": "Blitzle", "obtainable": 1, "type1": "Electric", "type2": "", },523: { "number": 523, "address":  0x226a2d, "bit": 2, "name": "Zebstrika", "obtainable": 1, "type1": "Electric", "type2": "", },524: { "number": 524, "address":  0x226a2d, "bit": 3, "name": "Roggenrola", "obtainable": 1, "type1": "Rock", "type2": "", },525: { "number": 525, "address":  0x226a2d, "bit": 4, "name": "Boldore", "obtainable": 1, "type1": "Rock", "type2": "", },526: { "number": 526, "address":  0x226a2d, "bit": 5, "name": "Gigalith", "obtainable": 1, "type1": "Rock", "type2": "", },527: { "number": 527, "address":  0x226a2d, "bit": 6, "name": "Woobat", "obtainable": 1, "type1": "Psychic", "type2": "Flying", },528: { "number": 528, "address":  0x226a2d, "bit": 7, "name": "Swoobat", "obtainable": 1, "type1": "Psychic", "type2": "Flying", },529: { "number": 529, "address":  0x226a2e, "bit": 0, "name": "Drilbur", "obtainable": 1, "type1": "Ground", "type2": "", },530: { "number": 530, "address":  0x226a2e, "bit": 1, "name": "Excadrill", "obtainable": 1, "type1": "Ground", "type2": "Steel", },531: { "number": 531, "address":  0x226a2e, "bit": 2, "name": "Audino", "obtainable": 1, "type1": "Normal", "type2": "", },532: { "number": 532, "address":  0x226a2e, "bit": 3, "name": "Timburr", "obtainable": 1, "type1": "Fighting", "type2": "", },533: { "number": 533, "address":  0x226a2e, "bit": 4, "name": "Gurdurr", "obtainable": 1, "type1": "Fighting", "type2": "", },534: { "number": 534, "address":  0x226a2e, "bit": 5, "name": "Conkeldurr", "obtainable": 1, "type1": "Fighting", "type2": "", },535: { "number": 535, "address":  0x226a2e, "bit": 6, "name": "Tympole", "obtainable": 1, "type1": "Water", "type2": "", },536: { "number": 536, "address":  0x226a2e, "bit": 7, "name": "Palpitoad", "obtainable": 1, "type1": "Water", "type2": "Ground", },537: { "number": 537, "address":  0x226a2f, "bit": 0, "name": "Seismitoad", "obtainable": 1, "type1": "Water", "type2": "Ground", },538: { "number": 538, "address":  0x226a2f, "bit": 1, "name": "Throh", "obtainable": 1, "type1": "Fighting", "type2": "", },539: { "number": 539, "address":  0x226a2f, "bit": 2, "name": "Sawk", "obtainable": 1, "type1": "Fighting", "type2": "", },540: { "number": 540, "address":  0x226a2f, "bit": 3, "name": "Sewaddle", "obtainable": 1, "type1": "Bug", "type2": "Grass", },541: { "number": 541, "address":  0x226a2f, "bit": 4, "name": "Swadloon", "obtainable": 1, "type1": "Bug", "type2": "Grass", },542: { "number": 542, "address":  0x226a2f, "bit": 5, "name": "Leavanny", "obtainable": 1, "type1": "Bug", "type2": "Grass", },543: { "number": 543, "address":  0x226a2f, "bit": 6, "name": "Venipede", "obtainable": 1, "type1": "Bug", "type2": "Poison", },544: { "number": 544, "address":  0x226a2f, "bit": 7, "name": "Whirlipede", "obtainable": 1, "type1": "Bug", "type2": "Poison", },545: { "number": 545, "address":  0x226a30, "bit": 0, "name": "Scolipede", "obtainable": 1, "type1": "Bug", "type2": "Poison", },546: { "number": 546, "address":  0x226a30, "bit": 1, "name": "Cottonee", "obtainable": 1, "type1": "Grass", "type2": "", },547: { "number": 547, "address":  0x226a30, "bit": 2, "name": "Whimsicott", "obtainable": 1, "type1": "Grass", "type2": "", },548: { "number": 548, "address":  0x226a30, "bit": 3, "name": "Petilil", "obtainable": 1, "type1": "Grass", "type2": "", },549: { "number": 549, "address":  0x226a30, "bit": 4, "name": "Lilligant", "obtainable": 1, "type1": "Grass", "type2": "", },550: { "number": 550, "address":  0x226a30, "bit": 5, "name": "Basculin", "obtainable": 1, "type1": "Water", "type2": "", },551: { "number": 551, "address":  0x226a30, "bit": 6, "name": "Sandile", "obtainable": 1, "type1": "Ground", "type2": "Dark", },552: { "number": 552, "address":  0x226a30, "bit": 7, "name": "Krokorok", "obtainable": 1, "type1": "Ground", "type2": "Dark", },553: { "number": 553, "address":  0x226a31, "bit": 0, "name": "Krookodile", "obtainable": 1, "type1": "Ground", "type2": "Dark", },554: { "number": 554, "address":  0x226a31, "bit": 1, "name": "Darumaka", "obtainable": 1, "type1": "Fire", "type2": "", },555: { "number": 555, "address":  0x226a31, "bit": 2, "name": "Darmanitan", "obtainable": 1, "type1": "Fire", "type2": "", },556: { "number": 556, "address":  0x226a31, "bit": 3, "name": "Maractus", "obtainable": 1, "type1": "Grass", "type2": "", },557: { "number": 557, "address":  0x226a31, "bit": 4, "name": "Dwebble", "obtainable": 1, "type1": "Bug", "type2": "Rock", },558: { "number": 558, "address":  0x226a31, "bit": 5, "name": "Crustle", "obtainable": 1, "type1": "Bug", "type2": "Rock", },559: { "number": 559, "address":  0x226a31, "bit": 6, "name": "Scraggy", "obtainable": 1, "type1": "Dark", "type2": "Fighting", },560: { "number": 560, "address":  0x226a31, "bit": 7, "name": "Scrafty", "obtainable": 1, "type1": "Dark", "type2": "Fighting", },561: { "number": 561, "address":  0x226a32, "bit": 0, "name": "Sigilyph", "obtainable": 1, "type1": "Psychic", "type2": "Flying", },562: { "number": 562, "address":  0x226a32, "bit": 1, "name": "Yamask", "obtainable": 1, "type1": "Ghost", "type2": "", },563: { "number": 563, "address":  0x226a32, "bit": 2, "name": "Cofagrigus", "obtainable": 1, "type1": "Ghost", "type2": "", },564: { "number": 564, "address":  0x226a32, "bit": 3, "name": "Tirtouga", "obtainable": 1, "type1": "Water", "type2": "Rock", },565: { "number": 565, "address":  0x226a32, "bit": 4, "name": "Carracosta", "obtainable": 1, "type1": "Water", "type2": "Rock", },566: { "number": 566, "address":  0x226a32, "bit": 5, "name": "Archen", "obtainable": 1, "type1": "Rock", "type2": "Flying", },567: { "number": 567, "address":  0x226a32, "bit": 6, "name": "Archeops", "obtainable": 1, "type1": "Rock", "type2": "Flying", },568: { "number": 568, "address":  0x226a32, "bit": 7, "name": "Trubbish", "obtainable": 1, "type1": "Poison", "type2": "", },569: { "number": 569, "address":  0x226a33, "bit": 0, "name": "Garbodor", "obtainable": 1, "type1": "Poison", "type2": "", },570: { "number": 570, "address":  0x226a33, "bit": 1, "name": "Zorua", "obtainable": 1, "type1": "Dark", "type2": "", },571: { "number": 571, "address":  0x226a33, "bit": 2, "name": "Zoroark", "obtainable": 1, "type1": "Dark", "type2": "", },572: { "number": 572, "address":  0x226a33, "bit": 3, "name": "Minccino", "obtainable": 1, "type1": "Normal", "type2": "", },573: { "number": 573, "address":  0x226a33, "bit": 4, "name": "Cinccino", "obtainable": 1, "type1": "Normal", "type2": "", },574: { "number": 574, "address":  0x226a33, "bit": 5, "name": "Gothita", "obtainable": 1, "type1": "Psychic", "type2": "", },575: { "number": 575, "address":  0x226a33, "bit": 6, "name": "Gothorita", "obtainable": 1, "type1": "Psychic", "type2": "", },576: { "number": 576, "address":  0x226a33, "bit": 7, "name": "Gothitelle", "obtainable": 1, "type1": "Psychic", "type2": "", },577: { "number": 577, "address":  0x226a34, "bit": 0, "name": "Solosis", "obtainable": 0, "type1": "Psychic", "type2": "", },578: { "number": 578, "address":  0x226a34, "bit": 1, "name": "Duosion", "obtainable": 0, "type1": "Psychic", "type2": "", },579: { "number": 579, "address":  0x226a34, "bit": 2, "name": "Reuniclus", "obtainable": 0, "type1": "Psychic", "type2": "", },580: { "number": 580, "address":  0x226a34, "bit": 3, "name": "Ducklett", "obtainable": 1, "type1": "Water", "type2": "Flying", },581: { "number": 581, "address":  0x226a34, "bit": 4, "name": "Swanna", "obtainable": 1, "type1": "Water", "type2": "Flying", },582: { "number": 582, "address":  0x226a34, "bit": 5, "name": "Vanillite", "obtainable": 1, "type1": "Ice", "type2": "", },583: { "number": 583, "address":  0x226a34, "bit": 6, "name": "Vanillish", "obtainable": 1, "type1": "Ice", "type2": "", },584: { "number": 584, "address":  0x226a34, "bit": 7, "name": "Vanilluxe", "obtainable": 1, "type1": "Ice", "type2": "", },585: { "number": 585, "address":  0x226a35, "bit": 0, "name": "Deerling", "obtainable": 1, "type1": "Normal", "type2": "Grass", },586: { "number": 586, "address":  0x226a35, "bit": 1, "name": "Sawsbuck", "obtainable": 1, "type1": "Normal", "type2": "Grass", },587: { "number": 587, "address":  0x226a35, "bit": 2, "name": "Emolga", "obtainable": 1, "type1": "Electric", "type2": "Flying", },588: { "number": 588, "address":  0x226a35, "bit": 3, "name": "Karrablast", "obtainable": 1, "type1": "Bug", "type2": "", },589: { "number": 589, "address":  0x226a35, "bit": 4, "name": "Escavalier", "obtainable": 1, "type1": "Bug", "type2": "Steel", },590: { "number": 590, "address":  0x226a35, "bit": 5, "name": "Foongus", "obtainable": 1, "type1": "Grass", "type2": "Poison", },591: { "number": 591, "address":  0x226a35, "bit": 6, "name": "Amoongus", "obtainable": 1, "type1": "Grass", "type2": "Poison", },592: { "number": 592, "address":  0x226a35, "bit": 7, "name": "Frillish", "obtainable": 1, "type1": "Water", "type2": "Ghost", },593: { "number": 593, "address":  0x226a36, "bit": 0, "name": "Jellicent", "obtainable": 1, "type1": "Water", "type2": "Ghost", },594: { "number": 594, "address":  0x226a36, "bit": 1, "name": "Alomomola", "obtainable": 1, "type1": "Water", "type2": "", },595: { "number": 595, "address":  0x226a36, "bit": 2, "name": "Joltik", "obtainable": 1, "type1": "Bug", "type2": "Electric", },596: { "number": 596, "address":  0x226a36, "bit": 3, "name": "Galvantula", "obtainable": 1, "type1": "Bug", "type2": "Electric", },597: { "number": 597, "address":  0x226a36, "bit": 4, "name": "Ferroseed", "obtainable": 1, "type1": "Grass", "type2": "Steel", },598: { "number": 598, "address":  0x226a36, "bit": 5, "name": "Ferrothorn", "obtainable": 1, "type1": "Grass", "type2": "Steel", },599: { "number": 599, "address":  0x226a36, "bit": 6, "name": "Klink", "obtainable": 1, "type1": "Steel", "type2": "", },600: { "number": 600, "address":  0x226a36, "bit": 7, "name": "Klang", "obtainable": 1, "type1": "Steel", "type2": "", },601: { "number": 601, "address":  0x226a37, "bit": 0, "name": "Klinklang", "obtainable": 1, "type1": "Steel", "type2": "", },602: { "number": 602, "address":  0x226a37, "bit": 1, "name": "Tynamo", "obtainable": 1, "type1": "Electric", "type2": "", },603: { "number": 603, "address":  0x226a37, "bit": 2, "name": "Eelektrik", "obtainable": 1, "type1": "Electric", "type2": "", },604: { "number": 604, "address":  0x226a37, "bit": 3, "name": "Eelektross", "obtainable": 1, "type1": "Electric", "type2": "", },605: { "number": 605, "address":  0x226a37, "bit": 4, "name": "Elgyem", "obtainable": 1, "type1": "Psychic", "type2": "", },606: { "number": 606, "address":  0x226a37, "bit": 5, "name": "Beheeyem", "obtainable": 1, "type1": "Psychic", "type2": "", },607: { "number": 607, "address":  0x226a37, "bit": 6, "name": "Litwick", "obtainable": 1, "type1": "Ghost", "type2": "Fire", },608: { "number": 608, "address":  0x226a37, "bit": 7, "name": "Lampent", "obtainable": 1, "type1": "Ghost", "type2": "Fire", },609: { "number": 609, "address":  0x226a38, "bit": 0, "name": "Chandelure", "obtainable": 1, "type1": "Ghost", "type2": "Fire", },610: { "number": 610, "address":  0x226a38, "bit": 1, "name": "Axew", "obtainable": 1, "type1": "Dragon", "type2": "", },611: { "number": 611, "address":  0x226a38, "bit": 2, "name": "Fraxure", "obtainable": 1, "type1": "Dragon", "type2": "", },612: { "number": 612, "address":  0x226a38, "bit": 3, "name": "Haxorus", "obtainable": 1, "type1": "Dragon", "type2": "", },613: { "number": 613, "address":  0x226a38, "bit": 4, "name": "Cubchoo", "obtainable": 1, "type1": "Ice", "type2": "", },614: { "number": 614, "address":  0x226a38, "bit": 5, "name": "Beartic", "obtainable": 1, "type1": "Ice", "type2": "", },615: { "number": 615, "address":  0x226a38, "bit": 6, "name": "Cryogonal", "obtainable": 1, "type1": "Ice", "type2": "", },616: { "number": 616, "address":  0x226a38, "bit": 7, "name": "Shelmet", "obtainable": 1, "type1": "Bug", "type2": "", },617: { "number": 617, "address":  0x226a39, "bit": 0, "name": "Accelgor", "obtainable": 1, "type1": "Bug", "type2": "", },618: { "number": 618, "address":  0x226a39, "bit": 1, "name": "Stunfisk", "obtainable": 1, "type1": "Ground", "type2": "Electric", },619: { "number": 619, "address":  0x226a39, "bit": 2, "name": "Mienfoo", "obtainable": 1, "type1": "Fighting", "type2": "", },620: { "number": 620, "address":  0x226a39, "bit": 3, "name": "Mienshao", "obtainable": 1, "type1": "Fighting", "type2": "", },621: { "number": 621, "address":  0x226a39, "bit": 4, "name": "Druddigon", "obtainable": 1, "type1": "Dragon", "type2": "", },622: { "number": 622, "address":  0x226a39, "bit": 5, "name": "Golett", "obtainable": 1, "type1": "Ground", "type2": "Ghost", },623: { "number": 623, "address":  0x226a39, "bit": 6, "name": "Golurk", "obtainable": 1, "type1": "Ground", "type2": "Ghost", },624: { "number": 624, "address":  0x226a39, "bit": 7, "name": "Pawniard", "obtainable": 1, "type1": "Dark", "type2": "Steel", },625: { "number": 625, "address":  0x226a3a, "bit": 0, "name": "Bisharp", "obtainable": 1, "type1": "Dark", "type2": "Steel", },626: { "number": 626, "address":  0x226a3a, "bit": 1, "name": "Bouffalant", "obtainable": 1, "type1": "Normal", "type2": "", },627: { "number": 627, "address":  0x226a3a, "bit": 2, "name": "Rufflet", "obtainable": 0, "type1": "Normal", "type2": "Flying", },628: { "number": 628, "address":  0x226a3a, "bit": 3, "name": "Braviary", "obtainable": 0, "type1": "Normal", "type2": "Flying", },629: { "number": 629, "address":  0x226a3a, "bit": 4, "name": "Vullaby", "obtainable": 1, "type1": "Dark", "type2": "Flying", },630: { "number": 630, "address":  0x226a3a, "bit": 5, "name": "Mandibuzz", "obtainable": 1, "type1": "Dark", "type2": "Flying", },631: { "number": 631, "address":  0x226a3a, "bit": 6, "name": "Heatmor", "obtainable": 1, "type1": "Fire", "type2": "", },632: { "number": 632, "address":  0x226a3a, "bit": 7, "name": "Durant", "obtainable": 1, "type1": "Bug", "type2": "Steel", },633: { "number": 633, "address":  0x226a3b, "bit": 0, "name": "Deino", "obtainable": 1, "type1": "Dark", "type2": "Dragon", },634: { "number": 634, "address":  0x226a3b, "bit": 1, "name": "Zweilous", "obtainable": 1, "type1": "Dark", "type2": "Dragon", },635: { "number": 635, "address":  0x226a3b, "bit": 2, "name": "Hydreigon", "obtainable": 1, "type1": "Dark", "type2": "Dragon", },636: { "number": 636, "address":  0x226a3b, "bit": 3, "name": "Larvesta", "obtainable": 1, "type1": "Bug", "type2": "Fire", },637: { "number": 637, "address":  0x226a3b, "bit": 4, "name": "Volcarona", "obtainable": 1, "type1": "Bug", "type2": "Fire", },638: { "number": 638, "address":  0x226a3b, "bit": 5, "name": "Cobalion", "obtainable": 1, "type1": "Steel", "type2": "Fighting", },639: { "number": 639, "address":  0x226a3b, "bit": 6, "name": "Terrakion", "obtainable": 1, "type1": "Rock", "type2": "Fighting", },640: { "number": 640, "address":  0x226a3b, "bit": 7, "name": "Virizion", "obtainable": 1, "type1": "Grass", "type2": "Fighting", },641: { "number": 641, "address":  0x226a3c, "bit": 0, "name": "Tornadus", "obtainable": 0, "type1": "Flying", "type2": "", },642: { "number": 642, "address":  0x226a3c, "bit": 1, "name": "Thundurus", "obtainable": 0, "type1": "Electric", "type2": "Flying", },643: { "number": 643, "address":  0x226a3c, "bit": 2, "name": "Reshiram", "obtainable": 0, "type1": "Dragon", "type2": "Fire", },644: { "number": 644, "address":  0x226a3c, "bit": 3, "name": "Zekrom", "obtainable": 1, "type1": "Dragon", "type2": "Electric", },645: { "number": 645, "address":  0x226a3c, "bit": 4, "name": "Landorus", "obtainable": 0, "type1": "Ground", "type2": "Flying", },646: { "number": 646, "address":  0x226a3c, "bit": 5, "name": "Kyurem", "obtainable": 1, "type1": "Dragon", "type2": "Ice", },647: { "number": 647, "address":  0x226a3c, "bit": 6, "name": "Keldeo", "obtainable": 0, "type1": "Water", "type2": "Fighting", },648: { "number": 648, "address":  0x226a3c, "bit": 7, "name": "Meloetta", "obtainable": 0, "type1": "Normal", "type2": "Psychic", },649: { "number": 649, "address":  0x226a3d, "bit": 0, "name": "Genesect", "obtainable": 0, "type1": "Bug", "type2": "Steel", },
}

function GetPokemonByProperty(key, value)
{
    return GetPokemonByProperties([ { "key": key, "value": value }])
}

function GetPokemonByProperties(keyValues)
{
    ret = []
    for num in pokemon
    {
        mon = pokemon[num]
        keyValuesMatched = 0
        for keyValue in keyValues
        {
            key = keyValue["key"]
            value = keyValue["value"]
            if (mon[key] == value)
            {
                keyValuesMatched = keyValuesMatched + 1
            }
        }
        
        if (keyValuesMatched == length(keyValues))
        {
            array_push(ret, mon)
        }
    }
    
    return ret
}

function GetObtainablePokemon()
{
    return GetPokemonByProperty("obtainable", 1)
}

function GetPokemonByType(type)
{
    ret = []
    ret = MergeArrays(ret, GetPokemonByProperty("type1", type))
    ret = MergeArrays(ret, GetPokemonByProperty("type2", type))
    return ret
}

function GetPokemonByDualType(type1, type2, obtainableOnly = 0)
{
    ret = []
    obtainable = { "key": "obtainable", "value": 1 }
    if (obtainableOnly == TRUE)
    {
        ret = MergeArrays(ret, GetPokemonByProperties([ { "key": "type1", "value": type1 }, { "key": "type2", "value": type2 }, obtainable ]))
        ret = MergeArrays(ret, GetPokemonByProperties([ { "key": "type1", "value": type2 }, { "key": "type2", "value": type1 }, obtainable ]))
    }
    else
    {
        ret = MergeArrays(ret, GetPokemonByProperties([ { "key": "type1", "value": type1 }, { "key": "type2", "value": type2 } ]))
        ret = MergeArrays(ret, GetPokemonByProperties([ { "key": "type1", "value": type2 }, { "key": "type2", "value": type1 } ]))
    }

    return ret
}

function NumberOfPokemonCaught()
{
    ret = 0
    for num in pokemon
    {
        mon = pokemon[num]
        ret = ret + bit(mon["bit"], mon["address"])
    }
    return ret
}

missablePokemonByPlayerChoice = 12

function TotalNumberOfObtainablePokemonInASingleSaveFile() => length(GetObtainablePokemon()) - missablePokemonByPlayerChoice

function areaId() => word(0x23b444)

locations = {
0x117: {  "id": 0x117, "key": "Entralink", "display": "in the Entralink", },0x118: {  "id": 0x118, "key": "EntreeForestEntrance", "display": "in the Entree Forest", },0x119: {  "id": 0x119, "key": "EntreeForestT2", "display": "in the Entree Forest", },0x11a: {  "id": 0x11a, "key": "EntreeForestTL", "display": "in the Entree Forest", },0x11b: {  "id": 0x11b, "key": "EntreeForestTR", "display": "in the Entree Forest", },0x11d: {  "id": 0x11d, "key": "EntreeForestT1", "display": "in the Entree Forest", },0x11f: {  "id": 0x11f, "key": "EntreeForestBL", "display": "in the Entree Forest", },0x120: {  "id": 0x120, "key": "EntreeForestBR", "display": "in the Entree Forest", },0x1ab: {  "id": 0x1ab, "key": "Aspertia", "display": "in Aspertia City", },0x1ac: {  "id": 0x1ac, "key": "PlayerHouse", "display": "home", },0x1ad: {  "id": 0x1ad, "key": "AspertiaHouseCL1F", "display": "in Aspertia City", },0x1ae: {  "id": 0x1ae, "key": "AspertiaHouseCL2F", "display": "in Aspertia City", },0x1af: {  "id": 0x1af, "key": "AspertiaHouseBL1F", "display": "in Aspertia City", },0x1b0: {  "id": 0x1b0, "key": "AspertiaHouseBL2F", "display": "in Aspertia City", },0x1b1: {  "id": 0x1b1, "key": "AspertiaHouseTR1F", "display": "in Aspertia City", },0x1b2: {  "id": 0x1b2, "key": "AspertiaHouseTR2F", "display": "in Aspertia City", },0x1b3: {  "id": 0x1b3, "key": "AspertiaPokemonCenter", "display": "at the Aspertia City Pokémon Center", },0x1b4: {  "id": 0x1b4, "key": "TrainerSchool", "display": "at the Trainer School", },0x1b5: {  "id": 0x1b5, "key": "Route19", "display": "on Route 19", },0x1b6: {  "id": 0x1b6, "key": "AspertiaGate", "display": "at the Aspertia gate", },0x1b7: {  "id": 0x1b7, "key": "Floccesy", "display": "in Floccesy Town", },0x1b8: {  "id": 0x1b8, "key": "FloccesyDojo", "display": "in Floccesy Town", },0x1b9: {  "id": 0x1b9, "key": "FloccesyHouseBC", "display": "in Floccesy Town", },0x1ba: {  "id": 0x1ba, "key": "FloccesyHouseBR", "display": "in Floccesy Town", },0x1bb: {  "id": 0x1bb, "key": "FloccesyPokemonCenter", "display": "at the Floccesy Town Pokémon Center", },0x1bc: {  "id": 0x1bc, "key": "Route20Ranch", "display": "at Floccesy Ranch", },0x1bd: {  "id": 0x1bd, "key": "FloccesyRanch", "display": "at Floccesy Ranch", },0x1be: {  "id": 0x1be, "key": "Route20", "display": "on Route 20", },0x1bf: {  "id": 0x1bf, "key": "Route20Gate", "display": "at the Route 20 gate", },0x1c0: {  "id": 0x1c0, "key": "Virbank", "display": "in Virbank City", },0x1c1: {  "id": 0x1c1, "key": "VirbankHouseTR", "display": "in Virbank City", },0x1c2: {  "id": 0x1c2, "key": "VirbankBusiness", "display": "at the Virbank City port", },0x1c6: {  "id": 0x1c6, "key": "VirbankPokemonCenter", "display": "in the Virbank City Pokémon Center", },0x1c8: {  "id": 0x1c8, "key": "VirbankComplex", "display": "in the Virbank Complex", },0x1e9: {  "id": 0x1e9, "key": "AspertiaGym", "display": "at the Aspertia City Gym", },0x1C7: {  "id": 0x1C7, "key": "VirbankGymEntrance", "display": "at the Virbank City Gym", },0x1f6: {  "id": 0x1f6, "key": "VirbankGym", "display": "at the Virbank City Gym", },0x1c9: {  "id": 0x1c9, "key": "VirbankComplexArea2", "display": "in the Virbank Complex", },0x1c5: {  "id": 0x1c5, "key": "VirbankGate", "display": "at the Virbank gate", },0x238: {  "id": 0x238, "key": "PokestarShoot", "display": "at Pokéstar Studios", },0x237: {  "id": 0x237, "key": "PokestarStage", "display": "at Pokéstar Studios", },0x236: {  "id": 0x236, "key": "PokestarHub", "display": "at Pokéstar Studios", },0x23e: {  "id": 0x23e, "key": "PokestarTheatre", "display": "at Pokéstar Studios", },0x1c4: {  "id": 0x1c4, "key": "SailingToCastelia", "display": "sailing to Castelia City", },0x26: {  "id": 0x26, "key": "LibertyPier", "display": "in Castelia City", },0x1c: {  "id": 0x1c, "key": "Castelia", "display": "in Castelia City", },0x2c: {  "id": 0x2c, "key": "BattleCompany1F", "display": "in Castelia City", },0x2d: {  "id": 0x2d, "key": "BattleCompany47F", "display": "in Castelia City", },0x2e: {  "id": 0x2e, "key": "BattleCompany55F", "display": "in Castelia City", },0x29: {  "id": 0x29, "key": "CasteliaPokemonCenter", "display": "in the Castelia City Pokémon Center", },0x28: {  "id": 0x28, "key": "CasteliaEasternDock", "display": "in Castelia City", },0x22: {  "id": 0x22, "key": "CasteliaStreet", "display": "in Castelia City", },0x2f: {  "id": 0x2f, "key": "GameFreakHQ1F", "display": "at Game Freak HQ", },0x30: {  "id": 0x30, "key": "GameFreakHQ22F", "display": "at Game Freak HQ", },0x36: {  "id": 0x36, "key": "CasteliaStreetLeftBuilding1F", "display": "in Castelia City", },0x37: {  "id": 0x37, "key": "CasteliaStreetLeftBuilding11F", "display": "in Castelia City", },0x21: {  "id": 0x21, "key": "ModeStreet", "display": "in Castelia City", },0x2b: {  "id": 0x2b, "key": "StudioCastelia", "display": "in Castelia City", },0x23: {  "id": 0x23, "key": "NarrowStreet", "display": "in Castelia City", },0x35: {  "id": 0x35, "key": "CafeSonata", "display": "in Castelia City", },0x2a: {  "id": 0x2a, "key": "PasserbyAnalytics", "display": "in Castelia City", },0x1f: {  "id": 0x1f, "key": "CasteliaWestStreet", "display": "in Castelia City", },0x38: {  "id": 0x38, "key": "NameRaterBuilding1F", "display": "in Castelia City", },0x39: {  "id": 0x39, "key": "MedalOffice", "display": "in Castelia City", },0x1ee: {  "id": 0x1ee, "key": "AmanitaOffice", "display": "in Castelia City", },0x1e: {  "id": 0x1e, "key": "CasteliaCentralPlaza", "display": "in Castelia City", },0x20: {  "id": 0x20, "key": "ModeStreet2", "display": "in Castelia City", },0x3c: {  "id": 0x3c, "key": "ModeStreetRightBuilding1F", "display": "in Castelia City", },0x3d: {  "id": 0x3d, "key": "ModeStreetRightBuilding47F", "display": "in Castelia City", },0x31: {  "id": 0x31, "key": "ModeStreetLeftBuilding1F", "display": "in Castelia City", },0x32: {  "id": 0x32, "key": "ModeStreetLeftBuilding11F", "display": "in Castelia City", },0x33: {  "id": 0x33, "key": "CasteliaGate", "display": "at the Castelia Gate", },0x1ef: {  "id": 0x1ef, "key": "CasteliaSewers1", "display": "in the Castelia sewers", },0x1f1: {  "id": 0x1f1, "key": "CasteliaSewers2", "display": "in the Castelia sewers", },0x1f3: {  "id": 0x1f3, "key": "CasteliaSewers3", "display": "in the Castelia sewers", },0x1f7: {  "id": 0x1f7, "key": "RelicPassage", "display": "going through Relic Passage", },0x1d: {  "id": 0x1d, "key": "CasteliaGym", "display": "in the Castelia City Gym", },0x1e8: {  "id": 0x1e8, "key": "CasteliaGymLeader", "display": "in the Castelia City Gym", },0xfc: {  "id": 0xfc, "key": "BridgeGate", "display": "at the bridge gate", },0x24: {  "id": 0x24, "key": "CasteliaLeftPier", "display": "in Castelia City", },0xeb: {  "id": 0xeb, "key": "LibertyGarden", "display": "in Liberty Garden", },0xec: {  "id": 0xec, "key": "LibertyLighthouse", "display": "in the Liberty Lighthouse", },0x146: {  "id": 0x146, "key": "Route4", "display": "on Route 4", },0x147: {  "id": 0x147, "key": "Route4House", "display": "on Route 4", },0x208: {  "id": 0x208, "key": "Route4House2", "display": "on Route 4", },0x209: {  "id": 0x209, "key": "Route4House2Upstairs", "display": "on Route 4", },0x207: {  "id": 0x207, "key": "Route4HouseUpstairs", "display": "on Route 4", },0x20a: {  "id": 0x20a, "key": "Route4House3", "display": "on Route 4", },0x20b: {  "id": 0x20b, "key": "Route4House3Upstairs", "display": "on Route 4", },0x20c: {  "id": 0x20c, "key": "Route4House4", "display": "on Route 4", },0x20d: {  "id": 0x20d, "key": "Route4House4Upstairs", "display": "on Route 4", },0x1ea: {  "id": 0x1ea, "key": "JoinAvenue", "display": "on Join Avenue", },0x1eb: {  "id": 0x1eb, "key": "JoinAvenueOffice", "display": "at the Join Avenue office", },0x3e: {  "id": 0x3e, "key": "Nimbasa", "display": "in Nimbasa City", },0x41: {  "id": 0x41, "key": "NimbasaPokemonCenter", "display": "in the Nimbasa City Pokémon Center", },0x40: {  "id": 0x40, "key": "NimbasaPark", "display": "in Nimbasa City", },0x249: {  "id": 0x249, "key": "NimbasaRollerCoaster", "display": "in Nimbasa City", },0x5c: {  "id": 0x5c, "key": "NimbasaGateEast", "display": "at the Nimbasa Gate", },0x17f: {  "id": 0x17f, "key": "Route16", "display": "on Route 16", },0x4f: {  "id": 0x4f, "key": "BigStadiumLobby", "display": "at the Big Stadium", },0x52: {  "id": 0x52, "key": "BigStadium", "display": "at the Big Stadium", },0x50: {  "id": 0x50, "key": "BigStadiumBleachers", "display": "at the Big Stadium", },0x54: {  "id": 0x54, "key": "SmallCourtLobby", "display": "at the Small Court", },0x55: {  "id": 0x55, "key": "SmallCourtBleachers", "display": "at the Small Court", },0x57: {  "id": 0x57, "key": "SmallCourt", "display": "at the Small Court", },0x5b: {  "id": 0x5b, "key": "NimbasaGateWest", "display": "at the Nimbasa Gate", },0x149: {  "id": 0x149, "key": "Route5", "display": "on Route 5", },0x58: {  "id": 0x58, "key": "NimbasaHouseLeft1F", "display": "in Nimbasa City", },0x59: {  "id": 0x59, "key": "NimbasaHouseLeft2F", "display": "in Nimbasa City", },0x5e: {  "id": 0x5e, "key": "NimbasaHouseRight1F", "display": "in Nimbasa City", },0x5f: {  "id": 0x5f, "key": "NimbasaHouseRight2F", "display": "in Nimbasa City", },0x9d: {  "id": 0x9d, "key": "DesertResort1", "display": "in the Desert Resort", },0x9f: {  "id": 0x9f, "key": "DesertResortGate", "display": "at the Desert Resort Gate", },0x9e: {  "id": 0x9e, "key": "DesertResort2", "display": "in the Desert Resort", },0xa0: {  "id": 0xa0, "key": "RelicCastle1F", "display": "in the Relic Castle", },0xa1: {  "id": 0xa1, "key": "RelicCastleB1F", "display": "in the Relic Castle", },0x148: {  "id": 0x148, "key": "Route5House", "display": "on Route 5", },0x42: {  "id": 0x42, "key": "GearStation", "display": "at the Gear Station", },0x4a: {  "id": 0x4a, "key": "GearStationAnvillePlatform", "display": "at the Gear Station", },0x48: {  "id": 0x48, "key": "GearStationSuperMultiPlatform", "display": "at the Gear Station", },0x47: {  "id": 0x47, "key": "GearStationMultiPlatform", "display": "at the Gear Station", },0x49: {  "id": 0x49, "key": "GearStationWiFiPlatform", "display": "at the Gear Station", },0x43: {  "id": 0x43, "key": "GearStationSinglePlatform", "display": "at the Gear Station", },0x44: {  "id": 0x44, "key": "GearStationSuperSinglePlatform", "display": "at the Gear Station", },0x45: {  "id": 0x45, "key": "GearStationDoublePlatform", "display": "at the Gear Station", },0x46: {  "id": 0x46, "key": "GearStationSuperDoublePlatform", "display": "at the Gear Station", },0x1a2: {  "id": 0x1a2, "key": "AnvilleTown", "display": "in Anville Town", },0x1a3: {  "id": 0x1a3, "key": "AnvilleTownHouse1", "display": "in Anville Town", },0x1a4: {  "id": 0x1a4, "key": "AnvilleTownHouse2", "display": "in Anville Town", },0x1a5: {  "id": 0x1a5, "key": "AnvilleTownHouse3", "display": "in Anville Town", },0x4d: {  "id": 0x4d, "key": "Theatre", "display": "in the Musical Theater", },0x51: {  "id": 0x51, "key": "BigStadium2", "display": "at the Big Stadium", },0x56: {  "id": 0x56, "key": "SmallCourt2", "display": "at the Small Court", },0x206: {  "id": 0x206, "key": "SecretGrotto1", "display": "in a Secret Grotto…", },0x3f: {  "id": 0x3f, "key": "NimbasaGym", "display": "in the Nimbasa City Gym", },0xfd: {  "id": 0xfd, "key": "DriftveilDrawbridge", "display": "on Driftveil Drawbridge", },0x60: {  "id": 0x60, "key": "DriftveilCity", "display": "in Driftveil City", },0x65: {  "id": 0x65, "key": "GrandHotel1F", "display": "in Driftveil City", },0x221: {  "id": 0x221, "key": "GrandHotel14F", "display": "in Driftveil City", },0x222: {  "id": 0x222, "key": "GrandHotel19F", "display": "in Driftveil City", },0x69: {  "id": 0x69, "key": "DriftveilMarket", "display": "in Driftveil City", },0x66: {  "id": 0x66, "key": "LuxurySuites", "display": "in Driftveil City", },0x223: {  "id": 0x223, "key": "LuxurySuites19F", "display": "in Driftveil City", },0x224: {  "id": 0x224, "key": "LuxurySuites23F", "display": "in Driftveil City", },0x6a: {  "id": 0x6a, "key": "PWTGate", "display": "in Driftveil City", },0x64: {  "id": 0x64, "key": "ChateauHotel", "display": "in Driftveil City", },0x21f: {  "id": 0x21f, "key": "ChateauHotel11F", "display": "in Driftveil City", },0x220: {  "id": 0x220, "key": "ChateauHotel25F", "display": "in Driftveil City", },0x67: {  "id": 0x67, "key": "ContinentalHotel", "display": "in Driftveil City", },0x225: {  "id": 0x225, "key": "ContinentalHotel23F", "display": "in Driftveil City", },0x226: {  "id": 0x226, "key": "ContinentalHotel25F", "display": "in Driftveil City", },0x63: {  "id": 0x63, "key": "DriftveilPokemonCenter", "display": "in the Driftveil City Pokémon Center", },0x14b: {  "id": 0x14b, "key": "Route6", "display": "on Route 6", },0x62: {  "id": 0x62, "key": "DriftveilGymLobby", "display": "in the Driftveil City Gym", },0x61: {  "id": 0x61, "key": "DriftveilGym", "display": "in the Driftveil City Gym", },0x14c: {  "id": 0x14c, "key": "SeasonResearchLab", "display": "in the Season Research Lab", },0x150: {  "id": 0x150, "key": "Route6House", "display": "on Route 6", },0xc2: {  "id": 0xc2, "key": "ChargestoneCaveOutside", "display": "in Chargestone Cave", },0xc3: {  "id": 0xc3, "key": "ChargestoneCaveLobby", "display": "in Chargestone Cave", },0xbf: {  "id": 0xbf, "key": "PWT", "display": "at the Pokémon World Tournament", },0xc0: {  "id": 0xc0, "key": "PWTBuilding", "display": "at the Pokémon World Tournament", },0xc1: {  "id": 0xc1, "key": "PWTArena", "display": "at the Pokémon World Tournament", },0x228: {  "id": 0x228, "key": "PlasmaFrigate", "display": "on the Plasma Frigate", },0x1f9: {  "id": 0x1f9, "key": "RelicPassage2", "display": "going through Relic Passage", },0x1f8: {  "id": 0x1f8, "key": "RelicPassage3", "display": "going through Relic Passage", },0xc4: {  "id": 0xc4, "key": "ChargestoneCaveB1F", "display": "in Chargestone Cave", },0x6b: {  "id": 0x6b, "key": "MistraltonCity", "display": "in Mistralton City", },0x6d: {  "id": 0x6d, "key": "MistraltonPokemonCenter", "display": "in the Mistralton City Pokémon Center", },0x70: {  "id": 0x70, "key": "MistraltonHouseRight", "display": "in Mistralton City", },0x6e: {  "id": 0x6e, "key": "MistraltonHouseCenter", "display": "in Mistralton City", },0x6f: {  "id": 0x6f, "key": "MistraltonCargoService", "display": "in Mistralton City", },0x6c: {  "id": 0x6c, "key": "MistraltonGym", "display": "in the Mistralton City Gym", },0x151: {  "id": 0x151, "key": "Route7", "display": "on Route 7", },0x157: {  "id": 0x157, "key": "Route7House", "display": "on Route 7", },0x158: {  "id": 0x158, "key": "Route7House2", "display": "on Route 7", },0xc6: {  "id": 0xc6, "key": "TwistMountainOutside", "display": "near Twist Mountain", },0x152: {  "id": 0x152, "key": "CelestialTower", "display": "in Celestial Tower", },0x153: {  "id": 0x153, "key": "CelestialTower2F", "display": "in Celestial Tower", },0x1ca: {  "id": 0x1ca, "key": "LentimasTown", "display": "in Lentimas Town", },0x1cb: {  "id": 0x1cb, "key": "LentimasTownHouse1", "display": "in Lentimas Town", }, 0x1cc: {  "id": 0x1cc, "key": "LentimasTownPokemonCenter", "display": "in the Lentimas Town Pokémon Center", }, 0x260: {  "id": 0x260, "key": "LentimasTownHouse2", "display": "in Lentimas Town", }, 0x1cd: {  "id": 0x1cd, "key": "ReversalMountain", "display": "on Reversal Mountain", }, 0x213: {  "id": 0x213, "key": "ReversalMountain1", "display": "inside Reversal Mountain", }, 0x215: {  "id": 0x215, "key": "ReversalMountain2", "display": "inside Reversal Mountain", }, 0x218: {  "id": 0x218, "key": "ReversalMountain3", "display": "inside Reversal Mountain", }, 0x19c: {  "id": 0x19c, "key": "UndellaTown", "display": "in Undella Town", }, 0x19f: {  "id": 0x19f, "key": "UndellaTownHouse1", "display": "in Undella Town", }, 0x1a0: {  "id": 0x1a0, "key": "UndellaTownHouse2", "display": "in Undella Town", }, 0x176: {  "id": 0x176, "key": "Route14", "display": "on Route 14", }, 0x19d: {  "id": 0x19d, "key": "UndellaTownPokemonCenter", "display": "in the Undella Town Pokémon Center", }, 0x174: {  "id": 0x174, "key": "UndellaGate", "display": "at the Undella Gate", }, 0x172: {  "id": 0x172, "key": "Route13", "display": "on Route 13", }, 0x175: {  "id": 0x175, "key": "Route13House", "display": "on Route 13", }, 0x196: {  "id": 0x196, "key": "LacunosaTown", "display": "in Lacunosa Town", }, 0x199: {  "id": 0x199, "key": "LacunosaTownOldLadyHouse", "display": "in Lacunosa Town", }, 
}

function GetLocationByKey(key)
{
    for i in locations
    {
        location = locations[i]
        
        if (location["key"] == key)
        {
            return location
        }
    }
}

function IsInLocation(key)
{
    location = GetLocationByKey(key)
    return areaId() == location["id"]
}

function WasJustInLocation(key)
{
    location = GetLocationByKey(key)
    return Delta(areaId()) == location["id"]
}

function char1() => word(0x21e9e8)
function char2() => word(0x21e9ea)
function char3() => word(0x21e9ec)
function char4() => word(0x21e9ee)
function char5() => word(0x21e9f0)
function char6() => word(0x21e9f2)
function char7() => word(0x21e9f4)

function GetCharactersForRichPresence()
{
    characters = { 0x0041: "A", 0x0042: "B", 0x0043: "C", 0x0044: "D", 0x0045: "E", 0x0046: "F", 0x0047: "G", 0x0048: "H", 0x0049: "I", 0x004a: "J", 0x004b: "K", 0x004c: "L", 0x004d: "M", 0x004e: "N", 0x004f: "O", 0x0050: "P", 0x0051: "Q", 0x0052: "R", 0x0053: "S", 0x0054: "T", 0x0055: "U", 0x0056: "V", 0x0057: "W", 0x0058: "X", 0x0059: "Y", 0x005a: "Z", 0x0061: "a", 0x0062: "b", 0x0063: "c", 0x0064: "d", 0x0065: "e", 0x0066: "f", 0x0067: "g", 0x0068: "h", 0x0069: "i", 0x006a: "j", 0x006b: "k", 0x006c: "l", 0x006d: "m", 0x006e: "n", 0x006f: "o", 0x0070: "p", 0x0071: "q", 0x0072: "r", 0x0073: "s", 0x0074: "t", 0x0075: "u", 0x0076: "v", 0x0077: "w", 0x0078: "x", 0x0079: "y", 0x007a: "z", 0x0030: "0", 0x0031: "1", 0x0032: "2", 0x0033: "3", 0x0034: "4", 0x0035: "5", 0x0036: "6", 0x0037: "7", 0x0038: "8", 0x0039: "9", 0x002c: ",", 0x002e: ".", 0x0027: "’", 0x246d: "♂", 0x246e: "♀", 0x003a: ":", 0x003b: ";", 0x0021: "!", 0x003f: "?", 0x201c: "“", 0x201d: "”", 0x2018: "‘", 0x0028: "(", 0x0029: ")", 0x246c: "…", 0xff65: "‧", 0x007e: "~", 0x0023: "#", 0x0025: "﹪", 0x002b: "+", 0x002d: "-", 0x002a: "*", 0x002f: "/", 0x003d: "=", 0x2474: "⊙", 0x2475: "Ο", 0x2476: "□", 0x2477: "△", 0x2478: "♢", 0x246f: "♠", 0x2471: "♥", 0x2472: "♦", 0x2470: "♣", 0x2473: "🟉", 0x2479: "♪", 0x247a: "☀", 0x247b: "☁", 0x247c: "☂", 0x247d: "☃", 0x247e: "😀", 0x247f: "😎", 0x2480: "😫", 0x2481: "😡", 0x2484: "⒵", 0x2482: "⮭", 0x2483: "⮯", }
    return characters
}

function GetLocationsForRichPresence()
{
    rpLocations = {}
    for id in locations
    {
        location = locations[id]
        locationString = location["display"]

        rpLocations[location["id"]] = locationString
    }
    return rpLocations
}

function IsInGame() => areaId() != 0x0

function IsLoadingSaveFile() => Delta(areaId()) == 0x0 && areaId() == 0x3213

function hours() => word(0x24279c)
function minutes() => byte(0x24279e)
function seconds() => byte(0x24279f)

function PlayTimeInSeconds()
{
    return hours() * 3600 + minutes() * 60 + seconds()
}

rich_presence_conditional_display(!IsInGame(), "On the title screen...")
rich_presence_display("{0}{1}{2}{3}{4}{5}{6} is {7} | {8}/{10} Caught | Play Time: {9}",
    rich_presence_lookup("Characters", char1(), GetCharactersForRichPresence()),
    rich_presence_lookup("Characters", char2(), GetCharactersForRichPresence()),
    rich_presence_lookup("Characters", char3(), GetCharactersForRichPresence()),
    rich_presence_lookup("Characters", char4(), GetCharactersForRichPresence()),
    rich_presence_lookup("Characters", char5(), GetCharactersForRichPresence()),
    rich_presence_lookup("Characters", char6(), GetCharactersForRichPresence()),
    rich_presence_lookup("Characters", char7(), GetCharactersForRichPresence()),
    rich_presence_lookup("Locations", areaId(), GetLocationsForRichPresence(), "somewhere in Unova"),
    rich_presence_value("Caught", NumberOfPokemonCaught(), "VALUE"),
    rich_presence_value("PlayTime", PlayTimeInSeconds(), "SECS"),
    rich_presence_value("Catchable", TotalNumberOfObtainablePokemonInASingleSaveFile(), "VALUE")
)

function WasValueSet(mem, oldValue, newValue)
{
    return once(IsValueJustSet(mem, oldValue, newValue))
}

function IsValueJustSet(mem, oldValue, newValue)
{
    return Delta(mem) == oldValue && mem == newValue
}

function WasValueSetInGame(mem, oldValue, newValue)
{
    return never(!IsInGame()) && WasValueSet(mem, oldValue, newValue)
}

function WasBitflagSetInGame(mem)
{
    return WasValueSetInGame(mem, 0, 1)
}

// This function allows the creation of achievements with built-in save protection that deal with a collection of values being set
// throughout the game. The schemas for both parameters are as follows:
//
// cheevo: "name": title
//         "description": self-explanatory
//         "points": self-explanatory
//         "threshold": how many values in the "addresses" dictionary must be set before this achievement is triggered
//
// conditions: "countsWhen": the condition that must be true in order for it to be counted in the total
//             "recalculateWhen": the condition that indicates that relevant values in the condition have changed,
//                                and so everything must be recalculated
//
// onlyAvailableWhen: A condition that must be true in all conditions for the achievement to trigger.
function GenerateCheevoFromConditions(cheevo, conditions, onlyAvailableWhen)
{
    loadedCounts = []
    totalCounts = []
    resetAlt = always_false()

    for i in conditions
    {
        condition = conditions[i]
        
        // This is the score when the game is loaded. If the loaded score is greater than or equal to the threshold--that is,
        // if the save file would satisfy enough conditions to trigger the achievement on load--this should trigger a
        // permanant pauselock to serve as save protection.
        array_push(loadedCounts, once(condition["countsWhen"] && IsLoadingSaveFile()))
        
        // We want both loaded and session counts here (that is, we don't care if we're loading a save file when these are tallied).
        // This way, loading a save doesn't invalidate the achievement outright if a player hasn't actually earned it yet.
        array_push(totalCounts, once(condition["countsWhen"]))
        
        resetAlt = resetAlt || condition["recalculateWhen"]
    }

    achievement(title = cheevo["name"], description = cheevo["description"], points = cheevo["points"], badge = cheevo["badge"],
        trigger = IsInGame() &&
            measured(tally(cheevo["threshold"], totalCounts)) && unless(tally(cheevo["threshold"], loadedCounts))
            && never(resetAlt) && onlyAvailableWhen && (always_false() || never(Delta(char1()) == 0 && char1() == 0))
    )
}

function GenerateConditionFromBitflag(bit)
{
    return { "countsWhen": (bit == 1), "recalculateWhen": (Delta(bit) != bit) }
}

pokemonConditions = {}
obtainablePokemon = GetObtainablePokemon()
for mon in obtainablePokemon
{
    pokemonConditions[mon["number"]] = GenerateConditionFromBitflag(bit(mon["bit"], mon["address"]))
}

GenerateCheevoFromConditions({
    "name": "Save Protection Test",
    "description": "If this triggers on load, then there's a problem!",
    "points": 0,
    "threshold": 3,
    "badge": "00000"
}, pokemonConditions, always_true())

GenerateCheevoFromConditions({
    "name": "A Long Way to Go",
    "description": "Obtain 10% of all Pokemon that can be caught in a single save file.",
    "points": 5,
    "threshold": (TotalNumberOfObtainablePokemonInASingleSaveFile() / 10),
    "badge": "00000"
}, pokemonConditions, always_true())

GenerateCheevoFromConditions({
    "name": "Coming Together",
    "description": "Obtain 25% of all Pokemon that can be caught in a single save file.",
    "points": 10,
    "threshold": (TotalNumberOfObtainablePokemonInASingleSaveFile() / 4),
    "badge": "00000"
}, pokemonConditions, always_true())

GenerateCheevoFromConditions({
    "name": "Really Filling Up",
    "description": "Obtain 50% of all Pokemon that can be caught in a single save file.",
    "points": 25,
    "threshold": (TotalNumberOfObtainablePokemonInASingleSaveFile() / 2),
    "badge": "00000"
}, pokemonConditions, always_true())

GenerateCheevoFromConditions({
    "name": "Gotta Catch 'Em All! - Black 2",
    "description": ("Obtain all " + TotalNumberOfObtainablePokemonInASingleSaveFile() + " Pokemon that can be caught in a single save file."),
    "points": 50,
    "threshold": TotalNumberOfObtainablePokemonInASingleSaveFile(),
    "badge": "00000"
}, pokemonConditions, always_true())


// 1 = Got free Potion at the Aspertia Gate
function aspertiaGateFlag() => byte(0x2256a4)

// 1 = Met rival for the first time
// 2 = Rival stays behind before the outlook
// 3 = Met Bianca for the first time
// 4 = Obtained starter Pokemon
// 5 = Rival gets his Pokedex
// 6 = Pokemon Center tutorial complete
// 7 = Got the Running Shoes
function openingFlag() => byte(0x225626)
achievement(title = "Onto the Road", points = 1, badge = "00000",
    description = "Step into the Aspertia Gate for the first time with your new starter Pokemon in tow.",
    trigger = aspertiaGateFlag() == 0 && openingFlag() == 7 && IsInLocation("AspertiaGate")
)

medalConditions = {}
for i in range(0x22a8e6, 0x22acde, 4)
{
    medalConditions[i] = GenerateConditionFromBitflag(bit2(i))
}

GenerateCheevoFromConditions({
    "name": "Rookie Medalist",
    "points": 10,
    "badge": "00000",
    "description": "Earn fifty medals.",
    "threshold": 50
}, medalConditions, always_true())

function numberOfPokemonInPlayerParty() => byte(0x21e3e8)
function pokemonSlotOffset() => 0x224
function pokemonBattleSlot1BaseAddr() => 0x25b1f0
function musicId() => word(0x243ae0)
function GymLeaderVictoryMusicIsPlaying() => musicId() == 0x47e

// 0x426 = Gym
// 0x46c = Gym Leader battle
function GymMusicIsPlaying() => musicId() == 0x426
function GymLeaderBattleStarted() => CreateHitTargetedAndNextChain([ Delta(musicId()) == 0x426, musicId() == 0, musicId() == 0x46c ])

// Battle slots appear to function like a twelve-item array. The player fills slots until they run out of Pokemon, at which point the slots get filled by the opponent's Pokemon.
//
// For example, if the player has two Pokemon and the opponent has three, the array will look like this:
//
// [p1] [p2] [o1] [o2] [o3] [] [] [] [] [] [] []
//
// Each slot has an offset difference of 0x224.
// This function assumes a zero-based index.
function GetPokemonInBattleSlot(slotId)
{
    slotBaseAddr = tbyte(PlayerPokemonSlotAddress(slotId))
    return GetPokemonByPointer(slotBaseAddr)
}

function GetPokemonByPointer(pointer)
{
    return {
        "id": word(pointer + 0xc),
        "level": byte(pointer + 0x18)
    }
}

function playerCurrentPokemonPointer() => tbyte(0x25736c)
function NumberOfGivenPokemonSwitchedIn(number, haystack)
{
    needle = GetPokemonByPointer(playerCurrentPokemonPointer())
    ret = []
    
    for pokemon in haystack
    {
        array_push(ret, once(Delta(needle["id"]) != pokemon["number"] && needle["id"] == pokemon["number"]))
    }
    
    return tally(number, ret)
}

function PlayerPokemonSlotAddress(slotId) => playerSlot1PokemonPointerBaseAddr() + slotId * 4

function PlayerPokemonSlotJustLoaded(slotId)
{
    slot = dword(PlayerPokemonSlotAddress(slotId))
    return Delta(slot) == 0 && slot > 0x02000000 && slot < 0x02ffffff
}

function VictoriousWhenPartyLevelIsAtMost(level, maxPartySize, when = always_true())
{
    trigger = always_false()
    
    for i in range(0, maxPartySize - 1)
    {
        subtrigger = always_true()
        for j in range(0, i)
        {
            mon = GetPokemonInBattleSlot(j)
            subtrigger = subtrigger && mon["level"] <= level
        }
        
        trigger = trigger || once(numberOfPokemonInPlayerParty() == i + 1 && subtrigger && PlayerPokemonSlotJustLoaded(i))
    }
    
    return trigger && trigger_when(when)
}

function VictoriousWhenMaxPartyLevelIsAtMostWhenGymLeaderBattleStarts(level, maxPartySize)
{
    return VictoriousWhenPartyLevelIsAtMost(level, maxPartySize, GymLeaderVictoryMusicIsPlaying())
}

function HasAtLeastOneGivenPokemonInParty(allowedPokemon, maxPartySize, checkExactSize = true)
{
    trigger = always_false()
    
    for i in range(0, maxPartySize - 1)
    {
        allowedPokemonWasFoundInSlot = always_false()
        for j in range(0, i)
        {
            mon = GetPokemonInBattleSlot(j)
            for allowedMon in allowedPokemon
            {
                allowedPokemonWasFoundInSlot = allowedPokemonWasFoundInSlot || mon["id"] == allowedMon["number"]
            }
        }
        
        checkpoint = allowedPokemonWasFoundInSlot && PlayerPokemonSlotJustLoaded(i)
        
        if (checkExactSize == true)
        {
            checkpoint = checkpoint && numberOfPokemonInPlayerParty() == i + 1
        }
        
        trigger = trigger || once(checkpoint)
    }
    
    return trigger
}

function HasOnlyGivenPokemonInParty(allowedPokemon, maxPartySize)
{
    trigger = always_false()
    
    for i in range(0, maxPartySize - 1)
    {
        allowedPokemonWasFoundInSlot = always_false()
        for j in range(0, i)
        {
            mon = GetPokemonInBattleSlot(j)
            for allowedMon in allowedPokemon
            {
                allowedPokemonWasFoundInSlot = allowedPokemonWasFoundInSlot || mon["id"] == allowedMon["number"]
            }
        }
        
        trigger = trigger || once(numberOfPokemonInPlayerParty() == i + 1 && allowedPokemonWasFoundInSlot && PlayerPokemonSlotJustLoaded(i))
    }
    
    return trigger
}

function playerSlot1PokemonPointerBaseAddr() => 0x2573ec
function playerSlot1PokemonPointer() => dword(playerSlot1PokemonPointerBaseAddr())
function GymLeaderBattleMusicIsPlaying() => musicId() == 0x46c
function PlayerSlot1PokemonJustLoaded() => Delta(playerSlot1PokemonPointer()) == 0 && playerSlot1PokemonPointer() > 0x02000000 && playerSlot1PokemonPointer() < 0x02ffffff
function PlayerSlot1PokemonJustLoadedInGymBattle() => PlayerSlot1PokemonJustLoaded() && GymLeaderBattleMusicIsPlaying()

AnEvenFightBattleStartedCallback = GymLeaderBattleStarted
achievement(title = "An Even Fight [m]", points = 10, badge = "00000",
    description = "Defeat Cheren with a party of at most two Pokemon with a max level of 10.",
    trigger = VictoriousWhenMaxPartyLevelIsAtMostWhenGymLeaderBattleStarts(10, 2)
        && never(!IsInLocation("AspertiaGym")) && never(GymMusicIsPlaying()) // Must be battling the Gym Leader while in the Aspertia Gym
)

function basicBadge() => bit0(0x2266e8)
achievement(title = "Elementary, My Dear", points = 5, badge = "00000",
    description = "Obtain the Basic Badge.",
    trigger = WasBitflagSetInGame(basicBadge())
)

function buttonInputFlags1Addr() => 0x1ff99c
function BButtonIsPressed() => bit1(buttonInputFlags1Addr()) == 1
function DirectionIsPressed() => high4(buttonInputFlags1Addr()) > 0
function XCoord() => byte(0x23b44a)
function YCoord() => byte(0x23b452)
function ZCoord() => byte(0x23b44e)
achievement(title = "Hardcore Parkour", points = 5, badge = "00000",
    description = "Sprint from Worker Isaac to Youngster Waylon without either touching ground level or letting go of a direction.",
    trigger = once(YCoord() == 0x33 && Delta(XCoord()) == 0x1d && XCoord() == 0x1c) // From Worker Isaac
        && trigger_when(ZCoord() == 2 && XCoord() == 8 && Delta(YCoord()) == 0x1e && YCoord() == 0x1d) // To Youngster Waylon (or at least the tile two x-coordinates in front of him)
        && never(Delta(ZCoord()) == 1 && ZCoord() == 0) // Made it to ground level
        && never(!IsInLocation("VirbankComplexArea2"))
        && never(!BButtonIsPressed()) && never(!DirectionIsPressed()) // Must always be sprinting and holding a direction
)

steelPokemon = GetPokemonByType("Steel")
firePokemon = GetPokemonByType("Fire")
function RoxieGymMusicIsPlaying() => musicId() == 0x44c
achievement(title = "Abandon the Forge [m]", points = 10, badge = "00000",
    description = "Defeat Roxie with a party containing no Steel- or Fire-type Pokemon (max Level 15, max party of 3).",
    trigger = VictoriousWhenMaxPartyLevelIsAtMostWhenGymLeaderBattleStarts(15, 3)
        && never(!IsInLocation("VirbankGym")) && never(RoxieGymMusicIsPlaying()) // Must be battling the Gym Leader while in the Virbank Gym
        && never(HasAtLeastOneGivenPokemonInParty(steelPokemon, 3))
        && never(HasAtLeastOneGivenPokemonInParty(firePokemon, 3))
)

function toxicBadge() => bit1(0x2266e8)
achievement(title = "Poison Everlasting", points = 5, badge = "00000",
    description = "Obtain the Toxic Badge.",
    trigger = WasBitflagSetInGame(toxicBadge())
)

// 2 = the Harlequin Hunt begins
// 3 = found one Harlequin
// 4 = found two Harlequins
// 5 = found three Harlequins
// 6 = completed Harlequin Hunt
function harlequinHuntFlag() => byte(0x2256a8)
achievement(title = "The Hunt Is Afoot", points = 1, badge = "00000",
    description = "Complete the Castelia Harlequin Hunt and earn a prize.",
    trigger = WasValueSetInGame(harlequinHuntFlag(), 5, 6)
)


monsWeakToBug = []
monsWeakToBug = MergeArrays(monsWeakToBug, GetPokemonByDualType("Bug", "Grass", TRUE))
monsWeakToBug = MergeArrays(monsWeakToBug, GetPokemonByDualType("Rock", "Dark", TRUE))
monsWeakToBug = MergeArrays(monsWeakToBug, GetPokemonByDualType("Grass", "Psychic", TRUE))
monsWeakToBug = MergeArrays(monsWeakToBug, GetPokemonByDualType("Grass", "Ice", TRUE))
monsWeakToBug = MergeArrays(monsWeakToBug, GetPokemonByDualType("Grass", "Dark", TRUE))
monsWeakToBug = MergeArrays(monsWeakToBug, GetPokemonByDualType("Ice", "Dark", TRUE))
monsWeakToBug = MergeArrays(monsWeakToBug, GetPokemonByDualType("Dragon", "Dark", TRUE))
monsWeakToBug = MergeArrays(monsWeakToBug, GetPokemonByDualType("Ground", "Grass", TRUE))
monsWeakToBug = MergeArrays(monsWeakToBug, GetPokemonByDualType("Rock", "Psychic", TRUE))
monsWeakToBug = MergeArrays(monsWeakToBug, GetPokemonByDualType("Normal", "Grass", TRUE))
monsWeakToBug = MergeArrays(monsWeakToBug, GetPokemonByDualType("Ground", "Psychic", TRUE))
monsWeakToBug = MergeArrays(monsWeakToBug, GetPokemonByDualType("Ground", "Dark", TRUE))
monsWeakToBug = MergeArrays(monsWeakToBug, GetPokemonByDualType("Psychic", "Ice", TRUE))
monsWeakToBug = MergeArrays(monsWeakToBug, GetPokemonByDualType("Water", "Psychic", TRUE))
monsWeakToBug = MergeArrays(monsWeakToBug, GetPokemonByDualType("Water", "Dark", TRUE))
monsWeakToBug = MergeArrays(monsWeakToBug, GetPokemonByDualType("Rock", "Grass", TRUE))
monsWeakToBug = MergeArrays(monsWeakToBug, GetPokemonByDualType("Water", "Grass", TRUE))
monsWeakToBug = MergeArrays(monsWeakToBug, GetPokemonByDualType("Normal", "Psychic", TRUE))
monsWeakToBug = MergeArrays(monsWeakToBug, GetPokemonByDualType("Grass", "", TRUE))
monsWeakToBug = MergeArrays(monsWeakToBug, GetPokemonByDualType("Psychic", "", TRUE))
monsWeakToBug = MergeArrays(monsWeakToBug, GetPokemonByDualType("Dark", "", TRUE))

function BurghGymMusicIsPlaying() => musicId() == 0x44a
function burghMaxParty() => 3
function burghMaxLevel() => 20
achievement(title = "Bee Allergy [m]", points = 10, badge = "00000",
    description = "Defeat Burgh with a party consisting only of obtainable Pokemon that are weak to Bug-type moves (max Level " + burghMaxLevel() + ", max party of " + burghMaxParty() + ").",
    trigger = VictoriousWhenMaxPartyLevelIsAtMostWhenGymLeaderBattleStarts(burghMaxLevel(), burghMaxParty())
        && never(!IsInLocation("CasteliaGymLeader")) && never(BurghGymMusicIsPlaying()) // Must be battling the Gym Leader while in the Castelia Gym Leader's room
        && HasOnlyGivenPokemonInParty(monsWeakToBug, burghMaxParty())
)

function insectBadge() => bit2(0x2266e8)
achievement(title = "Colorful Wings", points = 5, badge = "00000",
    description = "Obtain the Insect Badge.",
    trigger = WasBitflagSetInGame(insectBadge())
)

function ElesaGymMusicIsPlaying() => musicId() == 0x449
function elesaMaxParty() => 4
function elesaMaxLevel() => 28
groundMons = GetPokemonByType("Ground")
achievement(title = "Salt the Earth [m]", points = 25, badge = "00000",
    description = "Defeat Elesa with a party containing no Ground-type Pokemon (max Level " + elesaMaxLevel() + ", max party of " + elesaMaxParty() + ").",
    trigger = VictoriousWhenMaxPartyLevelIsAtMostWhenGymLeaderBattleStarts(elesaMaxLevel(), elesaMaxParty())
        && never(!IsInLocation("NimbasaGym")) && never(ElesaGymMusicIsPlaying()) // Must be battling the Gym Leader while in the Gym Leader's room
        && never(HasAtLeastOneGivenPokemonInParty(groundMons, elesaMaxParty()))
)

function boltBadge() => bit3(0x2266e8)
achievement(title = "Greased Lightning", points = 5, badge = "00000",
    description = "Obtain the Bolt Badge.",
    trigger = WasBitflagSetInGame(boltBadge())
)

function SetStyleActive() => bit6(0x21e9e4) == 1
function ClayGymMusicIsPlaying() => musicId() == 0x427
function clayMaxParty() => 3
function clayMaxLevel() => 30
flyingMons = GetPokemonByType("Flying")
achievement(title = "Firmly Rooted [m]", points = 10, badge = "00000",
    description = "Defeat Clay with a party containing no Flying-type Pokemon (max Level " + clayMaxLevel() + "; max party of " + clayMaxParty() + "; Set style only).",
    trigger = VictoriousWhenMaxPartyLevelIsAtMostWhenGymLeaderBattleStarts(clayMaxLevel(), clayMaxParty())
        && never(!IsInLocation("DriftveilGym")) && never(ClayGymMusicIsPlaying()) // Must be battling the Gym Leader while in the Gym Leader's room
        && never(HasAtLeastOneGivenPokemonInParty(flyingMons, clayMaxParty()))
        && never(!SetStyleActive())
)

function quakeBadge() => bit4(0x2266e8)
achievement(title = "Ground Zero", points = 5, badge = "00000",
    description = "Obtain the Quake Badge.",
    trigger = WasBitflagSetInGame(quakeBadge())
)

function skylaMaxLevel() => 35
function skylaMaxParty() => 6
function SkylaGymMusicIsPlaying() => musicId() == 0x4c4
electricMons = GetPokemonByType("Electric")
rockMons = GetPokemonByType("Rock")
achievement(title = "Meteorological Hazard [m]", points = 10, badge = "00000",
    description = "Defeat Skyla without using more than one species of Electric-type or Rock-type Pokemon (max Level " + skylaMaxLevel() + "; Set style only).",
    trigger = VictoriousWhenMaxPartyLevelIsAtMostWhenGymLeaderBattleStarts(skylaMaxLevel(), skylaMaxParty())
        && never(!IsInLocation("MistraltonGym")) && never(SkylaGymMusicIsPlaying()) // Must be battling the Gym Leader while in the Gym Leader's room
        && never(!SetStyleActive())
        && never(NumberOfGivenPokemonSwitchedIn(1, MergeArrays(electricMons, rockMons)))
)

function jetBadge() => bit5(0x2266e8)
achievement(title = "The Taste of Flight", points = 5, badge = "00000",
    description = "Obtain the Jet Badge.",
    trigger = WasBitflagSetInGame(jetBadge())
)

specialTypePokemon = []
specialTypePokemon = MergeArrays(specialTypePokemon, GetPokemonByDualType("Water", "", TRUE))
specialTypePokemon = MergeArrays(specialTypePokemon, GetPokemonByDualType("Grass", "", TRUE))
specialTypePokemon = MergeArrays(specialTypePokemon, GetPokemonByDualType("Fire", "", TRUE))
specialTypePokemon = MergeArrays(specialTypePokemon, GetPokemonByDualType("Ice", "", TRUE))
specialTypePokemon = MergeArrays(specialTypePokemon, GetPokemonByDualType("Electric", "", TRUE))
specialTypePokemon = MergeArrays(specialTypePokemon, GetPokemonByDualType("Psychic", "", TRUE))
specialTypePokemon = MergeArrays(specialTypePokemon, GetPokemonByDualType("Dragon", "", TRUE))
specialTypePokemon = MergeArrays(specialTypePokemon, GetPokemonByDualType("Dark", "", TRUE))

function driftveilTourneyMaxLevel() => 32
function PwtLobbyMusicPlaying() => musicId() == 0x4b0
function ColressVictoryMusicIsPlaying() => musicId() == 0x4ef
function WonDriftveilTournament() => Delta(driftveilTournamentWins()) + 1 == driftveilTournamentWins()
function driftveilTournamentWins() => byte(0x228d64)
achievement(title = "Driftveil's Specialist", points = 10, badge = "00000",
    description = "Complete the Driftveil Tournament using only Pokemon whose types were historically considered physical types (max Level " + driftveilTourneyMaxLevel() + "; Set style only).",
    trigger = once(!WonDriftveilTournament() && IsInLocation("PWTArena") && WasJustInLocation("PWTBuilding"))
        && trigger_when(WonDriftveilTournament())
        && never(IsInLocation("PWT"))
        && never(HasAtLeastOneGivenPokemonInParty(specialTypePokemon, 3, false))
        && never(!SetStyleActive())
)
