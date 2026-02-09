
# Armageddon AWS Terraform Labs

This repo holds the AWS infrastructure labs I built for the Armageddon project. Each lab walks through real cloud provisioning, automation, and deployment patterns using Terraform on AWS.

---

## Project Structure

### **`1a_upload/`**
This folder includes everything from **Lab 1A**, including:

- Terraform configs for the initial environment
- Base AWS resource provisioning
- Supporting scripts and setup materials

Lab 1A lays down the core environment that the later labs build on.

---

### **`1c-bonus-b/`**
This folder contains work for:

- **Lab 1C Bonus**
- **Lab 2**
- **Lab 3**

These labs expand the original setup with additional AWS services, automation, and infrastructure improvements.

---

## Lab Deliverables

Below are links to the full lab write‑ups, walkthroughs, and documentation.

### **Lab 1A**  
`https://docs.google.com/presentation/d/1UfRDSfNwgIVcux8Gj_pBdOwUH9RxWaoI00V2Yq_qQjQ/edit?usp=sharing` [(docs.google.com in Bing)](https://www.bing.com/search?q="https%3A%2F%2Fdocs.google.com%2Fpresentation%2Fd%2F1UfRDSfNwgIVcux8Gj_pBdOwUH9RxWaoI00V2Yq_qQjQ%2Fedit%3Fusp%3Dsharing")

---

### **Lab 1B**  
`https://docs.google.com/presentation/d/1u7emdQNsOtnx855h7DXI44n61fFC5qldFH0S8_iF9js/edit?usp=sharing` [(docs.google.com in Bing)](https://www.bing.com/search?q="https%3A%2F%2Fdocs.google.com%2Fpresentation%2Fd%2F1u7emdQNsOtnx855h7DXI44n61fFC5qldFH0S8_iF9js%2Fedit%3Fusp%3Dsharing")

---

### **Lab 1C**

- 1C Bonus C — [https://docs.google.com/presentation/d/1XW-RqOj3Z86LLRl3_p7njtOgrsQAp4Unp6MsL3JQKKs/edit?usp=sharing](https://docs.google.com/presentation/d/1XW-RqOj3Z86LLRl3_p7njtOgrsQAp4Unp6MsL3JQKKs/edit?usp=sharing)  
- 1C Bonus A (Outputs Deliverable) — [https://docs.google.com/presentation/d/1K7dEnQreHncRFk5z4258OR5bKteK8dlHlEE0GktyQrU/edit?usp=sharing](https://docs.google.com/presentation/d/1K7dEnQreHncRFk5z4258OR5bKteK8dlHlEE0GktyQrU/edit?usp=sharing)  
- 1C Bonus B — [https://docs.google.com/presentation/d/1rqUGH8U8PwrUqMfX7AlLGTTeAd8iaev-fgmiMOp0MBI/edit?usp=sharing](https://docs.google.com/presentation/d/1rqUGH8U8PwrUqMfX7AlLGTTeAd8iaev-fgmiMOp0MBI/edit?usp=sharing)  
- Walkthrough: Configuring SSM Agent with VPC Interface Endpoints — [https://docs.google.com/presentation/d/1DeIP4PTijl-Yqzw_E6HcRgYteYBgpOmoYr-jDlNa_ww/edit?usp=sharing](https://docs.google.com/presentation/d/1DeIP4PTijl-Yqzw_E6HcRgYteYBgpOmoYr-jDlNa_ww/edit?usp=sharing)  
- 1C Bonus D — [https://docs.google.com/presentation/d/14VJa-s3VhZVSiQLc4PFhCR1ghbU1tHeOe5wPCBjRaYw/edit?usp=sharing](https://docs.google.com/presentation/d/14VJa-s3VhZVSiQLc4PFhCR1ghbU1tHeOe5wPCBjRaYw/edit?usp=sharing)  
- 1C Bonus E — [https://docs.google.com/presentation/d/135n5xFdq_qhP_TeADPGzG9dFYsZHcsq8RQIvOXYS-70/edit?usp=sharing](https://docs.google.com/presentation/d/135n5xFdq_qhP_TeADPGzG9dFYsZHcsq8RQIvOXYS-70/edit?usp=sharing)  

---

### **Lab 2**

- Lab 2A — [https://docs.google.com/presentation/d/1827Ct7Mn9s32VT26lphxDR3E7vvFuWk0D0SPq_5eu_s/edit?usp=sharing](https://docs.google.com/presentation/d/1827Ct7Mn9s32VT26lphxDR3E7vvFuWk0D0SPq_5eu_s/edit?usp=sharing)  
- Lab 2B (“Be A Man”) — [https://docs.google.com/presentation/d/1lBLiwFE1LMCR1Lfx4d3WGxm8V-LsjluoIRTfqE28eeg/edit?usp=sharing](https://docs.google.com/presentation/d/1lBLiwFE1LMCR1Lfx4d3WGxm8V-LsjluoIRTfqE28eeg/edit?usp=sharing)  

---

### **Lab 3**

- Lab 3A — [https://docs.google.com/presentation/d/137ogLURE9_kVp_1AFt9BaFP_o4Gn47ySOjZ9DYhTTT8/edit?usp=sharing](https://docs.google.com/presentation/d/137ogLURE9_kVp_1AFt9BaFP_o4Gn47ySOjZ9DYhTTT8/edit?usp=sharing)  

---

## Technologies

- AWS (EC2, RDS, VPC, IAM, and more)
- Terraform (IaC)
- Bash
- Git/GitHub

---

## Security Notes

The following files are intentionally excluded:

- `.terraform/`  
- Terraform state files (`*.tfstate`)  
- Private keys (`*.pem`)  
- Terraform plan files (`tfplan`)  

This keeps sensitive data out of version control and avoids unnecessary large files.

---

## Running the Infrastructure

```bash
terraform init
terraform plan
terraform apply
```

Before running Terraform, make sure:

- Your AWS credentials are configured  
- Any required environment variables are set  

---

## What This Project Demonstrates

- Practical cloud automation  
- AWS networking and security fundamentals  
- Terraform workflows and patterns  
- Real‑world DevOps deployment practices  

---

If you want, I can also tighten the tone even further (more casual, more technical, more concise) or help reorganize the README into a more polished, portfolio‑ready format.
