# Make DevOps

If you hear your teams or individuals saying _"It will take days to onboard a new member..."_, _"It works on my machine..."_ or _"Our pipeline is to complex and no one really understands how it all works..."_ then you need to invest more in automation and perhaps take an interest in this project. This project will help you to make your deploys boring!

## Use cases

- Service team AWS accounts setup with predefined base components to speed up configuration
- CI/CD building blocks to support a clean implementation of your pipelines and make them vendor agnostic as much as it is feasible
- Development workflow with highly customisable project automation scripts (inspired by dotfiles) for advanced \*NIX shell scripting
- macOS setup to complement the above and fully automate development environment provisioning

## Installation

- Set up your development environment on a macOS - this command will install/update and configure your OS packages: `curl -L bit.ly/make-devops-macos | bash`
- Instrument your project with the automation scripts - this command will update the existing git project structure in the current directory: `curl -L bit.ly/make-devops-project | bash`
- Use the make targets to support your CI/CD flow
- Configure AWS service team accounts using Terraform templates

## Features

- Shell native
- Automated setup
- Local development flow support
- Pipeline consistency and testability
- Highly customisable and flexible implementation
- Integration with a 3rd-party packages and services
  - [Docker](build/automation/lib/docker.mk)
  - [Kubernetes](build/automation/lib/k8s.mk)
  - [Terraform](build/automation/lib/terraform.mk)
  - [AWS](build/automation/lib/aws.mk)
  - Notifications, e.g. email and Slack
  - Technology radar
  - [macOS](build/automation/lib/macos.mk)
- Documentation templates
  - [README.md](build/automation/lib/project/template/README.md)
  - [TODO.md](build/automation/lib/project/template/documentation/TODO.md)
  - [Contributing.md](build/automation/lib/project/template/documentation/Contributing.md)
  - [Onboarding.md](build/automation/lib/project/template/documentation/Onboarding.md)
  - [Architectural Decision Record](build/automation/lib/project/template/documentation/adr/README.md)
- Unit and integration [tests](build/automation/test)
- Example of the repository structure that can consist of a single or multiple projects
- Deployment [profiles](build/automation/var/profile/README.md)
  - A password, key, tokens etc. should be represented by a corresponding system variable in the profile files
  - No sensitive information should be stored in the profile files
    - An exception is the `local` profile where it is acceptable to set all the configuration options, e.g. `ADMIN_PASSWORD = secret`
    - The same variable in any other profile i.e. `live` should be defined as `#ADMIN_PASSWORD = [secret]` by a convention
    - All the sensitive variables should be sourced from the AWS Secrets Manager using `eval $$(make secret-fetch-and-export-variables NAME=secret-name)`
