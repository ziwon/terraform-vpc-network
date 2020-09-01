SHELL := $(shell which bash)
TF := $(shell command -v terraform 2> /dev/null)

TFVARS_DEV_FILE=tf_dev_tokyo.tfvars
TFVARS_PROD_FILE=tf_prod_seoul.tfvars

.SILENT: ;               # no need for @

PHONY: get-tools
get-tools: # Install tools for development: # make get-tools
	echo "Installing brew packages.."
	HOMEBREW_BUNDLE_NO_LOCK=1 brew bundle
	echo "Installing terrafrom.. "
ifdef TF
	mv "$(shell which terraform)" "$(shell which terraform)".bak
endif
	tfswitch -l

PHONY: init
ifeq (init,$(firstword $(MAKECMDGOALS)))
  ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  $(eval $(ARGS):;@:)
endif
init: # Initialize project: # make init {env}
	scripts/init.sh $(ARGS)

PHONY: plan
ifeq (plan,$(firstword $(MAKECMDGOALS)))
  ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  $(eval $(ARGS):;@:)
endif
plan: # Plan project: # make plan {env}
ifeq ($(ARGS),prod)
	terraform plan -var-file=config/$(TFVARS_PROD_FILE)
else
	terraform plan -var-file=config/$(TFVARS_DEV_FILE)
endif

.PHONY: plan-vpc
ifeq (plan-vpc,$(firstword $(MAKECMDGOALS)))
  ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  $(eval $(ARGS):;@:)
endif
plan-vpc: # Generates an execution plan for vpc : # make plan-vpc dev
ifeq ($(ARGS),prod)
	echo "Using $(TFVARS_PROD_FILE).."
	terraform plan \
	-var-file=config/$(TFVARS_PROD_FILE) \
	-target=module.global \
	-target=module.vpc_shared \
	-target=module.vpc_dev
else
	echo "Using $(TFVARS_DEV_FILE).."
	terraform plan \
	-var-file=config/$(TFVARS_DEV_FILE) \
	-target=module.global \
	-target=module.vpc_shared \
	-target=module.vpc_dev
endif

.PHONY: apply-vpc
ifeq (apply-vpc,$(firstword $(MAKECMDGOALS)))
  ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  $(eval $(ARGS):;@:)
endif
apply-vpc: # Apply an execution plan for vpc : # make apply-vpc dev
ifeq ($(ARGS),prod)
	echo "Using $(TFVARS_PROD_FILE).."
	terraform apply \
		-var-file=config/$(TFVARS_PROD_FILE) \
		-target=module.global \
		-target=module.vpc_shared \
		-target=module.vpc_dev
else
	echo "Using $(TFVARS_DEV_FILE).."
	terraform apply \
		-var-file=config/$(TFVARS_DEV_FILE) \
		-target=module.global \
		-target=module.vpc_shared \
		-target=module.vpc_dev
endif

.PHONY: plan-vpn
ifeq (plan-vpn,$(firstword $(MAKECMDGOALS)))
  ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  $(eval $(ARGS):;@:)
endif
plan-vpn: # Generates an execution plan for vpn : # make plan-vpn dev
ifeq ($(ARGS),prod)
	echo "Using $(TFVARS_PROD_FILE).."
	terraform plan \
	-var-file=config/$(TFVARS_PROD_FILE) \
	-target=module.global \
	-target=module.vpn_in_shared
else
	echo "Using $(TFVARS_DEV_FILE).."
	terraform plan \
	-var-file=config/$(TFVARS_DEV_FILE) \
	-target=module.global \
	-target=module.vpn_in_shared
endif

.PHONY: apply-vpn
ifeq (apply-vpn,$(firstword $(MAKECMDGOALS)))
  ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  $(eval $(ARGS):;@:)
endif
apply-vpn: # Apply an execution plan for vpn : # make apply-vpb dev
ifeq ($(ARGS),prod)
	echo "Using $(TFVARS_PROD_FILE).."
	terraform apply \
		-var-file=config/$(TFVARS_PROD_FILE) \
		-target=module.global \
		-target=module.vpn_in_shared
else
	echo "Using $(TFVARS_DEV_FILE).."
	terraform apply \
		-var-file=config/$(TFVARS_DEV_FILE) \
		-target=module.global \
		-target=module.vpn_in_shared
endif

PHONY: apply
ifeq (apply,$(firstword $(MAKECMDGOALS)))
  ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  $(eval $(ARGS):;@:)
endif
apply: # Apply project: # make apply {env}
ifeq ($(ARGS),prod)
	terraform apply -var-file=config/$(TFVARS_PROD_FILE)
else
	terraform apply -var-file=config/$(TFVARS_DEV_FILE)
endif

PHONY: destroy
ifeq (destroy,$(firstword $(MAKECMDGOALS)))
  ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  $(eval $(ARGS):;@:)
endif
destroy: # Destroy project: # make apply {env}
ifeq ($(ARGS),prod)
	terraform destroy -var-file=config/$(TFVARS_PROD_FILE)
else
	terraform destroy -var-file=config/$(TFVARS_DEV_FILE)
endif

PHONY: clean
clean: # Clean terraform: # make clean
	rm -rf .terraform
	rm -rf terraform.tfstate.d

PHONY: check-scripts
check-scripts: # Check scripts: # make check-scripts
	shellcheck scripts/*.sh

PHONY: show-azs
show-azs: # List availability zones from current region: # make show-azs
	aws ec2 describe-availability-zones | jq -c '[.AvailabilityZones[].ZoneName]|join(",")'

PHONY: help
help: # Show this help message: # make help
	echo "Usage: make [command] [args]"
	grep -E '^[a-zA-Z_-]+:.*?# .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ": # "}; {printf "\t\033[36m%-20s\033[0m \033[33m%-30s\033[0m (e.g. \033[32m%s\033[0m)\n", $$1, $$2, $$3}'

.DEFAULT_GOAL := help
