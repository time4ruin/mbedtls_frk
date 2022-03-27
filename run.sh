argc=$#

if [ 2 -eq $argc ]
then
    args_1=$1
    args_2=$2
    echo "sudo passwd : "$args_1
    echo "directory of custom gcc/as : "$args_2

    A=$(which as)
    B=$(ls -l $A)
    C=${B#*-\> }

    D=$(which gcc)
    E=$(ls -l $D)
    F=${E#*-\> }

    echo $args_1 | sudo -S ln -Tfs $args_2/as.out /usr/bin/as
    echo $args_1 | sudo -S ln -Tfs $args_2/gcc.out /usr/bin/gcc
    echo $(ls -al /usr/bin/gcc)
    echo $(ls -al /usr/bin/as)
    make clean
    make
    cp ./tests/test_suite_mpi.datax ./
    echo $args_1 | sudo -S perf stat -o result_perf_aligned.txt -e page-faults,br_inst_retired.conditional,br_misp_retired.conditional ./tests/test_suite_mpi >/dev/null
    echo $(cat result_perf_aligned.txt) > result_aligned.txt
    echo $(ls -al ./tests/test_suite_mpi) >> result_aligned.txt
    echo $(ls -al ./library/bignum.o) >> result_aligned.txt

    echo $args_1 | sudo -S ln -Tfs $C /usr/bin/as
    echo $args_1 | sudo -S ln -Tfs $F /usr/bin/gcc
    echo $(ls -al /usr/bin/gcc)
    echo $(ls -al /usr/bin/as)
    make clean
    make
    cp ./tests/test_suite_mpi.datax ./
    echo $args_1 | sudo -S perf stat -o result_perf_raw.txt -e page-faults,br_inst_retired.conditional,br_misp_retired.conditional ./tests/test_suite_mpi >/dev/null
    echo $(cat result_perf_raw.txt) > result_raw.txt
    echo $(ls -al ./tests/test_suite_mpi) >> result_raw.txt
    echo $(ls -al ./library/bignum.o) >> result_raw.txt
else
    echo "usage: ./run.sh {sudo passwd} {directory of custom gcc/as}"
fi
