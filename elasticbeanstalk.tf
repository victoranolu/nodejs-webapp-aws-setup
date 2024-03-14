#Setting an IAM role
resource "aws_iam_role" "iam_role" {
  name = "instance_role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

#Setting up IAM profile role to permit the provisioning of Instances
resource "aws_iam_instance_profile" "Instance-prod" {
  name = "instance-iam"
  role = aws_iam_role.role.name
} 

#Setting up the application
resource "aws_elastic_beanstalk_application" "nodejs-app" {
  name        = "LF-nodejs"
  description = "Elastic beanstalk app for nodejs"

  appversion_lifecycle {
    service_role          = aws_iam_role.beanstalk_service.arn
  }
}

#Setting up the application environment
resource "aws_elastic_beanstalk_environment" "nodejs-env" {
  name                = "LF-nodejs-env"
  application         = aws_elastic_beanstalk_application.nodejs-app.name
  solution_stack_name = "64bit Amazon Linux 2023 v6.1.1 running Node.js 18"
  tier = "WebServer"
  version_label = aws_elastic_beanstalk_application.nodejs-app.name
  setting {
    namespace = "aws:autoscaling:asg"
    name = "Availability Zones"
    value = "Any"
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name = "Cooldown"
    value = "450"
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name = "MinSize"
    value = "1"
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name = "MaxSize"
    value = "3"
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name =
    value = 
  }

}