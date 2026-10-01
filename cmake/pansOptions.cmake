add_library(pans_options INTERFACE)#配置包

target_compile_options(pans_options INTERFACE
    #GCC/Clang 通用选项
    $<OR:$<CMAKE_CXX_COMPILE_ID:GNU>,$<CMAKE_CXX_COMPILE_ID:Clang>>:
        -Wall               #常用告警
        -Wextra             #严重警告
        -Wpedantic          #严格遵循标准
        -fno-strict-aliasing #关闭严格编译
)

target_compile_options(pans_options INTERFACE
    $<$<AND:$<PLATFORM_ID:Linux>,$<OR,$<CXX_MODULES_COMPILE_ID:GNU>,$<CXX_MODULES_COMPILE_ID:Clang>>>:
        -fPIC #编译位置无关代码
    >
)

target_compile_options(pans_options INTERFACE
    $<$<AND:$<PLATFORM_ID:Linux>,$<OR,$<CXX_MODULES_COMPILE_ID:GNU>,$<CXX_MODULES_COMPILE_ID:Clang>>>:
        -rdynamic #栈回溯需要
    >
)

target_compile_definitions(pans_options INTERFACE
    $<$<CONFIG:Debug>:PANS_DEBUG>
)

target_compile_options(pans_options INTERFACE
    $<$<CONFIG:Debug>:-O0>
    $<$<CONFIG:Debug>:-g3>
    $<$<CONFIG:Debug>:-ggdb>
)

# ===== Release/RelWithDebInfo 共用选项 =====
target_compile_options(pans_options INTERFACE
    $<$<CONFIG:Release>:-DNDEBUG>
    $<$<CONFIG:Release>:-O2>
    $<$<CONFIG:Release>:-fno-omit-frame-pointer>
    
    $<$<CONFIG:RelWithDebInfo>:-DNDEBUG>
    $<$<CONFIG:RelWithDebInfo>:-O2>
    $<$<CONFIG:RelWithDebInfo>:-g>
    $<$<CONFIG:RelWithDebInfo>:-fno-omit-frame-pointer>
)

# ===== 覆盖率选项（默认关闭） =====
option(ENABLE_COVERAGE "Enable code coverage instrumentation" OFF)
if(ENABLE_COVERAGE)
    target_compile_options(pans_options INTERFACE
        $<$<CONFIG:Debug>:--coverage>
    )
    target_link_options(pans_options INTERFACE
        $<$<CONFIG:Debug>:--coverage>
    )
endif()