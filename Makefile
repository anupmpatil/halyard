.PHONY: all terraform-install fmt-check

all: terraform-install fmt-check

terraform-install:
	yum-config-manager --enable ol7_developer
	echo "" >> /etc/yum.repos.d/artifactory-ol7.repo
	echo "# makes ol7-developer-yum-local available" >> /etc/yum.repos.d/artifactory-ol7.repo
	echo "[ol7-developer-yum-local]" >> /etc/yum.repos.d/artifactory-ol7.repo
	echo "name=ol7-developer-yum-local" >> /etc/yum.repos.d/artifactory-ol7.repo
	echo "baseurl=https://artifactory.oci.oraclecorp.com/ol7-developer-yum-local/" >> /etc/yum.repos.d/artifactory-ol7.repo
	echo "gpgcheck=0" >> /etc/yum.repos.d/artifactory-ol7.repo
	echo "enabled=1" >> /etc/yum.repos.d/artifactory-ol7.repo
	echo "proxy=_none_" >> /etc/yum.repos.d/artifactory-ol7.repo
	yum install -y terraform
	@if [ -x "$$(command -v terraform)" ]; then \
    		echo "Terraform installed successfully"; \
    	else \
    		echo "Terraform is not installed, Please check the logs"; \
    		exit 1; \
    fi

fmt-check:
	@if [ -x "$$(command -v terraform)" ]; then \
		echo "==> Checking terraform formatting of files"; \
		(terraform fmt -check=true -recursive && echo "Terraform format check passed successfully") || (echo "Terraform files are not appropriately formatted. Please run terraform fmt -recursive to format them." && exit 1); \
	else \
		echo "No terraform command found"; \
		exit 1; \
	fi
