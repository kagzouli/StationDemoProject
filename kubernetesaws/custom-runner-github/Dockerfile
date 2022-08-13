FROM summerwind/actions-runner:latest

# Install tools
RUN sudo  apt update -y \
   && sudo apt-get -y install bash \
   && sudo apt-get -y install curl \
   && sudo apt-get -y install wget \
   && sudo apt-get -y install unzip 

# Install Helm
RUN sudo curl -fsSLo get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 && \
    sudo chmod 700 get_helm.sh && \
    sudo ./get_helm.sh

# Install terraform 
RUN sudo wget https://releases.hashicorp.com/terraform/1.2.7/terraform_1.2.7_linux_amd64.zip && \
    sudo unzip terraform_1.2.7_linux_amd64.zip && \
    sudo mv terraform /usr/local/bin/terraform && \
    sudo rm -f rm terraform_1.2.7_linux_amd64.zip 

# Install kubectl
RUN sudo curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.23.6/bin/linux/amd64/kubectl && \
    sudo chmod +x kubectl && \ 
    sudo mv kubectl /usr/local/bin/kubectl