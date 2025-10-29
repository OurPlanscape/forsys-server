#!/bin/bash

cd "$(dirname "$0")"/src/forsys || exit 1

Rscript --vanilla -e "library(plumber); pr('server.R') %>% pr_run(port=$1)"

exit 0
