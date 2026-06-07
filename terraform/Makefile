SHELL:=/bin/bash
dev/init:
	source .env && \
	terraform init \
		-backend-config="bucket=kcd-lima" \
		-backend-config="prefix=dev/kcd-cluster"

dev/plan: dev/init
	source .env && terraform plan -out create.tfplan

dev/apply: dev/plan
	source .env && terraform apply "create.tfplan"

dev/destroy: dev/init
	source .env && terraform destroy
