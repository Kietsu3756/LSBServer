-----------------------------------
-- Area: Windurst Waters
--  NPC: Jatan-Paratan
-- Starts and Finished Quest: Wondering Minstrel
-- !pos -59 -4 22 238
-----------------------------------
local ID = require("scripts/zones/Windurst_Waters/IDs")
require("scripts/globals/settings")
require("scripts/globals/keyitems")
require("scripts/globals/quests")
require("scripts/globals/titles")
-----------------------------------
local entity = {}

entity.onTrade = function(player, npc, trade)
    local wonderingstatus = player:getQuestStatus(xi.quest.log_id.WINDURST, xi.quest.id.windurst.WONDERING_MINSTREL)
    if (wonderingstatus == 1 and trade:hasItemQty(718, 1) == true and trade:getItemCount() == 1 and player:getCharVar("QuestWonderingMin_var") == 1) then
        player:startEvent(638)                 -- WONDERING_MINSTREL: Quest Finish
    end
end

entity.onTrigger = function(player, npc)

            --        player:delQuest(xi.quest.log_id.WINDURST, xi.quest.id.windurst.WONDERING_MINSTREL)


    local wonderingstatus = player:getQuestStatus(xi.quest.log_id.WINDURST, xi.quest.id.windurst.WONDERING_MINSTREL)
    local fame = player:getFameLevel(WINDURST)
    if (wonderingstatus == QUEST_AVAILABLE and fame >= 5) then
        local rand = math.random(1, 2)
        if (rand == 1) then
            player:startEvent(633)          -- WONDERING_MINSTREL: Before Quest
        else
            player:startEvent(634)          -- WONDERING_MINSTREL: Quest Start
        end
    elseif (wonderingstatus == QUEST_ACCEPTED) then
        player:startEvent(635)                 -- WONDERING_MINSTREL: During Quest
    elseif (wonderingstatus == QUEST_COMPLETED and player:needToZone()) then
        player:startEvent(639)                 -- WONDERING_MINSTREL: After Quest
    else
        local hour = VanadielHour()
        if (hour >= 18 or hour <= 6) then
            player:startEvent(611)             -- Singing 1 (daytime < 6 or daytime >= 18)
        else
            local rand = math.random(1, 2)
            if (rand == 1) then
                player:startEvent(610)          -- Standard Conversation 1 (daytime)
            else
                player:startEvent(615)             -- Standard Conversation 2 (daytime)
            end
        end
    end
end

entity.onEventUpdate = function(player, csid, option)
end

entity.onEventFinish = function(player, csid, option)
    if (csid == 634) then    -- WONDERING_MINSTREL: Quest Start
        player:addQuest(xi.quest.log_id.WINDURST, xi.quest.id.windurst.WONDERING_MINSTREL)
    elseif (csid == 638) then  -- WONDERING_MINSTREL: Quest Finish
        if (player:getFreeSlotsCount() == 0) then
            player:messageSpecial(ID.text.ITEM_CANNOT_BE_OBTAINED, 17349)
        else
            player:tradeComplete()
            player:completeQuest(xi.quest.log_id.WINDURST, xi.quest.id.windurst.WONDERING_MINSTREL)
            player:addItem(17349)
            player:messageSpecial(ID.text.ITEM_OBTAINED, 17349)
            player:addFame(WINDURST, 75)
            player:addTitle(xi.title.DOWN_PIPER_PIPE_UPPERER)
            player:needToZone(true)
            player:setCharVar("QuestWonderingMin_var", 0)
        end
    end
end

return entity
