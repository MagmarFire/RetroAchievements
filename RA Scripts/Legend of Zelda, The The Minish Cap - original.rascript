// Legend of Zelda, The: The Minish Cap
// #ID = 559

// Ticket 26994: Needs save protection; will trigger when a completed save file is loaded.
//               
//               Rich Presence at time of trigger:
//               Name: Link, 20(all) Heart Containers, 136 Figurines, 100 Fusions<br>MD5:
//               a104896da0047abe8bee2a6e3f4c7290
achievement(
    title = "Fire", description = "Obtain the Fire Element", points = 5,
    id = 2036, badge = "02487", published = "8/4/2013 8:00:34 AM", modified = "8/4/2013 8:10:47 AM",
    trigger = bit2(0x00AB42) == 0x1
)

// Ticket 26993: Needs save protection; will trigger when a completed save file is loaded.
//               
//               Rich Presence at time of trigger:
//               Name: Link, 20(all) Heart Containers, 136 Figurines, 100 Fusions<br>MD5:
//               a104896da0047abe8bee2a6e3f4c7290
achievement(
    title = "Water", description = "Obtain the Water Element", points = 5,
    id = 2035, badge = "02486", published = "8/4/2013 8:00:31 AM", modified = "8/4/2013 8:10:41 AM",
    trigger = bit4(0x00AB42) == 0x1
)

// Ticket 26995: Needs save protection; will trigger when a completed save file is loaded.
//               
//               Rich Presence at time of trigger:
//               Name: Link, 20(all) Heart Containers, 136 Figurines, 100 Fusions<br>MD5:
//               a104896da0047abe8bee2a6e3f4c7290
achievement(
    title = "Wind", description = "Obtain the Wind Element", points = 5,
    id = 2037, badge = "02488", published = "8/4/2013 8:00:38 AM", modified = "8/4/2013 8:10:52 AM",
    trigger = bit6(0x00AB42) == 0x1
)

// Ticket 26996: Needs save protection; will trigger when a completed save file is loaded.
//               
//               Rich Presence at time of trigger:
//               Name: Link, 20(all) Heart Containers, 136 Figurines, 100 Fusions<br>MD5:
//               a104896da0047abe8bee2a6e3f4c7290
achievement(
    title = "Power Bracelets", description = "Obtain the Power Bracelets", points = 5,
    id = 2039, badge = "02490", published = "8/4/2013 8:00:49 AM", modified = "8/4/2013 8:11:06 AM",
    trigger = bit2(0x00AB43) == 0x1
)

// Ticket 26997: Needs save protection; will trigger when a completed save file is loaded.
//               
//               Rich Presence at time of trigger:
//               Name: Link, 20(all) Heart Containers, 136 Figurines, 100 Fusions<br>MD5:
//               a104896da0047abe8bee2a6e3f4c7290
achievement(
    title = "Going For A Swim", description = "Obtain Flippers", points = 5,
    id = 2040, badge = "02491", published = "8/4/2013 8:00:51 AM", modified = "10/17/2019 3:22:01 PM",
    trigger = bit4(0x00AB43) == 0x1
)

// Ticket 26998: Needs save protection; will trigger when a completed save file is loaded.
//               
//               Rich Presence at time of trigger:
//               Name: Link, 20(all) Heart Containers, 136 Figurines, 100 Fusions<br>MD5:
//               a104896da0047abe8bee2a6e3f4c7290
achievement(
    title = "Light It Up", description = "Obtain the Lantern", points = 5,
    id = 2042, badge = "02493", published = "8/4/2013 8:00:57 AM", modified = "8/4/2013 8:11:22 AM",
    trigger = bit6(0x00AB35) == 0x1
)

// Ticket 26999: Needs save protection; will trigger when a completed save file is loaded.
//               
//               Rich Presence at time of trigger:
//               Name: Link, 20(all) Heart Containers, 136 Figurines, 100 Fusions<br>MD5:
//               a104896da0047abe8bee2a6e3f4c7290
achievement(
    title = "Graveyard", description = "Obtain the Graveyard Key and use it", points = 5,
    id = 2043, badge = "02494", published = "8/4/2013 8:01:00 AM", modified = "8/4/2019 9:04:58 PM",
    trigger = bit1(0x00AB41) == 0x1 && word(0x000BF4) != 0x1222
)

