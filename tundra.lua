local common = {
  Env = {
    CPPDEFS = {
      "ZLIB_DLL",
      "_CRT_SECURE_NO_WARNINGS",
      "FT2_INCLUDE=3pp/freetype2/include",
      'FT_CONFIG_CONFIG_H=\\"3pp/freetype2-custom/ftconfig.h\\"',
      "WIN32",
    },
    CPPPATH = {
      ".",
      "3pp/zlib",
      "3pp/freetype2/include",
      "3pp/sdl/include",
      "3pp/glpng/include",
      "3pp/png-custom",
      "3pp/libpng",
    },
    CCOPTS = {
      "/wd4127",  -- conditional expression is constant
      "/wd4100", -- Unreferenced formal
      "/wd4189", -- Unused variable
      "/wd4996", -- The POSIX name for this item is deprecated Instead, use the ISO C++ conformant name: _strdup. See online help for details.
      "/wd4244", -- The POSIX name for this item is deprecated Instead, use the ISO C++ conformant name: _strdup. See online help for details.
      { "/MDd"; Config = "*-*-debug" },
      { "/MD"; Config = "*-*-release" },
      { "/O2"; Config = "*-*-release" },
    },
    CXXOPTS = {
      "$(CCOPTS)",
      "/EHsc",    -- exceptions
    },
    GENERATE_PDB = "1",
  },
}

