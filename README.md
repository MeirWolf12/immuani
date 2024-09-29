
# Terraform AWS Network Architecture

## Project Overview

This project sets up an AWS network infrastructure using Terraform, featuring:

- **Two isolated VPCs**: Each VPC represents a separate project (Project A and Project B).
- **VPC Peering**: Allows secure, private communication between the two VPCs.
- **Security Groups**: Control access to instances, ensuring that only necessary traffic is allowed based on Zero Trust principles.
- **Transit Gateway** (optional): Provides a scalable solution for managing multiple VPCs in the future.

The setup ensures secure east-west traffic (internal communication) and provides the flexibility to scale the network.

## Architecture Diagram

The diagram below illustrates the cloud network architecture:

```
    +-------------------------------+
    |        Transit Gateway         |
    +-------------------------------+
                 |
    +------------+------------+
    |                         |
+---+---+                 +---+---+
| VPC A |                 | VPC B |
|       |                 |       |
|       |                 |       |
| Subnet|                 | Subnet|
+-------+                 +-------+
    |                         |
    +---------VPC Peering------+
```

### Components:

- **VPC A and VPC B**: Isolated networks, each with its own subnet and security group.
- **VPC Peering**: Establishes internal, private communication between the two VPCs.
- **Transit Gateway** (optional): Facilitates future VPC expansions for multi-region or multi-VPC architectures.

## File Breakdown

- `main.tf`: The main configuration file that initializes AWS as the provider and integrates the other files.
- `vpc.tf`: Defines VPCs, subnets, and networking components.
- `peering.tf`: Configures VPC Peering between VPC A and VPC B.
- `security_groups.tf`: Sets up Security Groups to control traffic into and out of the VPCs.
- `transit_gateway.tf`: (Optional) Configures a Transit Gateway for managing traffic between multiple VPCs.
- `outputs.tf`: Displays resource outputs like VPC and Peering IDs.

## How to Use

1. **Install Terraform**: Ensure you have Terraform installed. You can download it [here](https://www.terraform.io/downloads.html).

2. **Initialize the project**: Run the following command to initialize the Terraform environment:

   ```bash
   terraform init
   ```

3. **Apply the configuration**: To create the AWS infrastructure, execute:

   ```bash
   terraform apply
   ```

   You will be prompted to confirm. Type `yes` to apply the configuration.

4. **Review Outputs**: After the resources are created, Terraform will output the VPC IDs, Peering connection ID, and optionally, the Transit Gateway ID.

## Requirements

- **Terraform CLI**
- **AWS Account** with the necessary permissions (VPC, EC2, Transit Gateway)
- **AWS CLI** configured with credentials

## Diagram Explanation

- **VPC A and VPC B**: Represent isolated environments, each with its own public subnet.
- **VPC Peering**: Enables secure, internal communication between VPC A and VPC B.
- **Transit Gateway**: Provides a centralized, scalable routing hub for interconnecting multiple VPCs.

## Next Steps

You can extend this architecture by:
- Adding more VPCs and subnets.
- Connecting VPCs from different regions using the Transit Gateway.
- Implementing more granular security policies using AWS Network ACLs and additional Security Groups.
