Pod::Spec.new do |spec|
  spec.name         = 'Forbind'
  spec.version      = '0.1'
  spec.license      = { :type => 'MIT' }
  spec.homepage     = 'https://github.com/ulrikdamm/Forbind'
  spec.authors      = { 'Ulrik Damm' => 'ulrikdamm@me.com' }
  spec.summary      = 'Functional chaining and promises in Swift'
  spec.source       = { :git => 'https://github.com/ulrikdamm/Forbind.git', :tag => '0.1' }
  spec.source_files = 'Forbind/*.swift'
  spec.framework    = 'Foundation'
  
  spec.subspec 'ForbindExtensions' do |subspec|
    subspec.source_files = 'ForbindExtensions/*.swift'
  end
end
