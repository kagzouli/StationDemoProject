FROM ubuntu:20.04

# Install bash and curl
RUN apt-get update \
   && apt-get -y install bash \
   && apt-get -y install curl  

# Install Helm
RUN curl -fsSLo get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 && chmod 700 get_helm.sh && ./get_helm.sh

# Install docker
RUN 