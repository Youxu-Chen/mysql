#!/bin/bash
gnuplot << EOP
set style line 1 lt 1 lw 3
set style line 2 lt 5 lw 3
set style line 3 lt 7 lw 3
set terminal png size 960,480
set grid x y
set xlabel "Time(sec)"
set ylabel "Transactions"
set output "$2"
plot "$1" using 1:2 title "PS 5.1.56 buffer pool 512MM" ls 1 with lines,\
     "$1" using 3:4 title "PS 5.1.56 buffer pool 1g" ls 2 with lines,\
     "$1" using 3:6 title "PS 5.1.56 buffer pool 2g" ls 3 with lines axes x1y1                                                    
EOP