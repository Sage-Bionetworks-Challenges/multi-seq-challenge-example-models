FROM rocker/tidyverse:latest

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    python3.9 python3.9-dev \
    bedtools bedops tabix

# install r packages
RUN R -e "install.packages('bedr', repos = 'http://cran.us.r-project.org')"

CMD ["/bin/bash"]