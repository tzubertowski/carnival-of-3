-- dialogue system

dialog_active = false
dialog_text = ""
dialog_char_index = 0
dialog_timer = 0

function wrap_text(text, max_chars)
 local wrapped = ""
 local line_len = 0
 for i = 1, #text do
  local ch = sub(text, i, i)
  if ch == "\n" then
   wrapped = wrapped .. ch
   line_len = 0
  elseif line_len >= max_chars then
   wrapped = wrapped .. "\n" .. ch
   line_len = 1
  else
   wrapped = wrapped .. ch
   line_len += 1
  end
 end
 return wrapped
end

function show_dialog(text)
 dialog_active = true
 dialog_text = wrap_text(text, 36)
 dialog_char_index = 0
 dialog_timer = 0
end

function update_dialog()
 if dialog_active then
  dialog_timer += 1
  if dialog_timer >= 3 and dialog_char_index < #dialog_text then
   dialog_char_index += 1
   dialog_timer = 0
  end
 end
end

function draw_dialog(text)
 local box_x, box_y, box_w, box_h = 4, 88, 120, 32
 rectfill(box_x, box_y, box_x+box_w, box_y+box_h, 0)
 rect(box_x, box_y, box_x+box_w, box_y+box_h, 7)
 local revealed_text = sub(text, 1, dialog_char_index)
 print(revealed_text, box_x+5, box_y+5, 7)

 if dialog_char_index >= #text and (pulse_timer \ 10) % 2 == 0 then
  print(">>>", box_x+box_w-15, box_y+box_h-8, 7)
 end
end

function dialog_done()
 return dialog_char_index >= #dialog_text
end
