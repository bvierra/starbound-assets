function init()
  self.applyToTypes = effect.configParameter("applyToTypes") or {"player", "npc"}

  self.mouthPosition = status.statusProperty("mouthPosition") or {0,0}
  self.mouthBounds = {self.mouthPosition[1], self.mouthPosition[2], self.mouthPosition[1], self.mouthPosition[2]}
  self.setWet = false

  animator.setParticleEmitterOffsetRegion("bubbles", self.mouthBounds)
end

function allowedType()
  local entityType = world.entityType(entity.id())
  for _,applyType in ipairs(self.applyToTypes) do
    if entityType == applyType then 
      return true
    end
  end
end

function update(dt)
  if not allowedType then return false end

  local position = mcontroller.position()
  local worldMouthPosition = {
    self.mouthPosition[1] + position[1],
    self.mouthPosition[2] + position[2]
  }

  local liquidAtMouth = false
  if world.visibleLiquidAt then
    liquidAtMouth = world.visibleLiquidAt(worldMouthPosition)
  elseif world.liquidAt then
    liquidAtMouth = world.liquidAt(worldMouthPosition)
  end

  if liquidAtMouth and (liquidAtMouth[1] == 1 or liquidAtMouth[1] == 2) then 
    animator.setParticleEmitterActive("bubbles", true)
    self.setWet = true
  else
    animator.setParticleEmitterActive("bubbles", false)
  end

  status.removeEphemeralEffect("wet")
end

function uninit()
  if self.setWet then
    status.addEphemeralEffect("wet")
  end
end