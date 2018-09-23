#!/bin/bash

OBJDIR="$1"
LIBFILE="$2"
LIBS="$3"
BOOST_PREFIX="$4"
CFLAGS="$5"

echo "LIBS: $LIBS"
echo "LIBFILE: $LIBFILE"
echo "BOOST PREFIX: $BOOST_PREFIX"

cat <<SETUPPY > setup.py
from distutils.core import setup, Extension
import numpy as np
# import os
# os.environ["CC"] = "icc"
# os.environ["CXX"] = "icpc"

libs = ['S4', 'stdc++']
# libs.extend(["svml","imf"])
libs.extend([lib[2::] for lib in '$LIBS'.split()])


lib_dirs = ['$OBJDIR']
lib_dirs.extend(['$BOOST_PREFIX/lib'])
lib_dirs.extend(["$PROGRAMS_PATH/ant_hpc/lib"])
lib_dirs.extend(["$PROGRAMS_PATH/ant_hpc/openblas/lib"])
# lib_dirs.extend(["$MKLROOT/lib/intel64"])
# lib_dirs.extend(["/import/linux/intel/clusterstudio/15.0.2/lib/intel64"])

include_dirs = ['$BOOST_PREFIX/include', np.get_include()]
extra_link_args = ['$LIBFILE']
extra_compile_args=[]
extra_compile_args.extend(["-std=gnu99"])
extra_compile_args.extend([flag for flag in "$CFLAGS".split()])


S4module = Extension('S4',
	sources = ['S4/main_python.c'],
	libraries = libs,
	library_dirs = lib_dirs,
  include_dirs = include_dirs,
  # extra_objects = ['$LIBFILE'],
	extra_link_args = extra_link_args,
  runtime_library_dirs=['$BOOST_PREFIX/lib'],
	extra_compile_args=extra_compile_args
)

setup(name = 'S4',
	version = '1.1',
	description = 'Stanford Stratified Structure Solver (S4): Fourier Modal Method',
	ext_modules = [S4module]
)
SETUPPY
