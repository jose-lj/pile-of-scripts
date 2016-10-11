"""
--- createPcap.py
--- Jose Lopez Jimenez, 2016
--- Universidad de Granada
---
--- This code is based on the contribution of user @RPGillespie
--- at the website http://web2.codeproject.com/Tips/612847/Generate-a-quick-and-easy-custom-pcap-file-using-P
"""

#!/usr/bin/python
port = 9600

#Custom Foo Protocol Packet
message =  ('01 01 00 08'   #Foo Base Header
            '01 02 00 00'   #Foo Message (31 Bytes)
            '00 00 12 30'   
            '00 00 12 31'
            '00 00 12 32' 
            '00 00 12 33' 
            '00 00 12 34' 
            'D7 CD EF'      #Foo flags
            '00 00 12 35')     


"""----------------------------------------------------------------"""
""" Do not edit below this line unless you know what you are doing """
"""----------------------------------------------------------------"""

import sys
import binascii

#Global header for pcap 2.4
pcap_global_header =   ('D4 C3 B2 A1'   
                        '02 00'         #File format major revision (i.e. pcap <2>.4)  
                        '04 00'         #File format minor revision (i.e. pcap 2.<4>)   
                        '00 00 00 00'     
                        '00 00 00 00'     
                        'FF FF 00 00'     
                        '01 00 00 00')

#pcap packet header that must preface every packet
pcap_packet_header =   ('3D E1 E8 57'     
                        'AC EF 0C 00'     
                        'XX XX XX XX'   #Frame Size (little endian) 
                        'YY YY YY YY')  #Frame Size (little endian)

eth_header =   ('02 34 56 78 9A 01'     #Dest Mac    
                '42 34 56 78 XX XX'     #Source Mac  
                '89 2F')                #Protocol (0x0800 = IP)
                
hsr_tag =      ('00 00 XX XX')

ip_header =    ('45'                    #IP version and header length (multiples of 4 bytes)   
                '00'                      
                'XX XX'                 #Length - will be calculated and replaced later
                '00 00'                   
                '40 00 40'                
                '11'                    #Protocol (0x11 = UDP)          
                'YY YY'                 #Checksum - will be calculated and replaced later      
                '7F 00 00 01'           #Source IP (Default: 127.0.0.1)         
                '7F 00 00 01')          #Dest IP (Default: 127.0.0.1) 

udp_header =   ('80 01'                   
                'XX XX'                 #Port - will be replaced later                   
                'YY YY'                 #Length - will be calculated and replaced later        
                '00 00')
                
efuse = 0
                
def getByteLength(str1):
    return len(''.join(str1.split())) / 2

def break_fuse():
    global efuse
    efuse = 1

def writeByteStringToFile(bytestring, filename):
    bytelist = bytestring.split()  
    bytes = binascii.a2b_hex(''.join(bytelist))
    bitout = open(filename, 'ab')
    bitout.write(bytes)

def generatePCAP(message,port,pcapfile,smac,seqnum):
 
    eth = eth_header.replace('XX XX', "%04x"%smac)
    hsr = hsr_tag.replace('XX XX', "%04x"%seqnum)
    
    udp = udp_header.replace('XX XX',"%04x"%port)
    udp_len = getByteLength(message) + getByteLength(udp_header)
    udp = udp.replace('YY YY',"%04x"%udp_len)

    ip_len = udp_len + getByteLength(ip_header)
    ip = ip_header.replace('XX XX',"%04x"%ip_len)
    checksum = ip_checksum(ip.replace('YY YY','00 00'))
    ip = ip.replace('YY YY',"%04x"%checksum)
    
    pcap_len = ip_len + getByteLength(eth_header) + getByteLength(hsr_tag) 
    hex_str = "%08x"%pcap_len
    reverse_hex_str = hex_str[6:] + hex_str[4:6] + hex_str[2:4] + hex_str[:2]
    pcaph = pcap_packet_header.replace('XX XX XX XX',reverse_hex_str)
    pcaph = pcaph.replace('YY YY YY YY',reverse_hex_str)
    
    if efuse == 0: 
        bytestring = pcap_global_header + pcaph + eth + hsr + ip + udp + message
        break_fuse()
    else:
        bytestring = pcaph + eth + hsr + ip + udp + message
    writeByteStringToFile(bytestring, pcapfile)

#Splits the string into a list of tokens every n characters
def splitN(str1,n):
    return [str1[start:start+n] for start in range(0, len(str1), n)]

#Calculates and returns the IP checksum based on the given IP Header
def ip_checksum(iph):

    #split into bytes    
    words = splitN(''.join(iph.split()),4)

    csum = 0;
    for word in words:
        csum += int(word, base=16)

    csum += (csum >> 16)
    csum = csum & 0xFFFF ^ 0xFFFF

    return csum
    



"""------------------------------------------"""
""" execution starts here:                   """
"""------------------------------------------"""

if len(sys.argv) < 2:
        print 'usage: pcapgen.py output_file'
        exit(0)
        
source_mac = 0
seq_num = 0

# This loop sends 64 frames:
#  - 2 different sequence numbers '0' and '1'
#  - from 32 different source MACs
for source_mac in range(0,32):
    for seq_num in range(0,2):
        generatePCAP(message,port,sys.argv[1],source_mac,seq_num)  
