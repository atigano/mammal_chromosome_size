#!/bin/bash
#SBATCH -p shared,macmanes
#SBATCH --job-name="mummer"
#SBATCH --output=mummer2mus_%j.log
#SBATCH --mem=100GB #MB
#make alignment
#mummer2mus_chr.sh
module purge
module load anaconda/colsa
conda activate mummer4

REF=$1
QUERY=$2
cd ~/20pero/divergence_mus/mummer_chr_genomes
nucmer --maxgap 2000 -p mummer2${REF}_${QUERY}_chr -t 24 --mincluster 1000 ~/20pero/divergence_mus/mus_genomes_chr/Mus_${REF}_chr.fa ~/20pero/divergence_mus/mus_genomes_chr/Mus_${QUERY}_chr.fa
delta-filter -g -l 10000 mummer2${REF}_${QUERY}_chr.delta > mummer2${REF}_${QUERY}_chr.filter10k.delta
show-coords -B mummer2${REF}_${QUERY}_chr.filter10k.delta > mummer2${REF}_${QUERY}_chr.filter10k.tab_tmp
cut -f 1,6,7,8,9,10,12,13 mummer2${REF}_${QUERY}_chr.filter10k.tab_tmp | awk '$7 > 50' | awk '$9=$4-$3+1' | sed -e 's/ /\t/g' - | ( echo -e "CHR2\tCHR1\tS2\tE2\tS1\tE1\tIDY\tLEN2\tLEN1"; cat - ) > mummer2${REF}_${QUERY}_chr.filter10k.tab

