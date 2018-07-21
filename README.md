# Docker Cluster Bootstrap

An attempt to automate creating a Docker Cluster using Infrastructure as Code.
Built with Packer and Terraform.

The current version only supports deployments on AWS.

## Getting Started

TODO

### Prerequisites

Make sure you have both [Terraform](https://www.terraform.io/intro/getting-started/install.html) and [Packer](https://www.packer.io/intro/getting-started/install.html) installed.

## Usage

Create a `variables.json` file in the `image/` directory with the following content:
``` json
{
    "aws_access_key": "your-access-key",
    "aws_secret_key": "your-secret-key"
}
```

Validate the setup with:
``` bash
packer validate -var-file image/variables.json docker.json
```

Create and push the image with the following command:
``` bash
packer 
```

## Contributing

Please read [CONTRIBUTING.md](https://gist.github.com/PurpleBooth/b24679402957c63ec426) for details on our code of conduct, and the process for submitting pull requests to us.

## Versioning

We use [SemVer](http://semver.org/) for versioning. For the versions available, see the [tags on this repository](https://github.com/your/project/tags). 

## Authors

* **Tijmen Wierenga** - *Owner* - [PurpleBooth](https://github.com/TijmenWierenga)

See also the list of [contributors](https://github.com/your/project/contributors) who participated in this project.

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details