Build {

  Units = function()
    local zlib = SharedLibrary {
      Name = "zlib",
      SourceDir = "3pp/zlib/",
      Env = {
        CCOPTS = "/W3",
      },
      Sources = {
        "adler32.c", "crc32.c", "crc32.h", "deflate.c", "deflate.h",
        "gzclose.c", "gzguts.h", "gzlib.c", "gzread.c", "gzwrite.c",
        "infback.c", "inffast.c", "inffast.h", "inffixed.h", "inflate.c",
        "inflate.h", "inftrees.c", "inftrees.h", "trees.c", "trees.h",
        "zconf.h", "zlib.h", "zutil.c", "zutil.h",
      },
    }

    local libpng = SharedLibrary {
      Name = "libpng",
      Depends = { "zlib" },
      Defines = {
        "_USRDLL",
        "PNG_BUILD_DLL",
      },
      Propagate = {
        Defines = {
          "PNG_USE_DLL",
        },
      },
      SourceDir = "3pp/libpng/",
      Sources = {
        "png.c", "png.h", "pngconf.h", "pngdebug.h", "pngerror.c", "pngget.c",
        "pnginfo.h", "pngmem.c", "pngpread.c", "pngpriv.h", "pngread.c",
        "pngrio.c", "pngrtran.c", "pngrutil.c", "pngset.c", "pngstruct.h",
        "pngtest.c", "pngtrans.c", "pngwio.c", "pngwrite.c", "pngwtran.c",
        "pngwutil.c",
      },
    }

    local freetype2 = SharedLibrary {
      Name = "freetype2",
      Env = {
        CCOPTS = "/W3",
      },
      Defines = {
        "FT2_BUILD_LIBRARY",
        'FT_CONFIG_MODULES_H=\\"3pp/freetype2-custom/ftmodule.h\\"',
      },
      Includes = { "3pp/freetype2/include", },
      SourceDir = "3pp/freetype2/src/",
      Sources = {
        "base/ftsystem.c",
        "base/ftinit.c",
        "base/ftdebug.c",
        "base/ftbase.c",
        "base/ftbbox.c",
        "base/ftglyph.c",
        "base/ftbitmap.c",   -- optional, see <ftbitmap.h>
        "truetype/truetype.c", -- TrueType font driver
        "raster/raster.c",   -- monochrome rasterizer
        "smooth/smooth.c",   -- anti-aliasing rasterizer
        "autofit/autofit.c", -- auto hinting module
        "sfnt/sfnt.c",       -- SFNT files support
        "psnames/psnames.c", -- PostScript glyph names support
        "gzip/ftgzip.c",     -- support for compressed fonts (.gz)
      },
    }

    local ftgl = SharedLibrary {
      Name = "ftgl",
      Depends = { "freetype2" },
      Env = {
        CCOPTS = "/W3",
      },
      Libs = { "opengl32.lib", "glu32.lib" },
      Env = {
        CXXOPTS = {
          "/wd4512", -- Assignment operator could not be generated
          "/wd4244", -- Integer truncation
        },
      },
      Defines = {
        "FTGL_LIBRARY", -- building it
        '__FUNC__=\\"function\\"',  -- lame
      },
      Includes = {
        "3pp/ftgl/src",
        "3pp/ftgl-custom",
      },
      Propagate = {
        Includes = {
          "3pp/ftgl/src",
        },
      },
      SourceDir = "3pp/ftgl/src/",
      Sources = {
        "FTBuffer.cpp",
        "FTCharmap.cpp",
        "FTCharmap.h",
        "FTCharToGlyphIndexMap.h",
        "FTCleanup.cpp",
        "FTCleanup.h",
        "FTContour.cpp",
        "FTContour.h",
        "FTFace.cpp",
        "FTFace.h",
        "FTGL.cpp",
        "FTGlyphContainer.cpp",
        "FTGlyphContainer.h",
        "FTInternals.h",
        "FTLibrary.cpp",
        "FTLibrary.h",
        "FTList.h",
        "FTPoint.cpp",
        "FTSize.cpp",
        "FTSize.h",
        "FTUnicode.h",
        "FTVector.h",
        "FTVectoriser.cpp",
        "FTVectoriser.h",
        "FTFont/FTBitmapFont.cpp",
        "FTFont/FTBitmapFontImpl.h",
        "FTFont/FTBufferFont.cpp",
        "FTFont/FTBufferFontImpl.h",
        "FTFont/FTExtrudeFont.cpp",
        "FTFont/FTExtrudeFontImpl.h",
        "FTFont/FTFont.cpp",
        "FTFont/FTFontGlue.cpp",
        "FTFont/FTFontImpl.h",
        "FTFont/FTOutlineFont.cpp",
        "FTFont/FTOutlineFontImpl.h",
        "FTFont/FTPixmapFont.cpp",
        "FTFont/FTPixmapFontImpl.h",
        "FTFont/FTPolygonFont.cpp",
        "FTFont/FTPolygonFontImpl.h",
        "FTFont/FTTextureFont.cpp",
        "FTFont/FTTextureFontImpl.h",
        "FTGL/FTBBox.h",
        "FTGL/FTBitmapGlyph.h",
        "FTGL/FTBuffer.h",
        "FTGL/FTBufferFont.h",
        "FTGL/FTBufferGlyph.h",
        "FTGL/FTExtrdGlyph.h",
        "FTGL/FTFont.h",
        "FTGL/ftgl.h",
        "FTGL/FTGLBitmapFont.h",
        "FTGL/FTGLExtrdFont.h",
        "FTGL/FTGLOutlineFont.h",
        "FTGL/FTGLPixmapFont.h",
        "FTGL/FTGLPolygonFont.h",
        "FTGL/FTGLTextureFont.h",
        "FTGL/FTGlyph.h",
        "FTGL/FTLayout.h",
        "FTGL/FTOutlineGlyph.h",
        "FTGL/FTPixmapGlyph.h",
        "FTGL/FTPoint.h",
        "FTGL/FTPolyGlyph.h",
        "FTGL/FTSimpleLayout.h",
        "FTGL/FTTextureGlyph.h",
        "FTGlyph/FTBitmapGlyph.cpp",
        "FTGlyph/FTBitmapGlyphImpl.h",
        "FTGlyph/FTBufferGlyph.cpp",
        "FTGlyph/FTBufferGlyphImpl.h",
        "FTGlyph/FTExtrudeGlyph.cpp",
        "FTGlyph/FTExtrudeGlyphImpl.h",
        "FTGlyph/FTGlyph.cpp",
        "FTGlyph/FTGlyphGlue.cpp",
        "FTGlyph/FTGlyphImpl.h",
        "FTGlyph/FTOutlineGlyph.cpp",
        "FTGlyph/FTOutlineGlyphImpl.h",
        "FTGlyph/FTPixmapGlyph.cpp",
        "FTGlyph/FTPixmapGlyphImpl.h",
        "FTGlyph/FTPolygonGlyph.cpp",
        "FTGlyph/FTPolygonGlyphImpl.h",
        "FTGlyph/FTTextureGlyph.cpp",
        "FTGlyph/FTTextureGlyphImpl.h",
        "FTLayout/FTLayout.cpp",
        "FTLayout/FTLayoutGlue.cpp",
        "FTLayout/FTLayoutImpl.h",
        "FTLayout/FTSimpleLayout.cpp",
        "FTLayout/FTSimpleLayoutImpl.h",
      },
    }

    local sdl = SharedLibrary {
      Name = "sdl",
      SourceDir = "3pp/sdl/src/",
      Env = {
        CCOPTS = "/W3",
      },
      Includes = {
        "3pp/sdl-custom",
      },
      Defines = {
        "USING_PREMAKE_CONFIG_H",
      },
      Libs = {
        "kernel32.lib",
        "user32.lib", "opengl32.lib", "gdi32.lib", "advapi32.lib", "winmm.lib",
        "imm32.lib", "ole32.lib", "shell32.lib", "version.lib", "oleaut32.lib"
      },
      Sources = {
        "atomic/SDL_atomic.c",
        "atomic/SDL_spinlock.c",
        "audio/directsound/directx.h",
        "audio/directsound/SDL_directsound.c",
        "audio/directsound/SDL_directsound.h",
        "audio/dummy/SDL_directsound.h",
        "audio/dummy/SDL_dummyaudio.c",
        "audio/dummy/SDL_dummyaudio.h",
        "audio/disk/SDL_diskaudio.c",
        "audio/disk/SDL_diskaudio.h",
        "audio/SDL_audio.c",
        "audio/SDL_audiocvt.c",
        "audio/SDL_audiodev.c",
        "audio/SDL_audiodev_c.h",
        "audio/SDL_audiomem.h",
        "audio/SDL_audiotypecvt.c",
        "audio/SDL_audio_c.h",
        "audio/SDL_mixer.c",
        "audio/SDL_sysaudio.h",
        "audio/SDL_wave.c",
        "audio/SDL_wave.h",
        "audio/winmm/SDL_winmm.c",
        "audio/winmm/SDL_winmm.h",
        "core/linux/SDL_evdev.c",
        "core/linux/SDL_evdev.h",
        "core/linux/SDL_udev.c",
        "core/linux/SDL_udev.h",
        "core/windows/SDL_windows.c",
        "core/windows/SDL_windows.h",
        "cpuinfo/SDL_cpuinfo.c",
        "events/blank_cursor.h",
        "events/default_cursor.h",
        "events/scancodes_windows.h",
        "events/SDL_clipboardevents.c",
        "events/SDL_clipboardevents_c.h",
        "events/SDL_dropevents.c",
        "events/SDL_dropevents_c.h",
        "events/SDL_events.c",
        "events/SDL_events_c.h",
        "events/SDL_gesture.c",
        "events/SDL_gesture_c.h",
        "events/SDL_keyboard.c",
        "events/SDL_keyboard_c.h",
        "events/SDL_mouse.c",
        "events/SDL_mouse_c.h",
        "events/SDL_quit.c",
        "events/SDL_sysevents.h",
        "events/SDL_touch.c",
        "events/SDL_touch_c.h",
        "events/SDL_windowevents.c",
        "events/SDL_windowevents_c.h",
        "file/SDL_rwops.c",
        "filesystem/windows/SDL_sysfilesystem.c",
        "haptic/SDL_haptic.c",
        "haptic/SDL_haptic_c.h",
        "haptic/SDL_syshaptic.h",
        "haptic/windows/SDL_syshaptic.c",
        "joystick/SDL_gamecontroller.c",
        "joystick/SDL_gamecontrollerdb.h",
        "joystick/SDL_joystick.c",
        "joystick/SDL_joystick_c.h",
        "joystick/SDL_sysjoystick.h",
        "joystick/windows/SDL_dxjoystick.c",
        "joystick/windows/SDL_dxjoystick_c.h",
        "joystick/windows/SDL_mmjoystick.c",
        "libm/e_atan2.c",
        "libm/e_log.c",
        "libm/e_pow.c",
        "libm/e_rem_pio2.c",
        "libm/e_sqrt.c",
        "libm/k_cos.c",
        "libm/k_rem_pio2.c",
        "libm/k_sin.c",
        "libm/math_libm.h",
        "libm/math_private.h",
        "libm/s_atan.c",
        "libm/s_copysign.c",
        "libm/s_cos.c",
        "libm/s_fabs.c",
        "libm/s_floor.c",
        "libm/s_scalbn.c",
        "libm/s_sin.c",
        "loadso/windows/SDL_sysloadso.c",
        "power/SDL_power.c",
        "power/windows/SDL_syspower.c",
        "render/direct3d/SDL_render_d3d.c",
        "render/mmx.h",
        "render/opengl/SDL_glfuncs.h",
        "render/opengl/SDL_render_gl.c",
        "render/opengl/SDL_shaders_gl.c",
        "render/opengl/SDL_shaders_gl.h",
        "render/opengles/SDL_glesfuncs.h",
        "render/opengles/SDL_render_gles.c",
        "render/opengles2/SDL_gles2funcs.h",
        "render/opengles2/SDL_render_gles2.c",
        "render/opengles2/SDL_shaders_gles2.c",
        "render/opengles2/SDL_shaders_gles2.h",
        "render/SDL_render.c",
        "render/SDL_sysrender.h",
        "render/SDL_yuv_mmx.c",
        "render/SDL_yuv_sw.c",
        "render/SDL_yuv_sw_c.h",
        "render/software/SDL_blendfillrect.c",
        "render/software/SDL_blendfillrect.h",
        "render/software/SDL_blendline.c",
        "render/software/SDL_blendline.h",
        "render/software/SDL_blendpoint.c",
        "render/software/SDL_blendpoint.h",
        "render/software/SDL_draw.h",
        "render/software/SDL_drawline.c",
        "render/software/SDL_drawline.h",
        "render/software/SDL_drawpoint.c",
        "render/software/SDL_drawpoint.h",
        "render/software/SDL_render_sw.c",
        "render/software/SDL_render_sw_c.h",
        "render/software/SDL_rotate.c",
        "render/software/SDL_rotate.h",
        "SDL.c",
        "SDL_assert.c",
        "SDL_assert_c.h",
        "SDL_error.c",
        "SDL_error_c.h",
        "SDL_hints.c",
        "SDL_log.c",
        "stdlib/SDL_getenv.c",
        "stdlib/SDL_iconv.c",
        "stdlib/SDL_malloc.c",
        "stdlib/SDL_qsort.c",
        "stdlib/SDL_stdlib.c",
        "stdlib/SDL_string.c",
        "thread/SDL_systhread.h",
        "thread/SDL_thread.c",
        "thread/SDL_thread_c.h",
        "thread/generic/SDL_syscond.c",
        "thread/windows/SDL_sysmutex.c",
        "thread/windows/SDL_syssem.c",
        "thread/windows/SDL_systhread.c",
        "thread/windows/SDL_systhread_c.h",
        "thread/windows/SDL_systls.c",
        "timer/SDL_timer.c",
        "timer/SDL_timer_c.h",
        "timer/windows/SDL_systimer.c",
        "video/SDL_blit.c",
        "video/SDL_blit.h",
        "video/SDL_blit_0.c",
        "video/SDL_blit_1.c",
        "video/SDL_blit_A.c",
        "video/SDL_blit_auto.c",
        "video/SDL_blit_auto.h",
        "video/SDL_blit_copy.c",
        "video/SDL_blit_copy.h",
        "video/SDL_blit_N.c",
        "video/SDL_blit_slow.c",
        "video/SDL_blit_slow.h",
        "video/SDL_bmp.c",
        "video/SDL_clipboard.c",
        "video/SDL_egl.c",
        "video/SDL_egl_c.h",
        "video/SDL_fillrect.c",
        "video/SDL_pixels.c",
        "video/SDL_pixels_c.h",
        "video/SDL_rect.c",
        "video/SDL_rect_c.h",
        "video/SDL_RLEaccel.c",
        "video/SDL_RLEaccel_c.h",
        "video/SDL_shape.c",
        "video/SDL_shape_internals.h",
        "video/SDL_stretch.c",
        "video/SDL_surface.c",
        "video/SDL_sysvideo.h",
        "video/SDL_video.c",
        "video/dummy/SDL_nullevents.c",
        "video/dummy/SDL_nullevents_c.h",
        "video/dummy/SDL_nullframebuffer.c",
        "video/dummy/SDL_nullframebuffer_c.h",
        "video/dummy/SDL_nullvideo.c",
        "video/dummy/SDL_nullvideo.h",
        "video/windows/SDL_msctf.h",
        "video/windows/SDL_vkeys.h",
        "video/windows/SDL_windowsclipboard.c",
        "video/windows/SDL_windowsclipboard.h",
        "video/windows/SDL_windowsevents.c",
        "video/windows/SDL_windowsevents.h",
        "video/windows/SDL_windowsframebuffer.c",
        "video/windows/SDL_windowsframebuffer.h",
        "video/windows/SDL_windowskeyboard.c",
        "video/windows/SDL_windowskeyboard.h",
        "video/windows/SDL_windowsmessagebox.c",
        "video/windows/SDL_windowsmessagebox.h",
        "video/windows/SDL_windowsmodes.c",
        "video/windows/SDL_windowsmodes.h",
        "video/windows/SDL_windowsmouse.c",
        "video/windows/SDL_windowsmouse.h",
        "video/windows/SDL_windowsopengl.c",
        "video/windows/SDL_windowsopengl.h",
        "video/windows/SDL_windowsopengles.c",
        "video/windows/SDL_windowsopengles.h",
        "video/windows/SDL_windowsshape.c",
        "video/windows/SDL_windowsshape.h",
        "video/windows/SDL_windowsvideo.c",
        "video/windows/SDL_windowsvideo.h",
        "video/windows/SDL_windowswindow.c",
        "video/windows/SDL_windowswindow.h",
        "video/windows/wmmsg.h",
      },
    }

    local glpng = SharedLibrary {
      Name = "glpng",
      Defines = { "BUILDING_GLPNG" },
      Depends = { zlib, libpng },
      Libs = { "kernel32.lib", "opengl32.lib" },
      Sources = { "3pp/glpng/src/glpng.c" },
    }

    local chromium = Program {
      Defines = {
        "HAVE_CONFIG_H",
      },
      Env = {
        PROGOPTS = { "/SUBSYSTEM:WINDOWS" },
        CXXOPTS = { "/W4", "/WX" },
      },
      Name = "chromium",
      Depends = { "ftgl", "sdl", "glpng" },
      Libs = { "opengl32.lib", "glu32.lib" },
      Sources = {
        'chromium-bsu-config.h',
        "3pp/sdl/src/main/windows/SDL_windows_main.c",
        'src/Ammo.cpp', 'src/Ammo.h', 'src/Audio.cpp', 'src/Audio.h',
        'src/AudioOpenAL.cpp', 'src/AudioOpenAL.h', 'src/AudioSDLMixer.cpp',
        'src/AudioSDLMixer.h', 'src/compatibility.h', 'src/Config.cpp',
        'src/Config.h', 'src/define.h', 'src/EnemyAircraft.cpp',
        'src/EnemyAircraft.h', 'src/EnemyAircraft_Boss00.cpp',
        'src/EnemyAircraft_Boss00.h', 'src/EnemyAircraft_Boss01.cpp',
        'src/EnemyAircraft_Boss01.h', 'src/EnemyAircraft_Gnat.cpp',
        'src/EnemyAircraft_Gnat.h', 'src/EnemyAircraft_Omni.cpp',
        'src/EnemyAircraft_Omni.h', 'src/EnemyAircraft_RayGun.cpp',
        'src/EnemyAircraft_RayGun.h', 'src/EnemyAircraft_Straight.cpp',
        'src/EnemyAircraft_Straight.h', 'src/EnemyAircraft_Tank.cpp',
        'src/EnemyAircraft_Tank.h', 'src/EnemyAmmo.cpp', 'src/EnemyAmmo.h',
        'src/EnemyFleet.cpp', 'src/EnemyFleet.h', 'src/Explosions.cpp',
        'src/Explosions.h', 'src/extern.h', 'src/gettext.h', 'src/Global.cpp',
        'src/Global.h', 'src/Ground.cpp', 'src/Ground.h',
        'src/GroundMetal.cpp', 'src/GroundMetal.h',
        'src/GroundMetalSegment.cpp', 'src/GroundMetalSegment.h',
        'src/GroundSea.cpp', 'src/GroundSea.h', 'src/GroundSeaSegment.cpp',
        'src/GroundSeaSegment.h', 'src/GroundSegment.cpp',
        'src/GroundSegment.h', 'src/HeroAircraft.cpp', 'src/HeroAircraft.h',
        'src/HeroAmmo.cpp', 'src/HeroAmmo.h', 'src/HiScore.cpp',
        'src/HiScore.h', 'src/Image.cpp', 'src/Image.h', 'src/main.cpp',
        'src/main.h', 'src/MainGL.cpp', 'src/MainGL.h', 'src/MainGLUT.cpp',
        'src/MainGLUT.h', 'src/MainSDL.cpp', 'src/MainSDL.h',
        'src/MainSDL_Event.cpp', 'src/MainToolkit.cpp', 'src/MainToolkit.h',
        'src/MenuGL.cpp', 'src/MenuGL.h',
        'src/PowerUps.cpp', 'src/PowerUps.h', 'src/ScreenItem.cpp',
        'src/ScreenItem.h', 'src/ScreenItemAdd.cpp', 'src/ScreenItemAdd.h',
        'src/StatusDisplay.cpp', 'src/StatusDisplay.h', 'src/Text.cpp',
        'src/Text.h', 'src/TextFTGL.cpp', 'src/TextFTGL.h',
        'src/textGeometry.h', 'src/textGeometryBSU.cpp',
        'src/textGeometryChromium.cpp', 'src/TextGLC.cpp', 'src/TextGLC.h',
      },
    }
    Default(chromium)
  end,

  Configs = {
    Config {
      Name = "win64-vs2012",
      Tools = { { "msvc-vs2012"; TargetArch = "x64" } },
      Inherit = common,
      DefaultOnHost = "windows",
    },
  },

}
