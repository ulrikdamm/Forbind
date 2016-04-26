Pod::Spec.new do |spec|
  spec.name         = 'Forbind'
  spec.version      = '1.1'
  spec.license      = { :type => 'MIT' }
  spec.homepage     = 'https://github.com/ulrikdamm/Forbind'
  spec.authors      = { 'Ulrik Damm' => 'ulrikdamm@me.com' }
  spec.summary      = 'Functional chaining and promises in Swift'
  spec.source       = { :git => 'https://github.com/ulrikdamm/Forbind.git', :tag => '1.1' }
  spec.source_files = 'Forbind/*.swift'
  spec.framework    = 'Foundation'
  spec.ios.deployment_target = '8.0'
  spec.osx.deployment_target = '10.10'
  spec.tvos.deployment_target = '9.0'
end
