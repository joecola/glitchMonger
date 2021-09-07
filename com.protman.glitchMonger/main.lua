class "OneShotIdleNotifier"

function OneShotIdleNotifier:__init(delay_in_ms, callback, ...)
  assert(type(delay_in_ms) == "number" and delay_in_ms >= 0.0)
  assert(type(callback) == "function")

  self._callback = callback
  self._args = arg
  self._invoke_time = os.clock() + delay_in_ms / 1000

  renoise.tool().app_idle_observable:add_notifier(self, self.__on_idle)
end

function OneShotIdleNotifier:__on_idle()
  if (os.clock() >= self._invoke_time) then
    renoise.tool().app_idle_observable:remove_notifier(self, self.__on_idle)
    self._callback(unpack(self._args))
  end
end

function random_elem(tb)
  local keys = {}
  for k in pairs(tb) do
    table.insert(keys, k)
  end
  return tb[keys[math.random(#keys)]]
end

function parent_index(track_index)
  local s, parent_index = renoise.song(), nil
  for i, track in ripairs(s.tracks) do
    if track.type == renoise.Track.TRACK_TYPE_GROUP then
      if i - #track.members <= track_index and track_index < i then
        parent_index = i
      end
    end
  end
  rprint(parent_index)
  return parent_index
end

function glitchMonger()
  local sng = renoise.song()
  sng.sequencer:sort()
  local se = #sng.sequencer.pattern_sequence
  local te = sng.sequencer_track_count
  local st = {}
  local rt = {}
  local sa = nil
  local p = nil
  local kr = nil
  local oo = nil
  local rp = nil
  local div = nil
  local nl = nil
  local ofs = nil
  local gl = nil
  local rx = nil

  sng.sequencer:make_range_unique(1, se)

  for s = 1, se do
    if sng.sequencer:sequence_section_name(s):sub(1, 2) == "s_" then
      sa = true
    end
    if sa == true then
      table.insert(st, s)
    end
    if sng.sequencer:sequence_is_end_of_section(s) == true then
      sa = false
    end
  end
  --print("st--")
  --rprint(st)

  for s = 1, se do
    if sng.sequencer:sequence_section_name(s):sub(1, 2) == "r_" then
      sa = true
    end
    if sa == true then
      table.insert(rt, s)
    end
    if sng.sequencer:sequence_is_end_of_section(s) == true then
      sa = false
    end
  end
  --print("rt--")
  --rprint(rt)

  for s = 1, #rt do
    kr = random_elem(st)
    for t = 1, te do
      if sng.tracks[t].name:sub(1, 2) == "k_" then
        --  sng.patterns[rt[s]].tracks[t].alias_pattern_index = kr
        --print(sng.patterns[rt[s]].tracks[t].alias_pattern_index)
        sng.patterns[rt[s]].tracks[t]:copy_from(sng.patterns[kr].tracks[t])
      end
    end
  end

  for s = 1, #rt do
    oo = (s - 1) % (#st)
    for t = 1, te do
      if sng.tracks[t].name:sub(1, 2) == "o_" then
        --  sng.patterns[rt[s]].tracks[t].alias_pattern_index = st[oo + 1]
        --print(sng.patterns[rt[s]].tracks[t].alias_pattern_index)
        sng.patterns[rt[s]].tracks[t]:copy_from(sng.patterns[st[oo + 1]].tracks[t])
      end
    end
  end

  for s = 1, #rt do
    for t = 1, te do
      if sng.tracks[t].name:sub(1, 2) == "r_" then
        sng.patterns[rt[s]].tracks[t].alias_pattern_index = random_elem(st)
        --print(sng.patterns[rt[s]].tracks[t].alias_pattern_index)
        -- print(sng.patterns[rt[s]].tracks[t].is_alias)
        --sng.patterns[rt[s]].tracks[t].is_alias = false

        sng.patterns[rt[s]].tracks[t]:copy_from(sng.patterns[random_elem(st)].tracks[t])
      end
    end
  end

  for s = 1, #rt do
    for t = 1, te do
      OneShotIdleNotifier(
        100,
        function()
          if sng.tracks[t].name:sub(1, 2) == "g_" then
            -- sng.patterns[rt[s]].tracks[t].alias_pattern_index = random_elem(st)
            -- random_elem(st)
            gl = tonumber(sng.tracks[t].name:sub(3, 4))
            print(gl)
            nl = sng.patterns[rt[s]].number_of_lines
            div = math.floor(nl / gl)
            ofs = math.floor(nl / div)
            for d = 1, div do
              rp = random_elem(st)

              for l = ofs * (d - 1) + 1, ofs * d do
                --for l = 1, 16 do
                renoise.app():show_status("glitchmongering: " .. l)
                sng.patterns[rt[s]].tracks[t].lines[l]:copy_from(sng.patterns[rp].tracks[t].lines[l])
              end

              renoise.app():show_status("glitchmongering: " .. div)
              --print("div " .. div)
              renoise.app():show_status("glitchmongering: " .. rp)
              --print(rp)
              renoise.app():show_status("glitchmongering: OK")
            end
          end
        end
      )
    end
  end

  for s = 1, #rt do
    for t = 1, te do
      OneShotIdleNotifier(
        100,
        function()
          if sng.tracks[t].name:sub(1, 2) == "x_" then
            -- sng.patterns[rt[s]].tracks[t].alias_pattern_index = random_elem(st)
            -- random_elem(st)
            gl = tonumber(sng.tracks[t].name:sub(3, 4))
            print(gl)
            nl = sng.patterns[rt[s]].number_of_lines
            div = math.floor(nl / gl)
            ofs = math.floor(nl / div)
            for d = 1, div do
              rp = random_elem(st)
              rx = math.random(0, (div - 1)) * ofs
              --print(rx)
              print("----------------")
              for l = ofs * (d - 1) + 1, ofs * d do
                renoise.app():show_status("Gl1tChMoNg3r1nG: " .. rp)
                --for l = 1, 16 do
                -- print(rx)
                print("--")
                print(l)
                print(rx + 1 + ((l - 1) % (gl)))
                renoise.app():show_status("ງlit¢h๓໐ຖງēriຖງ: " .. l)
                sng.patterns[rt[s]].tracks[t].lines[l]:copy_from(
                  sng.patterns[rp].tracks[t].lines[(rx + 1 + ((l - 1) % (gl)))]
                )
                renoise.app():show_status("gLiTcHmOnGeRiNg: " .. rx)
              end

              renoise.app():show_status("gLiTcHmOnGeRiNg: " .. div)
              --print("div " .. div)
              renoise.app():show_status("Gl1tChMoNg3r1nG: " .. rp)
              --print(rp)
              renoise.app():show_status("ɓuıɹǝɓuoɯɥɔʇılɓ: OK")
            end
          end
        end
      )
    end
  end
end

renoise.tool():add_menu_entry {
  name = "Main Menu:Tools:glitchMonger",
  invoke = function()
    glitchMonger()
  end
}
