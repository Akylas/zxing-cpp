Pod::Spec.new do |s|
  s.name = 'zxing-cpp'
  s.version = '3.1.1'
  s.summary = 'C++ port of ZXing'
  s.homepage = 'https://github.com/zxing-cpp/zxing-cpp'
  s.author = 'axxel'
  s.readme = 'https://raw.githubusercontent.com/zxing-cpp/zxing-cpp/master/wrappers/ios/README.md'
  s.license = {
    :type => 'Apache License 2.0',
    :file => 'LICENSE'
  }
  s.source = {
    :git => 'https://github.com/zxing-cpp/zxing-cpp.git',
    :tag => "v#{s.version}"
  }
  s.module_name = 'ZXingCpp'
  s.platform = :ios, '12.0'
  s.library = ['c++']
  s.compiler_flags = [
    '-DZXING_INTERNAL',
    '-Wno-comma'
  ]
  s.pod_target_xcconfig = {
    'CLANG_CXX_LANGUAGE_STANDARD' => 'c++20',
    'HEADER_SEARCH_PATHS' => '$(PODS_TARGET_SRCROOT)/wrappers/ios/Sources/Wrapper'
  }

  s.default_subspec = 'Wrapper'

  s.subspec 'Core' do |ss|
    ss.source_files = 'core/src/**/*.{h,c,cpp}'
    ss.exclude_files = [ 'core/src/libzint/**' ]
    ss.private_header_files = 'core/src/**/*.h'
  end
  # core/src/libzint only holds stubs including ../../../zint/backend/..., which break once the
  # headers are copied into the framework: compile the zint backend sources directly instead
  zint_sources = %w[2of5inter 2of5inter_based aztec codabar code code128 common dmatrix dxfilmedge eci
                    filemem general_field gs1 large library maxicode medical output pdf417 qr raster
                    reedsol rss svg telepen upcean vector].join(',')
  s.subspec 'CoreZint' do |ss|
    ss.source_files = 'core/src/**/*.{h,c,cpp}', "zint/backend/{#{zint_sources}}.c"
    ss.exclude_files = 'core/src/libzint/**/*.h', "core/src/libzint/{#{zint_sources}}.c"
    ss.private_header_files = 'core/src/**/*.h'
    ss.compiler_flags = '-DZINT_NO_PNG'
    ss.pod_target_xcconfig = { 'HEADER_SEARCH_PATHS' => '$(PODS_TARGET_SRCROOT)/zint/backend' }
  end

  s.subspec 'Wrapper' do |ss|
    ss.dependency 'zxing-cpp/Core'
    ss.frameworks = 'CoreGraphics', 'CoreImage', 'CoreVideo'
    ss.source_files = 'wrappers/ios/Sources/Wrapper/**/*.{h,m,mm}'
    ss.public_header_files = 'wrappers/ios/Sources/Wrapper/Reader/{ZXIBarcodeReader,ZXIResult,ZXIPosition,ZXIPoint,ZXIGTIN,ZXIReaderOptions}.h',
                             'wrappers/ios/Sources/Wrapper/Writer/{ZXIBarcodeWriter,ZXIWriterOptions}.h',
                             'wrappers/ios/Sources/Wrapper/{ZXIErrors,ZXIFormat}.h'
    ss.exclude_files = 'wrappers/ios/Sources/Wrapper/UmbrellaHeader.h'
  end
end
