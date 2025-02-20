
![Orion Logo](https://juno-fx.github.io/Orion-Documentation/assets/orion.png)

[Read the full documentation here](https://juno-fx.github.io/Orion-Documentation/)

## Deployment Chart v1.0

## Usage

This describes a full deployment of Genesis. For a more detailed guide, please see the [setup documentation](https://juno-fx.github.io/Orion-Documentation/installation/deployments/).

## Demo Setup

This is for demo purposes only. Please do not use this in production.

### Prerequisites

- [devbox](https://www.jetify.com/docs/devbox/installing_devbox/)
- [helm](https://helm.sh/docs/intro/quickstart/)
- [docker](https://github.com/docker/docker-install?tab=readme-ov-file#dockerdocker-install)
  - On linux, make sure to follow the post-installation steps [here](https://docs.docker.com/engine/install/linux-postinstall/).

### Setup

1. Clone the Genesis-Deployment repository
```bash
git clone https://github.com/juno-fx/Genesis-Deployment.git
```

2. Change into the directory
```bash
cd Genesis-Deployment
```

3. Change to the branch you want to deploy
```bash
git checkout v1.0
```

4. Activate devbox
```bash
devbox shell
```

5. Copy the values.yaml file
```bash
cp values.yaml .values.yaml
```

6. Fill out the .values.yaml file with the appropriate values

7. Launch Genesis (Sometime there is a race condition with NGINX. If this fails, just try again)
```bash
make genesis
```

8. Access Genesis at `https://localhost/`

### Clean Up

1. Delete the Genesis deployment
```bash
make down
```

