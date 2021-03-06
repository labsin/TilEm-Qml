# Resolve the library (or other files) path
# Resolved_lib is defined to the lib or the lib it links to
# It follows multiple links
# Linking files are not processed

function(resolve_lib lib resolved_lib success)
    if(lib MATCHES "^-l(.*)$")
        set(${resolved_lib} ${lib} PARENT_SCOPE)
        set(${success} false PARENT_SCOPE)
    else()
        get_filename_component(resolved ${lib}
            REALPATH)
        if(EXISTS ${resolved})
            if(NOT ${resolved} STREQUAL ${lib})
                resolve_lib(${resolved} resolved temp)
            endif()
            set(${resolved_lib} ${resolved} PARENT_SCOPE)
            set(${success} true PARENT_SCOPE)
        else()
            set(${resolved_lib} ${lib} PARENT_SCOPE)
            set(${success} false PARENT_SCOPE)
        endif()
    endif()
endfunction(resolve_lib)

function(resolve_libs resolved_libs libs)
    foreach(lib ${ARGN})
        resolve_lib(${lib} resolved temp)
        list(APPEND ${resolved_libs} ${resolved})
    endforeach()
endfunction(resolve_libs)

function(remove_unexisting result_list lib_list)
    foreach(lib ${ARGN})
        if(EXISTS ${lib})
            list(APPEND ${result_list})
        endif()
    endforeach()
endfunction(remove_unexisting)