// Ticket 27000: Needs save protection; will trigger when a completed save file is loaded.
//               
//               Rich Presence at time of trigger:
//               Name: Link, 20(all) Heart Containers, 136 Figurines, 100 Fusions<br>MD5:
//               a104896da0047abe8bee2a6e3f4c7290
achievement(
    title = "White Sword", description = "Obtain the White Sword", points = 5,
    id = 2044, badge = "02495", published = "8/4/2013 8:01:02 AM", modified = "8/4/2013 8:11:27 AM",
    trigger = bit4(0x00AB32) == 0x1
)

// Ticket 27001: Needs save protection; will trigger when a completed save file is loaded.
//               
//               Rich Presence at time of trigger:
//               Name: Link, 20(all) Heart Containers, 136 Figurines, 100 Fusions<br>MD5:
//               a104896da0047abe8bee2a6e3f4c7290
achievement(
    title = "White Sword 2", description = "Infuse your sword with Earth and Fire elements", points = 10,
    id = 2045, badge = "02496", published = "8/4/2013 8:01:05 AM", modified = "8/4/2019 9:04:45 PM",
    trigger = bit6(0x00AB32) == 0x1
)

// Ticket 27002: Needs save protection; will trigger when a completed save file is loaded.
//               
//               Rich Presence at time of trigger:
//               Name: Link, 20(all) Heart Containers, 136 Figurines, 100 Fusions<br>MD5:
//               a104896da0047abe8bee2a6e3f4c7290
achievement(
    title = "White Sword 3", description = "Infuse your sword with the third element - Water", points = 10,
    id = 2046, badge = "02497", published = "8/4/2013 8:01:29 AM", modified = "9/26/2019 10:32:01 AM",
    trigger = bit0(0x00AB33) == 0x1
)

// Ticket 27003: Needs save protection; will trigger when a completed save file is loaded.
//               
//               Rich Presence at time of trigger:
//               Name: Link, 20(all) Heart Containers, 136 Figurines, 100 Fusions<br>MD5:
//               a104896da0047abe8bee2a6e3f4c7290
achievement(
    title = "Four Sword", description = "Infuse your sword with the fourth element - Wind", points = 10,
    id = 2047, badge = "02498", published = "8/4/2013 8:01:40 AM", modified = "8/4/2019 9:04:50 PM",
    trigger = bit4(0x00AB33) == 0x1
)

// Ticket 27004: Needs save protection; will trigger when a completed save file is loaded.
//               
//               Rich Presence at time of trigger:
//               Name: Link, 20(all) Heart Containers, 136 Figurines, 100 Fusions<br>MD5:
//               a104896da0047abe8bee2a6e3f4c7290
achievement(
    title = "Shiny!", description = "Obtain the Mirror Shield", points = 5,
    id = 2049, badge = "02500", published = "8/4/2013 8:01:46 AM", modified = "8/4/2013 8:11:43 AM",
    trigger = bit4(0x00AB35) == 0x1
)

// Ticket 27008: Needs save protection; will trigger when a completed save file is loaded.
//               
//               Rich Presence at time of trigger:
//               Name: Link, 20(all) Heart Containers, 136 Figurines, 100 Fusions<br>MD5:
//               a104896da0047abe8bee2a6e3f4c7290
achievement(
    title = "Bow Down", description = "Obtain a Bow", points = 5,
    id = 2057, badge = "02509", published = "8/4/2013 8:02:34 AM", modified = "8/4/2013 8:12:06 AM",
    trigger = bit2(0x00AB34) == 0x1
)

// Ticket 27009: Needs save protection; will trigger when a completed save file is loaded.
//               
//               Rich Presence at time of trigger:
//               Name: Link, 20(all) Heart Containers, 136 Figurines, 100 Fusions<br>MD5:
//               a104896da0047abe8bee2a6e3f4c7290
achievement(
    title = "It Doesn't Feel Lighter", description = "Obtain Light Arrows", points = 10,
    id = 2059, badge = "02511", published = "8/4/2013 8:02:40 AM", modified = "8/4/2019 9:04:41 PM",
    trigger = bit4(0x00AB34) == 0x1
)

