# Uncomment the next line to define a global platform for your project
platform :ios, '12.0'

# R.swift
def pod_Rswift
  pod 'R.swift', '~> 5.1.0'
end

# UI Libraries
def pod_UI
  pod 'PTCardTabBar', '~> 5.1.0'
end

target 'fetilip' do
  use_frameworks!
  pod_Rswift
  pod_UI

  target 'fetilipTests' do
    inherit! :search_paths
    # Pods for testing
  end
end

target 'fetilipUITests' do
  # Pods for testing
end
