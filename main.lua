-- #include dialog.lua
-- #include particles.lua
-- #include utils.lua

-- game state
current_scene = "title"
scene1_state  = "gold_anim"

-- player stats
current_gold  = 0
balloons      = 3
downgrades    = 0
upgrades      = {}
wager_amount  = 0

-- timers
pulse_timer   = 0
intro_timer   = 0
anim_timer    = 0

-- gold animation
gold_anim_target  = 0

-- dice state
dice_stopped  = false
dice_stop_t   = 0

-- sprite font map
char_to_sprite = {
 a=240,c=241,e=242,f=243,g=244,i=245,l=246,
 m=247,n=248,o=249,p=250,r=251,s=252,
 u=253,v=254,y=255,["3"]=236
}

-- render flags (set by enter_state, read by draw)
flag_cat_scene   = false
flag_table_scene = false
flag_gold_anim   = false
flag_cards       = false
flag_dialog      = false
flag_wager       = false
flag_is_dialog   = false

function enter_state(s)
 scene1_state   = s
 -- reset all flags
 flag_cat_scene   = false
 flag_table_scene = false
 flag_gold_anim   = false
 flag_cards       = false
 flag_dialog      = false
 flag_wager       = false
 flag_is_dialog   = false

 if s == "gold_anim" then
  anim_timer        = 0
  dice_stopped      = false
  flag_table_scene  = true
  flag_gold_anim    = true

 elseif s == "welcome_dialog" then
  flag_cat_scene   = true
  flag_dialog      = true
  flag_is_dialog   = true
  show_dialog(dialogues.welcome)

 elseif s == "intro_dialog" then
  flag_cat_scene   = true
  flag_dialog      = true
  flag_is_dialog   = true

  local msg = dialogues.gold_high
  if current_gold < 20 then
   current_gold = 20
   msg = dialogues.gold_low
  elseif current_gold < 50 then
   msg = dialogues.gold_mid
  end
  show_dialog(msg)

 elseif s == "rules_dialog" then
  flag_cat_scene   = true
  flag_dialog      = true
  flag_is_dialog   = true
  show_dialog(dialogues.rules)

 elseif s == "wager" then
  wager_amount     = 1
  flag_table_scene = true
  flag_wager       = true


 elseif s == "wager_dialog" then
  flag_cat_scene   = true
  flag_dialog      = true
  flag_is_dialog   = true

  show_dialog(dialogues.wager_comment)

 elseif s == "cards" then
  flag_cat_scene   = true
  flag_cards       = true

 end
end

function _init()
 init_confetti(40)
end

function _update()
 pulse_timer += 1
 update_particles()

 if current_scene == "title" then
  if intro_timer < 64 then
   intro_timer += 1
   if any_pressed() then intro_timer = 64 end
  elseif any_pressed() then
   gold_anim_target = flr(rnd(100)) + 1
   current_scene    = "scene1"
   enter_state("welcome_dialog")
  end

 elseif current_scene == "scene1" then
  if scene1_state == "gold_anim" then
   anim_timer += 1
   if not dice_stopped then
    -- grace period avoids eating the dialog button press
    if anim_timer > 20 and any_pressed() then
     current_gold  = gold_anim_target
     dice_stopped  = true
     dice_stop_t   = pulse_timer
    end
   elseif any_pressed() then
    enter_state("intro_dialog")
   end

  elseif flag_is_dialog then
   update_dialog_state()
   if dialog_ready_advance() then
    if scene1_state == "welcome_dialog" then enter_state("gold_anim")
    elseif scene1_state == "intro_dialog"  then enter_state("rules_dialog")
    elseif scene1_state == "rules_dialog"  then enter_state("wager")
    elseif scene1_state == "wager_dialog"  then enter_state("cards")
    end
   end

  elseif scene1_state == "wager" then
   if btnp(0) then wager_amount = max(1, wager_amount - 1)  end
   if btnp(1) then wager_amount = min(current_gold, wager_amount + 1)  end
   if btnp(3) then wager_amount = max(1, wager_amount - 10) end
   if btnp(2) then wager_amount = min(current_gold, wager_amount + 10) end
   if btnp(4) or btnp(5) then enter_state("wager_dialog") end

  elseif scene1_state == "cards" then
   if any_pressed() then current_scene = "dice" end
  end
 end
end

function _draw()
 cls(0)
 if current_scene == "title" then
  draw_title()
 elseif current_scene == "scene1" or current_scene == "dice" then
  draw_scene1()
 end
end

function draw_title()
 local camera_y = max(0, 128 - intro_timer*2)
 camera(0, camera_y)
 draw_particles(pulse_timer)
 palt(0, false)
 map(0, 22, 36, 16, 7, 5)
 palt()
 circ(64, 36, 28, 7)
 local title   = "carnival of 3"
 local title_x = 64 - #title*4
 for i = 1, #title do
  local sn = char_to_sprite[sub(title, i, i)]
  if sn then
   local wy = flr(sin(pulse_timer*0.007 + i*0.11) * 2)
   if (pulse_timer*3 + i*41) % 127 > 1 then
    spr(sn, title_x + (i-1)*8, 80 + wy)
   end
  end
 end
 if intro_timer >= 64 and (pulse_timer\15) % 2 == 0 then
  print("press any button", 32, 108, 7)
 end
 camera()
end

function draw_map(mx, my)
 palt(0, false)
 map(mx, my, 0, 0, 16, 16)
 palt()
end

function draw_scene1()
 if flag_table_scene then
  palt(0, false)
  map(0, 27, 0, 0, 16, 5)
  palt()
 end
 if flag_gold_anim then
  if not dice_stopped then
   draw_rolling_die(64, 55, pulse_timer)
   draw_prompt(ui.press_to_roll)
  else
   draw_rolling_die(64, 55, dice_stop_t)
   local msg = "you've rolled " .. current_gold .. " gold"
   draw_jiggle_text(msg, 64 - #msg*2, 68, 7)
   draw_prompt(ui.press_button)
  end
 end
 if flag_cat_scene then
  palt(0, false)
  map(0, 0, 0, 0, 16, 16)
  palt()
 end
 if flag_cards then
  palt(0, false)
  map(0, 16, 16, 40, 12, 6)
  palt()
 end
 if current_gold > 0 then
  draw_gold_hud(current_gold)
 end
 if flag_wager then
  print("wager:", 44, 50, 7)
  local amt = wager_amount .. " gold"
  local ax = 64 - #amt * 2
  draw_select_box(ax - 3, 59, #amt * 4 + 4, 9)
  draw_jiggle_text(amt, ax, 62, 7)
  if (pulse_timer \ 20) % 2 == 0 then
   print("< > : +-1    ^ v : +-10", 16, 76, 7)
  end
 end
 if flag_dialog then
  draw_dialog(dialog_text)
 end
end
