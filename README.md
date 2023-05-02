# Pure GitOps with Terraform Cloud, GitLab CI and ArgoCD

## Technologies used

| Name | Version
| :--- | :--- 
| [terraform cloud](https://app.terraform.io/) | ~> 1.4.4 
| [eks](https://aws.amazon.com/eks/)  | 1.26
| [argocd](https://argo-cd.readthedocs.io/en/stable/)  | v2.6.7
| [gitlab ci](https://about.gitlab.com/) | 15.11
| [go](https://go.dev/) | 1.19

</br>

**Disclaimer**: The application source code has its own repository, which is [here](https://github.com/KyriakosTsalia/pod-info-app). Ideally, the Kubernetes manifests would have their own repository as well, but for the sake of simplicity, they are hosted in this one. Furthermore, the whole project was developed on and for GitLab and then imported on GitHub.

## Summary
This project explores the capabilities of the GitOps way of defining infrastructure as well as implementing Continuous Deployment for cloud native applications. A simple Go application will be deployed on the AWS EKS platform and GitLab CI with ArgoCD will be used to handle the CI/CD part of it. Terraform Cloud (TFC) natively supports GitOps, so it is a natural choice for declaratively defining the whole infrastructure.

By cloning the repository and running <code>terraform apply</code> inside the <code>tfc-setup</code> directory, Terraform, through the [tfe provider](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs), creates a new TFC organization, a project and three separate workspaces. Each workspace uses the VCS-driven workflow and pulls changes from a specific path of this repository. The <code>eks</code> workspace creates an AWS VPC and then provisions an EKS cluster in it. The <code>argocd-installation</code> workspace installs ArgoCD on the newly formed Kubernetes cluster using the Helm provider. The <code>argocd-app</code> workspace creates the ArgoCD Application and the necessary credentials for interacting with both the application and manifest repositories.

In order to connect the repositories to Terraform Cloud, a GitLab Personal Access Token, which will be used to configure the TFC OAuth Client, needs to be created. This access token will also be used in the <code>argocd-app</code> workspace in order to create two GitLab Deploy Tokens: one with <code>read_repository</code> permissions for the manifest repo and one with <code>read_registry</code> for the application repo.

Any input variables that may be needed in all workspaces are proactively created and given values in the beginning along with the workspaces themselves. Furthermore, in order to connect to AWS, valid AWS account credentials (access key and secret access key) are needed. They will be accessible to all workspaces with the use of a TFC <code>project_variable_set</code>.

---

## License
Copyright &copy; 2023 Kyriakos Tsaliagkos

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
