#!/usr/bin/env bash


NPROCS = $(shell grep -c 'processor' /proc/cpuinfo)
MAKEFLAGS += -j$(NPROCS)

# To build:
#   make <target>
# Use the 'lib' target first to build the library, then either the Lua
# or Python targets are 'S4lua' and 'python_ext', respectively.

# BUILD_NAME=gnu_ant_hpc
# BUILD_NAME=gnu
BUILD_NAME=conda#serial/gnu
# BUILD_NAME=serial/intel

INTEL=0

# OBJDIR = ./build
# OBJDIR = ./build/gnu
OBJDIR = ./build/$(BUILD_NAME)


# Set these to the flags needed to link against BLAS and Lapack.
#  If left blank, then performance may be very poor.
#  On Mac OS,
#   BLAS_LIB = -framework vecLib
#   LAPACK_LIB = -framework vecLib
#  On Fedora: dnf install openblas-devel
#  On Debian and Fedora, with reference BLAS and Lapack (slow)
#   BLAS_LIB = -lblas
#   LAPACK_LIB = -llapack
#  NOTE: on Fedora, need to link blas and lapack properly, where X.X.X is some version numbers
#  Linking Command Example: sudo ln -s /usr/lib64/liblapack.so.X.X.X /usr/lib64/liblapack.so
#  blas Example: sudo ln -s /usr/lib64/libopeblas64.so.X.X.X /usr/lib64/libblas.so
#  Can also use -L to link to the explicit libary path
# BLAS_LIB = -L$(MKLROOT)/lib/intel64 -liomp5 -lpthread
# LAPACK_LIB =
# BLAS_INC = -I${MKLROOT}/include
# LAPACK_INC =


# ### ANTENNA CLUSTER
# BLAS_LIB = -L$(PROGRAMS_PATH)/ant_hpc/openblas/lib -lopenblas
# BLAS_INC = -I$(PROGRAMS_PATH)/ant_hpc/openblas/include

### LOCAL QMUL
# BLAS_LIB = -L$(PROGRAMS_PATH)/openblas/lib -lopenblas
# BLAS_INC = -I$(PROGRAMS_PATH)/openblas/include
### LAPTOP
## gnu
BLAS_INC = -I$(CONDA)/include
BLAS_LIB = -L$(CONDA)/lib -lopenblas
## intel
# BLAS_LIB = -L$(HOME)/intel/compilers_and_libraries_2019.2.187/linux/mkl/lib/intel64_lin -lmkl_intel_ilp64 -lmkl_intel_thread  -lmkl_core -liomp5 -lpthread -lm -ldl
# BLAS_INC = -I$(HOME)/intel/compilers_and_libraries_2019.2.187/linux/mkl/include

# -lmkl_intel_ilp64 -lmkl_intel_thread -lmkl_core -liomp5 -lpthread -lm -ldl

# Specify the flags for Lua headers and libraries (only needed for Lua frontend)
# Recommended: build lua in the current directory, and link against this local version

# LUA_INC = -I./lua-5.2.4/install/include
# LUA_LIB = -L./lua-5.2.4/install/lib -llua -ldl -lm
#### ANTENNA CLUSTER and LOCAL QMUL
### for LAPTOP comment this as Lua is installed system wide
# LUA_INC = -I$(PROGRAMS_PATH)/lua-5.3.4/src
# LUA_LIB = -L$(PROGRAMS_PATH)/lua-5.3.4/src -llua -ldl -lm

# OPTIONAL
# Typically if installed,
#  FFTW3_INC can be left empty
#  FFTW3_LIB = -lfftw3
#  or, if Fedora and/or fftw is version 3 but named fftw rather than fftw3
#  FTW3_LIB = -lfftw
#  May need to link libraries properly as with blas and lapack above
# FFTW3_INC =
# FFTW3_LIB = -lfftw3

### ANTENNA CLUSTER
# FFTW3_INC = -I$(PROGRAMS_PATH)/ant_hpc/include
# FFTW3_LIB = -L$(PROGRAMS_PATH)/ant_hpc/lib -lfftw3
### LOCAL QMUL
# FFTW3_INC = -I$(PROGRAMS_PATH)/fftw/include
# FFTW3_LIB = -L$(PROGRAMS_PATH)/fftw/lib -lfftw3
### LAPTOP
## gnu
FFTW3_INC = -I$(CONDA)/include
FFTW3_LIB = -L$(CONDA)/lib -lfftw3
## intel
# FFTW3_INC = -I$(HOME)/intel/compilers_and_libraries_2019.2.187/linux/mkl/include
# FFTW3_LIB = -L$(HOME)/intel/compilers_and_libraries_2019.2.187/linux/mkl/lib/intel64_lin -lfftw3

# Typically,
 PTHREAD_INC = -DHAVE_UNISTD_H
 PTHREAD_LIB = -lpthread
# PTHREAD_INC =
# PTHREAD_LIB =

# OPTIONAL
# If not installed:
# Fedora: dnf install libsuitsparse-devel
# Typically, if installed:
#CHOLMOD_INC = -I/usr/include/suitesparse
#CHOLMOD_LIB = -lcholmod -lamd -lcolamd -lcamd -lccolamd
CHOLMOD_INC = -I$(CONDA)/include
CHOLMOD_LIB = -L$(CONDA)/lib -lcholmod -lamd -lcolamd -lcamd -lccolamd



# Specify the boost library
BOOST_INC = -I$(CONDA)/include/boost
BOOST_LIBS = -L$(CONDA)/lib -lboost_serialization



# Specify the MPI library
# For example, on Fedora: dnf  install openmpi-devel
#MPI_INC = -I/usr/include/openmpi-x86_64/openmpi/ompi
#MPI_LIB = -lmpi
# or, explicitly link to the library with -L, example below
#MPI_LIB = -L/usr/lib64/openmpi/lib/libmpi.so
#MPI_INC = -I/usr/include/openmpi-x86_64/openmpi
#MPI_LIB = -L/usr/lib64/openmpi/lib/libmpi.so
MPI_INC =
MPI_LIB =

# Enable S4_TRACE debugging
# values of 1, 2, 3 enable debugging, with verbosity increasing as
# value increases. 0 to disable
S4_DEBUG = 0
S4_PROF = 0


# If compiling with MPI, the following must be modified to the proper MPI compilers
#
CC = gcc
CXX = g++
CFLAGS   += -O3 -Wall -march=native -fcx-limited-range -fPIC
CXXFLAGS += -O3 -Wall -march=native -fcx-limited-range -fPIC

#
#
# CC = icc
# CXX = icpc
# CFLAGS   += -fPIC -xHost -O3 -Wall# -no-prec-div -fp-model fast=2  -DMKL_ILP64 #-mkl=parallel
# CXXFLAGS += -fPIC -xHost -O3 -Wall# -no-prec-div -fp-model fast=2  -DMKL_ILP64 #-mkl=parallel
#
#

# options for Sampler module
OPTFLAGS = -O3 -fPIC

S4_BINNAME = $(OBJDIR)/S4
S4_LIBNAME = $(OBJDIR)/libS4.a
S4r_LIBNAME = $(OBJDIR)/libS4r.a



##################### DO NOT EDIT BELOW THIS LINE #####################


include Makefile_common
