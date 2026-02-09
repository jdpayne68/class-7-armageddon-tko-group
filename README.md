
#  Armageddon AWS Terraform Labs

This repository contains my AWS infrastructure labs completed for the Armageddon project.
The labs demonstrate cloud infrastructure provisioning, automation, and deployment using Terraform and AWS services.

---

##  Project Organization

The project files are organized into two main folders:

### ** `1a_upload/`**

Contains:

* **Lab 1A infrastructure setup**
* Terraform configuration files
* Initial AWS resource provisioning
* Supporting scripts and deployment materials

This lab establishes the foundational cloud environment used throughout later labs.

---

### **`1c-bonus-b/`**

Contains:

* **Lab 1C Bonus work**
* **Lab 2**
* **Lab 3**
* Additional infrastructure automation and enhancements

These labs extend the original AWS setup with additional services, deployment automation, and infrastructure improvements.

---

## 🔗 Lab Deliverable Links

Below are links to full lab deliverables, documentation, and supporting materials:

###  Lab 1A https://docs.google.com/presentation/d/1UfRDSfNwgIVcux8Gj_pBdOwUH9RxWaoI00V2Yq_qQjQ/edit?usp=sharing**

---

###  Lab 1B https://docs.google.com/presentation/d/1u7emdQNsOtnx855h7DXI44n61fFC5qldFH0S8_iF9js/edit?usp=sharing**

---

###  Lab 1C

1cbonus c -- https://docs.google.com/presentation/d/1XW-RqOj3Z86LLRl3_p7njtOgrsQAp4Unp6MsL3JQKKs/edit?usp=sharing
1C BONUS A OUTPUTS_DELIVERABLE-- https://docs.google.com/presentation/d/1K7dEnQreHncRFk5z4258OR5bKteK8dlHlEE0GktyQrU/edit?usp=sharing
1c bonus B --https://docs.google.com/presentation/d/1rqUGH8U8PwrUqMfX7AlLGTTeAd8iaev-fgmiMOp0MBI/edit?usp=sharing
walkthrough__1c bonus-A_How configure SSM agent using VPC Interface endpoints--https://docs.google.com/presentation/d/1DeIP4PTijl-Yqzw_E6HcRgYteYBgpOmoYr-jDlNa_ww/edit?usp=sharing
1c_bonus_d -- https://docs.google.com/presentation/d/14VJa-s3VhZVSiQLc4PFhCR1ghbU1tHeOe5wPCBjRaYw/edit?usp=sharing
1c_bonus_e -- https://docs.google.com/presentation/d/135n5xFdq_qhP_TeADPGzG9dFYsZHcsq8RQIvOXYS-70/edit?usp=sharing

---

### Lab 2
 **lab 2a--[lab 2a](https://docs.google.com/presentation/d/1827Ct7Mn9s32VT26lphxDR3E7vvFuWk0D0SPq_5eu_s/edit?usp=sharing)
2b_Be_A_Man -- https://docs.google.com/presentation/d/1lBLiwFE1LMCR1Lfx4d3WGxm8V-LsjluoIRTfqE28eeg/edit?usp=sharing

---

###  Lab 3

 **lab 3a --https://docs.google.com/presentation/d/137ogLURE9_kVp_1AFt9BaFP_o4Gn47ySOjZ9DYhTTT8/edit?usp=sharing

---

##  Technologies Used

* AWS Cloud Services (EC2, RDS, VPC, IAM)
* Terraform (Infrastructure as Code)
* Bash scripting
* Git/GitHub version control

---

##  Security Notice

The following sensitive or generated files are intentionally excluded:

* `.terraform/` provider cache
* Terraform state files (`*.tfstate`)
* Private key files (`*.pem`)
* Terraform plan files (`tfplan`)

This keeps the repository secure and prevents large file upload issues.

---



To deploy infrastructure locally:

```bash
terraform init
terraform plan
terraform apply
```

Make sure:

* AWS credentials are configured
* Required environment variables are set

---



This project demonstrates:

* Cloud infrastructure automation
* AWS networking and security configuration
* Terraform best practices
* Practical DevOps deployment workflows


