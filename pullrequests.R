
library(git2r)
library(tidyverse)
library(lubridate)


clone("https://github.com/colaboradados/colaboradados.github.io","colaboradados")

repository <- repository("colaboradados")

result <- shell("git -C colaboradados log --merges", intern = TRUE ) %>% 
    enframe(value = "info") %>% 
    select(-name) %>% 
    filter(str_detect(info,"Author:|Date:")) %>% 
    separate(col = "info", into = c("atributo","valor"), sep = " ", extra = "merge") %>% 
    mutate(linha = cumsum(str_detect(atributo,"Author"))) %>% 
    pivot_wider(names_from = atributo, values_from = valor) %>% 
    rename(autor = 2, data = 3) %>% 
    mutate(data = str_sub(data, 7) %>% lubridate::parse_date_time("0m d H M S Y z")  ) 


