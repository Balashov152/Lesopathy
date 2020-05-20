platform :ios, '11.0'
use_frameworks!
inhibit_all_warnings!
supports_swift_versions '>= 4.0'

source 'https://github.com/CocoaPods/Specs.git'

def app_pods
  #lint
  pod 'SwiftLint',                    '~> 0.34'
  pod 'SwiftFormat/CLI',              '~> 0.40'

  #architecture
  pod 'RxSwift',                      '~> 5.1'
  pod 'RxCocoa',                      '~> 5.1'
  pod 'RxGesture',                    '~> 3.0'
  pod 'RxDataSources',                '~> 4.0'
  pod 'RxViewController',	            '~> 0.4'
  pod 'RxKeyboard',	                  '~> 1.0'
  pod 'NSObject+Rx',                  '~> 5.1'

  #helpers
  pod 'SwiftPermissionManager'
  pod 'SBHelpers',                     '~> 0.2'
  pod 'SBHelpers/Rx',                  '~> 0.2'

  pod 'SnapKit',                       '~> 5.0'
end

target 'Lesoparty' do
  app_pods
end