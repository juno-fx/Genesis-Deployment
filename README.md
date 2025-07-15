
![Orion Logo](https://juno-fx.github.io/Orion-Documentation/assets/logos/orion/orion-dark.png)

[Read the full documentation here](https://juno-fx.github.io/Orion-Documentation/)

## Deployment Chart v1.3

###  🚀 New Features 

- Genesis Service upgraded to v2.0.0 (Major)
- Titan Microservice upgraded to v1.0.2
- Terra Microservice Service upgraded to v1.0.2

#### Genesis

- Deprecating CRD workstation templates
- Multi-container support added for workstation schema and templates
- Install Helios Open Source container schema via Terra App store
- Support mountless terra plugin installs
- workstation templates can now be upgraded when their schema is updated.
- LDAP support with self-signed CA's
- Basic Auth added for local development testing
- Kuiper User group permissions updated. Users assigned the Kuiper role, can now create workstation templates and access the API


### 🐛 Bug Fixes

#### Genesis

- Prevent user from submitting empty custom charts on project create
- Fixed broken link to documentation
- Terra App store fix for bad source loading
- Ensure network policy is deleted for project during project delete

#### Terra

- Account for plugins with empty values on install
- ensure our git source loads properly
- proper handling for bad source loading

#### Titan

- Ensure on cluster creation the owner UID is set to the provided UID. If no UID is provided defaulting to 1000

### 🧰  Maintenance

#### Genesis

- Connecting to project will now send user to project home page rather than login, if the user is already logged in
- Additional small maintenance updates for better user experience

## Usage

This describes a full deployment of Genesis. For a more detailed guide, please see the [setup documentation](https://juno-fx.github.io/Orion-Documentation/installation/deployments/).

