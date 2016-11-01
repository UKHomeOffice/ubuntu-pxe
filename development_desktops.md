# Secure Development Desktops


## Requirements

When developing in restricted environments there is a need to ensure that development machines are significantly hardened and follow best practices whilst still allowing for users to complete the development, testing and support of the environments they are within.

Standard guidelines for most environments tend to be very prescriptive and not designed towards the development lifecycle process and instead are for fixed end user devices designed for specific requirements.

This guide is to help Risk Owners and Administrators understand where we deviate from the standard CESG guidance for End User Devices published on 13 March 2015 https://www.cesg.gov.uk/guidance/end-user-devices-security-guidance-1404-lts


## Variations

The main variation to the guidance is the switch to the latest Ubuntu 16.04 long term support release. This is used as some newer hardware is not supported under 14.04, it is also good practice to keep on the latest LTS based release to ensure current security issues and bugs are minimised.


### Rules and Mitigations

|Security Principle|Suggested Resolution|Mitigation if not as per resolution|
|:---:|:---:|:---:|
|Data in Transit|Use of (StrongSwan) IPSec VPN client|We will be using OpenVPN over TLS, each tunnel will last for a Maximum of 8 hours for development systems and 2 for production systems. To obtain a new session users will be required to login to a secure access portal using central authentication and 2FA over TLS.|
|Data at Rest|LUKs full volume encryption with a 10 character password|Implemented as part of provisioning|
|Authentication|User uses a different password to LUKs password which is again a Minimum of 10 Characters, changed every 90 days||
|Secure Boot|This is not currently supported by Ubuntu||
|Platform integrity and application sandboxing|These requirements are met implicitly by the platform. AppArmor profiles where available limit application access to the platforms|AppArmor Profiles, Systemd restrictions and Docker Containers help limit the surface attack space for each application|
|Malicious Code Detection and Prevention|The platform implicitly provides some protection against malicious code being able to run.|ClamAV will also be used to detect Virus's, and IPTables will be enforced to restrict inbound access to the machines.|
|Security Policy Enforcement|Security policy enforcement via OS components|Policy Kit rules, LightDM settings, DConf Setting, PackageKit rules, gksu settings and gksudo settings||
|External Interface Protection||USB Datadisk access is denied by default|
|Device Updates|Operating System updates are set to automatically apply||
|Event Collection|Standard logs are collected via Rsyslog to remote sites via TLS and auditd is enabled to track auditable events|Currently both Rsyslog and Auditd are enabled and monitoring but there is no central facility to collect these logs when roaming.|
|Incident Response|There is no native wipe facility for Ubuntu however, access to remote sites is controlled via central VPN authentication which can be revoked||


### Plans

To deploy new hardware a central image of Ubuntu 16.04 will be used which has been customised to follow the best practice for a minimal environment. This is using the following work https://gitlab.digital.homeoffice.gov.uk/dsab-portpilot/ubuntu-client-pxe, Once hardware has the base operating system provisioned updates can be performed via https://github.com/UKHomeOffice/development_environment

As new security requirements are made or new applications are required updates are to be made via the development_environment project. These can be peer reviewed under the development branch and then once approved pushed by authorised staff to the master branch. After this point they can be pulled by target machines either automatically via a systemd background job or manually be the users.
