# www.jorgecarrillo.dev

![Website](https://img.shields.io/website?down_color=lightgrey&down_message=offline&up_color=green&up_message=up&url=https%3A%2F%2Fwww.jorgecarrillo.dev)
![Hugo Deploy S3](https://github.com/jorgeluiscarrillo/jorgecarrillo.dev/workflows/Hugo%20Deploy%20S3/badge.svg)

This is my personal website. My goal was to create a fast, secure site with automated builds and deployments to be able to manage the site through code and the CLI. Additionally, I wanted to achieve all of this while keeping hosting costs as low as possible.

### Infrastructure

- Amazon S3
    - Supports static website hosting at a very low cost
- Cloudflare (DNS & CDN)
    - Caches and optimizes the contents of my website on servers around the world to reduce latency and time for visitors (Free)
    - Provides HTTPS access to S3 and DDoS protection (Free)

I use [Terraform](https://www.terraform.io/) to create and manage my infrastructure on AWS and Cloudflare. Not only is my infrastructure cleanly documented in code, but it also saves me from having to go around navigating in the AWS console.

### Build

My website is built with [Hugo](https://gohugo.io). To maximize performance, I wanted my website built with basic HTML/CSS and without JavaScript. Therefore, Hugo was an obvious choice since it generates these files for me with little configuration needed.

### Deploy

I wanted to avoid having to manually update files on S3 each time I wanted to edit the content of my website. I was able to accomplish an automated deployment using GitHub Actions and Hugo's built-in [deploy](https://gohugo.io/hosting-and-deployment/hugo-deploy/) feature. Each time I push to this repository, a GitHub workflow is ran automatically which builds the website files and deploys them to the S3 website bucket.