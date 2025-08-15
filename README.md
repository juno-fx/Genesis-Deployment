
![Orion Logo](https://juno-fx.github.io/Orion-Documentation/assets/logos/orion/orion-dark.png)

[Read the full documentation here](https://juno-fx.github.io/Orion-Documentation/)

## Deployment Chart v1.4.0

###  🚀 New Features 

- Titan Microservice Service upgraded to v1.0.3
- Terra Microservice Service upgraded to v1.0.4
- Genesis Service upgraded to v2.1.0
- 
#### Genesis

- Terra App Store UI Refresh
- Dropped restriction forcing user to hibernate project before deleting storage
- Add k3s node provisioning and ansible credential creation via Genesis in the networking page and backend api
- Added help steppers to multiple pages (Workstations, Users/Groups, Networking)
- Cluster level Terra iFrame plugin dashboard support
- Add storage validation to both the front end storage creation form and backend api
- Allowing of user UID editing
- Add http_scheme selection setting to project creation


#### Terra
- Mixed namespace support added for bundles. Bundles can now have cluster-level plugins as well as project level plugins included in a single bundle.
- Plugin field backend schemas have been updated. This is in preparation for better front-end handling of plugin install fields.

#### Titan
- Allow editing of Titan user UID

###  🐛 Bug Fixes

#### Genesis
- Ensure the front end doesn't pass terra backend an empty sub-path key-value during install
- Fixed sizing of the Juno logo button box
- Bugfix when updating admin group users from group table previously would be blocked. This has been fixed.
- Fixed license banner warning sizing/placement

#### Titan
- Validating titan owner on creation to ensure valid user
- Bugfix when updating admin group users from group backend previously would be blocked. This has been fixed.

###  🧰 Maintenance

#### Genesis
- Updated license page context
- Added ingress auth handler
- Added/adjusted page and table loading states
- Updated Terra source create forms autofill settings


### 🔒 Security Update

#### Genesis

- We have improved upon how session secrets are generated. This better protects you against attackers attempting request forgery. While no direct attack vectors on public instances were found by our team, we still recommend updating Genesis&Hubble shortly after release. 


## Usage

This describes a full deployment of Genesis. For a more detailed guide, please see the [setup documentation](https://juno-fx.github.io/Orion-Documentation/installation/deployments/).
