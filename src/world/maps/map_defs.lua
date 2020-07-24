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
}