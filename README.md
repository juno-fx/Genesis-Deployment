
![Orion Logo](https://juno-fx.github.io/Orion-Documentation/genesis5.3.0-orion4.4.0/assets/logos/orion/orion-dark.png)

[Read the full documentation here](https://juno-fx.github.io/Orion-Documentation/genesis5.3.0-orion4.4.0)

## Deployment Chart v5.3.0

This deployment chart includes the release images for Genesis (v6.3.0), Titan (v2.2.0), Terra (v3.2.0), Metrics Gatherer (v0.0.4), and Rhea (v1.2.3).

See all the latest feature changes via our Changelogs [here](https://juno-fx.github.io/Orion-Documentation/genesis5.3.0-orion4.4.0/changelogs/feature/#2026-07-22)

A summary of all deprecations, migration steps between major versions and addressed security vulnerabilities is kept [in our technical changelog here](https://juno-fx.github.io/Orion-Documentation/genesis5.2.0-orion4.3.0/changelogs/technical/#2026-07-22-genesis-v540-orion-projects-v440).

---

## Ingress Controllers

This chart has been tested with these ingress controllers:

- [Kubernetes ingress-nginx](https://kubernetes.github.io/ingress-nginx/) (default)
- [Traefik](https://doc.traefik.io/traefik/providers/kubernetes-ingress/)
- [Cilium](https://docs.cilium.io/en/stable/network/servicemesh/ingress/)

All three are tested in Kind and should work in production Kubernetes clusters.

Set `ingress.className` to match your cluster's ingress class configuration.

> The root-level `ingressClassName` is deprecated and will be removed in a future release. Use `ingress.className` instead.

### Gateway API

Gateway API resources are not included in this chart but can be used by pointing an HTTPRoute at the `genesis` service (ports 3000 / 8000).

---

## Service and Ingress Configuration

### Service

The genesis service (external-facing) supports configurable type and annotations.

```yaml
service:
  type: ClusterIP            # ClusterIP | LoadBalancer | NodePort
  annotations: {}            # Annotations applied to the genesis service
```

Example for Coreweave CKS (public LoadBalancer with DNS):

```yaml
service:
  type: LoadBalancer
  annotations:
    service.beta.kubernetes.io/coreweave-load-balancer-type: public
    service.beta.kubernetes.io/external-hostname: genesis
```

The internal services (titan, terra, metrics-gatherer) are always ClusterIP and not user-configurable.

### Ingress

The ingress resource can be toggled and configured independently.

```yaml
ingress:
  enabled: true              # Toggle the ingress resource on/off
  className: ""              # Overrides root ingressClassName when set; falls back to it when empty
  annotations: {}            # Annotations applied to the ingress resource
```

When `ingress.enabled` is `false`, the ingress resource is omitted entirely.

Annotations on the ingress are useful for provider-specific features. Example for Traefik with cert-manager:

```yaml
ingress:
  enabled: true
  className: traefik
  annotations:
    cert-manager.io/cluster-issuer: letsencrypt-prod
```

---

## Testing

All tests run on a local Kind cluster. They provision the full stack -- Kind cluster, ingress controller, ArgoCD v2.10.16, and the Genesis chart -- then validate the deployment.

### Prerequisites

All tools are provided by the devbox environment:

- `docker`
- `kind`
- `kubectl`
- `helm`
- `make`

### Smoke Tests

Automated tests that provision a cluster, deploy the chart, verify the frontend responds with content "Juno Innovations", then tear down.

Each run is self-contained: create cluster, install, test, destroy.

**Scenario x Provider matrix:**

| Scenario | Description | IngressClassName |
|---|---|---|
| **dns** | Ingress hostname `orion.local` set; tested via `Host` header | `orion.local` resolves inside test container |
| **nohost** | No ingress host; tested by hitting Kind node IP directly | Ingress matches all traffic |

**Commands:**

| Test | Command |
|---|---|
| Default (nginx, DNS) | `make smoke-test-dns` |
| Default (nginx, no-host) | `make smoke-test-nohost` |
| Both scenarios (nginx) | `make smoke-test` |
| Traefik, DNS | `make smoke-test-dns-traefik` or `INGRESS_PROVIDER=traefik make smoke-test-dns` |
| Cilium, DNS | `make smoke-test-dns-cilium` or `INGRESS_PROVIDER=cilium make smoke-test-dns` |
| Traefik, no-host | `make smoke-test-nohost-traefik` |
| Cilium, no-host | `make smoke-test-nohost-cilium` |
| **All 6 combinations** | `make smoke-test-all` |

`make smoke-test-all` runs all scenarios and providers sequentially. It fails fast on the first failure and is designed for CI pipelines.

### Interactive Tests

Same provisioning as smoke tests but instead of curling and tearing down, they launch a LinuxServer.io Chromium container on the Kind Docker network with noVNC exposed on `localhost:3000`. Open your browser to `http://localhost:3000` to interact with Genesis.

**Commands:**

| Test | Command |
|---|---|
| Default (nginx, DNS) | `make interactive-test-dns` |
| Default (nginx, no-host) | `make interactive-test-nohost` |
| Traefik, DNS | `make interactive-test-dns-traefik` |
| Cilium, no-host | `make interactive-test-nohost-cilium` |

The READY banner shows:
- URL to open in your browser
- The URL loaded inside Chromium (hostname or IP)
- Test IP for direct access
- Login credentials

**Cleanup:**
```bash
make interactive-test-clean
```

Stops the browser container and deletes the Kind cluster.

### Test Values

Two values files in `.hack/` drive the test scenarios:

| File | Scenario | host value |
|---|---|---|
| `.hack/test-values-dns.yaml` | DNS | `orion.local` |
| `.hack/test-values-nohost.yaml` | No-host | `""` |

Both files configure basic authentication and a matching Titan owner user:

```yaml
env:
  BASIC_AUTH_EMAIL: "admin@juno-innovations.com"
  BASIC_AUTH_PASSWORD: "juno"
titan:
  owner: admin
  email: admin@juno-innovations.com
  uid: 1000
```

### How it works

The test scripts (`smoke-test.sh` / `interactive-test.sh`) do the following:

1. Delete any existing Kind cluster
2. Create a fresh Kind cluster (standard config or cilium-specific with `disableDefaultCNI`)
3. Install the selected ingress controller (nginx/traefik/cilium)
4. Install ArgoCD v2.10.16 (required by Genesis for argoproj.io CRDs)
5. Create a `juno-auth-secret` with a test token
6. Deploy the chart with the scenario values file and `ingressClassName` / `ingress.className` set to the provider
7. Wait for the Genesis pod to be ready
8. Run a test container (`curlimages/curl` or `lscr.io/linuxserver/chromium`) on the Kind Docker network

**For smoke tests:** The curl container curls `genesis-control-plane:80` (DNS scenario uses `-H "Host: orion.local"`) and checks for "Juno Innovations" in the response body. Retries up to 5 times with 3s delays to allow nginx endpoint sync.

**For interactive tests:** The Chromium container connects to the cluster network. The noVNC web interface is mapped to `localhost:3000`.

After testing, the cluster is torn down (smoke) or left running (interactive).

---

## Usage

For a full deployment guide, see the [setup documentation](https://juno-fx.github.io/Orion-Documentation/genesis5.1.0-orion4.2.0/installation/quick-start/).
