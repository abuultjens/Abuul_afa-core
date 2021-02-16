# Abuul_afa-core
Rapidly produces a list of core and non-core positions from a snippy full genome alignment. This tool is exclusively written in BASH and will run on virtually any system without the need for dependencies. 

### get the code
    $ git clone https://github.com/abuultjens/Abuul_afa-core.git

### run the script  
    $ sh Abuul_afa-core/Abuul_afa-core.sh [CPUs] [snippy.full.clean.aln] [PREFIX]  

##### arguments: 
``CPUs`` number of parallel processes to run  
``snippy.full.clean.aln`` snippy whole genome multi fasta alignment with sequence blocks consiting of only: A, G, C, T and N. This can be done with snippy-clean_full_aln (https://github.com/tseemann/snippy)  
``PREFIX`` prefix for outfiles  

# Outfiles

``[PREFIX]_core_pos.txt`` list of core positions  
``[PREFIX]_non-core_pos.txt`` list of non-core positions  
``[PREFIX]_core.tsv`` tab seperated file of core positions and isolate base calls  
``[PREFIX]_non-core.tsv`` tab seperated file of non-core positions and isolate base calls  

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
    
### check outfiles
    $ head test_core_pos.txt
    268
    269
    270
    271
    272
    273
    274
    275
    276
    277
    
    $ head test_non-core_pos.txt 
    1
    2
    3
    4
    5
    6
    7
    8
    9
    10
    
    $ head test_core.tsv
    INDEX   isolate_1 isolate_2 isolate_3
    268     A       A       A
    269     T       T       T
    270     A       A       A
    271     G       G       G
    272     A       A       A
    273     A       A       A
    274     G       G       G
    275     A       A       A
    276     A       A       A
    
    $ head test_non-core.tsv
    INDEX   isolate_1 isolate_2 isolate_3
    1       A       N       A
    2       T       N       T
    3       G       G       G
    4       G       G       G
    5       T       T       T
    6       A       A       A
    7       T       T       T
    8       C       C       C
    9       C       C       C


    

    
