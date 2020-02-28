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


-- Build item menu rottweiler
local ch_dog_rottweiler = {}  
ch_dog_rottweiler["Заспавнить/удалить собаку"] = {function(player,choice)
  local user_id = vRP.getUserId(player) -- get user_id
  if user_id then
      TriggerClientEvent("vrp_dog:spawndog_rottweiler",player)
      vRP.closeMenu(player)
    end
end,"Милая собачка"}

ch_dog_rottweiler["Лежать"] = {function(player,choice) -- 
  local user_id = vRP.getUserId(player) -- get user_id
  if user_id then
      TriggerClientEvent("vrp_dog:laydown",player)
      vRP.closeMenu(player) 
    end
end}

ch_dog_rottweiler["Сидеть"] = {function(player,choice) -- 
  local user_id = vRP.getUserId(player) -- get user_id
  if user_id then
      TriggerClientEvent("vrp_dog:sit",player)
      vRP.closeMenu(player) 
    end
end}

-- add item definition
vRP.defInventoryItem("dog_rottweiler","Ротвейлер","<img src='https://i.imgur.com/l9Xyi8g.png' height='200' width='200' />",function() return ch_dog_rottweiler end,0.5)

--Build item menu husky

local ch_dog_a_c_husky = {}  
ch_dog_a_c_husky["Заспавнить/удалить собаку"] = {function(player,choice)
  local user_id = vRP.getUserId(player) -- get user_id
  if user_id then
      TriggerClientEvent("vrp_dog:spawndog_husky",player)
      vRP.closeMenu(player)
    end
end,"Милая собачка"}

ch_dog_a_c_husky["Лежать"] = {function(player,choice) -- 
  local user_id = vRP.getUserId(player) -- get user_id
  if user_id then
      TriggerClientEvent("vrp_dog:laydown",player)
      vRP.closeMenu(player) 
    end
end}

ch_dog_a_c_husky["Сидеть"] = {function(player,choice) -- 
  local user_id = vRP.getUserId(player) -- get user_id
  if user_id then
      TriggerClientEvent("vrp_dog:sit",player)
      vRP.closeMenu(player) 
    end
end}

vRP.defInventoryItem("dog_husky","Хаски","<img src='https://i.imgur.com/U4ko0PK.png' height='200' width='200' />",function() return ch_dog_a_c_husky end,0.5)

--Build item menu
local ch_dog_shepherd = {}  
ch_dog_shepherd["Заспавнить/удалить собаку"] = {function(player,choice)
  local user_id = vRP.getUserId(player) -- get user_id
  if user_id then
      TriggerClientEvent("vrp_dog:spawndog_shepherd",player)
      vRP.closeMenu(player)
    end
end,"Милая собачка"}

ch_dog_shepherd["Лежать"] = {function(player,choice) -- 
  local user_id = vRP.getUserId(player) -- get user_id
  if user_id then
      TriggerClientEvent("vrp_dog:laydown",player)
      vRP.closeMenu(player) 
    end
end}

ch_dog_shepherd["Сидеть"] = {function(player,choice) -- 
  local user_id = vRP.getUserId(player) -- get user_id
  if user_id then
      TriggerClientEvent("vrp_dog:sit",player)
      vRP.closeMenu(player) 
    end
end}

vRP.defInventoryItem("dog_shepherd","Дворняжная собака","<img src='https://i.imgur.com/5khxQgd.png' height='200' width='200' />",function() return ch_dog_shepherd end,0.5)

--Build item menu retriever

local ch_dog_retriever = {}  
ch_dog_retriever["Заспавнить/удалить собаку"] = {function(player,choice)
  local user_id = vRP.getUserId(player) -- get user_id
  if user_id then
      TriggerClientEvent("vrp_dog:spawndog_retriever",player)
      vRP.closeMenu(player)
    end
end,"Милая собачка"}

ch_dog_retriever["Лежать"] = {function(player,choice) -- 
  local user_id = vRP.getUserId(player) -- get user_id
  if user_id then
      TriggerClientEvent("vrp_dog:laydown",player)
      vRP.closeMenu(player) 
    end
end}

ch_dog_retriever["Сидеть"] = {function(player,choice) -- 
  local user_id = vRP.getUserId(player) -- get user_id
  if user_id then
      TriggerClientEvent("vrp_dog:sit",player)
      vRP.closeMenu(player) 
    end
end}

vRP.defInventoryItem("dog_retriever","Дворняжка","<img src='https://i.imgur.com/295yW9s.png' height='200' width='200' />",function() return ch_dog_retriever end,0.5)
