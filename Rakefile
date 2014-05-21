BUILD_DIR             = "/tmp/NearbyMe"
APP_BUNDLE            = "#{BUILD_DIR}/NearbyMe.app"
AUTOMATION_TEMPLATE   = "automation/Template.tracetemplate"
RESULTS_PATH          = "automation_results"
OUTPUT_TRACE_DOCUMENT = "#{RESULTS_PATH}/Trace"

# If the automation_results directory isn't there, Instruments balks.
mkdir_p RESULTS_PATH

desc "Remove the automation_results directory and start fresh"
task "clean_results" do
  rm_rf RESULTS_PATH
end

desc "Run appropriate tests for iPhone and iPad Simulators"
task "default" do
  clean

  build "iphone"
  automate "automation/UIAutoMonkey.js"
  automate "automation/test_suite.js"
  automate "automation/test_sorting.js"
  automate "automation/test_location_permission.js"

  build "ipad"
  automate "automation/test_suite_ipad.js"

  close_sim

  puts "\nWin condition acquired!"
end

desc "Run appropriate tests for the connected device"
task "device" do
  $is_testing_on_device = true
  clean
  build "device"

  # NOTE: This is just an example that uses an unofficial hack to install app
  # bundles on devices marked for development. It doesn't work all the time and
  # there's no guarantee that it won't break for benign changes Apple makes to
  # their infrastructure. Still, I know you're curious so here's what I use.
  install_on_device

  if connected_device_is_ipad?
    automate "automation/test_suite_ipad.js"
  else
    automate "automation/UIAutoMonkey.js"
    automate "automation/test_suite.js"
    automate "automation/test_sorting.js"
  end

  puts "\nWin condition acquired!"
end

desc "Focused test run. Things in progress."
task "focus" do
  clean

  build "iphone"
  automate "automation/test_location_permission.js"

  close_sim

  puts "\nWin condition acquired!"
end


#
# Composable steps
#

def clean
  run_xcodebuild "clean"
end

def build type
  case type
  when "iphone"
    sdk = "iphonesimulator"
    fam = "1"
  when "ipad"
    sdk = "iphonesimulator"
    fam = "2"
  when "device"
    sdk = "iphoneos"
    fam = "1,2"
  else
    raise "Unknown build type: #{type}"
  end

  run_xcodebuild "build -sdk #{sdk} TARGETED_DEVICE_FAMILY=#{fam}"
end

def automate script
  reset_sim

  if $is_testing_on_device
    device_arg = "-w #{connected_device_id}"
  end

  env_vars = extract_environment_variables(script)

  sh %{
    bin/unix_instruments \\
      #{device_arg} \\
      -t "#{AUTOMATION_TEMPLATE}" \\
      -D "#{OUTPUT_TRACE_DOCUMENT}" \\
      "#{APP_BUNDLE}" \\
      -e UIARESULTSPATH "#{RESULTS_PATH}" \\
      -e UI_TESTS 1 \\
      -e UIASCRIPT "#{script}" \\
      #{env_vars}
  }
end

def close_sim
  sh %{killall "iPhone Simulator" || true}
end

def reset_sim
  close_sim
  sim_root = "~/Library/Application Support/iPhone Simulator"
  rm_rf File.expand_path(sim_root)
end


#
# Utility Methods
#

def run_xcodebuild extra_args
  sh %{
    xcodebuild \\
      -project NearbyMe.xcodeproj \\
      -scheme NearbyMeUITests \\
      -configuration Release \\
      CONFIGURATION_BUILD_DIR="#{BUILD_DIR}" \\
      #{extra_args}
  }
end

def extract_environment_variables script
  lines = File.readlines script
  arguments = []

  lines.each do |line|
    line.match(%r{^// (.+)=(.+)$})
    if $1
      arguments << "-e " + $1 + " " + $2
    end
  end

  arguments.join(" ")
end

def ioreg_output
  `ioreg -w 0 -rc IOUSBDevice -k SupportsIPhoneOS`
end

def connected_device_is_ipad?
  !ioreg_output.match(/"USB Product Name" = "iPad"/).nil?
end

def connected_device_id
  ioreg_output.match(/"USB Serial Number" = "([A-z\d]+)"/) && $1
end

def install_on_device
  # I got fruitstrap originally from here:
  # https://github.com/ghughes/fruitstrap
  #
  # It's no longer supported and you might need to use a fork on Github
  raise "No device connected" if !connected_device_id
  sh %{bin/fruitstrap -b #{APP_BUNDLE} -i #{connected_device_id}}
end

