#!/bin/bash

name="faketrophy"
outDir="out/$name"
friendly_name="Fake Trophy Unlock"
author="king_dedede"
version="1.0"
href="https://www.youtube.com/@king_dedede"
desc="When you would unlock a trophy, delay manual load screens by 11 seconds. Does not unlock the trophy."

mkdir -p $outDir
rm -f $outDir/patch.txt
echo "#- name: $friendly_name" >> $outDir/patch.txt
echo "#- author: $author" >> $outDir/patch.txt
echo "#- version: $version" >> $outDir/patch.txt
echo "#- href: $href" >> $outDir/patch.txt
echo "#- description: $desc" >> $outDir/patch.txt

# assembly source file
s() {
    powerpc64-linux-gnu-as -o $1.o -mregnames -mcell -be -o $1.o $1.s
    powerpc64-linux-gnu-ld --oformat=binary -o $outDir/$1.bin $1.o
    rm $1.o
    echo "0x$2: $1.bin" >> $outDir/patch.txt
}

# c source file
c() {
    powerpc64-linux-gnu-gcc -mcpu=cell -mbig -m32 -Wl,--oformat=binary,-Ttext=$2 -nostdlib -O2 -o $outDir/$1.bin $1.c
    echo "0x$2: $1.bin" >> $outDir/patch.txt
}

# single byte patch
p() {
    echo "0x$1: 0x$2" >> $outDir/patch.txt
}

# project setup is here

s trophy_thread 9858bc
s wait 8d3e60
p 979398 488d3e63
# p 978754 488d3e63 CRASHES!!
p 8d3e5c 0

# make the zip file, this is probably not the best way to do it

cd out/
rm -f $name.zip
zip -r $name.zip $name/

echo "Done building."
