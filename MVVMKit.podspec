Pod::Spec.new do |s|
  s.name             = 'MVVMKit'
  s.version          = '0.1.2'
  s.summary          = 'The MVVM pattern protocol oriented'
  s.homepage         = 'https://github.com/drakon-ag/MVVMKit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'drakon-ag' => 'alfogrillo@gmail.com' }
  s.source           = { :git => 'https://github.com/drakon-ag/MVVMKit.git', :tag => s.version.to_s }
  s.ios.deployment_target = '9.0'
  s.swift_version = '4.2'
  s.source_files = 'MVVMKit/**/*'
end
