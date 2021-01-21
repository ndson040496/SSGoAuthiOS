# Uncomment the next line to define a global platform for your project
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '13.0'

target 'SSGoAuth' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for SSGoAuth
  pod 'SSeoUtilities', '~> 0.0'
  pod 'SSUI', '~> 0.0'
  pod 'SSeoNetwork', '~> 0.0'
  pod 'Firebase/Auth', '~> 6.0'

  target 'SSGoAuthTests' do
    # Pods for testing
  end

  post_install do |pi|
    pi.pods_project.targets.each do |t|
      t.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
      end
    end
  end

end
