---@class BrokerBagsLDB
local ldb = _G['BrokerBags']:NewModule('BrokerBagsLDB', "AceEvent-3.0")
---@type BrokerBags
local addon = _G['BrokerBags']

---@type BrokerBagsBags
local bags = addon:GetModule('BrokerBagsBags')

---@type BrokerBagsOptions
local options = addon:GetModule('BrokerBagsOptions')

function ldb:OnInitialize()
    self.ldb = _G.LibStub:GetLibrary("LibDataBroker-1.1")

    ---LDB data object
    self.obj = self.ldb:NewDataObject(addon.title, {
        type = "data source",
        text = '?/?',
        icon = "Interface\\Icons\\INV_Misc_Bag_08"
    })

    self.obj.OnTooltipShow = self.OnTooltipShow
    self.obj.OnClick = self.OnClick

    self.icon = _G.LibStub("LibDBIcon-1.0")
    self.icon:Register(addon.title, self.obj, options.db)
end

function ldb:OnEnable()
    self:RegisterEvent("BAG_UPDATE_DELAYED")
    if addon.wow_major == 3 then
        self:RegisterEvent("BAG_UPDATE")
    end
    self:updateFillText()
end

function ldb:BAG_UPDATE_DELAYED()
    self:updateFillText()
end

function ldb:BAG_UPDATE()
    self:updateFillText()
end

---setText
---@param text string
---@param color ColorMixin
function ldb:setText(text, color)
    if color then
        self.obj.text = color:WrapTextInColorCode(text)
    else
        self.obj.text = text
    end

end

function ldb:updateBagStats(bagSlot)
    local bag = bags:getBag(bagSlot)
    if not bag then
        return
    end
    if not options.db.includeAmmo and bag:isAmmoBag() then
        return
    end

    if not options.db.includeProfession and bag:isProfessionBag() then
        return
    end

    self.totalSlots = self.totalSlots + bag.slots
    self.usedSlots = self.usedSlots + bag.used
    self.freeSlots = self.freeSlots + bag.free
end

function ldb:updateAllBags()
    self.totalSlots = 0
    self.usedSlots = 0
    self.freeSlots = 0
    for i = 0, _G.NUM_BAG_SLOTS do
        self:updateBagStats(i)
    end
end

function ldb:updateFillText()
    self:updateAllBags()

    local slots
    if options.db.showFreeSpace then
        slots = self.freeSlots
    else
        slots = self.usedSlots
    end

    if options.db.showTotal then
        self:setText(("%d/%d"):format(
            slots,
            self.totalSlots
        ))
    else
        self:setText(("%d"):format(slots))
    end

end

function ldb:OnTooltipShow()
    self:AddLine("Click to open your bags")
    self:AddLine("Right-Click to open options menu")
end

function ldb:OnClick(button)
    if button == "LeftButton" then
        bags:toggleBags()
    elseif button == "RightButton" then
        _G.Settings.OpenToCategory(addon.title)
    end
end