// Ticket 27005: Needs save protection; will trigger when a completed save file is loaded.
//               
//               Rich Presence at time of trigger:
//               Name: Link, 20(all) Heart Containers, 136 Figurines, 100 Fusions<br>MD5:
//               a104896da0047abe8bee2a6e3f4c7290
achievement(
    title = "Magic Trick", description = "Obtain the Magical Boomerang", points = 10,
    id = 2050, badge = "02501", published = "8/4/2013 8:01:48 AM", modified = "8/4/2019 9:04:28 PM",
    trigger = bit0(0x00AB35) == 0x1
)

// Ticket 27007: Needs save protection; will trigger when a completed save file is loaded.
//               
//               Rich Presence at time of trigger:
//               Name: Link, 20(all) Heart Containers, 136 Figurines, 100 Fusions<br>MD5:
//               a104896da0047abe8bee2a6e3f4c7290
achievement(
    title = "Set Up Us The Bomb", description = "Obtain a Remote Bomb", points = 5,
    id = 2055, badge = "02507", published = "8/4/2013 8:02:30 AM", modified = "8/4/2013 8:11:59 AM",
    trigger = bit0(0x00AB34) == 0x1
)

// Ticket 27006: Needs save protection; will trigger when a completed save file is loaded.
//               
//               Rich Presence at time of trigger:
//               Name: Link, 20(all) Heart Containers, 136 Figurines, 100 Fusions<br>MD5:
//               a104896da0047abe8bee2a6e3f4c7290
achievement(
    title = "Dig Dug", description = "Obtain Mole Mitts", points = 5,
    id = 2054, badge = "02505", published = "8/4/2013 8:02:26 AM", modified = "8/4/2013 8:11:55 AM",
    trigger = bit6(0x00AB36) == 0x1
)

// Ticket 27010: Needs save protection; will trigger when a completed save file is loaded.
//               
//               Rich Presence at time of trigger:
//               Name: Link, 20(all) Heart Containers, 136 Figurines, 100 Fusions<br>MD5:
//               a104896da0047abe8bee2a6e3f4c7290
achievement(
    title = "I Can Fly!", description = "Obtain Roc's Cape", points = 5,
    id = 2060, badge = "02512", published = "8/4/2013 8:02:43 AM", modified = "8/4/2013 8:12:17 AM",
    trigger = bit0(0x00AB37) == 0x1
)

// Ticket 27011: Needs save protection; will trigger when a completed save file is loaded.
//               
//               Rich Presence at time of trigger:
//               Name: Link, 20(all) Heart Containers, 136 Figurines, 100 Fusions<br>MD5:
//               a104896da0047abe8bee2a6e3f4c7290
achievement(
    title = "Pegasus Boots", description = "Obtain Pegasus Boots", points = 5,
    id = 2061, badge = "02513", published = "8/4/2013 8:02:46 AM", modified = "8/4/2013 8:12:22 AM",
    trigger = bit2(0x00AB37) == 0x1
)

// Ticket 27012: Needs save protection; will trigger when a completed save file is loaded.
//               
//               Rich Presence at time of trigger:
//               Name: Link, 20(all) Heart Containers, 136 Figurines, 100 Fusions<br>MD5:
//               a104896da0047abe8bee2a6e3f4c7290
achievement(
    title = "Ocarina of Wind", description = "Obtain the Ocarina of Wind", points = 5,
    id = 2062, badge = "02514", published = "8/4/2013 8:02:49 AM", modified = "8/4/2013 8:12:25 AM",
    trigger = bit6(0x00AB37) == 0x1
)

// Ticket 27013: Needs save protection; will trigger when a completed save file is loaded.
//               
//               Rich Presence at time of trigger:
//               Name: Link, 20(all) Heart Containers, 136 Figurines, 100 Fusions<br>MD5:
//               a104896da0047abe8bee2a6e3f4c7290
achievement(
    title = "Lon Lon Ranch", description = "Find and return the Lon Lon Ranch Key", points = 3,
    id = 2089, badge = "02564", published = "8/7/2013 9:49:34 PM", modified = "8/4/2019 9:04:16 PM",
    trigger = bit7(0x00AB3F) == 0x1
)

