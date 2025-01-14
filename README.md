# connect-plus-azure-infra
Infrastructure as code for Connect+ Azure environments

## Customer Deployments
The [Deploy Customer Instance](https://github.com/copelandsoftware/connect-plus-azure-infra/actions/workflows/deploy-customer-instance.yml) action helps to create the initial layout of azure resources necessary for a customer pre-migration from the GDC.

The main bulk of infrastructure as code (ARM) templates here are activated through the Deploy Customer Instance pipeline.

## Alerting Deployments & Azure Monitor
Read more about monitoring / alerting [here](/AzureMonitor)
Monitoring is deployed in two ways.
- One for individual customers, after their migration via the [Deploy Customer Alert Action](https://github.com/copelandsoftware/connect-plus-azure-infra/actions/workflows/deploy-customer-alert.yml)
- In bulk via the [Deploy AZ Monitor Action](https://github.com/copelandsoftware/connect-plus-azure-infra/actions/workflows/deploy-az-monitor.yml) - this should only be run after changes are made to monitoring that need to apply to all customers (or a subset)
  - The above requires reading its parameters from the `customers.json` file and will apply parameters from that file.
  - Manual tweaks have been made to monitoring so care needs to be taken not to clobber those changes by using `what-if` parameters to determine what changes will be made
