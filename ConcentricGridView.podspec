Pod::Spec.new do |s|
  s.name         = "ConcentricGridView"
  s.version      = "0.0.1"
  s.summary      = "Concentric grid system"
  s.description  = <<-DESC
    ConcentricGridView is a grid system that is used by UICollectionViewLayout
    to lay out UICollectionViewCells in a concentric way using different distribution algorithms.
                   DESC
  s.homepage         = "https://github.com/dmgts/concentric-grid-view"
  s.license          = { :type => "MIT", :file => "LICENSE" }
  s.authors          = { "Dmitry Gutsulyak" => "doberq@gmail.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/dmgts/concentric-grid-view.git", :tag => "0.0.1" }
  s.source_files  = "Pod/**/*.{h,swift}"
  s.requires_arc = true
end
