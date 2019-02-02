
Pod::Spec.new do |s|


  s.name         = "ChatBotICICI"
  s.version      = "1.0.12"
  s.summary      = "Pod for ChatBotICICI"

    s.description  = <<-DESC
	Pod for ChatBot
                   DESC

  s.homepage     = "https://github.com/ranapnm123/ChatBotICICI.git"


   s.license      = { :type => "MIT", :file => "LICENSE" }


  s.author             = { "ranapn123" => "ranapnm@gmail.com" }
  
   s.platform     = :ios, "9.0"

  
  s.source       = { :git => "https://github.com/ranapnm123/ChatBotICICI.git", :tag => "#{s.version.to_s}" }

  s.source_files  = "ChatBotPro", "ChatBotPro/**/*.{h,m}"
  s.exclude_files = "ChatBotPro/**/LaunchScreen.storyboard"

 

     s.resource_bundle = { 'ChatBotPro' => [ 'ChatBotPro/**/*.{png,jpg,storyboard,xib,lproj,xcassets,xcdatamodeld}' ] }
    #s.resources = “ChatBotPro/*.storyboard”, “ChatBotPro/*.xcassets” 

 
   s.frameworks = "CoreData", "Foundation"

  

   s.static_framework = true
   s.dependency "Firebase/Core"
   s.dependency "IDMPhotoBrowser"
   s.dependency "FirebaseMessaging"
   s.dependency 'AWSS3', '~> 2.6.13'            # For file transfers
end
