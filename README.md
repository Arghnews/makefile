# Makefile template
Fed up of not understanding Makefiles and their disgusting syntax and therefore not being able to efficiently compile my stuff and rely on a brand new hacky bash script every time.
Hence this template.

This demos a c++17 (std::size function) file with the xxHash library and prettyprint (header only) included.
Has res directory that will be synced with the bin directory when run ie. can place required files for program in there.

Reminder to myself that -Wl,-rpath,/path/to/libs/at/runtime
-Wl passes arguments to the linker, -rpath says look at the next argument(s) for shared libraries when run.

Have removed the xxHash and cxx-prettyprint .git dirs - just want this as a simple demo and I don't know about git submodules yet or how best to handle. Also xxHash shared library objects are built inside the xxHash directory for simplicity if a bit of a mess.

