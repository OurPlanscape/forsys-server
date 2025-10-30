FROM rstudio/r-base:4.5-noble

RUN apt-get update && \
    apt-get -y install \
    g++ binutils \
    openssh-client \
    libc6-dev libsqlite3-dev \
    libpng-dev libtiff-dev libjpeg-dev \
    libgdal-dev libproj-dev libgeos-dev gdal-bin \
    libpq-dev libfreetype-dev libfontconfig1-dev libxml2-dev  \
    libgit2-dev libharfbuzz-dev libfribidi-dev libudunits2-dev \
    libcurl4-openssl-dev libssl-dev \
    libsodium-dev libglpk-dev \
    postgresql-client

RUN mkdir -p /app
WORKDIR /app

COPY install.R /app/
RUN Rscript install.R

COPY .env /app/
COPY src/* /app

EXPOSE 8000

CMD [ "Rscript", "--vanilla", "-e", "library(plumber); pr('server.R') %>% pr_run(host='0.0.0.0', port=8000)" ]