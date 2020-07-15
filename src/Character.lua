Character = Class{}

function Character:init(def, level)
    self.name = def.name
    self.type = def.type
    self.id = def.id

    self.animations = self:createAnimations(def.animations)

    self.baseHP = def.baseHP
    self.baseAttack = def.baseAttack
    self.baseDefense = def.baseDefense
    self.baseSpeed = def.baseSpeed

    self.HP = self.baseHP
    self.attack = self.baseAttack
    self.defense = self.baseDefense
    self.speed = self.baseSpeed

    self.expPerLvl = def.expPerLvl or 0
    self.level = level
    
    self.currentExp = 0
    self.expToLevel = self.level * self.level * 5 * 0.75

    self.levelUpPoints = 0

    self:calculateStats()
    
    self.currentHP = self.HP

    self.healthBar = nil
    self.displayHealthBar = nil
    self.expBar = nil

    -- used to determine current location of character in game
    self.currentScreenX = nil
    self.currentScreenY = nil

    self.opacity = def.opacity or 255

    -- used to determine the target number
    self.target = nil
    self.targetSelected = false
    self.attacked = false

    self.isDead = false
end

function Character:update(dt)
    self.currentAnimation:update(dt)
end

function Character:changeAnimation(name)
    self.currentAnimation = self.animations[name]
end

function Character:createAnimations(animations)
    local animationsReturned = {}

    for k, animationDef in pairs(animations) do
        animationsReturned[k] = Animation {
            texture = animationDef.texture or 'entities',
            frames = animationDef.frames,
            interval = animationDef.interval
        }
    end

    return animationsReturned
end

function Character:calculateStats()
    self.levelUpPoints = self.levelUpPoints + (self.level - 1) * LEVEL_UP_STATS_UPGRADE

    self:statsLevelUp()
end

function Character:statsLevelUp()
    local stats = {'hp', 'attack', 'defense', 'speed'}

    while not (self.levelUpPoints == 0) do
        self:increaseStat(stats[math.random(#stats)], 1)
        self.levelUpPoints = self.levelUpPoints - 1
    end
end

function Character:levelUp()
    self.level = self.level + 1
    self.expToLevel = self.level * self.level * 5 * 0.75

    self.levelUpPoints = self.levelUpPoints + LEVEL_UP_STATS_UPGRADE
end

function Character:increaseStat(stat, increaseAmount)
    if stat == 'hp' then
        self.HP = self.HP + increaseAmount
        self.currentHP = self.currentHP + increaseAmount
    elseif stat == 'attack' then
        self.attack = self.attack + increaseAmount
    elseif stat == 'defense' then
        self.defense = self.defense + increaseAmount
    elseif stat == 'speed' then
        self.speed = self.speed + increaseAmount
    end

    return stat, increaseAmount
end

function Character:render()
    love.graphics.setColor(255, 255, 255, self.opacity)
    love.graphics.draw(gTextures[self.currentAnimation.texture], gFrames[self.currentAnimation.texture][self.currentAnimation:getCurrentFrame()], self.currentScreenX, self.currentScreenY)
end