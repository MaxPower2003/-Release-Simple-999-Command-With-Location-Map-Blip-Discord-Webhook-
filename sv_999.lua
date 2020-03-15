-- Simple 999 Command (With Location & Blip) -- 
		-- Made By Max Power --

displayLocation = true  -- By Changing this to 'false' it will make it so your location is not displayed in chat --
blips = true -- By Changing this to 'false' it will disable 999 call blips meaning your location will not be shown on the map --
disableChatCalls = false -- By Chaning this to 'false' it will make it so 999 call are not displayed in chat (Recommended to have Discord Webhook setup if disabling this) --
webhookurl = 'Insert Webhook URL Here' -- Add your discord webhook url here, if you do not want this leave it blank (More info on FiveM post) --
ondutymode = false -- By chaning this to 'true' it will make it so only Emergency Services and people who have used the 'onduty' command can see 999 calls and blips --

-- Code --

local onduty = false

RegisterServerEvent('999')
AddEventHandler('999', function(location, msg, x, y, z, name, ped)
	local playername = GetPlayerName(source)
	local ped = GetPlayerPed(source)
	if displayLocation == false then
		if disableChatCalls == false then
			TriggerClientEvent('chatMessage', -1, '', {255,255,255}, '^*^4999 | Caller ID: ^r' .. playername .. '^*^4 | Report: ^r' .. msg)
			sendDiscord('999 Communications', '**999 | Caller ID: **' .. playername .. '** | Report: **' .. msg)  
		else
			sendDiscord('999 Communications', '**999 | Caller ID: **' .. playername .. '** | Report: **' .. msg)  
		end
	else
		if disableChatCalls == false then
			if ondutymode then
				TriggerClientEvent('999:sendtoteam', -1, playername, location, msg, x, y, z)
				TriggerClientEvent('chatMessage', source, '', {255,255,255}, '^*^4999 | Caller ID: ^r' .. playername .. '^*^4 | Location: ^r' .. location .. '^*^4 | Report: ^r' .. msg)
				TriggerClientEvent('chatMessage', source, '', {255,255,255}, '^1This call has been sent to Emergency Services.')
			else 
				TriggerClientEvent('chatMessage', -1, '', {255,255,255}, '^*^4999 | Caller ID: ^r' .. playername .. '^*^4 | Location: ^r' .. location .. '^*^4 | Report: ^r' .. msg)
			end
			sendDiscord('999 Communications', '**999 | Caller ID: **' .. playername .. '** | Location: **' .. location .. '** | Report: **' .. msg)
		else
			sendDiscord('999 Communications', '**999 | Caller ID: **' .. playername .. '** | Location: **' .. location .. '** | Report: **' .. msg)
		end
		if blips == true then
			if not ondutymode then
				TriggerClientEvent('999:setBlip', -1, name, x, y, z)
			end 
		end
	end
end)

RegisterServerEvent('999:sendmsg')
AddEventHandler('999:sendmsg', function(name, location, msg, x, y, z)
	TriggerClientEvent('chatMessage', source, '', {255,255,255}, '^*^3Dispatch: ^4999 | Caller ID: ^r' .. name .. '^*^4 | Location: ^r' .. location .. '^*^4 | Report: ^r' .. msg)
	if blips then
		TriggerClientEvent('999:setBlip', source, name, x, y, z)
	end
end)

function sendDiscord(name, message)
	local content = {
        {
        	["color"] = '5015295',
            ["title"] = "**".. name .."**",
            ["description"] = message,
            ["footer"] = {
                ["text"] = "Simple 999 Command | Made by Max Power",
            },
        }
    }
  	PerformHttpRequest(webhookurl, function(err, text, headers) end, 'POST', json.encode({username = name, embeds = content}), { ['Content-Type'] = 'application/json' })
end


	