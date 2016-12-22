#requires vcftools, rtg-tools
#input files: pass_filtered_CHH11676_CHH11677_CHH11678.vcf
#LCR-hs37d5.bed
#may need to use sed -i 's/chr//g' filename to remove chr from vcf or bed files
#hg19.sdf http://www.realtimegenomics.com/news/pre-formatted-reference-datasets/

export PATH=$PATH:/usr/bin/rtg-tools-3.7.1-eb13bbb


#Separate each individual to its own VCF file
vcftools --vcf pass_filtered_CHH11676_CHH11677_CHH11678.vcf --out CHH1676_indel --keep-only-indels --recode --indv CHH11676
vcftools --vcf pass_filtered_CHH11676_CHH11677_CHH11678.vcf --out CHH1677_indel --keep-only-indels --recode --indv CHH11677
vcftools --vcf pass_filtered_CHH11676_CHH11677_CHH11678.vcf --out CHH1678_indel --keep-only-indels --recode --indv CHH11678

vcftools --vcf pass_filtered_CHH11676_CHH11677_CHH11678.vcf --out trio_SNP --recode 
vcftools --vcf pass_filtered_CHH11676_CHH11677_CHH11678.vcf --out trio_SNP_LCR --recode --exclude-bed LCR-hs37d5.bed
vcftools --vcf pass_filtered_CHH11676_CHH11677_CHH11678.vcf --out tri_SNP_J5 --recode --exclude-bed Duke800_PatternsRepeat5
vcftools --vcf pass_filtered_CHH11676_CHH11677_CHH11678.vcf --out tri_SNP_J10 --recode --exclude-bed Duke800_PatternsRepeat10
vcftools --vcf pass_filtered_CHH11676_CHH11677_CHH11678.vcf --out tri_SNP_rmsk.bed --recode --exclude-bed rmsk.bed
#Filter trio to exclude LCR
vcftools --vcf CHH1676_indel.recode.vcf --out CHH1676_indel_LCR --keep-only-indels --recode --exclude-bed LCR-hs37d5.bed
vcftools --vcf CHH1677_indel.recode.vcf --out CHH1677_indel_LCR --keep-only-indels --recode --exclude-bed LCR-hs37d5.bed
vcftools --vcf CHH1678_indel.recode.vcf --out CHH1678_indel_LCR --keep-only-indels --recode --exclude-bed LCR-hs37d5.bed

vcftools --vcf CHH1676_indel.recode.vcf --out CHH1676_indel_J10 --keep-only-indels --recode --exclude-bed Duke800_PatternsRepeat10
vcftools --vcf CHH1677_indel.recode.vcf --out CHH1677_indel_J10 --keep-only-indels --recode --exclude-bed Duke800_PatternsRepeat10
vcftools --vcf CHH1678_indel.recode.vcf --out CHH1678_indel_J10 --keep-only-indels --recode --exclude-bed Duke800_PatternsRepeat10

vcftools --vcf CHH1676_indel.recode.vcf --out CHH1676_indel_J5 --keep-only-indels --recode --exclude-bed Duke800_PatternsRepeat5
vcftools --vcf CHH1677_indel.recode.vcf --out CHH1677_indel_J5 --keep-only-indels --recode --exclude-bed Duke800_PatternsRepeat5
vcftools --vcf CHH1678_indel.recode.vcf --out CHH1678_indel_J5 --keep-only-indels --recode --exclude-bed Duke800_PatternsRepeat5

vcftools --vcf CHH1676_indel.recode.vcf --out CHH1676_indel_rmsk --keep-only-indels --recode --exclude-bed rmsk.bed
vcftools --vcf CHH1677_indel.recode.vcf --out CHH1677_indel_rmsk --keep-only-indels --recode --exclude-bed rmsk.bed
vcftools --vcf CHH1678_indel.recode.vcf --out CHH1678_indel_rmsk --keep-only-indels --recode --exclude-bed rmsk.bed

#bgzip all files
bgzip -c CHH1676_indel.recode.vcf > CHH1676_indel.recode.vcf.gz
tabix -p vcf CHH1676_indel.recode.vcf.gz 
bgzip -c CHH1676_indel_LCR.recode.vcf > CHH1676_indel_LCR.recode.vcf.gz
tabix -p vcf CHH1676_indel_LCR.recode.vcf.gz
bgzip -c CHH1677_indel.recode.vcf > CHH1677_indel.recode.vcf.gz
tabix -p vcf CHH1677_indel.recode.vcf.gz 
bgzip -c CHH1677_indel_LCR.recode.vcf > CHH1677_indel_LCR.recode.vcf.gz
tabix -p vcf CHH1677_indel_LCR.recode.vcf.gz
bgzip -c CHH1678_indel.recode.vcf > CHH1678_indel.recode.vcf.gz
tabix -p vcf CHH1678_indel.recode.vcf.gz 
bgzip -c CHH1678_indel_LCR.recode.vcf > CHH1678_indel_LCR.recode.vcf.gz
tabix -p vcf CHH1678_indel_LCR.recode.vcf.gz

