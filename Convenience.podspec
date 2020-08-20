Pod::Spec.new do |s|
    s.name              = "Convenience"
    s.version           = "0.0.2"
    s.summary           = "Reusable Swift code for my personal projects."


    s.homepage          = "https://github.com/keeshux/convenience"
    s.license           = { :type => "BSD", :file => "LICENSE" }
    s.author            = { "Davide De Rosa" => "me@davidederosa.com" }
    s.source            = { :git => "https://github.com/keeshux/convenience.git", :tag => "v#{s.version}" }
    s.swift_version     = "5.0"

    s.subspec "About" do |p|
        p.ios.deployment_target = "11.0"
        p.ios.source_files = "Convenience/About/*.{swift,xib}"
        p.ios.dependency "Convenience/Tables"
    end
    s.subspec "Alerts" do |p|
        p.ios.deployment_target = "11.0"
        p.ios.source_files = "Convenience/Alerts/*.{swift,xib}"
    end
    s.subspec "Awesome" do |p|
        p.ios.deployment_target = "11.0"
        p.ios.source_files = "Convenience/Awesome/*.{swift,xib}"
        p.ios.dependency "FontAwesome.swift"
    end
    s.subspec "Dialogs" do |p|
        p.ios.deployment_target = "11.0"
        p.ios.source_files = "Convenience/Dialogs/*.{swift,xib}"
        p.ios.dependency "MBProgressHUD"
    end
    s.subspec "InApp" do |p|
        p.ios.deployment_target = "11.0"
        p.osx.deployment_target = "10.11"
        p.source_files = "Convenience/InApp/*.{swift,xib}"
        p.frameworks = "StoreKit"
    end
    s.subspec "Keychain" do |p|
        p.ios.deployment_target = "11.0"
        p.osx.deployment_target = "10.11"
        p.source_files = "Convenience/Keychain/*.{swift,xib}"
    end
    s.subspec "Misc" do |p|
        p.ios.deployment_target = "11.0"
        p.osx.deployment_target = "10.11"
        p.source_files = "Convenience/Misc/*.{swift,xib}"
    end
    s.subspec "Options" do |p|
        p.ios.deployment_target = "11.0"
        p.ios.source_files = "Convenience/Options/*.{swift,xib}"
    end
    s.subspec "Persistence" do |p|
        p.ios.deployment_target = "11.0"
        p.osx.deployment_target = "10.11"
        p.source_files = "Convenience/Persistence/*.{swift,xib}"
    end
    s.subspec "Reviewer" do |p|
        p.ios.deployment_target = "11.0"
        p.osx.deployment_target = "10.11"
        p.source_files = "Convenience/Reviewer/*.{swift,xib}"
    end
    s.subspec "Tables" do |p|
        p.ios.deployment_target = "11.0"
        p.ios.source_files = "Convenience/Tables/*.{swift,xib}"
    end
    s.subspec "WebServices" do |p|
        p.ios.deployment_target = "11.0"
        p.osx.deployment_target = "10.11"
        p.dependency "SwiftyBeaver"
        p.source_files = "Convenience/WebServices/*.{swift,xib}"
    end
end
