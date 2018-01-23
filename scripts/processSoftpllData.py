import sys

infile, outfile = sys.argv[1], sys.argv[2]

with open(infile) as inf:
    lines=inf.readlines()

linesb=[]
decimals=[]
decimalsOrd=[]

linesb.append(lines[0::5])
linesb.append(lines[1::5])
linesb.append(lines[2::5])
linesb.append(lines[3::5])

prueba = str(int(linesb[0][0],16))

for lineb in linesb:
    for i in range(len(lineb)):
        lineb[i] = str(int(lineb[i],16))
    decimals.append(lineb)

for i in range(len(decimals[3])):
    decimalsOrd.append(decimals[0][i] +' '+ decimals[1][i]+' ' + decimals[2][i]+' ' + decimals[3][i] + '\n')


with open(outfile,"w") as outf:
#   outf.writelines(number + '\n' for n)
   for line in decimalsOrd:
       outf.writelines(line)
