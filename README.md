# Abuul_afa-core
Produces a list of positions that are core and non-core from a snippy full genome alignment

### get the code
    $ git clone https:

### run the script
    $ sh Abuul_afa-core/Abuul_afa-core.sh [CPUs] [snippy.full.clean.aln] [PREFIX]

##### arguments: 
``CPUs`` number of parallel processes to run
``snippy.full.clean.aln`` snippy whole genome multi fasta alignment with sequence blocks consiting of only: A, G, C, T and N. This can be done with snippy-clean_full_aln (https://github.com/tseemann/snippy).
``PREFIX`` prefix for outfiles

# Example

### run snippy
    $ snippy --outdir isolate_1 --ref ref.gbk --R1 isolate_1_R1.fq.gz --R2 isolate_1_R2.fq.gz  
    $ snippy --outdir isolate_2 --ref ref.gbk --R1 isolate_2_R1.fq.gz --R2 isolate_2_R2.fq.gz  
    $ snippy --outdir isolate_3 --ref ref.gbk --R1 isolate_3_R1.fq.gz --R2 isolate_3_R2.fq.gz
    
### run snippy-core
    $ snippy-core --prefix test --ref ref.gbk isolate_1 isolate_2 isolate_3  
    
### run snippy-clean_full_aln
    $ snippy-clean_full_aln test.full.aln > test.full.clean.aln  
    
### run Abuul_afa-core.sh
    $ sh Abuul_afa-core/Abuul_afa-core.sh 10 test.full.clean.aln test  
