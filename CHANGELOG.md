Changelog

All notable changes to this project will be documented in this file.

The format is based on Keep a Changelog and this project adheres to Semantic Versioning.
[Unreleased]

[0.3.0] - 2021-12-07

Publish DockerImage to jupiterone-infra ECR

    - Added Jenkinsfile to add automation to this package
    - Added terraform to create ECR repository
    - Added deploy script to publish image to ECR repository

[0.2.0] - 2021-11-26

    - Upgraded CycloneDX to `0.19.0` from `0.14.0`
    - Upgraded @cyclonedx/bom to `3.1.1`
    - Added an `rm` call to `node-cdx-bom` to resolve bug that incurred on multiple calls to the same repository
    - Upgrade Dockerfile to use node14 and npm instead of yarn
