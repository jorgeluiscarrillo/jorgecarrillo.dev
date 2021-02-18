# jorgecarrillo.dev

[![Website](https://img.shields.io/website?down_color=lightgrey&down_message=offline&up_color=green&up_message=up&url=https%3A%2F%2Fwww.jorgecarrillo.dev)](https://www.jorgecarrillo.dev)
[![Hugo Deploy S3](https://github.com/jorgeluiscarrillo/jorgecarrillo.dev/workflows/Hugo%20Deploy%20S3/badge.svg)](https://github.com/jorgeluiscarrillo/jorgecarrillo.dev/actions)

This is my personal website built with [Hugo](https://gohugo.io). My goal was to create a fast, secure site with automated builds and deployments to be able to manage the site through code and the CLI.

### Infrastructure

My website is hosted on Amazon S3. S3 does not support HTTPS when configured as a website endpoint, so it is best to serve its content through a CDN like [Amazon CloudFront](https://aws.amazon.com/cloudfront/) or [Cloudflare](https://www.cloudflare.com/). For my use case, I decided that Cloudflare was a better option since it provides the essential performance and security features for free (caching/optimizations, SSL, DDoS  protection).

I use [Terraform](https://www.terraform.io/) to create and manage my infrastructure on AWS and Cloudflare. Not only is my infrastructure cleanly documented in code (check the `terraform` directory), but it also saves me from having to go around navigating in the AWS console.

### Deploy

I wanted to avoid having to manually update files on S3 each time I wanted to edit the content of my website. I was able to accomplish an automated deployment using GitHub Actions and Hugo's built-in [deploy](https://gohugo.io/hosting-and-deployment/hugo-deploy/) feature. Each time I push to this repository, a GitHub [workflow](https://github.com/jorgeluiscarrillo/jorgecarrillo.dev/blob/master/.github/workflows/hugo-deploy-s3.yml) runs automatically which builds the website files and deploys them to the S3 website bucket in a matter of seconds.