Pod::Spec.new do |s|
  s.name         = 'OMValidation'
  s.version      = '0.1.0'
  s.summary      = 'Validation'
  s.homepage     = 'http://github.com/b52/OMValidation'
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { 'Oliver Mader' => 'b52@reaktor42.de' }
  s.ios.deployment_target = '5.0'
  s.osx.deployment_target = '10.7'
  s.tvos.deployment_target = '9.0'
  s.source       = { :git => 'https://github.com/b52/OMValidation.git', :tag => s.version.to_s }
  s.requires_arc = true

  s.default_subspec = 'Core'

  s.subspec 'Core' do |cs|
    cs.source_files = 'Sources/*.h', 'Sources/*.m'
    cs.public_header_files = 'Sources/*.h'
  end

  s.subspec 'Promises' do |hs|
    hs.dependency 'OMValidation/Core'
    hs.dependency 'OMPromises'

    hs.source_files = 'Sources/Promises'
    hs.public_header_files = 'Sources/Promises/*.h'
    hs.xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => 'OMVALIDATION_PROMISES_AVAILABLE=1' }
  end
end
