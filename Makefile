dev:
	rm -rf .terraform*
	git pull
	terrafile -f env-dev/Terrafile
	terraform init -backend-config=env-dev/backend.tfvars
	terraform apply -auto-approve -var-file=env-dev/main.tfvars

prod:
	rm -rf .terraform*
	git pull
	terrafile -f env-prod/Terrafile
	terraform init -backend-config=env-prod/backend.tfvars
	terraform apply -auto-approve -var-file=env-prod/main.tfvars

dev-destroy:
	rm -rf .terraform*
	git pull
	terrafile -f env-dev/Terrafile
	terraform init -backend-config=env-dev/backend.tfvars
	terraform destroy -auto-approve -var-file=env-dev/main.tfvars

prod-destroy:
	rm -rf .terraform*
	git pull
	terrafile -f env-prod/Terrafile
	terraform init -backend-config=env-prod/backend.tfvars
	terraform destroy -auto-approve -var-file=env-prod/main.tfvars