- Data Docker image to [run SQL scripts](build/automation/lib/docker/image/postgres/assets/sbin/run.sh) against a database instance
- Tools Docker image with [various command-line utilities](build/automation/lib/docker/image/tools/Dockerfile) pre-installed
- [Git hooks](build/automation/etc/githooks)
- [Git secrets](https://github.com/awslabs/git-secrets)
- Visual Studio Code and iTerm configuration
- Virtual environments for Python, Go, Java and Node.js
- Texas AWS MFA [script](build/automation/bin/texas-mfa.py)
- Texas AWS SSM Session Manager [script](build/automation/bin/texas-ssm-connect.py)
- Toggle natural scrolling [script](build/automation/bin/toggle-natural-scrolling)
- Remote pair programming and [live collaboration](https://marketplace.visualstudio.com/items?itemName=MS-vsliveshare.vsliveshare)

## Usage

- Run `make help-all` to see all available targets
- Update the toolchain scripts to the most recent version by executing `make devops-synchronise`
- Use `make devops-print-variables` to print out all the effective variables. Include `PROFILE=[name]` to evaluate profile specific variables
- To run unit test suite use `make devops-test-suite` or alternatively to run a single one execute `make devops-test-single NAME=[test target name]`. Set the `DEBUG=true` flag to run the tests in the verbose mode
- To provision your macOS run `make macos-setup` or alternatively update configuration `make macos-config`

## Conventions

- Set all the profile specific information in a `build/automation/var/profile/[name].mk` file
- Set all the project specific information in the `build/automation/var/project.mk` file. There is set of mandatory variables that must be defined for the library to function correctly. For more details, please refer to the `build/automation/var/project.mk` file from the Project Template workspace
- Your development flow should be described in the main `Makefile` in the root directory of the project. Content of that file must meet certain implementation requirements and include some predefined sections
- Create custom helper targets in the `Makefile` file or in the individual sub-project directories. These targets should be lower-level targets supporting your project's development flow
- If a library target does not work in the expected way there are two ways of solving that issue
  - Create a patch, raise an MR and assign it to one of the library maintainers
  - Override the make target by creating it with the same name in the `build/automation/var/project.mk` file
- Target name convention
  - Use `descriptive-name`
  - Create `project-*` targets for the ops work flow or production usage, e.g. `project-build`, `project-deploy`
  - Create `dev-*` targets for the dev work flow, e.g. `dev-build`
  - Create `[component]-[activity]` complementary targets
  - Prefix target with the underscore i.e. `_descriptive-name` to indicate that it is a 'private' target
  - Do not exceed 40 characters
- Target help convention
  - Sample format is `# Target description - mandatory: ARG1=[argument description]; optional: ARG2="argument-value"; return: [string]`. A mandatory argument name can be concise e.g. `IMAGE`, however to avoid unpredicted behaviour while constructing higher lever make targets use more descriptive naming convention for the optional arguments e.g. `DOCKER_IMAGE`
  - Prefix with `#` to indicate a project specific development workflow target listed by `make help` or `help-project-development`
  - Prefix with `##` to indicate a project specific supporting or deployment target listed by `make help-project-supporting`
  - Prefix with `###` to indicate library target, use `make help-all` to see the full list of available targets
  - An argument is mandatory when target cannot function without it being specified and this argument is not a configuration option
  - An argument is optional when it is provided by a profile, however it is intended to be set from the command-line depending on the context
- Best practices
  - Use the same names for secret keys and make variables defined in your profiles
  - Group variables logically, e.g. `DB_HOST`, `DB_PORT`, `DB_NAME`, `DB_USERNAME`, `DB_PASSWORD` create a one group
  - Sort a group of variables alphabetically if there is no direct correlation between them, e.g. `TF_VAR_route53_terraform_state_key`, `TF_VAR_vpc_terraform_state_key`
  - Never modify library files, except the `Makefile` and files that are in the `build/automation/var` directory which are project-specific
  - Always use a single tab character for code indentations
  - Follow the variable assignment [rules](https://www.gnu.org/software/make/manual/html_node/Flavors.html#Flavors) to avoid an unexpected result
    - Any project or profile specific variable should be recursively expanded by using the `=` operator
    - Best practice is to keep all the modules variable assignments as recursively expanded which will allow to override and customise the configuration
    - However, within the `build/automation/init.mk` simply expanded variables (using `:=`) are preferred as this will enable to inherit value from a corresponding shell variable e.g. `export PROFILE=dev` will work as expected in line `PROFILE := $(or $(PROFILE), local)` and set the profile to `dev`
  - Naming
    - Service tag: `$(PROJECT_GROUP_SHORT)` or its prefix
    - ECR image: `$(PROJECT_GROUP_SHORT)/$(PROJECT_NAME_SHORT)/$(NAME)`
    - K8s namespace: `$(PROJECT_ID)-$(ENVIRONMENT)` or `$(PROJECT_ID)-$(ENVIRONMENT)-job`
    - Terraform state: `$(PROJECT_ID)/$(ENVIRONMENT)/$(STACK)`
    - AWS tags: `TagSet=[{key=Programme,value=$(PROGRAMME)},{key=Service,value=$(SERVICE_TAG),{key=Environment,value=$(ENVIRONMENT)},{key=Profile,value=$(PROFILE)}]`
    - AWS resources prefix: `$(PROJECT_ID)-*`
    - AWS secret name for deployment: `$(PROJECT_ID)-$(PROFILE)/deployment`
    - AWS bucket name for deployment: `$(PROJECT_ID)-$(PROFILE)-deployment`
    - AWS table name for deployment: `$(PROJECT_ID)-deployment`
    - AWS database instance: `$(PROJECT_ID)-$(ENVIRONMENT)` or `$(PROJECT_ID)-$(NAME)-$(ENVIRONMENT)`
    - Local domain names: `$(PROJECT_NAME_SHORT).local`, `$(PROJECT_NAME).local`, `$(PROJECT_NAME_SHORT)-$(PROJECT_GROUP_SHORT).local`
  - SSL certificate
    - A default SSL certificate for development is going to be created by the automation scripts in the `build/automation/etc/certificate` directory
    - Commit the relevant files and use this certificate to enable encrypted communication between components within the project
  - Versioning
    - Library build: `[YYYYmmdd]` - fixed on the date of modification as a Docker tag
    - User build: `[YYYYmmddHHMMss]-[hash]` - dynamic, set during the build process as a Docker tag
    - On demand deployment: `[YYYYmmddHHMMss]-[env]` - set by a developer as a Git tag and then as a Docker tag as well on the corresponding image

## Guiding Principles

- Simplicity and usability
- Do one thing well
- Clear intent, principle of least surprise
- Non-enforcing and supporting role
- Well documented, documentation as code
- A pipeline can run anywhere, e.g. any \*NIX like system
- Technology agnostic and universal design that can support Java, .NET, Python, Go, Node and others

## Maintenance

- Update software versions
  - Docker base images version in the `build/automation/lib/docker.mk` file and all the related modules
  - Python packages version from the `PYTHON_BASE_PACKAGES` list in the `build/automation/lib/python.mk` file
  - Tools version in the `build/automation/lib/docker/image/tools/Dockerfile` file
  - Gunicorn version in the `build/automation/lib/docker/image/python-app/Dockerfile` file
  - Docker library images version in any `build/automation/lib/docker/image/*/VERSION` file
  - Terraform modules in the `build/automation/lib/terraform/template/modules` directory

You can also check the versions alignment across the library by running the `make devops-check-versions` command.

## CI/CD Design

![DevOps Pipelines](build/automation/lib/project/template/documentation/diagrams/DevOps-Pipelines.png)

## Status

| Category       | Badges                                                                                                                           |
| -------------- | -------------------------------------------------------------------------------------------------------------------------------- |
| Automated Test | [![CircleCI](https://circleci.com/gh/nhsd-exeter/make-devops.svg?style=shield)](https://circleci.com/gh/nhsd-exeter/make-devops) |
