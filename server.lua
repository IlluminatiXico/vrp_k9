local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")

local function ch_dog_sit(player,choice)
  TriggerClientEvent("vrp_dog:sit", player)
end

local function ch_dog_laydown(player,choice)
  TriggerClientEvent("vrp_dog:laydown", player)
end

local function ch_dog_spawngod(player,choice)
  TriggerClientEvent("vrp_dog:spawndog",player)
end

vRP.registerMenuBuilder("main", function(add, data)
  local user_id = vRP.getUserId(data.player)
  if user_id then
    local choices = {}

    -- build k9 menu
    choices["K9"] = {function(player,choice)
      local menu  = vRP.buildMenu("dogs", {player = player})
      menu.name = "K9"
      menu.css={top="75px",header_color="#9167dd"}
      menu.onclose = function(player) vRP.openMainMenu(player) end -- onclose event and open main menu

      if vRP.hasPermission(user_id,"player.list") then -- sit
        menu["Сидеть"] = {ch_dog_sit}
      end
      if vRP.hasPermission(user_id, "player.list") then -- laydown
        menu["Лежать"] = {ch_dog_laydown}
      end
      if vRP.hasPermission(user_id, "player.list") then -- spawn dog / delete dog
        menu["Заспавнить/удалить собаку"] = {ch_dog_spawngod, "[G] что бы собака следовала. [ПКМ+G] что атаковать "}
      end

      vRP.openMenu(player,menu)
    end}

    add(choices)
  end
end)