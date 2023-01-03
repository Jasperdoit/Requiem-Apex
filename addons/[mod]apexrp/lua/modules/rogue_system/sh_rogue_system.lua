RogueMenu = RogueMenu or {}
RogueMenu.Theme = {
    ["backgroundcolor"] = Color(94, 61, 0, 220),
    ["black"] = Color(0, 0, 0, 240),
    ["button"] = Color(182, 182, 182, 255),
    ["profilepanel"] = Color(55, 55, 55, 220),
    ["scrollpanelcolor"] = Color(40, 40, 40, 220),
    ["cpactivecolor"] = Color(0, 30, 160, 220),
    ["cproguecolor"] = Color(255,114,0,255),
    ["cpdefunctbuttoncolor"] = Color(160, 30, 0, 220),
    ["Text"] = Color(255, 255, 255, 255),
}
RogueMenu.Divisions = {
    "union",
    "helix",
    "grid",
    "jury"
}

RogueMenu.Ranks = {
    "rct",
    "00",
    "25"
}

DarkRP.declareChatCommand{
    command = "requestrogue",
    description = "Requests rogue permission from staff",
    delay = 1.5
}

DarkRP.declareChatCommand{
    command = "cancelroguerequest",
    description = "Cancels your rogue permission request.",
    delay = 1.5
}

DarkRP.declareChatCommand{
    command = "cancelrogueperms",
    description = "Removes your rogue permissions if you are rogue.",
    delay = 1.5
}