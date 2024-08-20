### AWS S3

Amazon Simple Storage Service (Amazon S3) is an object storage service that offers industry-leading scalability, data availability, security, and performance. This service is designed to handle any amount of data and allows users to manage it from any location on the web.

### Design Decisions

- **Scalability**: The setup ensures that your logging infrastructure can scale with your application demands using the power of Kubernetes and Helm charts.
- **Security**: Integrations with AWS IAM for access management and enforced security protocols.
- **State Storage**: AWS S3 is utilized for storing Loki chunks and ruler configurations.
- **Monitoring**: The inclusion of Promtail for log collection and Grafana for visualization makes the monitoring stack robust and comprehensive.
- **Helm Charts**: Helm is used for the deployment and management of Loki, Promtail, and Grafana, making rollbacks and upgrades easier.
- **Namespace Isolation**: Each service is deployed within its own namespace in Kubernetes to improve security and manageability.

### Runbook

#### S3 Bucket Access Issues

If you encounter access issues with your S3 bucket, ensure that the IAM role or user has the appropriate permissions.

To check the IAM policy:

```sh
aws iam get-role-policy --role-name YOUR_ROLE_NAME --policy-name YOUR_POLICY_NAME
```

Ensure the policy includes at least the following permissions on the S3 bucket:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:GetObject",
        "s3:ListBucket"
      ],
      "Resource": [
        "arn:aws:s3:::YOUR_BUCKET_NAME",
        "arn:aws:s3:::YOUR_BUCKET_NAME/*"
      ]
    }
  ]
}
```

#### Loki Not Writing Logs to S3

If Loki isn't writing logs to S3, verify the Loki configuration settings.

Check the Loki pod logs:

```sh
kubectl logs POD_NAME -n NAMESPACE
```

Look for errors related to AWS S3. Additionally, check the Loki configuration loaded in Kubernetes:

```sh
kubectl get configmap loki-config -n NAMESPACE -o yaml
```

Ensure this snippet is configured correctly:

```yaml
storage_config:
  aws:
    s3: s3://YOUR_BUCKET_NAME
    region: YOUR_AWS_REGION
```

#### Logs Not Visible in Grafana

If logs are not visible in Grafana, verify Grafana's data source settings and the connectivity to Loki.

First, check the network accessibility from Grafana to Loki:

```sh
kubectl exec -it POD_NAME -n NAMESPACE -- curl http://loki-gateway.NAMESPACE.svc.cluster.local/loki/api/v1/query
```

Then, verify Grafana's data source settings in the UI under "Configuration" > "Data Sources." Ensure Loki is set up properly and the URL matches:

```yaml
url: http://loki-gateway.NAMESPACE.svc.cluster.local
```

Finally, check Grafana logs for any errors:

```sh
kubectl logs POD_NAME -n NAMESPACE
```

#### AWS IAM Role Issues

If there are IAM Role issues, check the role assignments and trust relationships.

Verify that the role used by your Kubernetes service account has the correct trust relationship:

```sh
aws iam get-role --role-name YOUR_ROLE_NAME
```

Ensure the trust relationship allows the Kubernetes cluster to assume the role:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
```

Ensure the service account in Kubernetes is annotated with the correct IAM role:

```sh
kubectl describe serviceaccount SERVICE_ACCOUNT_NAME -n NAMESPACE
```

It should have the annotation:

```sh
eks.amazonaws.com/role-arn: arn:aws:iam::ACCOUNT_ID:role/YOUR_ROLE_NAME
```

