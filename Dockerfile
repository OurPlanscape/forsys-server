FROM r-base:4.4.2

RUN apt-get update && \
    apt-get -y install \
    g++ binutils cmake build-essential \
    git

RUN apt-get install -y \
    openssh-client \
    libssl-dev libabsl-dev libcurl4-openssl-dev

RUN apt-get install -y \
    libc6-dev libsqlite3-dev \
    libpng-dev libtiff-dev libjpeg-dev \
    libgdal-dev libproj-dev libgeos-dev gdal-bin

RUN apt-get install -y \
    libpq-dev libfreetype-dev libfontconfig1-dev libxml2-dev  \
    libgit2-dev libharfbuzz-dev libfribidi-dev libudunits2-dev 

RUN apt-get install -y \
    pkg-config \
    libsodium-dev libglpk-dev libuv1-dev \
    postgresql-client

RUN mkdir -p /app
WORKDIR /app

RUN R -e "install.packages(c('remotes', 'pacman', 'import'), repos='http://cran.rstudio.com/')"

RUN R -e "install.packages(c('dplyr', 'textshaping', 'stringi'), repos='http://cran.rstudio.com/')"
RUN R -e "install.packages(c('ggnewscale', 'udunits2', 'sf'), repos='http://cran.rstudio.com/')"
RUN R -e "install.packages(c('ragg', 'pkgdown', 'devtools'), repos='http://cran.rstudio.com/')"
RUN R -e "install.packages(c('DBI', 'RPostgreSQL', 'RPostgres'), repos='http://cran.rstudio.com/')"
RUN R -e "install.packages(c('optparse', 'rjson', 'glue'), repos='http://cran.rstudio.com/')"
RUN R -e "install.packages(c('purrr', 'logger', 'tidyr'), repos='http://cran.rstudio.com/')"
RUN R -e "install.packages(c('checkmate', 'uuid', 'doParallel'), repos='http://cran.rstudio.com/')"
RUN R -e "install.packages(c('httpuv', 'plumber'), repos='http://cran.rstudio.com/')"

# Required for patchmax pinned version
RUN R -e "library(remotes); remotes::install_bitbucket('richierocks/assertive.base')"
RUN R -e "library(remotes); remotes::install_bitbucket('richierocks/assertive.properties')"
RUN R -e "library(remotes); remotes::install_bitbucket('richierocks/assertive.types')"
RUN R -e "library(remotes); remotes::install_bitbucket('richierocks/assertive.numbers')"
RUN R -e "library(remotes); remotes::install_bitbucket('richierocks/assertive.strings')"
RUN R -e "library(remotes); remotes::install_bitbucket('richierocks/assertive.datetimes')"
RUN R -e "library(remotes); remotes::install_bitbucket('richierocks/assertive.files')"
RUN R -e "library(remotes); remotes::install_bitbucket('richierocks/assertive.sets')"
RUN R -e "library(remotes); remotes::install_bitbucket('richierocks/assertive.matrices')"
RUN R -e "library(remotes); remotes::install_bitbucket('richierocks/assertive.models')"
RUN R -e "library(remotes); remotes::install_bitbucket('richierocks/assertive.data')"
RUN R -e "library(remotes); remotes::install_bitbucket('richierocks/assertive.data.uk')"
RUN R -e "library(remotes); remotes::install_bitbucket('richierocks/assertive.data.us')"
RUN R -e "library(remotes); remotes::install_bitbucket('richierocks/assertive.reflection')"
RUN R -e "library(remotes); remotes::install_bitbucket('richierocks/assertive.code')"
RUN R -e "library(remotes); remotes::install_bitbucket('richierocks/assertive')"


RUN R -e "library(remotes); remotes::install_github('forsys-sp/patchmax@patchmax_0.2.0')"

# Install forsysr from specific commit to ensure compatibility with patchmax version
RUN R -e "library(remotes); remotes::install_github('forsys-sp/forsysr@7b9641a5fd0be1e660944ef54c2d062bb2cd228c')"
RUN R -e "library(remotes); remotes::install_github('milesmcbain/friendlyeval')"


COPY src/* /app/
COPY src/rscripts /app/rscripts/

EXPOSE 8000

CMD [ "Rscript", "--vanilla", "-e", "library(plumber); pr('server.R') %>% pr_run(host='0.0.0.0', port=8000)" ]
