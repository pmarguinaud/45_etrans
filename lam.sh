#!/bin/bash

ulimit -s unlimited
export OMP_NUM_THREADS=1

set -x
set -e

module unload gnu
module load nvhpc/20.9

#mpirun -np 2 ./bin/AATESTPROG --namelist fort.4.20x20 --time 1 > AATESTPROG.eo 2>&1
mpirun -np 2 ./bin/AATESTPROG \
  --namelist fort.4.20x20 \
  --u-file 20x20/AATESTPROG.20x20.gp.000045.dat \
  --v-file 20x20/AATESTPROG.20x20.gp.000009.dat \
  --time 1 > AATESTPROG.eo 2>&1

rm -f snapshot_*

~sor/3d/glgrib/glgrib.sh --field[0].path AATESTPROG.fa%WW01U AATESTPROG.fa%WW01V --field[0].type VECTOR --field[0].palette.name cold_hot --field[0].vector.arrow.color black --scene.center.on
~sor/3d/glgrib/glgrib.sh --field[0].path AATESTPROG.fa%WW01U --field[0].palette.name cold_hot --scene.center.on
~sor/3d/glgrib/glgrib.sh --field[0].path AATESTPROG.fa%WW01V --field[0].palette.name cold_hot --scene.center.on


for f in snapshot_* AATESTPROG.fa
do
mv $f ~/tmp/.
ssh ecgate scp ~/tmp/$f phi001@90.76.140.145:tmp/$f
done


