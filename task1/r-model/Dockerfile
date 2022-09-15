# choose existing image or build your own
FROM r-base:4.0.3

# install required libraries
RUN R -e "install.packages('data.table', 'tibble'), repos = 'http://cran.us.r-project.org')"
# install pigz for faster tar
RUN apt-get update && apt-get install -y pigz
# copy model script to container
COPY r_example_model.R /r_example_model.R
# execute the model with '/data' as input dir and 'output' as output dir
CMD ["Rscript", "/r_example_model.R", "/data", "/output"]