// Ticket 27014: Needs save protection; will trigger when a completed save file is loaded.
//               
//               Rich Presence at time of trigger:
//               Name: Link, 20(all) Heart Containers, 136 Figurines, 100 Fusions<br>MD5:
//               a104896da0047abe8bee2a6e3f4c7290
achievement(
    title = "Swordsman Newsletter", description = "Subscribe to Swordsman Newsletter and collect all issues", points = 10,
    id = 2178, badge = "02660", published = "8/12/2013 11:43:19 AM", modified = "8/4/2019 9:04:22 PM",
    trigger = bit7(0x00ACDF) == 0x1 && low4(0x00ACE0) == 0xF && bit4(0x00ACE0) == 0x1 && bit5(0x00ACE0) == 0x1 && 
              bit6(0x00ACE0) == 0x1
)

// Ticket 27023: Needs save protection. Will trigger upon loading up and starting a completed save file.
//               
//               Rich Presence at time of trigger:
//               Name: Link, 20(all) Heart Containers, 136 Figurines, 100 Fusions<br>MD5:
//               a104896da0047abe8bee2a6e3f4c7290
achievement(
    title = "Miracle Maker", description = "Fuse at least 50 Kinstones", points = 10,
    id = 2347, badge = "02843", published = "8/20/2013 5:26:51 AM", modified = "8/4/2019 9:03:45 PM",
    trigger = byte(0x00AB57) >= 0x32 && word(0x000BF4) != 0x0000
)

// Ticket 27022: Needs save protection; will trigger when a completed save file is loaded.
//               
//               Rich Presence at time of trigger:
//               Name: Link, 20(all) Heart Containers, 136 Figurines, 100 Fusions<br>MD5:
//               a104896da0047abe8bee2a6e3f4c7290
achievement(
    title = "Tingle Trophy", description = "Complete all Kinstone Fusions", points = 25,
    id = 2349, badge = "02506", published = "8/20/2013 5:40:45 AM", modified = "3/30/2020 2:40:29 PM",
    trigger = bit2(0x00AB41) == 0x1 && prev(bit2(0x00AB41)) == 0x0 && byte(0x00AB57) >= 0x63
)

// Ticket 27017: Needs save protection; will trigger when a completed save file is loaded.
//               
//               Rich Presence at time of trigger:
//               Name: Link, 20(all) Heart Containers, 136 Figurines, 100 Fusions<br>MD5:
//               a104896da0047abe8bee2a6e3f4c7290
achievement(
    title = "Dexterous", description = "Learn all 6 abilities speeding up various actions", points = 10,
    id = 2248, badge = "02740", published = "8/15/2013 10:06:34 PM", modified = "4/15/2015 12:42:09 PM",
    trigger = word(0x00AB4E) == 0x0555
)

// Ticket 27018: Needs save protection; will trigger when a completed save file is loaded.
//               
//               Rich Presence at time of trigger:
//               Name: Link, 20(all) Heart Containers, 136 Figurines, 100 Fusions<br>MD5:
//               a104896da0047abe8bee2a6e3f4c7290
achievement(
    title = "Navigator", description = "Complete the Hyrule Map and activate all Wind Crests", points = 10,
    id = 2249, badge = "02741", published = "8/15/2013 11:25:04 PM", modified = "8/4/2019 9:03:42 PM",
    trigger = word(0x00AA80) == 0xFFFF && byte(0x00AA83) == 0xFF && byte(0x00AA82) == 0x01
)

// Ticket 26991: Needs save protection; will trigger when a completed save file is loaded.
//               
//               Rich Presence at time of trigger:
//               Name: Link, 20(all) Heart Containers, 136 Figurines, 100 Fusions<br>MD5:
//               a104896da0047abe8bee2a6e3f4c7290
achievement(
    title = "Rupee Gatherer", description = "Gather 300 Rupees", points = 5,
    id = 1474, badge = "02661", published = "5/31/2013 4:40:39 AM", modified = "8/4/2019 9:03:49 PM",
    trigger = word(0x00AB00) >= 0x012C
)

// Ticket 27019: Needs save protection; will trigger when a completed save file is loaded.
//               
//               Rich Presence at time of trigger:
//               Name: Link, 20(all) Heart Containers, 136 Figurines, 100 Fusions<br>MD5:
//               a104896da0047abe8bee2a6e3f4c7290
achievement(
    title = "Crouching Tiger", description = "Obtain all Tiger Scrolls", points = 10,
    id = 2258, badge = "02749", published = "8/16/2013 9:23:34 AM", modified = "8/4/2019 9:03:53 PM",
    trigger = word(0x00AB44) == 0x5555
)

