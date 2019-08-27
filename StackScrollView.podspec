Pod::Spec.new do |s|
  s.name             = 'StackScrollView'
  s.version          = '1.6.0'
  s.summary          = 'Scalable form builder with UICollectionView'
  s.homepage         = 'https://github.com/muukii/StackScrollView'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'muukii' => 'muukii.app@gmail.com' }
  s.source           = { :git => 'https://github.com/muukii/StackScrollView.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/muukii0803'

  s.ios.deployment_target = '9.0'
  s.source_files = 'StackScrollView/**/*.swift'

end
