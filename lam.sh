#!/bin/bash

ulimit -s unlimited
export OMP_NUM_THREADS=1

set -x
set -e

module unload gnu
module load nvhpc/20.9

#mpirun -np 2 ./bin/AATESTPROG --namelist fort.4.20x20 --time 1 > AATESTPROG.eo 2>&1
# --field-file 20x20/AATESTPROG.20x20.gp.000058.dat \

mpirun -np 1 ./bin/AATESTPROGDER \
  --namelist fort.4.20x20 \
  --time 1 > AATESTPROGDER.eo 2>&1


for f in *.fa
do
  cp $f ~/tmp/
  ssh ecgate scp ~/tmp/$f phi001@90.76.140.145:tmp/$f
done

