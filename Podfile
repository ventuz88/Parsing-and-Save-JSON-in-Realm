source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'

target 'RxSwift-Init' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for RxSwift-Init
  #pod 'RxSwift',    '~> 3.0'
  #pod 'RxCocoa',    '~> 3.0'

  # JSON Parser
  pod 'Freddy'
  
  # HTTPRequest
  pod 'Alamofire'
  
  # Local Datastore
  pod 'RealmSwift'


end


post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '3.0'
    end
  end
end
