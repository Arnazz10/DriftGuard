SHELL := /usr/bin/env bash

ENV ?= dev
AWS_REGION ?= us-east-1
CLUSTER_NAME ?= driftguard-$(ENV)

.PHONY: terraform-fmt terraform-validate plan apply bootstrap teardown demo-canary demo-bluegreen demo-rollback demo-selfheal

terraform-fmt:
	terraform -chdir=terraform fmt -recursive

terraform-validate:
	terraform -chdir=terraform validate

plan:
	terraform -chdir=terraform plan -var-file=environments/$(ENV).tfvars

apply:
	terraform -chdir=terraform apply -var-file=environments/$(ENV).tfvars
	aws eks update-kubeconfig --name $(CLUSTER_NAME) --region $(AWS_REGION)

bootstrap:
	bash scripts/bootstrap.sh

teardown:
	bash scripts/teardown.sh $(ENV)

demo-canary:
	bash scripts/demo-canary.sh $(ENV)

demo-bluegreen:
	bash scripts/demo-bluegreen.sh $(ENV)

demo-rollback:
	bash scripts/demo-rollback.sh $(ENV)

demo-selfheal:
	bash scripts/demo-selfheal.sh $(ENV)

