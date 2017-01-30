Pod::Spec.new do |s|
  s.name             = 'Nessie'
  s.version          = '0.1.0'
  s.summary          = 'Capital One Nessie API SDK written in Swift.'
  s.description      = <<-DESC
Capital One Nessie API SDK written in Swift, using SwiftyJSON for JSON parsing. Use this Cocoapod to quickly interface with the Capital One Nessie API.
                       DESC
  s.homepage         = 'https://github.com/nessieisreal/nessie-ios-sdk-swift'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Jason Ji' => 'jason.ji@capitalone.com' }
  s.source           = { :git => 'https://github.com/nessieisreal/nessie-ios-sdk-swift.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/hacknessie'

  s.ios.deployment_target = '9.0'

  s.source_files = 'Nessie-iOS-Wrapper/**/*'
  s.dependency 'SwiftyJSON', '~> 3.1'
end