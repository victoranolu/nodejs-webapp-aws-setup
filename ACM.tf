#resource "aws_acm_certificate" "example" {
  #domain_name               = "example.com"
 # subject_alternative_names = ["www.example.com"]
  #validation_method         = "DNS"
#}

#data "aws_route53_zone" "main" {
 # name         = "example.com"
  #private_zone = false
#}

#data "aws_route53_record" "www" {
 # for_each = {
  #  for dvo in aws_acm_certificate.example.domain_validation_options : dvo.domain_name => {
   #   name    = dvo.resource_record_name
    #  record  = dvo.resource_record_value
     # type    = dvo.resource_record_type
      #zone_id = dvo.domain_name == "example.com" ? data.aws_route53_zone.example_com.zone_id : data.aws_route53_zone.example_com.zone_id
    #}
  #}

  #allow_overwrite = true
 ##records         = [each.value.record]
 # ttl             = 60
 # type            = each.value.type
 # zone_id         = each.value.zone_id
#}

#resource "aws_acm_certificate_validation" "example" {
 # certificate_arn         = aws_acm_certificate.example.arn
  #validation_record_fqdns = [for record in aws_route53_record.example : record.fqdn]
#}