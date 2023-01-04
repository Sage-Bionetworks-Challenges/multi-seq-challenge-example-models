# choose existing image or build your own
# it will take a while to build rocker/tidyverse
FROM r-base:4.0.3

# install python and install pigz for faster tar
RUN apt-get update && apt-get install -y --no-install-recommends git python3 python3-dev python3-pip
RUN cp /usr/bin/python3 /usr/bin/python

# install python dependencies
RUN pip install --user magic-impute

# install R dependencies
RUN R -e "install.packages(c('ggplot2', 'reticulate', 'data.table', 'tibble'), repos = 'http://cran.us.r-project.org')"

# note: the Rmagic has been removed from CRAN, so install Rmagic from GitHub 
RUN git clone https://github.com/KrishnaswamyLab/MAGIC.git
RUN cd MAGIC/Rmagic && R CMD INSTALL .

# copy model script to container
COPY imputation_model.R /imputation_model.R
COPY run_model.R /run_model.R

# execute the model with '/input' as input dir and 'output' as output dir
ENTRYPOINT ["Rscript", "/run_model.R", "/input", "/output"]
