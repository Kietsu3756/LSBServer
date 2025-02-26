-----------------------------------
-- Area: Lower Jeuno
--  NPC: Naruru
-- Starts and Finishes Quests: Cook's Pride
-- !pos -56 0.1 -138 245
-----------------------------------
local ID = require("scripts/zones/Lower_Jeuno/IDs")
require("scripts/globals/keyitems")
require("scripts/globals/settings")
require("scripts/globals/quests")
require("scripts/globals/titles")
require("scripts/globals/utils")
require("scripts/globals/shop")
-----------------------------------
local entity = {}

entity.onTrade = function(player, npc, trade)
end

entity.onTrigger = function(player, npc)
    local TheWonderMagicSet = player:getQuestStatus(xi.quest.log_id.JEUNO, xi.quest.id.jeuno.THE_WONDER_MAGIC_SET)
    local CooksPride = player:getQuestStatus(xi.quest.log_id.JEUNO, xi.quest.id.jeuno.COOK_S_PRIDE)
    local TheKindCardian = player:getQuestStatus(xi.quest.log_id.JEUNO, xi.quest.id.jeuno.THE_KIND_CARDIAN)
    local WildcatJeuno = player:getCharVar("WildcatJeuno")

    if (player:getQuestStatus(xi.quest.log_id.JEUNO, xi.quest.id.jeuno.LURE_OF_THE_WILDCAT) == QUEST_ACCEPTED and not utils.mask.getBit(WildcatJeuno, 13)) then
        player:startEvent(10053)
    elseif (TheWonderMagicSet == QUEST_COMPLETED and CooksPride == QUEST_AVAILABLE) then
        if (player:getCharVar("CooksPrideVar") == 0) then
            player:startEvent(189) -- Start quest "Cook's pride" Long CS
        else
            player:startEvent(188) -- Start quest "Cook's pride" Short CS
        end
    elseif (CooksPride == QUEST_ACCEPTED and player:hasKeyItem(xi.ki.SUPER_SOUP_POT) == false) then
        player:startEvent(186) -- During quest "Cook's pride"
    elseif (player:hasKeyItem(xi.ki.SUPER_SOUP_POT) == true) then
        player:startEvent(187) -- Finish quest "Cook's pride"
    elseif (CooksPride == QUEST_COMPLETED and TheKindCardian == QUEST_AVAILABLE) then
        if (player:getCharVar("theLostCardianVar") == 0) then
            player:startEvent(31) -- During quests "The lost cardian"
        else
            player:startEvent(71) -- During quests "The lost cardian"
        end
    elseif (CooksPride == QUEST_COMPLETED and TheKindCardian ~= QUEST_COMPLETED) then
        player:startEvent(71) -- During quests "The kind cardien"
    elseif (TheKindCardian == QUEST_COMPLETED) then
        player:startEvent(72) -- New standard dialog after the quest "The kind cardien"
    else
        player:startEvent(98) -- Standard dialog
    end
end

entity.onEventUpdate = function(player, csid, option)
end

entity.onEventFinish = function(player, csid, option)
    if ((csid == 189 or csid == 188) and option == 0) then
        player:addQuest(xi.quest.log_id.JEUNO, xi.quest.id.jeuno.COOK_S_PRIDE)
    elseif (csid == 189 and option == 1) then
        player:setCharVar("CooksPrideVar", 1)
    elseif (csid == 187) then
        if (player:getFreeSlotsCount() == 0) then
            player:messageSpecial(ID.text.ITEM_CANNOT_BE_OBTAINED, 13446)
        else
            player:addTitle(xi.title.MERCY_ERRAND_RUNNER)
            player:delKeyItem(xi.ki.SUPER_SOUP_POT)
            player:setCharVar("CooksPrideVar", 0)
            player:addGil(xi.settings.GIL_RATE * 3000)
            player:messageSpecial(ID.text.GIL_OBTAINED, xi.settings.GIL_RATE * 3000)
            player:addItem(13446)
            player:messageSpecial(ID.text.ITEM_OBTAINED, 13446) -- Mythril Ring
            player:addFame(JEUNO, 30)
            player:completeQuest(xi.quest.log_id.JEUNO, xi.quest.id.jeuno.COOK_S_PRIDE)
        end
    elseif (csid == 10053) then
        player:setCharVar("WildcatJeuno", utils.mask.setBit(player:getCharVar("WildcatJeuno"), 13, true))
    end
end

return entity
