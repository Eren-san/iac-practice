# iac-practice

This repository is a hands-on practice project combining **Infrastructure as Code (IaC)** with a simple application setup.  
It is designed to experiment with Terraform, Docker, CI/CD, and serverless concepts in a practical way.

---

## 📁 Project Structure

- `app/` – Application source code  
- `terraform/` – Terraform infrastructure configuration  
- `bootstrap/` – Setup and initialization scripts  
- `.github/workflows/` – GitHub Actions CI/CD workflows  
- `Dockerfile` – Container image definition  
- `lambda_function.py` – AWS Lambda function example  
- `requirements.txt` – Python dependencies  

---

## Installation & Usage

Clone the repository
```console
# Clone the repo
$ git clone https://github.com/Eren-san/iac-practice.git

# Change directory
$ cd iac-practice
```

Application setup
```console
# Create a virtual environment
$ python3 -m venv venv

# Activate the venv
# Linux / macOS
$ source venv/bin/activate
# Windows (PowerShell)
PS> Set-ExecutionPolicy RemoteSigned
PS> .\venv\Scripts\Activate.ps1

# Install dependencies
$ pip install -r requirements.txt

# Run the application
$ python lambda_function.py
```

---

## Terraform

```console
# Change directory to terraform
$ cd terraform

# Initialize terraform
$ terraform init

# Review execution plan
$ terraform plan

# Apply infrastructure
$ terraform apply -auto-approve

# Destroy infrastructure (when needed)
$ terraform destroy -auto-approve
```
