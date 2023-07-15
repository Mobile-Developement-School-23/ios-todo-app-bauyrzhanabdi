# Uncomment the next line to define a global platform for your project
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '12.0'
inhibit_all_warnings!
use_frameworks!

def import_pods
    # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
    
    pod 'FLEX', :configurations => ['Debug']
    pod 'SwiftLint'
    pod 'SwiftFormat/CLI', '~> 0.49'
end

target 'TodoListProject' do
  inherit! :search_paths
  import_pods

  target 'TodoListProjectTests' do
    inherit! :search_paths
    import_pods
  end
end
