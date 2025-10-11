---@class BrokerBagsBags
local bags = _G['BrokerBags']:NewModule('BrokerBagsBags', "AceEvent-3.0")

---@class BagObject
local bag_obj = {
    bagIndex = nil,
    slots = nil,
    free = nil,
    used = nil,
}

local function in_range(value, low, high)
    return value >= low and value <= high
end

function bag_obj:getItemInfo(slot)
    return _G.C_Container.GetContainerItemInfo(self.bagIndex, slot)
end

function bag_obj:pickupItem(slot)
    return _G.C_Container.PickupContainerItem(self.bagIndex, slot)
end

function bag_obj:isAmmoBag()
    return in_range(self.bagFamily, 1, 3)
end

function bag_obj:isProfessionBag()
    return in_range(self.bagFamily, 4, 27)
end

function bag_obj:open()
    _G.OpenBag(self.bagIndex)
end

---@param bagIndex number The slot containing the bag, e.g. 0 for backpack, etc.
---@return BagObject
function bags:getBag(bagIndex)
    local data = _G.CreateFromMixins(bag_obj)
    data.bagIndex = bagIndex
    data.slots = _G.C_Container.GetContainerNumSlots(bagIndex)
    if data.slots == 0 then
        return --Bag slot not populated
    end
    data.free, data.bagFamily = _G.C_Container.GetContainerNumFreeSlots(bagIndex)
    data.used = data.slots - data.free

    return data
end

---Toggle all bags
function bags:toggleBags()
    if _G.ToggleAllBags then
        _G.ToggleAllBags()
    else
        if _G.ContainerFrame1:IsShown() then
            _G.CloseAllBags()
        else
            _G.OpenAllBags()
        end
    end
end

