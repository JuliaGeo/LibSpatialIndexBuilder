# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder

name = "LibSpatialIndexBuilder"
version = v"1.8.5"

# Collection of sources required to build LibSpatialIndexBuilder
sources = [
    "http://download.osgeo.org/libspatialindex/spatialindex-src-$version.tar.bz2" =>
    "31ec0a9305c3bd6b4ad60a5261cba5402366dd7d1969a8846099717778e9a50a",
]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir
cd spatialindex-src-$version/
./configure --prefix=$prefix --host=$target
make
make install
"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = supported_platforms()

# The products that we will ensure are always built
products(prefix) = [
    LibraryProduct(prefix, "libspatialindex_c", :libspatialindex_c),
    LibraryProduct(prefix, "libspatialindex", :libspatialindex)
]

# Dependencies that must be installed before this package can be built
dependencies = []

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies)

