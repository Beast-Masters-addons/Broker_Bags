local addonName = ...
---@class BrokerBags
local addon = _G.LibStub("AceAddon-3.0"):NewAddon("BrokerBags")
_G['BrokerBags'] = addon
addon.version = '@project-version@'
addon.major, addon.minor = _G['BMUtils-Version'].parse_version(addon.version)

---Internal addon name
---@type string
addon.name = addonName

---Wow major version
---@type number
addon.wow_major = math.floor(tonumber(select(4, _G.GetBuildInfo()) / 10000))

local GetAddOnMetadata = _G.GetAddOnMetadata or (_G.C_AddOns and _G.C_AddOns.GetAddOnMetadata)
---Addon title to show to user
---@type string
addon.title = GetAddOnMetadata(addon.name, "Title")
---Addon notes
---@type string
addon.notes = GetAddOnMetadata(addon.name, "Notes")
