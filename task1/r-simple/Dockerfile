# choose existing image or build your own
FROM r-base:4.0.3

# install required libraries
RUN R -e "install.packages(c('data.table', 'tibble', 'parallelly'), repos = 'http://cran.us.r-project.org')"
# copy model script to container
COPY imputation_model.R /imputation_model.R
COPY run_model.R /run_model.R
# execute the model with '/data' as input dir and 'output' as output dir
ENTRYPOINT ["Rscript", "/run_model.R", "/input", "/output"]
