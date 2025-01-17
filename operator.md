### k8s-loki-s3

Grafana Loki is a horizontally scalable, highly available log aggregation system designed for cost-effective indexing and querying of logs, optimized for Kubernetes and cloud-native environments. This specific bundle is designed to integrate with S3 for log storage, making it affordable and infinitely scalable.

### Design Decisions

- **Scalability**: The setup ensures that your logging infrastructure can scale with your application demands using the power of Kubernetes and Helm charts.
- **Security**: Integrations with AWS IAM for S3 access management and enforced security protocols.
- **Log Storage**: AWS S3 is the intended log storage, providing cost effective, infinitely-scalable storage.
- **Monitoring**: Promtail is installed into the Kubernetes cluster for log collection and transmission.
- **Visualization**: Loki integrates natively with Grafana to provide rich visual querying of logs.
- **Helm Charts**: Helm is used for the deployment and management of Loki, Promtail, and Grafana, making rollbacks and upgrades easier.

### Runbook

#### Connecting to Grafana

While loki does provide an API for querying logs, the best tool to visualize and query is Grafana which integrates with Loki natively.

The default username for the Grafana instance is `admin`, and the password is specified as a Massdriver secret.

By default, Grafana will not be exposed publicly. You can still access Grafana using [Kubernetes port-forwarding](https://kubernetes.io/docs/tasks/access-application-cluster/port-forward-access-application-cluster/).

```bash
kubectl port-forward svc/<package-name>-grafana 8080:80 --namespace <namespace>
```

This will make Grafana reachable on http://localhost:8080. Obviously you can modify this command to fit your customizations.


#### Querying Logs in Grafana

To query logs in Grafana, there is [extensive documentation](https://grafana.com/docs/loki/latest/query/) about the query language LogQL on Loki's website.

For a quick example, the following will guide you through your first query:

1. Click on the Explore icon in the sidebar.
2. Be sure Loki is selected as the data source.
3. Build Queries with LogQL

Retrieve all logs from a namespace:

```logql
{namespace="your-namespace"}
```

Filter logs containing a specific keyword:

```logql
{namespace="your-namespace"} |= "error"
```
