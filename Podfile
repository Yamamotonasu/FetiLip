# Uncomment the next line to define a global platform for your project
platform :ios, '12.0'

post_install do |installer|
  installer.pods_project.build_configurations.each do |config|
    config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
  end
end

# R.swift
def pod_Rswift
  pod 'R.swift', '~> 5.4.0'
end

target 'fetilip' do
  use_frameworks!
  pod_Rswift

  target 'fetilipTests' do
    inherit! :search_paths
    # Pods for testing
  end
end

target 'fetilipUITests' do
  # Pods for testing
end
