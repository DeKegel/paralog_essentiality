## Paralog Essentiality

Source code for [Paralog buffering contributes to the variable essentiality of genes in cancer cell lines](https://journals.plos.org/plosgenetics/article?id=10.1371/journal.pgen.1008466)

Cite as: De Kegel & Ryan (2019) *Paralog buffering contributes to the variable essentiality of genes in cancer cell lines*. PLoS Genet

### Data analysis notebooks overview:
All of the main and most of the supplementary figures for the manuscript are generated in these notebooks.

| Notebook                           | Figures                     | Brief description                                        |
|:-----------------------------------|:----------------------------|:---------------------------------------------------------|
| 01_paralog_multitarget.ipynb       | Fig. S1A, S1B               | Investigate paralogs affected by multi-targeting sgRNAs  |
| 02_paralogs_vs_essentiality.ipynb  | Fig. 2, 3 | Compare essentiality of paralogs and singletons          |
| 03_WGD_vs_SSD.ipynb                | Fig. 4                 | Compare essentiality of WGD vs. SSD paralogs             |
| 04_regression_model.ipynb          |                             | Compare regression models for essentiality with different paralog features |
| 05_A1_essentiality_vs_A2_expression.ipynb  | Fig. 5, S2B  | Identify putative SL pairs using essentiality (CERES scores) and gene expression |
| 06_A2_loss_reasons.ipynb           |                             | Identify potential explanations (copy number, mutation) for gene loss |
| 07_putative_SL_features.ipynb      | Fig. 6, S2A, S2C, S2D     | Identify features of putative SL paralog pairs           |

NOTE: Figures S3 and S4 consist of Figs 2, 3B, 3C and 4B re-drawn using different fitness score thresholds


### Data processing notebooks overview:
These notebooks process raw/third party data for use in the analysis.

| Notebook                             | Figures    | Brief description                                        |
|:-------------------------------------|:-----------|:---------------------------------------------------------|
| 01_process_protein_complexes.ipynb   |            | Create map of Entrez ID to CORUM protein complex ID (protein complex membership) |
| 02_process_ensembl_paralogs          |            | Generate list of protein-coding paralog pairs with min. 20% sequence identity + some feat. annotations |
| 03_generate_gene_summary.ipynb       | Fig. S1C   | For each gene, summarize essentiality and paralog features |
| 04_process_depmap_expr.ipynb         |            | Filter CCLE gene expression for use in data analysis nb 5  |


### Running CERES overview:
These notebooks + R scripts are used to re-process logfold change data from DepMap CRISPR screens with [CERES](https://github.com/cancerdatasci/ceres), to remove multi-targetting sgRNAs. The output from running all scripts in this folder is `local_data\processed\depmap19Q1\gene_scores_11_07_19.csv`. The notebooks can run in the conda environment, but the R scripts should be run independently (e.g. in R studio). Code to install the necessary Bioconductor packages + CERES is included in the R scripts. The R scripts also require the [bowtie](http://bowtie-bio.sourceforge.net/index.shtml) and [samtools](http://samtools.sourceforge.net/) command line tools which are only available for Linux/macOS.

| Order | Notebook or R scripts                  | Brief description                                        |
|:------|:---------------------------------------|:---------------------------------------------------------|
|1      | 01_preprocess_depmap_data              | Extract sgRNAs to align and format files for CERES       |
|2      | R_scripts/align_guides.R               | Align all sgRNAs to the reference genome (hg19), allowing up to two mismatches |
|3      | 02_filter_multi_target_guides          | Filter out sgRNAs that align to readthrough genes and/or to multiple genes (incl. w/ mismatch) |
|4      | R_scripts/run_CERES.R                  | Run CERES with the filtered logfold changes data |
|5      | 03_ceres_post_processing               | Process CERES output to drop genes targeted by too few guides + normalize scores to reference (non-)essential genes |
|6      | 04_essential_cutoff.ipynb              | Calculate a cutoff fitness score for cell line specific essentiality |


### To run Jupyter notebooks:
* Obtain 3rd party data - sources are listed in data_sources
   * The folder for running CERES has its own data_sources file with the third party files that are only needed there
   * Note: this is primarily needed for running notebooks in the 0_running_ceres and 1_data_processing folders
* Set path to 3rd party data directory in environment.yml (3rd_party_dir)
  * Note: this can also be set in the activate environment with: `conda env config vars set 3rd_party_data=my_dir`
* Create [conda](https://docs.conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html) environment from the environment.yml file: `conda env create -f environment.yml`
* Activate conda environment: `conda activate paralogSL`
* Start notebooks: `jupyter notebook`




