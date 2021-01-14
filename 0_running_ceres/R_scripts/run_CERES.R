# RUN CERES TO GET GENE LEVEL SCORES

# Note: The wrap_ceres function takes at least 7 hours to run on modern hardware
# Genome version: hg19

# Script adapted from example at:  https://github.com/cancerdatasci/ceres

# Inputs:
#   - Filtered logfold changes file
#   - Bowtie indexes for hg19
#   - CCDS gene annotations for GRCh37.p13 = CCDS.20131129.txt

# Output: gene scores

BiocManager::install(version = "3.8")

BiocManager::install("Biostrings")
BiocManager::install("Rsamtools")
BiocManager::install("GenomeInfoDb")
BiocManager::install("BSgenome")
BiocManager::install("BSgenome.Hsapiens.UCSC.hg19")
BiocManager::install("GenomicRanges")

# Install CERES package
install.packages("devtools")
devtools::install_github("cancerdatasci/ceres")

Sys.setenv("PKG_CXXFLAGS"="-std=c++11")

library(ceres)
library(tidyverse)
library(magrittr)

# Set location of bowtie indices, CCDS gene annotations and DepMap inputs
third_party_dir <- "/Users/barbaradekegel/Google Drive/3rd_party_data"
local_dir <- "../../local_data/processed/depmap19Q1"

bowtie_indexes <- file.path(third_party_dir, "bowtie_indexes", "hg19")
Sys.setenv(BOWTIE_INDEXES = bowtie_indexes)

# 1. Segmented copy number data from DepMap
cn_seg_file <- file.path(third_party_dir, "depmap", "19Q1", "copy_number.tsv")

# 2. Gene annotations, aligments were mapped to gene coding sequences using CCDS
gene_annot_file <- file.path(third_party_dir, "ccds_gene_annotations", "CCDS.20131129.txt")

# 3. Replicate map: maps replicates to cell lines
# param replicate_map data.frame with column names `Replicate` and `CellLine`
rep_map_file <- file.path(third_party_dir, "depmap", "19Q1", "replicate_map.tsv")

# 4. Guide-level dependency data
raw_dep_file_p1 <- file.path(local_dir, "filtered_lfc_11_07_19.csv")

# Generate the guide dep .rds file directly from the .csv - bypass the .gct file
# Note: If check.names = TRUE, an 'X' is prepended to all column names starting with a number
guide_dep_tibble <- read_csv(raw_dep_file)
# Check tibble
dim(guide_dep_tibble)

# Convert to matrix
guide_dep <- guide_dep_tibble %>%
  as.data.frame() %>%
  set_rownames(.[["Construct Barcode"]]) %>%
  select(-c(`Construct Barcode`)) %>%
  as.matrix %>%
  set_rownames(str_extract(rownames(.), "^[ACGT]+")) %>%
  {.[unique(rownames(.)),]} %>%
  remove.rows.all.nas()
guide_dep[1:4,1:4]
dim(guide_dep)

# Create directory for prepared CERES inputs
inputs_dir <- file.path("ceres_inputs", "depmap", "19Q1", "2019-07-11")
dir.create(inputs_dir, recursive=T, showWarnings=F)

dep_rds_output_path <- file.path(inputs_dir, "guide_dep.Rds")
saveRDS(guide_dep, dep_rds_output_path)


# Generate the CERES inputs and put them in the specified inputs dir
# Do not include X and Y genes
prepare_ceres_inputs(inputs_dir=inputs_dir,
                     dep_file=NULL,
                     pre_generated_guides_file=dep_rds_output_path,
                     cn_seg_file=cn_seg_file,
                     gene_annot_file=gene_annot_file,
                     rep_map_file=rep_map_file,
                     genome_id="hg19",
                     chromosomes=paste0("chr", c(as.character(1:22))),
                     dep_normalize="zmad")

# Lambda_g=0.4 is used by DepMap, mentioned in: Extracting Biological Insights from the Project Achilles 
ceres <- wrap_ceres(sg_path=file.path(inputs_dir, "guide_sample_dep.Rds"),
                       cn_path=file.path(inputs_dir, "locus_sample_cn.Rds"),
                       guide_locus_path=file.path(inputs_dir, "guide_locus.Rds"),
                       locus_gene_path=file.path(inputs_dir, "locus_gene.Rds"),
                       replicate_map_path=file.path(inputs_dir, "replicate_map.Rds"),
                       run_id="19Q1",
                       params=list(lambda_g=0.4))


ceres_unscaled <- data.frame(ceres_output$gene_essentiality_results$ge_fit)
head(ceres_unscaled)
dim(ceres_unscaled)
write.csv(ceres_unscaled, file.path(data_dir, "ceres_output_11_07_19.csv"))
