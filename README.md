# The Zero Trust Lab Guide

The Zero Trust Lab Guide aims to provide a level 200 learning path that will help you understand the Microsoft end-to-end Zero Trust story through logically ordered guidance across Microsoft 365 and Azure with the hope that it sovles some of the challenges that you can face when building a lab utulising Microsoft 365, such as:

- Where do I start?
- How complicated should my lab be?
- Build for learning? (repeatability – easy to tear down and rebuild)
- Build for demo’s (build once, low maintenance, longevity is key)
- How do I know the correct path and order to take?
- How do I know when I’m done with a part of the deployment and that it was done right?

## Advantages of using the lab guide

- The guide is modular and logically structured in scenario-based phases following best practices where possible.
- Provides a choice of doing Hybrid (aka On-Premises AD) or Cloud Only deployment
- Clearly articulated exit criteria for each phase and step
- Complexity of the Hybrid Identity option goes no deeper than enabling Password Hash Sync to avoid ADFS
- No Microsoft Entra Connect – Cloud Sync Only
- No public DNS or cert requirements – Everything works with *.onmicrosoft.com (even on-prem scenarios)

## What does it cover?

- Microsoft Entra ID Premium features across P1 & P2
- Microsoft Intune
- Microsoft Purview
- Microsoft Sentinel
- Microsoft Defender for Identity/Endpoint/O365/Cloud Apps
- Azure IaaS
- Azure Bastion
- Microsoft Security Benchmark
- Azure Policies

## Lab Guide Map

A visual represenation of the lab and deployment order is located at [https://aka.ms/ztlabguidemap](https://github.com/microsoft/cloudlab/blob/main/src/website/static/ZTLabGuideMap.pdf)

## Lab Guide 

The actual labs are located at https://aka.ms/ztlabguide
