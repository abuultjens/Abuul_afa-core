#!/bin/bash

# USAGE:
# $ sh sh.sh [CPUs] [snippy.full.clean.aln] [PREFIX]

N_SPLIT=$1
MFA=$2
PREFIX=$3

echo "Using ${N_SPLIT} CPUs"

# generate random prefix for all tmp files
RAND_1=`echo $((1 + RANDOM % 100))`
RAND_2=`echo $((100 + RANDOM % 200))`
RAND_3=`echo $((200 + RANDOM % 300))`
RAND=`echo "${RAND_1}${RAND_2}${RAND_3}"`

# index
samtools faidx ${MFA}

# make fofn from full.mfa
grep ">" ${MFA} | tr -d '>' > ${RAND}_fofn.txt

# get number of taxa in fofn
N_TAXA=`wc -l ${RAND}_fofn.txt | awk '{print $1}'`
echo "Reading ${N_TAXA} isolates"

# split fofn
split -d -l ${N_SPLIT} ${RAND}_fofn.txt FOFN_${RAND}_

# make fofn fofn
ls FOFN_${RAND}_* > ${RAND}_FOFN.txt

for GROUP in $(cat ${RAND}_FOFN.txt); do

	echo "Processing group ${GROUP}"

	FILE=`echo ${GROUP}`

	for TAXA in $(cat ${FILE}); do
		# extract single fasta entries to file without header
		samtools faidx ${MFA} ${TAXA} | grep -v ">" | tr -d '\n' > ${RAND}_${TAXA}.seq &
	done

	wait
	
	for TAXA in $(cat ${FILE}); do
			# add line ending	
		echo "" >> ${RAND}_${TAXA}.seq
			# put comma between char, rm comma from end of line, transpose
		sed 's/./&,/g' < ${RAND}_${TAXA}.seq | sed 's/.$//' | tr ',' '\t' | datamash transpose -H > ${RAND}_${TAXA}.2.tr.tsv &
	done

	wait

done

# paste
echo "Joining ${N_SPLIT} columns"
paste ${RAND}*.2.tr.tsv > ${RAND}_ALL.tr.tsv

# get wc
WC=`wc -l ${RAND}_ALL.tr.tsv | awk '{print $1}'`
echo "Reference sequence is ${WC} bp long"

# make index
seq 1 ${WC} > ${RAND}_seq_1-${WC}.txt

# join index column
paste ${RAND}_seq_1-${WC}.txt ${RAND}_ALL.tr.tsv > ${RAND}_ALL.seq.tr.tsv

# write outfiles
cat ${RAND}_ALL.seq.tr.tsv | grep -v "N" | cut -f 1 > ${PREFIX}_core_pos.txt		
cat ${RAND}_ALL.seq.tr.tsv | grep "N" | cut -f 1 > ${PREFIX}_non-core_pos.txt

N_CORE=`wc -l ${PREFIX}_core_pos.txt | awk '{print $1}'`
echo "${N_CORE} positions are core"

echo "Writing outfiles with prefix ${PREFIX}"

# make header for tsv
echo "INDEX" > ${RAND}_head.txt
cat ${RAND}_fofn.txt >> ${RAND}_head.txt
datamash transpose -H < ${RAND}_head.txt > ${RAND}_head.tr.txt

# make core tsv
cat ${RAND}_ALL.seq.tr.tsv | grep -v "N" > ${RAND}_${PREFIX}_core_ALL.txt
cat ${RAND}_head.tr.txt ${RAND}_${PREFIX}_core_ALL.txt > ${PREFIX}_core.tsv

# make non-core tsv
cat ${RAND}_ALL.seq.tr.tsv | grep "N" > ${RAND}_${PREFIX}_non-core_ALL.txt
cat ${RAND}_head.tr.txt ${RAND}_${PREFIX}_non-core_ALL.txt > ${PREFIX}_non-core.tsv

#mv ${RAND}_ALL.seq.tr.tsv ${PREFIX}_DB.tsv

# rm tmp files
rm *${RAND}*
