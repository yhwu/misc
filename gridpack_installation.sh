# start from fresh ubuntu 16.04
# follow instructions from https://www.gridpack.org/wiki/index.php/Building_on_Ubuntu

# install some standard libraries
# sudo apt-get -y install git
# sudo apt-get -y install libboost-all-dev
# sudo apt-get -y install openmpi-bin make cmake git gfortran libblas-dev liblapack-dev doxygen
# sudo apt-get -y install libmetis-dev libparmetis-dev
# sudo apt-get -y install glpk-utils  libglpk-dev
# sudo apt-get -y install indicator-multiload # not necessary


# install gridpack to $prefix
prefix="$HOME/opt/gridpack"


# gather PETSC, GA, GridPACK
# note, it is important not to use most recent commits
mkdir -p $prefix
cd $prefix

# git clone https://github.com/GridOPTICS/GridPACK.git .
# git submodule update --init

wget http://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-3.6.4.tar.gz
tar zxf petsc-3.6.4.tar.gz
mv petsc-3.6.4 petsc
wget https://github.com/GlobalArrays/ga/releases/download/v5.6.2/ga-5.6.2.tar.gz
tar zxf ga-5.6.2.tar.gz
mv ga-5.6.2 ga
wget https://github.com/GridOPTICS/GridPACK/releases/download/v3.1/GridPACK-3.1.tar.gz
tar zxf GridPACK-3.1.tar.gz
mv GridPACK-3.1 GridPACK

# install PETSC
PETSC_DIR="$prefix/petsc"
export PETSC_DIR
cd $PETSC_DIR
./configure \
    PETSC_ARCH=arch-ubuntu-real-opt \
    --with-prefix="$prefix" \
    --with-mpi=1 \
    --with-cc=mpicc \
    --with-fc=mpif90 \
    --with-cxx=mpicxx \
    --with-clanguage=c++ \
    --with-c++-support=1 \
    --with-cxx-dialect=C++11 \
    --CXX_CXXFLAGS=-std=gnu++11 \
    --with-c-support=0 \
    --with-fortran=1 \
    --with-pthread=0 \
    --with-scalar-type=real \
    --with-fortran-kernels=generic \
    --with-parmetis=1 \
    --download-parmetis=1 \
    --with-metis=1 \
    --download-metis=1 \
    --with-superlu_dist=1 \
    --download-superlu_dist=1 \
    --with-blas-lapack-dir=/usr \
    --with-suitesparse=1 \
    --download-suitesparse=1 \
    --with-mumps=0 \
    --with-scalapack=0 \
    --with-shared-libraries=0 \
    --with-x=0 \
    --with-mpirun=mpirun \
    --with-mpiexec=mpiexec \
    --with-debugging=0

make PETSC_DIR="$prefix/petsc" PETSC_ARCH=arch-ubuntu-real-opt all
make PETSC_DIR="$prefix/petsc" PETSC_ARCH=arch-ubuntu-real-opt test
make PETSC_DIR="$prefix/petsc" PETSC_ARCH=arch-ubuntu-real-opt streams


# install GA
cd $prefix/ga
./autogen.sh
./configure \
     --enable-cxx \
     --enable-i4 \
     --disable-f77 \
     --with-mpi \
     --prefix="$prefix" \
     --with-blas=no \
     --with-lapack=no \
     --enable-shared=no \
     --enable-static=yes \
     MPICC=mpicc MPICXX=mpicxx MPIF77=mpif90 \
     MPIEXEC=mpiexec MPIRUN=mpirun

make
make install


# install GridPack
cd $prefix
cmake -Wno-dev --debug-try-compile \
      -D PETSC_DIR:STRING="$prefix/petsc" \
      -D PETSC_ARCH:STRING="arch-ubuntu-real-opt" \
      -D GA_DIR:STRING="$prefix" \
      -D MPI_CXX_COMPILER:STRING="mpicxx" \
      -D MPI_C_COMPILER:STRING="mpicc" \
      -D MPIEXEC:STRING="mpiexec" \
      -D MPIEXEC_MAX_NUMPROCS:STRING="4" \
      -D GRIDPACK_TEST_TIMEOUT:STRING=30 \
      -D USE_GLPK:BOOL=OFF \
      -D CMAKE_INSTALL_PREFIX:PATH="$prefix" \
      ./GridPACK/src

make
make test
