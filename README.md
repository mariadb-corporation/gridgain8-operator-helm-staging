# gridgain8-operator-helm-staging

Staging Helm charts for GridGain 8 Operator. Work in progress for internal CI/CD; do not use for important workloads.

After GitHub Pages is enabled on branch `gh-pages` (root):

```bash
helm repo add gridgain8-operator-staging https://mariadb-corporation.github.io/gridgain8-operator-helm-staging
helm repo update
helm search repo gridgain8-operator-staging
```

Production index (separate repo): https://gridgain-operator.mariadb.com
