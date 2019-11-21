#!/bin/bash

OBJDIR="$1"
LIBFILE="$2"
LIBS="$3"
BOOST_PREFIX="$4"
CFLAGS="$5"
INTEL="$6"

echo "LIBS: $LIBS"
echo "LIBFILE: $LIBFILE"
echo "BOOST PREFIX: $BOOST_PREFIX"

cat <<SETUPPY > setup.py
from distutils.core import setup, Extension
import numpy as np
import os
if $INTEL == 1:
	os.environ["CC"] = "icc"
	os.environ["CXX"] = "icpc"
else:
	os.environ["CC"] = "/usr/bin/gcc"
	os.environ["CXX"] = "/usr/bin/g++"

libs = ['S4', 'stdc++']
# libs.extend(["svml","imf"])
libs_ = [lib for lib in '$LIBS'.split()]

lib_dirs = ['$OBJDIR']
lib_dirs.extend(['$BOOST_PREFIX/lib'])
print(libs_)

for  l in libs_:
	if l.startswith("-L"):
		lib_dirs.append(l[2:])
	else:
		libs.append(l[2:])
	
print("-"*74)
print("libs: ", libs)
print("lib_dirs: ", lib_dirs)
print("-"*74)

# lib_dirs.extend(["$PROGRAMS_PATH/ant_hpc/lib"])
# lib_dirs.extend(["$PROGRAMS_PATH/ant_hpc/openblas/lib"])
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
