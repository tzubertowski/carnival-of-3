-- confetti system for carnival atmosphere

confetti = {}

function init_confetti(count)
 confetti = {}
 for i = 1, count do
  local w = flr(rnd(3)) + 2  -- 2-4 pixels wide
  local h = flr(rnd(5)) + 4  -- 4-8 pixels tall

  -- 20% chance to flip (wider than tall)
  if rnd(1) < 0.2 then
   w, h = h, w
  end

  add(confetti, {
   x = rnd(128),
   y = rnd(128) - 128,
   vy = rnd(0.5) + 0.3,
   wobble = rnd(1),
   wobble_speed = rnd(0.05) + 0.02,
   style = flr(rnd(2)),
   width = w,
   height = h
  })
 end
end

function update_particles()
 for c in all(confetti) do
  c.y += c.vy
  c.wobble = (c.wobble + c.wobble_speed) % 1
  -- remove if off screen
  if c.y > 128 then
   del(confetti, c)
   -- respawn at top
   local w = flr(rnd(3)) + 2
   local h = flr(rnd(5)) + 4
   if rnd(1) < 0.2 then
    w, h = h, w
   end

   add(confetti, {
    x = rnd(128),
    y = -8,
    vy = rnd(0.5) + 0.3,
    wobble = rnd(1),
    wobble_speed = rnd(0.05) + 0.02,
    style = flr(rnd(2)),
    width = w,
    height = h
   })
  end
 end
end

function draw_particles(pulse_t)
 for c in all(confetti) do
  local wobble_x = sin(c.wobble) * 1.5
  local x1 = c.x + wobble_x
  local y1 = c.y
  local x2 = x1 + c.width - 1
  local y2 = y1 + c.height - 1

  if c.style == 0 then
   -- black body with white border
   rectfill(x1, y1, x2, y2, 0)
   rect(x1, y1, x2, y2, 7)
  else
   -- white solid
   rectfill(x1, y1, x2, y2, 7)
  end
 end
end
