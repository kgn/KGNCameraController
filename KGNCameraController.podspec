Pod::Spec.new do |spec|
  spec.name = 'KGNCameraController'
  spec.version = '0.0.2'
  spec.authors = {'David Keegan' => 'git@davidkeegan.com'}
  spec.homepage = 'https://github.com/kgn/KGNCameraController'
  spec.summary = 'A camera view build on top of AVFoundation'
  spec.source = {:git => 'https://github.com/kgn/KGNCameraController.git', :tag => "v#{spec.version}"}
  spec.license = { :type => 'MIT', :file => 'LICENSE' }

  spec.platform = :ios
  spec.requires_arc = true
  spec.source_files = 'KGNCameraController'
end
