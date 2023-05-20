RegisterServerEvent('Nzdx-Craft:Inventory', function(data)
    local xP = ESX.GetPlayerFromId(source)
    if data.Jenis == 'add' then
        if xP.getWeight() >= Nzdx.BeratInventory then
            TriggerClientEvent('ox_lib:notify', source, { type = 'error', description = 'Tas Kamu Penuh'})
        else
            exports.ox_inventory:AddItem(source, data.Nama, data.Jumlah)  
        end
    elseif data.Jenis == 'del' then
        if exports.ox_inventory:GetItem(source, data.Nama, nil, true) >= data.Jumlah then
            exports.ox_inventory:RemoveItem(source, data.Nama, data.Jumlah)
        end
    end
end)

ESX.RegisterServerCallback('Nzdx-Craft:KondisiBahan', function(source, cb, Bahan)
    local src       = source
    local jumlah    = 0
    local xP        = ESX.GetPlayerFromId(src)

    if not GlobalState['sedangCrafting'] then
        for k, v in pairs(Bahan) do
            if xP.getInventoryItem(v.Nama) and xP.getInventoryItem(v.Nama).count >= v.Jumlah then
                jumlah = jumlah + 1
                if jumlah == #Bahan then
                    cb(true)
                end
            else
                TriggerClientEvent('ox_lib:notify', src, { type = 'error', description = "Kamu Tidak Cukup Memiliki Bahan"})
                cb(false)
                return
            end
        end
    else
        TriggerClientEvent('ox_lib:notify', src, { type = 'error', description = "Kamu Sedang Melakukan Crafting"})
    end
end)