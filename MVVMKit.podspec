Pod::Spec.new do |s|
  s.name             = 'MVVMKit'
  s.version          = '2.3.0'
  s.summary          = 'The MVVM pattern protocol oriented'
  s.homepage         = 'https://github.com/alfogrillo/MVVMKit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'alfogrillo' => 'alfogrillo@gmail.com' }
  s.source           = { :git => 'https://github.com/alfogrillo/MVVMKit', :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'
  s.swift_version = '5.0'
  s.source_files = 'MVVMKit/**/*'
end
