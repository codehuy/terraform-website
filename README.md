# terraform-website
Building My Resume Website on AWS with Terraform and CI/CD

Welcome to my Terraform resume project! I originally did this project through ClickOps to learn more about the different services of AWS. You can check it out on my other repo. I then redid this entire project again with the goal to learn Iac / Terraform.  This was part of the Cloud Resume Challenge and represents a hands-on journey with AWS, Terraform, and CI/CD through GitHub Actions. By building this project, I was able to learn and  showcase my skills in cloud infrastructure, automation, and serverless computing. Below is a detailed look at the components, challenges, and insights I gained along the way.

# Project Overview

This project is designed to:

	1.	Host a static resume website on AWS, with a custom domain configured through Route 53.
	2.	Implement a dynamic view counter to track site visits, stored in DynamoDB.
	3.	Use CI/CD with GitHub Actions to automatically deploy infrastructure changes through Terraform.

# Architecture

To make the website scalable, cost-effective, and easy to manage, I broke down the architecture as follows:

	1.	S3 and Route 53: S3 handles static file hosting, while Route 53 manages the DNS for my custom domain.
	2.	CloudFront: Speeds up global content delivery and provides SSL.
	3.	DynamoDB: Stores page views for the view counter.
	4.	Lambda: Updates the view counter each time the page is loaded
	5.	CI/CD with GitHub Actions: Automates the infrastructure deployment process, pushing updates as soon as changes are committed to the GitHub repository.

# Here’s an overview of the architecture:

Technologies and Why I Chose Them

	•	Terraform: Provides Infrastructure as Code (IaC) capabilities, making deployment reproducible and manageable.
	•	GitHub Actions: Ensures continuous delivery of infrastructure changes by automatically applying any updates made to the Terraform configuration.
	•	AWS Services (S3, Route 53, CloudFront, DynamoDB, Lambda): These services integrate well to support a serverless architecture, minimizing costs and complexity.

Building and Automating the Project

1. Hosting the Static Site on S3

S3 was an obvious choice for hosting static content, offering durability and scalability for a resume site. Configuring Route 53 allowed me to link my custom domain with ease.

Challenge: Configuring HTTPS correctly required adding CloudFront, which manages SSL termination for the custom domain. After some trial and error with ACM, I successfully linked CloudFront with my domain.

2. View Counter with DynamoDB and Lambda

To make the site interactive, I implemented a view counter that stores page visits in a DynamoDB table. Each visit triggers the Lambda function, which updates the counter.

Challenge: Setting up Lambda was initially challenging but essential for allowing the frontend to interact with the Lambda function securely.

3. Automating Deployments with CI/CD

The CI/CD pipeline, powered by GitHub Actions, is central to this project. Every time I make changes to the Terraform code, GitHub Actions automatically validates and applies them, ensuring quick, error-free deployments.

Challenge: Configuring GitHub Actions to work seamlessly with AWS credentials required careful setup. However, once configured, it enabled a streamlined deployment process that adds significant value to the project.

# Lessons Learned

	•	CI/CD Integration: Setting up CI/CD to handle Infrastructure as Code significantly simplifies deployments and keeps the infrastructure in sync with code changes.
	•	Serverless Architecture: Using serverless components like Lambda, DynamoDB, and CloudFront provided me with a deeper understanding of AWS’s managed services and their cost efficiencies.
	•	Automation through Terraform: Writing infrastructure as code has been incredibly valuable for managing resources and scaling the architecture as needed.

# Conclusion

Creating this project was a rewarding experience, combining cloud technology with automation and CI/CD best practices. It was a fun learning experience that help me understand terraform better and how it helps automate the cloud. 