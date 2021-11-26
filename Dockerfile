# GENERIC DOCKER SETUP
FROM node:14
WORKDIR /opt/jupiterone
RUN apt-get update

# CYCLONEDX
# Keep an eye out for releases of cyclonedx
# We might need to bump a version when necessary
RUN wget https://github.com/CycloneDX/cyclonedx-cli/releases/download/v0.19.0/cyclonedx-linux-x64 -O /bin/cyclonedx
RUN chmod +x /bin/cyclonedx

COPY . .

# NPM PACKAGES
RUN npm install -g @cyclonedx/bom@3.1.1
RUN npm install --production

USER 10000:10001

# Assume that project root is mounted at /src
ENTRYPOINT ["/opt/jupiterone/bin/node-cdx-bom", "/src"]