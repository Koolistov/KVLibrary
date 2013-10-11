Pod::Spec.new do |s|
  s.name         = "KVLibrary"
  s.version      = "0.0.1"
  s.summary      = "Collection of handy classes from Koolistov Pte. Ltd."
  s.homepage     = "http://koolistov.github.io/KVLibrary"
  s.license      = 'MIT'
  s.author       = { "Johan Kool" => "johan@koolistov.net" }
  s.platform     = :ios
  s.ios.deployment_target = "5.0"
  s.source       = { :git => "https://github.com/Koolistov/KVLibrary.git", :tag => "0.0.1" }
  s.source_files  = '**/*.{h,m}'
  s.exclude_files = '*Tests/*.{h,m}'
  s.framework  = 'CommonCrypto'
  s.requires_arc = true
end
