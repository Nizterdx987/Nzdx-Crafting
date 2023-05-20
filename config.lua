Nzdx = {}

Nzdx.BeratInventory = 400000
Nzdx.NamaTarget     = 'qtarget'
Nzdx.PakiMiniGame   = false

Nzdx.AksesCrafting  = {
    ['police'] = 0,
}
Nzdx.TempatCrafting = {
    {
        Nama        = 'Crafting Pelabuhan', -- Nama lokasi crafting
        Lokasi      = vector3(605.3633, -3095.3330, 6.0693), -- Koordinat lokasi crafting dalam format vector3
        Blips       = true -- Apakah ingin menampilkan blip pada lokasi crafting (true/false)
    },
}

Nzdx.BahanCraft = {
    ["Weapon_CombatPistol"]  = {
        Nama    = 'Weapon_CombatPistol',
        Label   = '[PD] Combat Pistol',
        Waktu   = 10000,
        Bahan   = {
            [1] = { Nama = "iron", Jumlah = 5 },
            [2] = { Nama = "gold", Jumlah = 5 }
        },
        Hasil   = "Weapon_CombatPistol",
        Dapat   = 1,
    },

    ["bandage"]  = {
        Nama    = 'bandage"',
        Label   = 'Perban',
        Waktu   = 7000,
        Bahan   = {
            [1] = { Nama = "medikit", Jumlah = 10 },
        },
        Hasil   = "bandage",
        Dapat   = 5,
    },
}
