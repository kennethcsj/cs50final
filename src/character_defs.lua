CHARACTER_IDS = {
    'player-boy', 'player-girl'
}

CHARACTER_DEFS = {
    ['player-boy'] = {
        name = 'Ken',
        type = 'hero',
        id = 'player-boy',
        baseHP = 10,
        baseAttack = 5,
        baseDefense = 5,
        baseSpeed = 5,
        animations = {
            ['idle-left'] = {
                frames = {17},
                texture = 'entities'
            },
            ['idle-right'] = {
                frames = {29},
                texture = 'entities'
            },
            ['idle-down'] = {
                frames = {5},
                texture = 'entities'
            }
        }
    },
    ['player-girl'] = {
        name = 'Ni',
        type = 'hero',
        id = 'player-girl',
        baseHP = 10,
        baseAttack = 5,
        baseDefense = 5,
        baseSpeed = 5,
        animations = {
            ['idle-left'] = {
                frames = {20},
                texture = 'entities'
            },
            ['idle-right'] = {
                frames = {32},
                texture = 'entities'
            },
            ['idle-down'] = {
                frames = {8},
                texture = 'entities'
            },
        }
    },
}

ENEMY_DEFS = {
    ['bat'] = {
        name = 'Bat',
        type = 'enemy',
        baseHP = 5,
        baseAttack = 2,
        baseDefense = 2,
        baseSpeed = 6,
        expPerLvl = 3,
        animations = {
            ['idle-left'] = {
                frames = {64, 65, 66, 65},
                interval = 0.2
            },
            ['idle-right'] = {
                frames = {76, 77, 78, 77},
                interval = 0.2
            },
        }
    },
    ['boss'] = {
        name = 'Bat Boss',
        type = 'boss',
        baseHP = 50,
        baseAttack = 10,
        baseDefense = 10,
        baseSpeed = 10,
        expPerLvl = 10,
        animations = {
            ['idle-left'] = {
                frames = {7, 8, 9},
                interval = 0.2,
                texture = 'boss'
            },
            ['idle-right'] = {
                frames = {13, 14, 15},
                interval = 0.2,
                texture = 'boss'
            },
        }
    },
}