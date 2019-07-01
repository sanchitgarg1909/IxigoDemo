platform :ios, '9.0'

target 'IxigoDemo' do
  use_frameworks!

  pod 'Alamofire'
  
  pod 'Realm'
  pod 'RealmSwift'

  pod 'Toaster'

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '5.0'
        end
    end
end
