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
show-coords -c mummer2${REF}_${QUERY}_chr.filter10k.delta > mummer2${REF}_${QUERY}_chr.filter10k.coords
~/scripts/coords2csv.sh mummer2${REF}_${QUERY}_chr.filter10k.coords
