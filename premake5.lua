workspace "guetzli"
  configurations { "Release", "Debug" }
  language "C++"
  cppdialect "C++11"
  includedirs { ".", "third_party/butteraugli", "clguetzli" }
  libdirs {}

  filter "action:vs*"
    platforms { "x86_64", "x86" }

  filter "platforms:x86"
    architecture "x86"
  filter "platforms:x86_64"
    architecture "x86_64"

  -- workaround for #41
  filter "action:gmake"
    symbols "On"

  filter "configurations:Debug"
    symbols "On"
  filter "configurations:Release"
    optimize "Full"
  filter {}

  project "guetzli_static"
    kind "StaticLib"
    files
      {
        "guetzli/*.cc",
        "guetzli/*.h",
        "third_party/butteraugli/butteraugli/butteraugli.cc",
        "third_party/butteraugli/butteraugli/butteraugli.h",
        "clguetzli/*.cpp",
        "clguetzli/*.h"
      }
    removefiles "guetzli/guetzli.cc"
    filter "action:gmake"
      linkoptions { "`pkg-config --static --libs libpng || libpng-config --static --ldflags`" }
      buildoptions { "`pkg-config --static --cflags libpng || libpng-config --static --cflags`" }

  project "guetzli"
    kind "ConsoleApp"
    filter "action:gmake"
	  --defines { "__USE_OPENCL__", "__USE_CUDA__", "__SUPPORT_FULL_JPEG__" }
      linkoptions { "`pkg-config --libs libpng || libpng-config --ldflags`" }
      buildoptions { "`pkg-config --cflags libpng || libpng-config --cflags`" }
      --links { "OpenCL", "cuda", "profiler", "unwind", "jpeg" }
    filter "action:vs*"
      links { "shlwapi" }
    filter {}
    files
      {
        "guetzli/*.cc",
        "guetzli/*.h",
        "third_party/butteraugli/butteraugli/butteraugli.cc",
        "third_party/butteraugli/butteraugli/butteraugli.h",
        "clguetzli/*.cpp",
        "clguetzli/*.h"
      }
