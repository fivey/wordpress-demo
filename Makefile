ENVIRONS = local test prod

.PHONY: check_env
check_env:
ifeq ($(filter $(ENV),$(ENVIRONS)),) 
	$(error ENV must be set to local, test, or prod)
endif

.PHONY: deploy
deploy: check_env
ifeq ($(ENV), local)
    # docker pull mysql:5.7
	# docker pull wordpress:latest
	docker run --name $(ENV)-db -e MYSQL_ROOT_PASSWORD=db-password -d mysql:5.7
	docker run --name $(ENV)-wordpress -p 8080:80 --link $(ENV)-db:mysql -d wordpress:latest
else ifeq ($(ENV), test)
    # deploy to test env in ECS
else ifeq ($(ENV), prod)
    # deploy to prod env in ECS
endif

# .PHONY: ecr-login
# ecr-login:
# 	aws ecr get-login \
# 	--registry-ids $(ACCOUNT) \
# 	--region us-east-1 \
# 	--no-include-email | sh -

# .PHONY: docker_build
# docker_build: check_env
# 	docker build --pull -t $(IMG_NAME) .

# .PHONY: docker_push
# docker_push: check_env docker_build ecr-login
# 	docker tag $(IMG_NAME):latest $(ACCOUNT).dkr.ecr.us-west-2.amazonaws.com/$(IMG_NAME):latest
# 	docker push $(ACCOUNT).dkr.ecr.us-west-2.amazonaws.com/$(IMG_NAME):latest

# # Terraform
# .PHONY: terraform_init
# terraform_init: check_env
# 	cd ./terraform/env/$(ENV) && \
# 	terraform init

# .PHONY: terraform_plan
# terraform_plan: check_env
# 	cd ./terraform/env/$(ENV) && \
# 	terraform get && \
# 	terraform plan

# .PHONY: terraform_apply
# terraform_apply: check_env upload
# 	cd ./terraform/env/$(ENV) && \
# 	terraform apply