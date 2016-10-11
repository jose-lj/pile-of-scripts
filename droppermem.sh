#!/bin/bash

BASEADDR=0x10062000
BASEADDR2=0x100620f8
BASEADDR3=0x100620fc

ACCEPT_COUNT0=0x1006101C
ACCEPT_COUNT1=0x10061020
DROP_COUNT0=0x10061014
DROP_COUNT1=0x10061018

divider============================
divider=$divider$divider
width=40

STRING="$(devmem $ACCEPT_COUNT0)"
printf "Port 0 accepted:\t%8s\n" ${STRING:2}
STRING="$(devmem $ACCEPT_COUNT1)"
printf "Port 1 accepted:\t%8s\n" ${STRING:2}
STRING="$(devmem $DROP_COUNT0)"
printf "Port 0 dropped:\t%8s\n" ${STRING:2}
STRING="$(devmem $DROP_COUNT1)"
printf "Port 1 dropped:\t%8s\n" ${STRING:2}

HEADER="\n %6s    %12s   %9s\n"
FORMAT="    %02d     %2s:%2s:%2s:%2s:%2s:%2s      %4s\n"
STRING="$(devmem $BASEADDR)"
printf '\nUsed positions: %s\n' $STRING
printf "$HEADER" "Pos." "   MAC Addr.   " "  Seqnum"
printf "%$width.${width}s\n" "$divider"


for i in {0..31}
do
	BASEADDR2=$((BASEADDR2+8))
	STRING1="$(devmem $BASEADDR2)"
	BASEADDR3=$((BASEADDR3+8))
	STRING2="$(devmem $BASEADDR3)"
	printf "$FORMAT" $i ${STRING1:2:2} ${STRING1:4:2} ${STRING1:6:2} ${STRING1:8:2} ${STRING2:2:2} ${STRING2:4:2} ${STRING2:6:4}
	#printf '%s Seqnum %s\n' ${STRING:2:4} ${STRING:6:4}
done


