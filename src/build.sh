#!/bin/bash

### Some Decoration
RCol='\e[0m'    # Text Reset

# Regular           Bold                Underline           High Intensity      BoldHigh Intens     Background          High Intensity Backgrounds
Bla='\e[0;30m';     BBla='\e[1;30m';    UBla='\e[4;30m';    IBla='\e[0;90m';    BIBla='\e[1;90m';   On_Bla='\e[40m';    On_IBla='\e[0;100m';
Red='\e[0;31m';     BRed='\e[1;31m';    URed='\e[4;31m';    IRed='\e[0;91m';    BIRed='\e[1;91m';   On_Red='\e[41m';    On_IRed='\e[0;101m';
Gre='\e[0;32m';     BGre='\e[1;32m';    UGre='\e[4;32m';    IGre='\e[0;92m';    BIGre='\e[1;92m';   On_Gre='\e[42m';    On_IGre='\e[0;102m';
Yel='\e[0;33m';     BYel='\e[1;33m';    UYel='\e[4;33m';    IYel='\e[0;93m';    BIYel='\e[1;93m';   On_Yel='\e[43m';    On_IYel='\e[0;103m';
Blu='\e[0;34m';     BBlu='\e[1;34m';    UBlu='\e[4;34m';    IBlu='\e[0;94m';    BIBlu='\e[1;94m';   On_Blu='\e[44m';    On_IBlu='\e[0;104m';
Pur='\e[0;35m';     BPur='\e[1;35m';    UPur='\e[4;35m';    IPur='\e[0;95m';    BIPur='\e[1;95m';   On_Pur='\e[45m';    On_IPur='\e[0;105m';
Cya='\e[0;36m';     BCya='\e[1;36m';    UCya='\e[4;36m';    ICya='\e[0;96m';    BICya='\e[1;96m';   On_Cya='\e[46m';    On_ICya='\e[0;106m';
Whi='\e[0;37m';     BWhi='\e[1;37m';    UWhi='\e[4;37m';    IWhi='\e[0;97m';    BIWhi='\e[1;97m';   On_Whi='\e[47m';    On_IWhi='\e[0;107m';

echo -e "${Gre} -----------------------------------------------------------------"
echo -e "${On_Gre} Starting Build Process for CTranslate2- ROCm${RCol}"
echo -e "${On_Gre} - Note: "
echo -e "${On_Gre}    - Architecture: $PYTORCH_ROCM_ARCH"
echo -e "${On_Gre}    - HSA_OVERRIDE_GFX_VERSION: $HSA_OVERRIDE_GFX_VERSION ${RCol}"
echo -e "${Gre} -----------------------------------------------------------------${RCol}\n"

cd CTranslate2-rocm

echo -e "${Gre} -----------------------------------------------------------------${RCol}"
echo -e "${On_Gre} 1. Setting Up Conda Environment Skipped.${RCol}"
echo -e "${Gre} -----------------------------------------------------------------${RCol}\n"

# # Initialize conda
# conda init bash

# # Activate the conda environment
# source activate py_3.9

echo -e "\n${Gre} -----------------------------------------------------------------${RCol}"
echo -e "${On_Gre} 2.  Running CMake with Architecture Spec'd${RCol}"
#echo -e "${On_Gre} - Note: "
#echo -e "${On_Gre}    - DCMAKE_HIP_ARCHITECTURES: $PYTORCH_ROCM_ARCH ${RCol}"
echo -e "${Gre} -----------------------------------------------------------------${RCol}\n"

# Run cmake with specified options
CLANG_CMAKE_CXX_COMPILER=clang++ CXX=clang++ HIPCXX="$(hipconfig -l)/clang" HIP_PATH="$(hipconfig -R)" \
cmake -S . -B build -DWITH_MKL=OFF -DWITH_HIP=ON -DCMAKE_HIP_ARCHITECTURES=$PYTORCH_ROCM_ARCH -DBUILD_TESTS=ON -DWITH_CUDNN=ON

