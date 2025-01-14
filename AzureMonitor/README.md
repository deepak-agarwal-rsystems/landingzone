### Workflow
The workflow contained in `deploy-az-monitor.yml` deploys :
- Subscription level rules : Every resource of a type will be targeted with some rule ie. All VMs in a subscription
- Customer level rules : Each customer will be targeted to create an Application Insights group and availability tests are created that target the specific site of a customer, these resources are placed in the customers resource group
- Action Groups : Every alert rule will ping an action group that handles it, any higher severity issues will target the on-call group and others will target the info group which can be configured for any level of informing
- Alert processing rules : Specific massaging of alert rules post-firing are configured here

The main configurations for targeting are defined within the `deploy-az-monitor.yml` which defines a number of prefixes to target resource groups, VMs, etc.

ie. Customer resource groups are assumed to start with `RG-Z-CUST`
#### Args
    - Environment to deploy to : Targets the subscription (dev v prod)
    - Resource Group to deploy to : Targets the resource group to place most of the generic alerting rules
    - Perform Dry Run : If true does no deployment but will show for testing purposes what would be deployed, if false will actually deploy

### Subscription level alerts

Each of the following are aggregated with a 5 minute lookback, and queried every 5 minutes.

  ---
  | Name                      | Metric Namespace                   | Metric Name                          | Operator    | Threshold | Severity |
  |---------------------------|------------------------------------|--------------------------------------|-------------|-----------|----------|
  | alm-cpu-percentage        | microsoft.compute/virtualmachines | Percentage CPU                       | GreaterThan | 95        | 1        |
  | alm-available-memory      | microsoft.compute/virtualmachines | Available Memory Bytes               | LessThan    | 250000000 | 2        |
  | alm-disk-writes           | microsoft.compute/virtualmachines | OS Disk Write Bytes/sec              | GreaterThan | 1000000000 | 3        |
  | alm-disk-latency          | microsoft.compute/virtualmachines | OS Disk Latency                      | GreaterThan | 500       | 3        |
  | alm-disk-read             | microsoft.compute/virtualmachines | OS Disk Read Operations/Sec          | GreaterThan | 200       | 3        |
  | alm-vm-available          | microsoft.compute/virtualmachines | VmAvailabilityMetric                 | LessThan    | 1         | 0        |
  | alm-byte-response-time    | Microsoft.Network/applicationgateways | BackendFirstByteResponseTime       | GreaterThan | 5000      | 3        |
  | alm-failed-requests       | Microsoft.Network/applicationgateways | FailedRequests                     | GreaterThan | 50        | 2        |
  | alm-backend-availability  | Microsoft.Network/loadBalancers     | DipAvailability                     | LessThan    | 99        | 2        |
  | alm-under-ddos-attack     | Microsoft.Network/VirtualNetworks   | IfUnderDDoSAttack                    | GreaterThan | 0         | 1        |
  | alm-ping-average-round-trip | Microsoft.Network/VirtualNetworks | PingMeshAverageRoundtripMs           | LessThan    | 5000      | 4        |
  | alm-ping-failed-percent   | Microsoft.Network/VirtualNetworks   | PingMeshProbesFailedPercent          | GreaterThan | 0         | 3        |
  | aks-cpu-percentage        | Microsoft.ContainerService/managedClusters | node_cpu_usage_percentage       | GreaterThan | 95        | 1        |
  | aks-memory-percentage     | Microsoft.ContainerService/managedClusters | node_memory_working_set_percentage | GreaterThan | 95        | 1        |
  ---

### Customer level alerts

Each customer resource group (defined by the `$CUSTOMERS` github variable) gets an Application Insights instance within its resource groups.

Within the App Insights resource 3 availability tests are defined that target the Connect+ app.
- /JaruStats.do?query=testAlarm&alarmReceivingThreshold=30'
- /JaruStats.do?query=testE2Protocol'
- /JaruStats.do?query=testLogin'

Each of these are hit from different locations and tested about 5 times every 10 minutes

### Action Groups

The current action groups exist mainly to inform the pager duty webhook if any severe alerts have been fired.

### Alert Processing Rules

The current alert processing rules serve mainly to suppress alerts for the DB VMs of `vm-z-orad-p-001` and `vm-z-orad-p-002`.  These VMs run a back up procedure every day that takes about an hour or so at 3AM EST.
So from 3-5 AM EST, for these VMs only, alerts are suppressed with the assummption that memory and CPU values are outside of the expected thresholds.