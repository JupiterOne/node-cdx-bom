FROM node:12
WORKDIR /opt/jupiterone
RUN apt-get update && apt-get -y upgrade
RUN wget https://github.com/CycloneDX/cyclonedx-cli/releases/download/v0.14.0/cyclonedx-linux-x64 -O /bin/cyclonedx
RUN chmod +x /bin/cyclonedx
COPY . .
RUN yarn install
# Assume that project root is mounted at /src
ENTRYPOINT ["/opt/jupiterone/bin/node-cdx-bom", "/src"]