-- particle system

particles = {}

function clear_particles()
 particles = {}
end

function init_particles(count, center_x, center_y, orbit_dist)
 for i = 1, count do
  add(particles, {
   angle = rnd(1),
   angle_speed = (rnd(0.003) + 0.0008) * (rnd(1) > 0.5 and 1 or -1),
   orbit_radius = rnd(4) + orbit_dist,
   flicker_phase = flr(rnd(5)),
   center_x = center_x,
   center_y = center_y
  })
 end
end

function update_particles()
 for p in all(particles) do
  p.angle = (p.angle + p.angle_speed) % 1
 end
end

function draw_particles(pulse_t)
 for p in all(particles) do
  if (pulse_t + p.flicker_phase) % 4 > 0 then
   pset(
    p.center_x + cos(p.angle) * (28 + p.orbit_radius),
    p.center_y + sin(p.angle) * (28 + p.orbit_radius),
    7
   )
  end
 end
end
