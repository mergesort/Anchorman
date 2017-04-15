Pod::Spec.new do |spec|
  spec.name         = 'Anchorman'
  spec.summary      = 'A small layer above autolayout to make it slightly more automatic'
  spec.version      = '2.0'
  spec.license      = { :type => 'MIT' }
  spec.author      =  { 'Joe Fabisevich' => 'github@fabisevi.ch' }
  spec.source_files = 'Anchorman/*.{swift}'
  spec.source       =  { :git => 'https://github.com/mergesort/Anchorman.git', :tag => "#{spec.version}" }
  spec.homepage     = 'https://github.com/mergesort/Anchorman'

  spec.ios.deployment_target = '9.0'
  spec.requires_arc = true
  spec.social_media_url = 'https://twitter.com/mergesort'
  spec.framework    = 'UIKit'
end
