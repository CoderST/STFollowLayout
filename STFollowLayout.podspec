Pod::Spec.new do |s|

  # 项目名称
s.name         = 'STFollowLayout' 
# 描述一下项目的作用
s.summary      = 'On the basis of STFollowLayout.'
# 版本号
s.version      = '1.0.0'
# 开源许可证
s.license      = { :type => 'MIT', :file => 'LICENSE' }
# 作者信息
s.authors      = { 'CoderST' => '694468528@qq.com' }
# 所支持的系统以及版本号
s.platform     = :ios, '8.0'
# 项目首页
s.homepage     = "https://github.com/CoderST/RowFayout"
# 资源地址链接
s.source       = { :git => 'https://github.com/CoderST/STFollowLayout.git', :tag => s.version.to_s }
# 是否支持arc
s.requires_arc = true
# 文件
s.source_files = 'STFollowLayout/**/*.{h,m}'
# 头文件
s.public_header_files = 'STFollowLayout/*.{h}'
# 所用到的系统类库
s.frameworks = 'Foundation', 'UIKit'
# 所用到 cocoapods 中的其他类库
#s.dependency 'AFNetworking', '~>3.1.0'

end
