ORG_NAME = nhsd-exeter
PROGRAMME = uec
PROJECT_GROUP = [uec/dos-api]
PROJECT_GROUP_SHORT = [uec-dos-api]
PROJECT_NAME = [project-name]
PROJECT_NAME_SHORT = [pns]
PROJECT_DISPLAY_NAME = [Project Name]
PROJECT_ID = $(PROJECT_GROUP_SHORT)-$(PROJECT_NAME_SHORT)

TEAM_NAME = [Team Name]
TEAM_ID = [team-name]

ROLE_PREFIX = [UECCommon]
PROJECT_TAG = $(PROJECT_NAME)
SERVICE_TAG = $(PROJECT_GROUP_SHORT)
SERVICE_TAG_COMMON = texas

PROJECT_TECH_STACK_LIST = python,java,terraform,shell

DOCKER_REPOSITORIES =
SSL_DOMAINS_PROD =
DEPLOYMENT_SECRETS = $(PROJECT_ID)-$(PROFILE)/deployment
