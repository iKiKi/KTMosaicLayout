Pod::Spec.new do |spec|

  spec.name                     = 'KTMosaicLayout'
  spec.version                  = '1.0.0'
  spec.swift_version            = '4.0'
  spec.cocoapods_version        = '>= 1.4.0'
  spec.author                   = { "Killian THORON" => "killian.thoron@gmail.com" }
  spec.social_media_url         = 'http://twitter.com/kthoron'
  spec.license                  = { :type => "MIT", :file => "LICENSE" }
  spec.homepage                 = 'https://github.com/iKiKi/KTMosaicLayout'
  spec.source                   = { :git => "https://github.com/iKiKi/KTMosaicLayout.git", :tag => spec.version.to_s }
  spec.summary                  = "A Swift UICollectionViewLayout to layout items on different columns"
  spec.description              = <<-DESC
                                    KTMosaicLayout is a Swift UICollectionViewLayout being able to display UICollectionView items on different columns.
                                    In case at least 3 columns is defined for a section. KTMosaicLayout can display the first item of this section in a "big" style.
                                  DESC
  spec.static_framework = true
  spec.module_name              = 'KTMosaicLayout'

  # iOS
  spec.ios.deployment_target    = "9.0"
  spec.ios.frameworks           = 'Foundation', 'UIKit'
  spec.ios.source_files         = 'Sources/*.swift'

  # tvOS
  spec.tvos.deployment_target   = "9.0"
  spec.tvos.frameworks          = 'Foundation', 'UIKit'
  spec.tvos.source_files        = 'Sources/*.swift'

end
