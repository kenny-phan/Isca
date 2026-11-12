#!/bin/bash -l

#SBATCH --account=pi_mpr49
#SBATCH --job-name=scratch_giant_planet
#SBATCH --output=scratch_giant_planet.%j.out
#SBATCH --error=scratch_giant_planet.%j.err
#SBATCH --partition=day
#SBATCH --nodes=1
#SBATCH --ntasks=64
#SBATCH --cpus-per-task=1
#SBATCH --mem=32G
#SBATCH --time=01:00:00
#SBATCH --export=ALL

# --- Activate the Isca conda env FIRST ---
source /apps/software/system/software/miniconda/24.11.3/etc/profile.d/conda.sh
conda activate isca

# --- Sanity check (shows up in .out / .err) ---
echo "Host: $(hostname)"
echo "python: $(which python)"
python -c "import sys, numpy, netCDF4; print('exe:', sys.executable); print('numpy:', numpy.__version__); print('netCDF4:', netCDF4.__version__)"

# --- Isca compiler/NetCDF env (now CONDA_PREFIX is set) ---
source ~/programs/isca/src/extra/env/gfortran

# --- Isca paths ---
export GFDL_BASE=${HOME}/programs/isca
export GFDL_WORK=${HOME}/scratch_pi_mpr49/ktp9/isca_work
export GFDL_DATA=${HOME}/scratch_pi_mpr49/ktp9/isca_data

# --- Run ---
sed -i "s/^NCORES =.*$/NCORES = $(echo ${SLURM_NTASKS:-1})/" ${GFDL_BASE}/exp/test_cases/giant_planet/scratch_giant_planet_test_case.py

python ${GFDL_BASE}/exp/test_cases/giant_planet/scratch_giant_planet_test_case.py