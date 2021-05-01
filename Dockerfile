FROM node:12
WORKDIR /opt/jupiterone
RUN apt-get update && apt-get -y upgrade && apt-get -y install jq
RUN npm install -g @cyclonedx/bom
RUN wget https://github.com/CycloneDX/cyclonedx-cli/releases/download/v0.14.0/cyclonedx-linux-x64 -O /bin/cyclonedx
RUN chmod +x /bin/cyclonedx
COPY . .
CMD ["/opt/jupiterone/generate-bom.sh", "/src"]