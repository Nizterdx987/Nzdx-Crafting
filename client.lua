function Additem(nama, banyak)
    if tonumber(banyak) < 0 then return end
        TriggerServerEvent('Nzdx-Craft:Inventory', {Jenis = 'add', Nama = nama, Jumlah = banyak})
    return
end

function Removeitem(nama, banyak)
    if tonumber(banyak) < 0 then return end
        TriggerServerEvent('Nzdx-Craft:Inventory', {Jenis = 'del', Nama = nama, Jumlah = banyak})
    return
end

CreateThread(function()
    for k, v in pairs(Nzdx.TempatCrafting) do
		exports[Nzdx.NamaTarget]:AddCircleZone("Crafting_"..v.Nama, v.Lokasi, 1.0, {
			name        = "Crafting_"..v.Nama,
			debugPoly   = false,
			useZ        = true,
			}, {
				options = {
					{
						event   = "Nzdx-Craft:ListMenu",
						icon    = "far fas fa-paste",
						label   = "Akses Crafting",
                        job     = Nzdx.AksesCrafting,
                        canInteract = function(entity) return not GlobalState['sedangCrafting'] end
					}
				},
			distance = 2.0
		})
        
        if v.Blips == true then
			CraftBlips = AddBlipForCoord(v.Lokasi[1], v.Lokasi[2], v.Lokasi[3])
            SetBlipSprite(CraftBlips, 643)
            SetBlipDisplay(CraftBlips, 4)
            SetBlipScale(CraftBlips, 0.8)
            SetBlipColour(CraftBlips, 1)
            SetBlipAsShortRange(CraftBlips, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(v.Nama)
            EndTextCommandSetBlipName(CraftBlips)
        end
    end
end)

RegisterNetEvent('Nzdx-Craft:ListMenu', function()
    crafting = {}
    ListItem = {}
    for k, v in pairs(Nzdx.BahanCraft) do
        local item  = {}
        local text  = ""
        local Nzdx  = exports.ox_inventory:Items()

        for a, b in pairs(v.Bahan) do
            text = text .. " 🔨 " .. Nzdx[b.Nama].label .. ":" .. b.Jumlah .. " x " .. "\n"          
        end

        crafting[#crafting + 1] = {
            title       = v.Label,
            description = text,
            event       = 'Nzdx-Craft:CekBahan',
            args        = {
                Nama    = v.Label,
                Item    = k,
                Waktu   = v.Waktu,
                Hasil   = v.Hasil,
                Jumlah  = v.Dapat
            }
        }
    end

    lib.registerContext({
        id      = 'nzdx:crafting',
        title   = 'Crafting Menu',
        options = crafting
    })

    lib.showContext('nzdx:crafting')
end)

RegisterNetEvent('Nzdx-Craft:CekBahan', function(data)
    ESX.TriggerServerCallback('Nzdx-Craft:KondisiBahan', function(CekKondisi)
        if CekKondisi then
            TriggerEvent('Nzdx-Craft:ActionCrafting', data.Nama, data.Item, tonumber(data.Waktu), data.Hasil, data.Jumlah)
        else
            return
        end
    end, Nzdx.BahanCraft[data.Item].Bahan)
end)

RegisterNetEvent('Nzdx-Craft:ActionCrafting', function(Nama, Item, Durasi, Hasil, Angka)
    local Bahan = Nzdx.BahanCraft[Item].Bahan
    if Nzdx.PakiMiniGame then
        local Kondisi = lib.skillCheck({'easy', 'easy', {areaSize = 60, speedMultiplier = 2}, 'hard'}, {'w', 'a', 's', 'd'})
        if Kondisi == true then
            FreezeEntityPosition(cache.ped, true)
            GlobalState['sedangCrafting']   = true
            if lib.progressBar({
                    duration     = Durasi,
                    label        = Nama,
                    useWhileDead = false,
                    canCancel    = true,
                    disable = {
                        car = true,
                    },
                    anim = {
                        dict = 'mini@repair',
                        clip = 'fixing_a_player'
                    },
                })
            then 
                for k, v in pairs(Bahan) do
                    Removeitem(v.Nama, v.Jumlah)
                end
                Additem(Hasil, Angka)
                FreezeEntityPosition(cache.ped, false)
                GlobalState['sedangCrafting']   = false
            else
                FreezeEntityPosition(cache.ped, false)
                GlobalState['sedangCrafting']   = false
                lib.notify({
                    title       = 'Nzdx-Crafting',
                    description = 'Anda Baru Saja Menggagalkan Crafting',
                    type        = 'error'
                })
            end
        else
            GlobalState['sedangCrafting']   = false
            lib.notify({
                title       = 'Nzdx-Crafting',
                description = 'Anda Gagal Dalam Crafting',
                type        = 'error'
            })
        end
    else
        FreezeEntityPosition(cache.ped, true)
        GlobalState['sedangCrafting']   = true
        if lib.progressBar({
                duration     = Durasi,
                label        = Nama,
                useWhileDead = false,
                canCancel    = true,
                disable = {
                    car = true,
                },
                anim = {
                    dict = 'mini@repair',
                    clip = 'fixing_a_player'
                },
            })
        then 
            for k, v in pairs(Bahan) do
                Removeitem(v.Nama, v.Jumlah)
            end
            Additem(Hasil, Angka)
            FreezeEntityPosition(cache.ped, false)
            GlobalState['sedangCrafting']   = false
        else
            FreezeEntityPosition(cache.ped, false)
            GlobalState['sedangCrafting']   = false
            lib.notify({
                title       = 'Nzdx-Crafting',
                description = 'Anda Baru Saja Menggagalkan Crafting',
                type        = 'error'
            })
        end
    end
end)