#path to where the SRA bin folder is located; could eliminate by making SRAT globally executable 
PATH_SRA_DIR="your_path_here/"

#go to where your kallisto test directory is found, if necessary
cd "your_path_here"

#load the config file
source test_kallisto/config_SRP006900.file

#download the data 
for i in "${arr[@]}"
do
   "$PATH_SRA_DIR"sratoolkit.2.5.0-mac64/bin/fastq-dump --accession $i --outdir test_kallisto
done

#create the intranscripts index file 
kallisto index -i transcripts.idx transcripts.fasta.gz

#create output directories, and then run kallisto for each of the runs
for i in "${arr[@]}"
do
	mkdir output_"$i"
	kallisto quant -i transcripts.idx -o output_"$i" -l "$AVG_READ_LENGTH" "$i"".fastq"
done

