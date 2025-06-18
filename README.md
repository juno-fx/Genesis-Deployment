
![Orion Logo](https://juno-fx.github.io/Orion-Documentation/assets/logos/orion.png)

[Read the full documentation here](https://juno-fx.github.io/Orion-Documentation/)

## Deployment Chart v1.2

###  🚀 New Features 

- Genesis Service upgraded to v1.1.1
- Titan Microservice upgraded to v1.0.1
- Terra Microservice Service upgraded to v1.0.1

#### Genesis

- Project configuration now accessible by all admin users, rather than just the owner
- Workstation templates are now editable, and can be duplicated. Making it easy to create new templates from existing ones.
- Workstation table, now has a details drop down showing the template details.
- Workstation template names can now include dashes
- Group Import ability added via CSV or json.
- LDAP nextauth support added
- Quick mounts added to storage creation, allowing for host path storage mounting.
- cluster-level terra plugin support added to the terra app store
- Development link added to user drop down for admin users and users with terra/titan permissions. This will link users to the api endpoints documentation.

#### Titan

- Group upload endpoint added, providing a way to batch create Titan user groups.

### 🐛 Bug Fixes

#### Genesis

- A middleware bugfix has been put in place for the terra app store permissions
- Workstation limit bugfix put in place ensuring proper limits are set
- Network rules bugfix put in place to ensure they are properly set

#### Terra

- Updated hardcoded helmchart metadata names. Ensuring charts are unique and follow provided install name
- Better handling of our git sources, when deleted/recreating to ensure plugins are tracked back properly to their original source.

#### Titan

- Better handling of data when it is defined as none

### 🧰  Maintenance

#### Genesis

- ensure license api endpoint compatibility included with new genesis endpoints
- API token creation now only available for admin users, and users with terra/titan permissions
- workstation table pagination updates
- Networking table updates


## Usage

This describes a full deployment of Genesis. For a more detailed guide, please see the [setup documentation](https://juno-fx.github.io/Orion-Documentation/installation/deployments/).