// Ticket 27015: Needs save protection; will trigger when a completed save file is loaded.
//               
//               Rich Presence at time of trigger:
//               Name: Link, 20(all) Heart Containers, 136 Figurines, 100 Fusions<br>MD5:
//               a104896da0047abe8bee2a6e3f4c7290
achievement(
    title = "Rupee Collector", description = "Collect 500 Rupees", points = 5,
    id = 2179, badge = "02663", published = "8/12/2013 1:13:56 PM", modified = "8/4/2019 9:03:51 PM",
    trigger = word(0x00AB00) >= 0x01F4
)

// Ticket 27016: Needs save protection; will trigger when a completed save file is loaded.
//               
//               Rich Presence at time of trigger:
//               Name: Link, 20(all) Heart Containers, 136 Figurines, 100 Fusions<br>MD5:
//               a104896da0047abe8bee2a6e3f4c7290
achievement(
    title = "Rupee Hoarder", description = "Hoard 999 Rupees", points = 10,
    id = 2180, badge = "02664", published = "8/12/2013 1:13:59 PM", modified = "8/4/2019 9:03:55 PM",
    trigger = word(0x00AB00) >= 0x03E7
)

// Ticket 27020: Needs save protection; will trigger when a completed save file is loaded.
//               
//               Rich Presence at time of trigger:
//               Name: Link, 20(all) Heart Containers, 136 Figurines, 100 Fusions<br>MD5:
//               a104896da0047abe8bee2a6e3f4c7290
achievement(
    title = "Resourceful", description = "Obtain all four Bottles", points = 25,
    id = 2260, badge = "02751", published = "8/16/2013 11:22:22 AM", modified = "10/23/2019 5:12:02 PM",
    trigger = byte(0x00AB39) == 0x55
)

// Ticket 27021: Needs save protection; will trigger when a completed save file is loaded.
//               
//               Rich Presence at time of trigger:
//               Name: Link, 20(all) Heart Containers, 136 Figurines, 100 Fusions<br>MD5:
//               a104896da0047abe8bee2a6e3f4c7290
achievement(
    title = "Carlov Medal", description = "Collect all 136 Figurines", points = 25,
    id = 2310, badge = "02809", published = "8/19/2013 8:49:12 PM", modified = "10/23/2019 5:12:02 PM",
    trigger = word(0x00AB0E) >= 0xFFFE && word(0x00AB10) == 0xFFFF && word(0x00AB12) == 0xFFFF && 
              word(0x00AB14) == 0xFFFF && word(0x00AB16) == 0xFFFF && word(0x00AB18) == 0xFFFF && word(0x00AB1A) == 0xFFFF && 
              word(0x00AB1C) == 0xFFFF && word(0x00AB1E) == 0x01FF && byte(0x00AAF0) == 0x88 && byte(0x00AA46) == 0x01 && bit4(0x00AB41) == 0x1
)

// Ticket 26992: Needs save protection; will trigger when a completed save file is loaded.
//               
//               Rich Presence at time of trigger:
//               Name: Link, 20(all) Heart Containers, 136 Figurines, 100 Fusions<br>MD5:
//               a104896da0047abe8bee2a6e3f4c7290
achievement(
    title = "Stayin' Alive", description = "Have 20 Heart Containers", points = 25,
    id = 1496, badge = "01735", published = "5/31/2013 5:40:11 PM", modified = "9/29/2019 11:02:03 AM",
    trigger = byte(0x00AAEB) == 0xA0
)

// Ticket 26315: Kill the boss 3 times without getting damaged and doesn't trigger<br>MD5: Unknown<br>Emulator:
//               RetroArch (VMA)
achievement(
    title = "Bested Big Green Chuchu", description = "Defeat the Big Green Chuchu without taking damage", points = 10,
    id = 2078, badge = "02540", published = "8/5/2013 5:15:22 AM", modified = "8/5/2013 5:31:38 AM",
    trigger = once(byte(0x000BF4) == 0x48) && once(byte(0x000BF5) == 0x17) && never(byte(0x000BF5) == 0x0B) && 
              word(0x000BF4) == 0x0049 && never(byte(0x00AAEA) < prev(byte(0x00AAEA))) && once(byte(0x00188D) == 0xFF) && byte(0x00188D) == 0x00 && 
              never(bit0(0x00AB42) < prev(bit0(0x00AB42))) && bit0(0x00AB42) == 0x1
)
