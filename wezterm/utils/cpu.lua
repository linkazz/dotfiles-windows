local wezterm = require 'wezterm';

-- Function to get CPU usage
local function get_cpu_usage()
  local platform = wezterm.target_triple()
  local cmd = ""

  if platform:find("linux") then
    cmd = "top -bn1 | grep 'Cpu(s)' | sed 's/.*, *\\([0-9.]*\\)%* id.*/\\1/' | awk '{print 100 - $1\"%\"}'"
  elseif platform:find("windows") then
    cmd = "powershell -Command \"Get-Counter -Counter '\\Processor(_Total)\\% Processor Time' -SampleInterval 1 -MaxSamples 1 | ForEach-Object { [math]::Round($_.CounterSamples[0].CookedValue, 2) }\""
  else
    return "CPU: N/A"
  end

  local cpu_usage = wezterm.run_child_process({"bash", "-c", cmd})
  return "CPU: " .. cpu_usage[1];
end
