Pod::Spec.new do |spec|
  spec.name         = 'Anchorman'
  spec.summary      = 'A small layer on top of autolayout to make layouts slightly more automatic'
  spec.version      = '3.2'
  spec.license      = { :type => 'MIT' }
  spec.author      =  { 'Joe Fabisevich' => 'github@fabisevi.ch' }
  spec.source_files = 'Sources/Anchorman/*.{swift}'
  spec.source       =  { :git => 'https://github.com/mergesort/Anchorman.git', :tag => "#{spec.version}" }
  spec.homepage     = 'https://github.com/mergesort/Anchorman'

  spec.ios.deployment_target = '9.0'
  spec.swift_version = '5.1'
  spec.requires_arc = true
  spec.social_media_url = 'https://twitter.com/mergesort'
  spec.framework    = 'UIKit'
end
