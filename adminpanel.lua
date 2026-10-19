-- ===== اعدادات (عدلها حسب سيرفرك) =====
local WEATHER_COMMANDS = {
  { name = "Clear",  cmd = "/weather clear" },
  { name = "Cloudy", cmd = "/weather cloudy" },
  { name = "Rain",   cmd = "/weather rain" },
  { name = "Fog",    cmd = "/weather fog" },
}
-- ======================================

local password = ""
local targetName = ""
local status = ""
local statusUntil = 0

local function say(text)
  status = text
  statusUntil = os.clock() + 4
end

local function send(cmd)
  ac.sendChatMessage(cmd)
  say("ارسلت: " .. (cmd:find("^/admin") and "/admin ****" or cmd))
end

ui.registerOnlineExtra(
  ui.Icons.Settings,
  "Admin Panel",
  function() return true end,
  function()
    -- تسجيل الدخول (الباسورد ما ينحفظ بالسكربت)
    ui.text("Login")
    password = ui.inputText("Admin password", password, ui.InputTextFlags.Password)
    if ui.button("Login", vec2(-0.1, 26)) and password ~= "" then
      send("/admin " .. password)
      password = ""
    end

    ui.separator()
    ui.text("Session")
    if ui.button("Next Session", vec2(-0.1, 26)) then send("/next_session") end
    if ui.button("Restart Session", vec2(-0.1, 26)) then send("/restart_session") end

    ui.separator()
    ui.text("Weather")
    for _, w in ipairs(WEATHER_COMMANDS) do
      if ui.button(w.name, vec2(-0.1, 26)) then send(w.cmd) end
    end

    ui.separator()
    ui.text("Players")
    targetName = ui.inputText("Player name", targetName)
    if ui.button("Kick", vec2(-0.1, 26)) and targetName ~= "" then
      send("/kick " .. targetName)
    end

    if os.clock() < statusUntil then ui.text(status) end
    return false
  end,
  nil,
  ui.OnlineExtraFlags.Tool
)