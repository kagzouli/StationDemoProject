FROM ubuntu:20.04

# Install tools
RUN apt-get update \
   && apt-get -y install bash \
   && apt-get -y install curl \
   && apt-get -y install wget \
   && apt-get -y install unzip 

# Install Helm
RUN curl -fsSLo get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 && chmod 700 get_helm.sh && ./get_helm.sh

# Install terraform 
RUN wget https://releases.hashicorp.com/terraform/1.2.7/terraform_1.2.7_linux_amd64.zip && \
    unzip terraform_1.2.7_linux_amd64.zip && \
    mv terraform /usr/local/bin/terraform && \
    rm -f rm terraform_1.2.7_linux_amd64.zip 