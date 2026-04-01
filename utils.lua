-- utility functions

-- blinking selection box around interactive content
function draw_select_box(x, y, w, h)
 if (pulse_timer \ 8) % 2 == 0 then
  rect(x, y, x + w, y + h, 7)
 end
end

-- static prompt box (no typewriter) with blinking >>
function draw_prompt(text)
 local bx, by, bw, bh = 4, 88, 120, 32
 rectfill(bx, by, bx+bw, by+bh, 0)
 rect(bx, by, bx+bw, by+bh, 7)
 print(text, bx+5, by+5, 7)
 if (pulse_timer \ 10) % 2 == 0 then
  print(">>>", bx+bw-15, by+bh-8, 7)
 end
end

-- 3d wireframe cube tumbling on two axes
function draw_rolling_die(cx, cy, t)
 local ax = t * 0.019
 local ay = t * 0.031
 local s  = 10
 local function proj(vx, vy, vz)
  local x  =  vx*cos(ay) + vz*sin(ay)
  local z  = -vx*sin(ay) + vz*cos(ay)
  local y  =  vy*cos(ax) - z*sin(ax)
  return cx + x*s, cy + y*s
 end
 local v = {}
 for i,p in ipairs({
  {-1,-1,-1},{1,-1,-1},{1,1,-1},{-1,1,-1},
  {-1,-1, 1},{1,-1, 1},{1,1, 1},{-1,1, 1}
 }) do
  local px,py = proj(p[1],p[2],p[3])
  v[i] = {px,py}
 end
 local e = {1,2,2,3,3,4,4,1, 5,6,6,7,7,8,8,5, 1,5,2,6,3,7,4,8}
 for i = 1, #e, 2 do
  line(v[e[i]][1],v[e[i]][2], v[e[i+1]][1],v[e[i+1]][2], 7)
 end
end

-- renders text char-by-char with a sine wave vertical jiggle
function draw_jiggle_text(text, x, y, col)
 for i = 1, #text do
  local dy = flr(sin(pulse_timer * 0.08 + i * 0.35) * 2)
  print(sub(text, i, i), x + (i-1)*4, y + dy, col)
 end
end

function any_pressed()
 for i = 0, 5 do if btnp(i) then return true end end
end

function draw_sprite_font(text, x, y, char_to_sprite)
 for i = 1, #text do
  local sprite_num = char_to_sprite[sub(text, i, i)]
  if sprite_num then spr(sprite_num, x + (i-1)*8, y) end
 end
end

function draw_sprite_font_centered(text, y, char_to_sprite)
 draw_sprite_font(text, 64 - #text*4, y, char_to_sprite)
end
