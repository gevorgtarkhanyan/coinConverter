# Uncomment the next line to define a global platform for your project
platform :ios, '9.0'

warn_for_unused_master_specs_repo = false

target 'CoinsConverter' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  warn_for_unused_master_specs_repo = false
  
  # Pods for CoinsConverter
  pod 'Alamofire'
  pod 'RealmSwift'
  pod 'Charts'
  pod 'SDWebImage'
  pod 'KeychainAccess'
  pod 'Localize-Swift'
  
  pod 'Firebase/Core'
  pod 'FirebaseCrashlytics'
  pod 'Firebase/Analytics'
  pod 'Firebase/Performance'
  pod 'libxlsxwriter'
  
  target 'ConverterWidgetExtension' do
    inherit! :search_paths
    pod 'Alamofire'
    pod 'Localize-Swift'
  end
  
  target 'IntentConverterWidget' do
    inherit! :search_paths
    pod 'Alamofire'
    pod 'Localize-Swift'
  end
  
end


#post_install do |installer|
#  installer.pods_project.targets.each do |target|
#    target.build_configurations.each do |config|
#      config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
#    end
#  end
#end

