MAP_DEFS = {
    ['portal'] = {
        solid = false,
        consumable = false,
        interactable = false,
        contactable = true,
        texture = 'portals',
        width = 48,
        height = 48,
        animations = {
            ['default'] = {
                frames = {3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13},
                interval = 0.15,
                texture = 'portals',
            }
        }
    },
    ['chest'] = {
        solid = false,
        consumable = false,
        interactable = true,
        contactable = false,
        texture = 'chest',
        width = 16,
        height = 24,
        animations = {
            ['default'] = {
                frames = {2},
                texture = 'chest',
            },
            ['open'] = {
                frames = {38},
                texture = 'chest'
            }
        }
    },
    ['metal-gate-hor-mid'] = {
        isSolid = true,
        isConsumable = false,
        texture = 'tiles',
        frame = 77
    },
    ['metal-gate-hor-left'] = {
        isSolid = true,
        isConsumable = false,
        texture = 'tiles',
        frame = 80
    },
    ['metal-gate-hor-right'] = {
        isSolid = true,
        isConsumable = false,
        texture = 'tiles',
        frame = 79
    },
    ['metal-gate-ver'] = {
        isSolid = true,
        isConsumable = false,
        texture = 'tiles',
        frame = 84
    },
    ['wooden-gate-hor-mid'] = {
        isSolid = true,
        isConsumable = false,
        texture = 'tiles',
        frame = 74
    },
    ['wooden-gate-hor-left'] = {
        isSolid = true,
        isConsumable = false,
        texture = 'tiles',
        frame = 66
    },
    ['wooden-gate-hor-right'] = {
        isSolid = true,
        isConsumable = false,
        texture = 'tiles',
        frame = 65
    },
    ['wooden-gate-ver'] = {
        isSolid = true,
        isConsumable = false,
        texture = 'tiles',
        frame = 81
    },
}