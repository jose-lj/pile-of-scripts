#!/bin/bash

BASEADDR=0x10071000
BASEADDR2=0x100710f8
BASEADDR3=0x100710fc

ACCEPT_COUNT0=0x1007001C
ACCEPT_COUNT1=0x10070020
DROP_COUNT0=0x10070014
DROP_COUNT1=0x10070018

divider============================
divider=$divider$divider
width=41

STRING="$(devmem $ACCEPT_COUNT0)"
printf "Port 0 accepted:\t%d\n" ${STRING}
STRING="$(devmem $ACCEPT_COUNT1)"
printf "Port 1 accepted:\t%d\n" ${STRING}
STRING="$(devmem $DROP_COUNT0)"
printf "Port 0 dropped:\t\t%d\n" ${STRING}
STRING="$(devmem $DROP_COUNT1)"
printf "Port 1 dropped:\t\t%d\n" ${STRING}

HEADER="\n%7s     %12s   %9s\n"
FORMAT="%02d     %1d     %2s:%2s:%2s:%2s:%2s:%2s      %4s\n"
STRING="$(devmem $BASEADDR)"
printf "$HEADER" "Pos. Used" "   MAC Addr.   " "  Seqnum"
printf "%$width.${width}s\n" "$divider"

for i in {0..31}
do
	BASEADDR2=$((BASEADDR2+8))
	STRING1="$(devmem $BASEADDR2)"
	BASEADDR3=$((BASEADDR3+8))
	STRING2="$(devmem $BASEADDR3)"
	RESULT=$((STRING & (1 << $i)))
	if [ "$RESULT" -eq 0 ]; then
		RESULT=0
	else
		RESULT=1
	fi
	printf "$FORMAT" $i $RESULT ${STRING1:2:2} ${STRING1:4:2} ${STRING1:6:2} ${STRING1:8:2} ${STRING2:2:2} ${STRING2:4:2} ${STRING2:6:4}
	#printf '%s Seqnum %s\n' ${STRING:2:4} ${STRING:6:4}
done
printf "%$width.${width}s\n" "$divider\n"



