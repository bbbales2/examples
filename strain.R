library(ggplot2)
library(rstanarm)
library(tidyverse)
library(tibble)
library(tidyr)
library(rstan)
library(GGally)

trial = 1:7
reuses = c(1, 2, 3, 0, 1, 2, 3)
means = c(20.0, 19.0, 18.5, 20.5, 19.7, 18.9, 18.2)
stds = rep(1.0, length(means))
ns = c(10, 17, 12, 22, 5, 18, 7)

strain_data = data_frame(
  trial = as.integer(unlist(mapply(rep, trial, ns))),
  reuses = as.integer(unlist(mapply(rep, reuses, ns))),
  strain = unlist(mapply(rnorm, ns, means, stds))
)

strain_data %>%
  ggplot(aes(trial, strain)) + 
  geom_boxplot(aes(group = trial)) +
  geom_point(aes(colour = factor(reuses)))

res = stan_glm(strain ~ reuses, data = strain_data, 
               family = gaussian(link = "identity"))

dat = list(N = dim(strain_data)[1],
            K = 4,
            reuses = strain_data$reuses,
            strains = strain_data$strain)

fit1 = stan('/home/bbales2/examples/strain.stan', data=dat, iter=2000, chains=4, warmup=1000, init_r=5)
fit2 = stan('/home/bbales2/examples/mu_strain.stan', data=dat, iter=2000, chains=4, warmup=1000, init_r=5)

lit1 = tbl_df(as.matrix(fit1))
lit2 = tbl_df(as.matrix(fit2))

acomp = data_frame(which = rep(c("first", "second"), each = 4000), a = c(lit1$a, lit2$a))

acomp %>%
  ggplot(aes(a)) +
  geom_density(aes(color = which)) +
  xlim(-5, 5)

lit1 %>%
  ggplot(aes(first)) +
  geom_histogram()

p = strain_data %>%
    ggplot(aes(trial, strain)) + 
    geom_boxplot(aes(group = trial)) +
    geom_point(aes(colour = factor(reuses)))
