#!/bin/bash

BASEADDR=0x10062000
BASEADDR2=0x100620f8
BASEADDR3=0x100620fc

divider============================
divider=$divider$divider
width=40

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


