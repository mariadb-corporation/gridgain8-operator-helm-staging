# gridgain8-operator

GridGain Kubernetes operator (manager, RBAC, validating webhook). CRDs are a separate chart by default; set crds.enabled to bundle them. Webhook TLS uses built-in certificates by default; cert-manager is optional.

**Homepage:** <https://github.com/mariadb-corporation/gridgain8-operator-helm>

```bash
helm repo add gridgain8-operator https://gridgain-operator.mariadb.com
helm install gridgain8-operator-crds gridgain8-operator/gridgain8-operator-crds
helm install gridgain8-operator gridgain8-operator/gridgain8-operator \
  -n <namespace> --create-namespace
```

The operator image is `docker.mariadb.com/gridgain8-operator` (`linux/amd64`). Configure an image pull secret for `docker.mariadb.com`.

## Requirements

Kubernetes: `>=1.35.0-0`

Tested on Kubernetes 1.35 (`KIND_IMAGE=kindest/node:v1.35.0`).

cert-manager is **not** required unless `webhook.cert.certManager.enabled` is set to `true`.

## Namespace

Helm installs all namespaced resources into the release namespace (`helm install ... -n <namespace>`). For example, `-n skysql-system` is supported. Raw Kustomize manifests under `config/default` default to `gridgain-k8s-operator-system` instead.

## GridGainCluster roles

The chart installs ClusterRoles `gridgain-k8s-operator-gridgaincluster-admin-role` and `gridgain-k8s-operator-gridgaincluster-editor-role` and does not bind them. Binding either role in a namespace is equivalent to creating pods there, including the use of any ServiceAccount in that namespace. Bind them only to subjects who may create pods.

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| crds | object | `{"enabled":false}` | CRDs |
| crds.enabled | bool | `false` | Whether this chart should install the CRDs. False by default: install gridgain8-operator-crds first. Only set true on the initial deploy. If this chart owns the CRDs and is later uninstalled, GridGainClusters are DELETED. |
| currentNamespaceOnly | bool | `false` | Whether the operator should watch CRDs only in its own namespace or not. When true, RBAC is downgraded to namespace-scoped Role, webhook is disabled, and only GridGainClusters in the operator's namespace are reconciled. |
| fullnameOverride | string | `""` |  |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.repository | string | `"docker.mariadb.com/gridgain8-operator"` |  |
| image.tag | string | `""` | Image tag. Empty uses the chart appVersion. |
| imagePullSecrets | list | `[]` |  |
| livenessProbe.initialDelaySeconds | int | `15` |  |
| livenessProbe.periodSeconds | int | `20` |  |
| manager.featureGates | object | `{"Auth":false,"CRDTLS":false,"ControlCenter":false,"Metrics":false,"NamedCaches":false,"Persistence":false}` | Alpha feature gates (default off). See docs/feature-gates.md. |
| manager.healthProbeBindAddress | string | `":8081"` |  |
| manager.leaderElect | bool | `true` |  |
| manager.webhookCertPath | string | `"/tmp/k8s-webhook-server/serving-certs"` |  |
| metrics.enabled | bool | `false` | Enable the operator ServiceMonitor. Prometheus Operator CRDs must be installed. |
| metrics.serviceMonitor.additionalLabels | object | `{}` | Labels added to the ServiceMonitor (e.g. release: kube-prometheus-stack). |
| metrics.serviceMonitor.enabled | bool | `true` | Create the ServiceMonitor when metrics.enabled is true. |
| metrics.serviceMonitor.interval | string | `"30s"` | Interval to scrape operator metrics |
| metrics.serviceMonitor.metricRelabelings | list | `[]` |  |
| metrics.serviceMonitor.relabelings | list | `[]` |  |
| metrics.serviceMonitor.scrapeTimeout | string | `"25s"` | Timeout if metrics cannot be retrieved in the interval |
| metricsService.port | int | `8080` | Operator metrics bind and Service port (HTTP, same as mariadb-enterprise-operator). |
| nameOverride | string | `""` |  |
| pdb.enabled | bool | `false` | Enable PodDisruptionBudget for the operator. When enabled with replicaCount: 1, the operator pod becomes unevictable during voluntary disruptions (node drains), protecting webhook availability at the cost of potentially delaying node maintenance. |
| pdb.minAvailable | int | `1` | Minimum number of available operator pods. |
| podSecurityContext.runAsNonRoot | bool | `true` |  |
| podSecurityContext.seccompProfile.type | string | `"RuntimeDefault"` |  |
| readinessProbe.initialDelaySeconds | int | `5` |  |
| readinessProbe.periodSeconds | int | `10` |  |
| replicaCount | int | `1` |  |
| resources.limits.cpu | string | `"500m"` |  |
| resources.limits.memory | string | `"128Mi"` |  |
| resources.requests.cpu | string | `"10m"` |  |
| resources.requests.memory | string | `"64Mi"` |  |
| securityContext.allowPrivilegeEscalation | bool | `false` |  |
| securityContext.capabilities.drop[0] | string | `"ALL"` |  |
| securityContext.readOnlyRootFilesystem | bool | `true` |  |
| serviceAccount.create | bool | `true` |  |
| serviceAccount.name | string | `"gridgain-k8s-operator-controller-manager"` |  |
| terminationGracePeriodSeconds | int | `10` |  |
| validatingWebhook.name | string | `"gridgain-k8s-operator-validating-webhook-configuration"` |  |
| webhook.cert.certManager.enabled | bool | `false` | Use cert-manager for webhook TLS instead of built-in operator provisioning. |
| webhook.cert.certManager.issuerName | string | `"gridgain-k8s-operator-selfsigned-issuer"` | cert-manager Issuer name (when certManager.enabled is true). |
| webhook.cert.certManager.secretName | string | `"webhook-server-cert"` | Secret name for webhook TLS material (cert-manager mode). |
| webhook.cert.certManager.servingCertificateName | string | `"gridgain-k8s-operator-serving-cert"` | cert-manager Certificate name (when certManager.enabled is true). |
| webhookService.port | int | `443` |  |
| webhookService.targetPort | int | `9443` |  |

## cert-manager (optional)

```yaml
webhook:
  cert:
    certManager:
      enabled: true
```

When enabled, the chart renders cert-manager Issuer/Certificate resources and mounts the webhook Secret. The operator runs with `--webhook-cert-provider=cert-manager` and cert-manager cainjector patches `ValidatingWebhookConfiguration.caBundle`.
