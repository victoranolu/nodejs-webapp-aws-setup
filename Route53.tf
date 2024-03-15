resource "aws_route53_zone" "main" {
  name = "example.com" # insert the main web domain name here
}

resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "www.example.com" # Insert the domain name 
  type    = "A"
  ttl     = 300
  
  alias {
    name = aws_elastic_beanstalk_application.nodejs-app
    zone_id = aws_elastic_beanstalk_application.nodejs-app.zone_id
    evaluate_target_health = true
  }
}
