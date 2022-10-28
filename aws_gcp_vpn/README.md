# aws_gcp_vpn

Setup a VPN between AWS & GCP

Implements https://medium.com/peek-travel/connecting-an-aws-and-gcp-vpc-using-an-ipsec-vpn-tunnel-with-bgp-f332c2885975

## Pre-apply configuration

Before you apply this module you'll need to create a VPN Gateway in AWS with the following configuration:

```
resource "aws_vpn_gateway" "default" {
  amazon_side_asn = var.aws_private_asn
  vpc_id          = var.aws_vpc_id

  tags = {
    Name = "aws-to-gcp-vpg"
  }
}
```

You'll also need to turn on Route Propagation in the routing table for this VPC
