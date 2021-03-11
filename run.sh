#!/bin/bash

ulimit -s unlimited
export OMP_NUM_THREADS=1

#DR_HOOK_NOT_MPI=1 ./bin/AATESTPROG --namelist fort.4.20x20 --lmpoff --time 0 > AATESTPROG.eo 2>&1
mpirun -np 2 ./bin/AATESTPROG --namelist fort.4.20x20 --lmpoff --time 0 > AATESTPROG.eo 2>&1

/home/ms/fr/sor/3d/glgrib/glgrib.sh AATESTPROG.fa%ZZZFFFFF
mv snapshot_0000.png ~/tmp/.

ssh ecgate scp ~/tmp/snapshot_0000.png phi001@90.76.140.145:tmp/snapshot_0000.png

mpirun -np 1 ./bin/lfitools extractgrib --fa-file AATESTPROG.fa 

#~/install/PGI209/eccodes-2.14.0/bin/grib_dump  AATESTPROG.fa.G/ZZZFFFFF.grb 

cp AATESTPROG.fa.G/ZZZFFFFF.grb ~/tmp/ZZZFFFFF.grb
ssh ecgate scp ~/tmp/ZZZFFFFF.grb phi001@90.76.140.145:tmp/ZZZFFFFF.grb

