solution "bgfx"
	configurations {
		"Debug",
		"Release",
	}
  
	if _ACTION == "xcode4" then
		platforms {
			"Universal",
		}
	else
		platforms {
			"x32",
			"x64",
--			"Xbox360",
			"Native", -- for targets where bitness is not specified
		}
	end

_3RD_DIR = path.getabsolute("../..")
ROOT_DIR = path.getabsolute("..")
BUILD_DIR = path.join(ROOT_DIR, ".build")
printf("BUILD_DIR=%s", BUILD_DIR)

BGFX_DIR  = path.join(_3RD_DIR, "bgfx")
BX_DIR    = os.getenv("BX_DIR")

local BGFX_THIRD_PARTY_DIR = path.join(BGFX_DIR, "3rdparty")
if not BX_DIR then
	BX_DIR = path.getabsolute(path.join(BGFX_DIR, "../bx"))
end

if not os.isdir(BX_DIR) then
	print("bx not found at " .. BX_DIR)
	print("For more info see: https://bkaradzic.github.io/bgfx/build.html")
	os.exit()
end

dofile (path.join(BX_DIR, "scripts/toolchain.lua"))
if not toolchain(BUILD_DIR, BGFX_THIRD_PARTY_DIR) then
	return -- no action specified
end

function copyLib()
end

dofile(path.join(BGFX_DIR, "scripts/bgfx.lua"))
  
bgfxProject("", "StaticLib", {})

project "bgfx"
  language "C++"
  
	includedirs {
		path.join(ROOT_DIR, "include"),
	}
  
  files {
    path.join(ROOT_DIR, "src/bgfx-helper.c")
  }
