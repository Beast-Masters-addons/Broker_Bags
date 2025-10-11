---@class BrokerBagsOptions
local options = _G['BrokerBags']:NewModule('BrokerBagsOptions', "AceEvent-3.0")
---@type BrokerBags
local addon = _G['BrokerBags']

---@type BMUtilsBasic
local basic = _G.LibStub("BMUtilsBasic")

local AceConfig = _G.LibStub("AceConfig-3.0")
local AceConfigDialog = _G.LibStub("AceConfigDialog-3.0")

function options:getOptionsTable()
    ---@type BrokerBagsLDB
    local ldb = addon:GetModule('BrokerBagsLDB')

    local bagOptionsTable = {
        type = "group",
        get = function(info)
            return options.db[info[#info]]
        end,
        set = function(info, value)
            options.db[info[#info]] = value
            ldb:updateFillText()
        end,
        args = {
            confdesc = {
                order = 1,
                type = "description",
                name = addon.notes,
            },
            separator1 = {
                order = 100,
                type = "header",
                name = "General options",
            },
            minimap = {
                order = 101,
                name = "Minimap icon",
                desc = "Show minimap icon",
                type = "toggle",
                set = function()
                    if type(options.db.minimap) ~= 'boolean' then
                        options.db.minimap = true
                    else
                        options.db.minimap = not options.db.minimap
                    end

                    if options.db.minimap then
                        ldb.icon:Show(addon.title)
                    else
                        ldb.icon:Hide(addon.title)
                    end
                end,
            },
            separator2 = {
                order = 200,
                type = "header",
                name = "Bag types to include in slot count",
            },
            includeProfession = {
                type = "toggle",
                order = 201,
                name = "Profession",
                desc = "Include profession bags in slot count",
            },
            includeAmmo = {
                type = "toggle",
                order = 202,
                name = "Ammunition",
                desc = "Include ammunition bags in slot count",
            },
            separator3 = {
                order = 300,
                type = "header",
                name = "Display options",
            },
            showFreeSpace = {
                type = "toggle",
                order = 303,
                name = "Free slots",
                desc = "Show total number of free bag slots",
            },
            showTotal = {
                type = "toggle",
                order = 304,
                name = "Total slots",
                desc = "Show the total amount of slots in your bags",
            },
        }
    }
    if addon.wow_major > 3 then
        bagOptionsTable['args']['includeAmmo'] = nil
    end

    return bagOptionsTable
end

function options:reset()
    self.db = {
        showFreeSpace = true,
        includeAmmo = false,
        includeProfession = false,
        showTotal = true,
        minimap = false,
    }
end

function options:OnInitialize()
    local db = _G.LibStub("AceDB-3.0"):New("BrokerBagsDB")
    self.db = db.profile

    if basic.empty(self.db) then
        self:reset()
    end
end

function options:OnEnable()
    -- Register the config
    AceConfig:RegisterOptionsTable(addon.title, self:getOptionsTable())
    AceConfigDialog:AddToBlizOptions(addon.title, addon.title)
end