bgzip -c CHH1676_indel_J10.recode.vcf > CHH1676_indel_J10.recode.vcf.gz
tabix -p vcf CHH1676_indel_J10.recode.vcf.gz
bgzip -c CHH1677_indel_J10.recode.vcf > CHH1677_indel_J10.recode.vcf.gz
tabix -p vcf CHH1677_indel_J10.recode.vcf.gz
bgzip -c CHH1678_indel_J10.recode.vcf > CHH1678_indel_J10.recode.vcf.gz
tabix -p vcf CHH1678_indel_J10.recode.vcf.gz




awk '{if($0 !~ /^#/) print "chr"$0; else print $0}' CHH1676_indel.recode.vcf > CHH1676_indel.chr.vcf

bgzip -c CHH1676_indel.chr.vcf > CHH1676_indel.chr.vcf.gz
tabix -p vcf CHH1676_indel.chr.vcf.gz

awk '{if($0 !~ /^#/) print "chr"$0; else print $0}' CHH1676_indel_LCR.recode.vcf > CHH1676_indel_LCR.chr.vcf

bgzip -c CHH1676_indel_LCR.chr.vcf > CHH1676_indel_LCR.chr.vcf.gz
tabix -p vcf CHH1676_indel_LCR.chr.vcf.gz

rtg vcfeval -b CHH1676_indel.chr.vcf.gz -c CHH1676_indel_LCR.chr.vcf.gz -o CHH1676_indel_LCR_validation -t hg19.sdf


awk '{if($0 !~ /^#/) print "chr"$0; else print $0}' CHH1677_indel.recode.vcf > CHH1677_indel.chr.vcf
bgzip -c CHH1677_indel.chr.vcf > CHH1677_indel.chr.vcf.gz
tabix -p vcf CHH1677_indel.chr.vcf.gz

awk '{if($0 !~ /^#/) print "chr"$0; else print $0}' CHH1677_indel_LCR.recode.vcf > CHH1677_indel_LCR.chr.vcf
bgzip -c CHH1677_indel_LCR.chr.vcf > CHH1677_indel_LCR.chr.vcf.gz
tabix -p vcf CHH1677_indel_LCR.chr.vcf.gz

rtg vcfeval -b CHH1677_indel.chr.vcf.gz -c CHH1677_indel_LCR.chr.vcf.gz -o CHH1677_indel_LCR_validation -t hg19.sdf



awk '{if($0 !~ /^#/) print "chr"$0; else print $0}' CHH1678_indel.recode.vcf > CHH1678_indel.chr.vcf
bgzip -c CHH1678_indel.chr.vcf > CHH1678_indel.chr.vcf.gz
tabix -p vcf CHH1678_indel.chr.vcf.gz

awk '{if($0 !~ /^#/) print "chr"$0; else print $0}' CHH1678_indel_LCR.recode.vcf > CHH1678_indel_LCR.chr.vcf
bgzip -c CHH1678_indel_LCR.chr.vcf > CHH1678_indel_LCR.chr.vcf.gz
tabix -p vcf CHH1678_indel_LCR.chr.vcf.gz

rtg vcfeval -b CHH1678_indel.chr.vcf.gz -c CHH1678_indel_LCR.chr.vcf.gz -o CHH1678_indel_LCR_validation -t hg19.sdf

#compare with dbsnp

bcftools stats CHH1676_indel.recode.vcf.gz dbsnp_135.b37.vcf.gz
bcftools stats CHH1676_indel_LCR.recode.vcf.gz dbsnp_135.b37.vcf.gz
bcftools stats CHH1676_indel_J10.recode.vcf.gz dbsnp_135.b37.vcf.gz
bcftools stats CHH1677_indel.recode.vcf.gz dbsnp_135.b37.vcf.gz
bcftools stats CHH1677_indel_LCR.recode.vcf.gz dbsnp_135.b37.vcf.gz
bcftools stats CHH1678_indel.recode.vcf.gz dbsnp_135.b37.vcf.gz
bcftools stats CHH1678_indel_LCR.recode.vcf.gz dbsnp_135.b37.vcf.gz

#compare with exac
bcftools stats CHH1676_indel.recode.vcf.gz ExAC.r0.3.1.sites.vep.vcf.gz
bcftools stats CHH1676_indel_LCR.recode.vcf.gz ExAC.r0.3.1.sites.vep.vcf.gz
bcftools stats CHH1676_indel_J10.recode.vcf.gz ExAC.r0.3.1.sites.vep.vcf.gz

#Calculate allele frequency
#files to process: LCR variants intersection dbSNP(2590) vs LCR variants not intersecting dbSNP(1202)
bcftools isec -p LCRdbSNPcomplement -C CHH1676_indel_LCR.recode.vcf.gz dbsnp_135.b37.vcf.gz
bcftools isec -p LCRdbSNPisec CHH1676_indel_LCR.recode.vcf.gz dbsnp_135.b37.vcf.gz
fill-an-ac LCRdbSNPcomplement.vcf

bcftools isec -p LCRdbSNPisec CHH1676_indel_LCR.recode.vcf.gz dbsnp_135.b37.vcf.gz

