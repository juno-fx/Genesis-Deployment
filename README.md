
![Orion Logo](https://juno-fx.github.io/Orion-Documentation/assets/logos/orion.png)

[Read the full documentation here](https://juno-fx.github.io/Orion-Documentation/)

## Deployment Chart v1.2

###  🚀 New Features 

- Titan Microservice upgraded to v1.0.1
- Terra Microservice Service upgraded to v1.0.1

#### Titan

- Group upload endpoint added, providing a way to batch create Titan user groups.

### 🐛 Bug Fixes

#### Terra

- Updated hardcoded helmchart metadata names. Ensuring charts are unique and follow provided install name
- Better handling of our git sources, when deleted/recreating to ensure plugins are tracked back properly to their original source.

#### Titan

- Better handling of data when it is defined as none

## Usage

This describes a full deployment of Genesis. For a more detailed guide, please see the [setup documentation](https://juno-fx.github.io/Orion-Documentation/installation/deployments/).

