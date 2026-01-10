# OCI Artifact Sync Workflows

This directory contains GitHub Actions workflows for syncing OCI artifacts (container images, Helm charts, etc.) from one registry to another using [Skopeo](https://github.com/containers/skopeo).

## Workflows

### 1. sync-oci-artifacts.yml

A flexible workflow that accepts artifact configurations as input parameters. Best for one-off syncs or when you want to specify artifacts dynamically.

**Trigger:** Manual (`workflow_dispatch`)

**Usage:**

1. Go to Actions tab → "Sync OCI Artifacts" workflow
2. Click "Run workflow"
3. Fill in the parameters:
   - **artifacts**: JSON array of artifacts to sync
   - **source_registry**: (Optional) Source registry hostname
   - **source_username**: (Optional) Source registry username
   - **destination_registry**: Destination registry (default: docker.io)
   - **destination_username**: (Optional) Destination registry username

**Example artifacts JSON:**
```json
[
  {
    "source": "oci://ghcr.io/bank-vaults/helm-charts/vault-operator:1.23.0",
    "destination": "docker.io/khuedoan/helm-vault-operator:1.23.0"
  },
  {
    "source": "docker://quay.io/prometheus/node-exporter:v1.7.0",
    "destination": "docker.io/khuedoan/node-exporter:1.7.0"
  }
]
```

**Required Secrets:**
- `SOURCE_REGISTRY_PASSWORD`: Password for source registry (if authentication required)
- `DESTINATION_REGISTRY_PASSWORD`: Password for destination registry (if authentication required)

### 2. sync-oci-artifacts-config.yml

A workflow that reads artifact configurations from a JSON file in the repository. Best for regular syncs of a predefined list of artifacts.

**Trigger:** 
- Manual (`workflow_dispatch`)
- Push to `.github/sync-artifacts.json`
- Scheduled (daily at 00:00 UTC)

**Usage:**

1. Copy `.github/sync-artifacts.json.example` to `.github/sync-artifacts.json`
2. Edit the file to add your artifacts
3. Commit and push
4. The workflow will run automatically, or trigger it manually

**Config File Format:**
```json
{
  "artifacts": [
    {
      "source": "oci://ghcr.io/bank-vaults/helm-charts/vault-operator:1.23.0",
      "destination": "docker://docker.io/khuedoan/helm-vault-operator:1.23.0",
      "enabled": true
    },
    {
      "source": "docker://quay.io/prometheus/node-exporter:v1.7.0",
      "destination": "docker://docker.io/khuedoan/node-exporter:1.7.0",
      "enabled": false
    }
  ]
}
```

**Required Secrets:**
- `DOCKERHUB_USERNAME`: Docker Hub username
- `DOCKERHUB_TOKEN`: Docker Hub access token
- `SOURCE_GHCR_TOKEN`: (Optional) GitHub token for accessing ghcr.io
- `SOURCE_REGISTRY`: (Optional) Additional source registry hostname
- `SOURCE_USERNAME`: (Optional) Additional source registry username
- `SOURCE_REGISTRY_PASSWORD`: (Optional) Additional source registry password
- `DESTINATION_REGISTRY`: (Optional) Additional destination registry hostname
- `DESTINATION_USERNAME`: (Optional) Additional destination registry username
- `DESTINATION_REGISTRY_PASSWORD`: (Optional) Additional destination registry password

## Supported Protocols

Skopeo supports multiple transport protocols:
- `docker://` - Docker registry (default for registries)
- `oci://` - OCI layout directory
- `dir://` - Local directory
- `containers-storage:` - Container storage

## Setting Up Secrets

1. Go to repository Settings → Secrets and variables → Actions
2. Click "New repository secret"
3. Add the required secrets based on which workflow you're using

For Docker Hub:
- Name: `DOCKERHUB_USERNAME`, Value: your Docker Hub username
- Name: `DOCKERHUB_TOKEN`, Value: your Docker Hub access token

For GitHub Container Registry:
- Name: `SOURCE_GHCR_TOKEN`, Value: GitHub personal access token with `read:packages` scope

## Examples

### Sync a Helm chart from GHCR to Docker Hub
```json
{
  "source": "oci://ghcr.io/bank-vaults/helm-charts/vault-operator:1.23.0",
  "destination": "docker://docker.io/khuedoan/helm-vault-operator:1.23.0"
}
```

### Sync a container image from Quay to Docker Hub
```json
{
  "source": "docker://quay.io/prometheus/node-exporter:v1.7.0",
  "destination": "docker://docker.io/khuedoan/node-exporter:1.7.0"
}
```

### Sync multiple platform variants
Both workflows use `skopeo copy --all` which copies all platform variants (amd64, arm64, etc.) of multi-arch images.

## Troubleshooting

- **Authentication failures**: Verify that secrets are set correctly and have the necessary permissions
- **Image not found**: Check that the source image exists and the URL format is correct
- **Rate limiting**: Consider adding retry logic or spreading out sync operations
- **Large images**: The workflow may time out for very large images; consider running manually during off-peak hours
