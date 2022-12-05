# choose existing image or build your own
FROM r-base:4.2.0

# install required R libraries
RUN R -e "install.packages(c('data.table', 'tibble', 'Rmagic'), repos = 'http://cran.us.r-project.org')"

# install python and install pigz for faster tar
RUN apt-get update && apt-get install -y --no-install-recommends python3 python3-dev python3-pip
RUN cp /usr/bin/python3 /usr/bin/python

# install MAGIC python repository
RUN pip install --upgrade pip
RUN pip install --user magic-impute

# copy model script to container
COPY imputation_model.R /imputation_model.R
COPY run_model.R /run_model.R

# execute the model with '/input' as input dir and 'output' as output dir
ENTRYPOINT ["Rscript", "/run_model.R", "/input", "/output"]
