Pod::Spec.new do |spec|
  spec.name         = 'ForbindExtensions'
  spec.version      = '0.1'
  spec.license      = { :type => 'MIT' }
  spec.homepage     = 'https://github.com/ulrikdamm/Forbind'
  spec.authors      = { 'Ulrik Damm' => 'ulrikdamm@me.com' }
  spec.summary      = 'Functional chaining and promises in Swift'
  spec.source       = { :git => 'https://github.com/ulrikdamm/Forbind.git', :tag => '0.1' }
  spec.source_files = 'ForbindExtensions/*.swift'
  spec.frameworks   = 'Foundation', 'UIKit'
  spec.ios.deployment_target = '8.0'
  spec.platform		= :ios
  spec.dependency 'Forbind'
end
