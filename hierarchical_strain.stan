data {
  int<lower=1> N;
  int<lower=1> K;
  int<lower=0> reuses[N];
  real strains[N];
}

parameters{
  real mu[K];
  real<lower=0.0> sig[K];
  real<lower=0.0> tau;
}

model {
  sig ~ normal(0.0, tau);
  
  for (n in 1:N)
    strains[n] ~ normal(mu[reuses[n] + 1], sig[reuses[n] + 1]);
}