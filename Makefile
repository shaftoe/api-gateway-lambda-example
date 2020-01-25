include config.mk

cleanup:
	@printf 'Cleaning up\n'
	@rm -f lambda.zip

create_zip:
	@echo 'Zipping lambda'
	@zip --junk-paths -r lambda.zip src/

deploy: cleanup create_zip
	@printf 'Running terraform apply...\n'
	@terraform apply \
		-var "region=$(region)" \
		-var "profile_name=$(profile_name)" \
		-var "domain_name=$(domain_name)" \
		-var "pushover_token=$(pushover_token)" \
		-var "pushover_userkey=$(pushover_userkey)" \
		infra/
