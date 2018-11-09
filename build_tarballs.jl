# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder

name = "LibSpatialIndexBuilder"
version = v"0.0.0"

# Collection of sources required to build LibSpatialIndexBuilder
sources = [
    "http://download.osgeo.org/libspatialindex/spatialindex-src-1.8.5.tar.bz2" =>
    "31ec0a9305c3bd6b4ad60a5261cba5402366dd7d1969a8846099717778e9a50a",

]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir
cd spatialindex-src-1.8.5/
./configure --prefix=$prefix --host=$target
make
make install

if [ $target = "x86_64-w64-mingw32" ]; then
cd $WORKSPACE/srcdir
ls
cd ..
ls
cd destdir/
ls
cd bin/
ls
cd ..
cd ..
cd metadir/
ls
cd ../srcdir/
ls
cd spatialindex-src-1.8.5/
ls
exit

fi

"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = [
    Linux(:i686, libc=:glibc),
    Linux(:x86_64, libc=:glibc),
    Linux(:aarch64, libc=:glibc),
    Linux(:armv7l, libc=:glibc, call_abi=:eabihf),
    Linux(:powerpc64le, libc=:glibc),
    Linux(:i686, libc=:musl),
    Linux(:x86_64, libc=:musl),
    Linux(:aarch64, libc=:musl),
    Linux(:armv7l, libc=:musl, call_abi=:eabihf),
    FreeBSD(:x86_64)
]

# The products that we will ensure are always built
products(prefix) = [
    LibraryProduct(prefix, "libspatialindex_c", :libspatialindex_c),
    LibraryProduct(prefix, "libspatialindex", :libspatialindex)
]

# Dependencies that must be installed before this package can be built
dependencies = [
    
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies)

