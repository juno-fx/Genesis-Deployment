![Orion Logo](https://juno-fx.github.io/Orion-Documentation/assets/logos/orion/orion-dark.png)

[Read the full documentation here](https://juno-fx.github.io/Orion-Documentation/genesis2.0.3-orion2.0.1)

## Deployment Chart v2.0.3

This deployment chart includes the release images for Genesis (v3.0.3), Titan (v2.0.0), Terra (v2.0.0), and Rhea (v1.0.0).

See all the latest feature changes via our Changelogs [here](https://juno-fx.github.io/Orion-Documentation/genesis2.0.3-orion2.0.1/changelogs/feature/#2026-02-07)
<br>

## Usage

This describes a full deployment of Genesis. For a more detailed guide, please see the [setup documentation](https://juno-fx.github.io/Orion-Documentation/genesis2.0.3-orion2.0.1/installation/quick-start/).

## Ingress Controller Support

This chart now supports multiple ingress controllers for maximum flexibility and future-proofing as NGINX Ingress Controller heads toward retirement in March 2026.

### Supported Controllers

| Controller  | Values Option | Authentication Method      | CRDs Required | Best For                                   |
|-------------|---------------|----------------------------|---------------|--------------------------------------------|
| **NGINX**   | `nginx`       | Native annotations         | ❌             | Existing deployments (backward compatible) |
| **Traefik** | `traefik`     | ForwardAuth middleware     | ✅             | Modern deployments, full feature set       |
| **Cilium**  | `cilium`      | Gateway API SecurityPolicy | ✅             | Future-proof, Kubernetes standard          |

### Configuration

Set your preferred controller in `values.yaml`:

```yaml
ingressController: nginx  # Options: nginx | traefik | cilium
```

### Deployment Commands

Deploy with your preferred controller:

```bash
# NGINX (default - existing behavior)
make genesis INGRESS_CONTROLLER=nginx

# Traefik (modern with full features)
make genesis INGRESS_CONTROLLER=traefik

# Cilium (future-ready, Gateway API)
make genesis INGRESS_CONTROLLER=cilium
```

### Migration Path

1. **Existing NGINX users**: No changes needed - continue using `ingressController: nginx`
2. **Migrate to Traefik**: Switch to `ingressController: traefik` for modern features
3. **Migrate to Cilium**: Switch to `ingressController: cilium` for Gateway API standard

### Authentication Support

- **NGINX**: Uses `nginx.ingress.kubernetes.io/auth-url` annotation (no CRDs)
- **Traefik**: Uses ForwardAuth middleware CRD with `traefik.ingress.kubernetes.io/router.middlewares` annotation
- **Cilium**: Uses Gateway API SecurityPolicy CRD for external authentication

All controllers integrate with your existing Genesis authentication service at `http://genesis.{{ .Release.Namespace }}.svc.cluster.local:3000/api/socket-auth/`.