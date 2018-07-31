ENVIRONS = local test prod
S3_BUCKET = fivey-tfstate

# Check for valid environment
.PHONY: check_env
check_env:
ifeq ($(filter $(ENV),$(ENVIRONS)),) 
	$(error ENV must be set to local, test, or prod)
endif

.PHONY: deploy
deploy: check_env
ifeq ($(ENV), local)
	docker run --name $(ENV)-db -e MYSQL_ROOT_PASSWORD=password -d mysql:5.7
	docker run --name $(ENV)-wordpress -p 8080:80 --link $(ENV)-db:mysql -d wordpress:latest
else
	$(MAKE) terraform_apply
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
# 	docker tag $(IMG_NAME):latest $(ACCOUNT).dkr.ecr.us-east-1.amazonaws.com/$(IMG_NAME):latest
# 	docker push $(ACCOUNT).dkr.ecr.us-east-1.amazonaws.com/$(IMG_NAME):latest

.PHONY: terraform_init
terraform_init: check_env
	chmod +x ./setup-tf-backend.sh
	./setup-tf-backend.sh $(S3_BUCKET)
	cd ./terraform/env/$(ENV) && \
	terraform init

.PHONY: terraform_apply
terraform_apply: check_env terraform_init
	cd ./terraform/env/$(ENV) && \
	terraform apply