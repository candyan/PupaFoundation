Pod::Spec.new do |s|

  s.name          = 'PupaFoundation'
  s.version       = '1.1.6'
  s.summary       = 'Pupa is a custom foundation framework for Cocoa'
  s.homepage      = 'https://github.com/candyan/PupaFoundation'
  s.license       = 'MIT'
  s.author        = { 'Candyan' => 'liuyanhp@gmail.com' }
  s.platform      = :ios, '5.0'
  s.requires_arc       = true

  s.source        = {
      :git => 'https://github.com/candyan/PupaFoundation.git',
      :tag => s.version.to_s
  }
  s.source_files       = 'Source/**/*.{h,m}'

end
