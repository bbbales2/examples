data {
  int<lower=1> N;
  int<lower=1> T;
  int<lower=1> trials[N];
  real strains[N];
}

parameters{
  real mu[T];
  real<lower=0.0> sig[T];
  real<lower=0.0> tau;
}

model {
  sig ~ normal(0.0, tau);
  
  for (n in 1:N)
    strains[n] ~ normal(mu[trials[n]], sig[trials[n]]);
}
