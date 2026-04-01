-- utility functions

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
