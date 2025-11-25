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

RUN R -e "options(warn = 2); install.packages('remotes', repos='https://cloud.r-project.org/')"
RUN R -e "options(warn = 2); install.packages('pacman', repos='https://cloud.r-project.org/')"
RUN R -e "options(warn = 2); install.packages('import', repos='https://cloud.r-project.org/')"
RUN R -e "options(warn = 2); install.packages('dplyr', repos='https://cloud.r-project.org/')"
RUN R -e "options(warn = 2); install.packages('textshaping', repos='https://cloud.r-project.org/')"
RUN R -e "options(warn = 2); install.packages('stringi', repos='https://cloud.r-project.org/')"
RUN R -e "options(warn = 2); install.packages('ggnewscale', repos='https://cloud.r-project.org/')"
RUN R -e "options(warn = 2); install.packages('sf', repos='https://cloud.r-project.org/')"
RUN R -e "options(warn = 2); install.packages('ragg', repos='https://cloud.r-project.org/')"
RUN R -e "options(warn = 2); install.packages('pkgdown', repos='https://cloud.r-project.org/')"
RUN R -e "options(warn = 2); install.packages('devtools', repos='https://cloud.r-project.org/')"
RUN R -e "options(warn = 2); install.packages('DBI', repos='https://cloud.r-project.org/')"
RUN R -e "options(warn = 2); install.packages('RPostgreSQL', repos='https://cloud.r-project.org/')"
RUN R -e "options(warn = 2); install.packages('RPostgres', repos='https://cloud.r-project.org/')"
RUN R -e "options(warn = 2); install.packages('optparse', repos='https://cloud.r-project.org/')"
RUN R -e "options(warn = 2); install.packages('rjson', repos='https://cloud.r-project.org/')"
RUN R -e "options(warn = 2); install.packages('glue', repos='https://cloud.r-project.org/')"
RUN R -e "options(warn = 2); install.packages('purrr', repos='https://cloud.r-project.org/')"
RUN R -e "options(warn = 2); install.packages('logger', repos='https://cloud.r-project.org/')"
RUN R -e "options(warn = 2); install.packages('tidyr', repos='https://cloud.r-project.org/')"
RUN R -e "options(warn = 2); install.packages('checkmate', repos='https://cloud.r-project.org/')"
RUN R -e "options(warn = 2); install.packages('uuid', repos='https://cloud.r-project.org/')"
RUN R -e "options(warn = 2); install.packages('doParallel', repos='https://cloud.r-project.org/')"
RUN R -e "options(warn = 2); install.packages('httpuv', repos='https://cloud.r-project.org/')"
RUN R -e "options(warn = 2); install.packages('plumber', repos='https://cloud.r-project.org/')"


# Install pinned versions of forsys packages
RUN R -e "options(warn = 2); library(remotes); remotes::install_github('forsys-sp/patchmax@ab174cc6dc7f1fe7277c360eba1e6abcaf610429')"
RUN R -e "options(warn = 2); library(remotes); remotes::install_github('forsys-sp/forsysr@179045ffc861ad5f6c313c726d70885e9071df20')"
RUN R -e "options(warn = 2); library(remotes); remotes::install_github('milesmcbain/friendlyeval')"


COPY src/* /app/
COPY src/rscripts /app/rscripts/

EXPOSE 8000

CMD [ "Rscript", "--vanilla", "-e", "library(plumber); pr('server.R') %>% pr_run(host='0.0.0.0', port=8000)" ]
