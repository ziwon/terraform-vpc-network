region = "{{ REGION }}"
vpc_id = "{{ VPC_ID }}"

project = "{{ PROJECT_NAME }}"
app = "{{ APP_NAME }}"
environment = "{{ ENV }}"

certificate_arn = "{{ CERTIFICATE_ARN }}"
kms_arn = "{{ KMS_ARN }}"

tags = {
	"Client" = "{{ CLIENT_NAME }}"
	"Terraform" = true
	"Environment" = "{{ ENV }}"
}
