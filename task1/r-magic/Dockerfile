# choose existing image or build your own
# it will take a while to build rocker/tidyverse
FROM rocker/tidyverse:4.2.0

# install python and install pigz for faster tar
RUN apt-get update && apt-get install -y --no-install-recommends python3 python3-dev python3-pip
RUN cp /usr/bin/python3 /usr/bin/python

# install MAGIC python repository
RUN pip install --upgrade pip
RUN pip install --user magic-impute

# install Rmagic package
# note: the latest Rmagic is removed from CRAN 10/7/2022, install older version
RUN R -e "devtools::install_version('Rmagic', version = '2.0.3', repos = 'http://cran.us.r-project.org/')"

# copy model script to container
COPY imputation_model.R /imputation_model.R
COPY run_model.R /run_model.R

# execute the model with '/input' as input dir and 'output' as output dir
ENTRYPOINT ["Rscript", "/run_model.R", "/input", "/output"]
