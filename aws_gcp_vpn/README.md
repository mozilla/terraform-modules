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

## Exporting peer VPN network routes to AWS

If you'd like to connect to a service using VPC networking peering, such as CloudSQL, [follow the steps](https://cloud.google.com/sql/docs/mysql/configure-private-ip#vpn) to export custom routes and then create a custom route advertisement for that range.

<!-- BEGIN_TF_DOCS -->


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_private_asn"></a> [aws\_private\_asn](#input\_aws\_private\_asn) | ASN for AWS VPN gateway | `number` | n/a | yes |
| <a name="input_aws_vpc_id"></a> [aws\_vpc\_id](#input\_aws\_vpc\_id) | AWS VPC id | `string` | n/a | yes |
| <a name="input_aws_vpn_gateway_id"></a> [aws\_vpn\_gateway\_id](#input\_aws\_vpn\_gateway\_id) | AWS VPN Gateway ID | `string` | n/a | yes |
| <a name="input_gcp_advertised_ip_ranges"></a> [gcp\_advertised\_ip\_ranges](#input\_gcp\_advertised\_ip\_ranges) | value | `set(object({ description = string, range = string }))` | `[]` | no |
| <a name="input_gcp_network_name"></a> [gcp\_network\_name](#input\_gcp\_network\_name) | GCP VPN network name | `string` | `"default"` | no |
| <a name="input_gcp_private_asn"></a> [gcp\_private\_asn](#input\_gcp\_private\_asn) | ASN for GCP VPN gateway | `number` | n/a | yes |
| <a name="input_gcp_project_id"></a> [gcp\_project\_id](#input\_gcp\_project\_id) | GCP project id | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
