battlecry = battlecry or {}

battlecry.MaleSound = {
    Sound("vo/episode_1/npc/male01/cit_kill01.wav"),
    Sound("vo/episode_1/npc/male01/cit_kill02.wav"),
    Sound("vo/episode_1/npc/male01/cit_kill03.wav"),
    Sound("vo/episode_1/npc/male01/cit_kill04.wav"),
    Sound("vo/episode_1/npc/male01/cit_kill05.wav"),
    Sound("vo/episode_1/npc/male01/cit_kill06.wav"),
    Sound("vo/episode_1/npc/male01/cit_kill07.wav"),
    Sound("vo/episode_1/npc/male01/cit_kill08.wav"),
    Sound("vo/episode_1/npc/male01/cit_kill09.wav"),
    Sound("vo/episode_1/npc/male01/cit_kill10.wav"),
    Sound("vo/episode_1/npc/male01/cit_kill11.wav"),
    Sound("vo/episode_1/npc/male01/cit_kill12.wav"),
    Sound("vo/episode_1/npc/male01/cit_kill13.wav"),
    Sound("vo/episode_1/npc/male01/cit_kill14.wav"),
    Sound("vo/episode_1/npc/male01/cit_kill15.wav"),
    Sound("vo/episode_1/npc/male01/cit_kill16.wav"),
    Sound("vo/episode_1/npc/male01/cit_kill17.wav"),
    Sound("vo/episode_1/npc/male01/cit_kill19.wav"),
    Sound("vo/episode_1/npc/male01/cit_kill20.wav")
}

battlecry.FemaleSound = {
    Sound("vo/episode_1/npc/female01/cit_kill01.wav"),
    Sound("vo/episode_1/npc/female01/cit_kill02.wav"),
    Sound("vo/episode_1/npc/female01/cit_kill03.wav"),
    Sound("vo/episode_1/npc/female01/cit_kill04.wav"),
    Sound("vo/episode_1/npc/female01/cit_kill05.wav"),
    Sound("vo/episode_1/npc/female01/cit_kill06.wav"),
    Sound("vo/episode_1/npc/female01/cit_kill07.wav"),
    Sound("vo/episode_1/npc/female01/cit_kill08.wav"),
    Sound("vo/episode_1/npc/female01/cit_kill09.wav"),
    Sound("vo/episode_1/npc/female01/cit_kill10.wav"),
    Sound("vo/episode_1/npc/female01/cit_kill11.wav"),
    Sound("vo/episode_1/npc/female01/cit_kill12.wav"),
    Sound("vo/episode_1/npc/female01/cit_kill13.wav"),
    Sound("vo/episode_1/npc/female01/cit_kill14.wav"),
    Sound("vo/episode_1/npc/female01/cit_kill15.wav"),
    Sound("vo/episode_1/npc/female01/cit_kill16.wav"),
    Sound("vo/episode_1/npc/female01/cit_kill17.wav")
}

battlecry.ConsMaleSound = {
    Sound("vo/scales/usec3_enemy_down_01_l.wav"),
    Sound("vo/scales/usec3_enemy_down_02_l.wav"),
    Sound("vo/scales/usec3_enemy_down_03_l.wav"),
    Sound("vo/scales/usec3_enemy_down_04_l_bl.wav"),
    Sound("vo/scales/usec3_enemy_down_05_bl.wav"),
    Sound("vo/scales/usec3_enemy_down_06_bl.wav"),
    Sound("vo/scales/usec3_enemy_down_06_l.wav"),
    Sound("vo/scales/usec3_fight_02_bl.wav"),
    Sound("vo/scales/usec3_fight_03_bl.wav"),
    Sound("vo/scales/usec3_fight_04.wav"),
    Sound("vo/scales/usec3_fight_05.wav"),
    Sound("vo/scales/usec3_fight_06.wav"),
    Sound("vo/scales/usec3_fight_12_bl.wav"),
    Sound("vo/scales/usec3_fight_13.wav"),
    Sound("vo/scales/usec3_fight_31_bl.wav"),
    Sound("vo/scales/usec3_fight_32_bl.wav"),
    Sound("vo/scales/usec3_fight_35_bl.wav"),
    Sound("vo/scales/usec3_fight_38_bl.wav"),
    Sound("vo/scales/usec3_fight_40_bl.wav"),
    Sound("vo/scales/usec3_fight_43_bl.wav"),
    Sound("vo/scales/usec3_fight_53_bl.wav")
}