# Build the project with 16 parallel jobs
cmake --build build -- -j16

# Change to the build directory
cd build

echo -e "\n${Gre} -----------------------------------------------------------------${RCol}"
echo -e "${On_Gre} 3.  Installing the CMake Build${RCol}"
echo -e "${Gre} -----------------------------------------------------------------${RCol}\n"

# Install the build with conda or system-wide
cmake --install . #--prefix $CONDA_PREFIX # use this line if using conda
sudo make install

echo -e "${Gre} -----------------------------------------------------------------${RCol}"
echo -e "${On_Gre} 4.  Linking with ldconfig${RCol}"
echo -e "${Gre} -----------------------------------------------------------------${RCol}\n"

# Update shared library cache
sudo ldconfig




echo -e "\n${Gre} -----------------------------------------------------------------${RCol}"
echo -e "${On_Gre} Python Package Assembly Omitted ${RCol}"
echo -e "${Gre} -----------------------------------------------------------------${RCol}\n"
# Change to the python directory
# cd ../python

# # everything is functioning up to here, but then the python package build fails
# # possibly build it in conda then install it outside of conda?

# echo -e "${Gre} -----------------------------------------------------------------${RCol}"
# echo -e "${On_Gre} 5. Setting Up Conda Environment.${RCol}"
# echo -e "${Gre} -----------------------------------------------------------------${RCol}\n"

# # Initialize conda
# conda init bash

# # Activate the conda environment
# source activate py_3.9

# echo -e "\n${Gre} -----------------------------------------------------------------${RCol}"
# echo -e "${On_Gre} 6. Installing Python Requirements${RCol}"
# echo -e "${Gre} -----------------------------------------------------------------${RCol}\n"
# # Install Python dependencies
# pip install wheel==0.43.0 setuptools==69.5.1 pybind11==2.11.1

# echo -e "\n${Gre} -----------------------------------------------------------------${RCol}"
# echo -e "${On_Gre} 7. Creating Wheel File${RCol}"
# echo -e "${Gre} -----------------------------------------------------------------${RCol}\n"

# # Build the Python wheel
# python setup.py bdist_wheel

# echo -e "\n${Gre} -----------------------------------------------------------------${RCol}"
# echo -e "${On_Gre} 8. Installing Wheel File.${RCol}"
# echo -e "${Gre} -----------------------------------------------------------------${RCol}\n"

# # Install the built wheel
# pip install dist/*.whl --no-deps

# Update the library path
# echo -e "$\n{Gre} -----------------------------------------------------------------${RCol}"
# echo -e "${On_Gre} 9. Updating Library Path"
# echo -e "${On_Gre} - Note: "
# echo -e "${On_Gre}    - Conda Prefix: $CONDA_PREFIX${RCol}"
# echo -e "${Gre} -----------------------------------------------------------------${RCol}"


#export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$CONDA_PREFIX/lib/

# #Summary of parameters
# echo -e "$\n{Gre} -----------------------------------------------------------------${RCol}"
# echo -e "${On_Gre} 8. Parameter Summary"
# echo -e "${On_Gre} - Note: "
# echo -e "${On_Gre}    - Conda Prefix: $CONDA_PREFIX${RCol}"
# echo -e "${On_Gre}    - Architecture: $PYTORCH_ROCM_ARCH"
# echo -e "${On_Gre}    - HSA_OVERRIDE_GFX_VERSION: $HSA_OVERRIDE_GFX_VERSION ${RCol}"
# echo -e "${On_Gre}    - DCMAKE_HIP_ARCHITECTURES: $PYTORCH_ROCM_ARCH ${RCol}"
# echo -e "${Gre} -----------------------------------------------------------------${RCol}"


echo -e "\n${Gre} -----------------------------------------------------------------${RCol}"
echo -e "${On_Gre} FINAL. Installing Wheel File.${RCol}"
echo -e "${Gre} -----------------------------------------------------------------${RCol}\n"

# Install the built wheel
pip install /src/*.whl