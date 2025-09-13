dofile_once("data/scripts/lib/utilities.lua") -- Noita's internal utilities

function OnModInit()
	local player_name = ModSettingGet("scipio-sprite-mod.player_name")
	local translations = ModTextFileGetContent("data/translations/common.csv")
	translations = translations .. [["animal_player","]] .. player_name .. [[",,,,,,,,,,,,,]]
	ModTextFileSetContent("data/translations/common.csv", translations)
end

-- mostly ripped from the random loadout mod
function OnPlayerSpawned(player_entity)
	local check_flag = "scipio sprite mod init done"
	if GameHasFlagRun(check_flag) then return end
	GameAddFlagRun(check_flag)

	local player_sprite_comp = nil
	local player_lukky_comp = EntityGetFirstComponentIncludingDisabled(player_entity, "SpriteComponent", "lukki_enable")
	local player_arm_id = nil
	local cape_id = nil
	for _, child in pairs(EntityGetAllChildren(player_entity)) do
		local entity_tags = EntityGetTags(child)
		if string.match(entity_tags, "lukki_disable") then
			player_sprite_comp = child
		end
		if EntityGetName(child) == "arm_r" then
			player_arm_id = child
		end
		if EntityGetName(child) == "cape" then
			cape_id = child
		end
	end
	player_sprite_comp = EntityGetFirstComponent(player_entity, "SpriteComponent")
	local player_sprite_file = "mods/Scipio-Sprite-Mod/scipio/player.xml"
	ComponentSetValue(player_sprite_comp, "image_file", player_sprite_file)

	player_sprite_comp = EntityGetFirstComponent(player_entity, "SpriteComponent")
	local player_lukky_file = "mods/Scipio-Sprite-Mod/scipio/player_lukky.xml"
	ComponentSetValue(player_lukky_comp, "image_file", player_lukky_file)

	local player_arm_sprite_comp = EntityGetFirstComponent(player_arm_id, "SpriteComponent")
	local player_arm_sprite_file = "mods/Scipio-Sprite-Mod/scipio/player_arm.xml"
	ComponentSetValue(player_arm_sprite_comp, "image_file", player_arm_sprite_file)

	local player_ragdoll_comp = EntityGetFirstComponent(player_entity, "DamageModelComponent")
	local player_ragdoll_file = "mods/Scipio-Sprite-Mod/scipio/ragdolls/filenames.txt"
	ComponentSetValue(player_ragdoll_comp, "ragdoll_filenames_files", player_ragdoll_file)

	local player_x, player_y = EntityGetTransform(player_entity)
	local tail_id = EntityLoad("mods/Scipio-Sprite-Mod/scipio/tail/verlet_tail.xml", player_x, player_y)
	EntityAddChild(player_entity, tail_id)

	if ModSettingGet("scipio-sprite-mod.cape_toggle") then
		EntityKill(cape_id)
	end
end