battlecry.ConsFemaleSound = {
    Sound("vo/episode_1/npc/female01/cit_kill01.wav"),
    Sound("vo/episode_1/npc/female01/cit_kill02.wav"),
    Sound("vo/episode_1/npc/female01/cit_kill03.wav"),
    Sound("vo/episode_1/npc/female01/cit_kill04.wav"),
    Sound("vo/episode_1/npc/female01/cit_kill05.wav"),
    Sound("vo/episode_1/npc/female01/cit_kill06.wav"),
    Sound("vo/episode_1/npc/female01/cit_kill07.wav"),
    Sound("vo/episode_1/npc/female01/cit_kill08.wav"),
    Sound("vo/episode_1/npc/female01/cit_kill09.wav"),
    Sound("vo/episode_1/npc/female01/cit_kill10.wav"),
    Sound("vo/episode_1/npc/female01/cit_kill11.wav"),
    Sound("vo/episode_1/npc/female01/cit_kill12.wav"),
    Sound("vo/episode_1/npc/female01/cit_kill13.wav"),
    Sound("vo/episode_1/npc/female01/cit_kill14.wav"),
    Sound("vo/episode_1/npc/female01/cit_kill19.wav"),
    Sound("vo/episode_1/npc/female01/cit_kill20.wav")
}

battlecry.CP = {
    Sound("battlecry/cp/battlecry01.wav"),
    Sound("battlecry/cp/battlecry02.wav"),
    Sound("battlecry/cp/battlecry03.wav"),
    Sound("battlecry/cp/battlecry04.wav"),
    Sound("battlecry/cp/battlecry05.wav")
}

battlecry.OTA = {
    Sound("battlecry/ota/battlecry01.wav"),
    Sound("battlecry/ota/battlecry02.wav"),
    Sound("battlecry/ota/battlecry03.wav"),
    Sound("battlecry/ota/battlecry04.wav"),
    Sound("battlecry/ota/battlecry05.wav")
}

hook.Add("PlayerDeath", "Soundbattlecry", function(victim, ent, attacker)
    if not attacker:IsValid() then return end
    if not victim:IsValid() then return end
    if not attacker:IsPlayer() then return end
    if attacker.Battlecrysounded == true then
  
    return end

    attacker.Battlecrysounded = true
    battlecry.Sound = nil

    //Citizen
    if attacker:Team() == TEAM_CITIZEN and attacker:GetNWBool("IsRebelscum", false) then
        if victim:Team() == TEAM_CP or victim:Team() == TEAM_OVERWATCH or victim:Team() == TEAM_CONSCRIPT or victim:Team() == TEAM_ADMINISTRATOR then
            if string.find(string.lower(attacker:GetModel()) , "female") then
                battlecry.Sound = table.Random(battlecry.FemaleSound)
            else
                battlecry.Sound = table.Random(battlecry.MaleSound)
            end
        end
    end
    //Conscript
    if attacker:Team() == TEAM_CONSCRIPT then
        if victim:Team() == TEAM_CITIZEN and victim:GetNWBool("IsRebelscum", false) then
            if string.find(string.lower(attacker:GetModel()) , "female") then
                battlecry.Sound = table.Random(battlecry.ConsFemaleSound)
            else
                battlecry.Sound = table.Random(battlecry.ConsMaleSound)
            end
        end
    end

    //Civil Protection
    if attacker:Team() == TEAM_CP then
        if victim:Team() == TEAM_CITIZEN and victim:GetNWBool("IsRebelscum", false) then
                battlecry.Sound = table.Random(battlecry.CP)
                -- print("I'm a CP and have selected sound: ".. battlecry.Sound)
        end
    end
    //Overwatch
    if attacker:Team() == TEAM_OVERWATCH then
        if victim:Team() == TEAM_CITIZEN and victim:GetNWBool("IsRebelscum", false) then
                battlecry.Sound = table.Random(battlecry.OTA)
        end
    end


    //Play Battlecry
    if battlecry.Sound == nil then
        attacker.Battlecrysounded = nil
        -- print("Sound is nil so I won't play anything :/")
        return
    end
    timer.Simple(.5, function()
        attacker:EmitSound(battlecry.Sound)
        -- print("I have played:" .. battlecry.Sound)
    end)

    timer.Simple(30, function()
        attacker.Battlecrysounded = nil
    end)
end)


