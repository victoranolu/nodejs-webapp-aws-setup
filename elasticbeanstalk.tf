#Setting an IAM role
resource "aws_iam_role" "iam_role" {
  name = "instance_role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
        {
            Action = "sts:AssumeRole"
            Effect = "Allow",
            Principal = {
                Service = "ec2.amazonaws.com"
            },
            
        }
    ]
})
}

#Setting up IAM profile role to permit the provisioning of Instances
resource "aws_iam_instance_profile" "Instance-prod" {
  name = "instance-iam"
  role = aws_iam_role.iam_role.name
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
    name = "IaminstanceProfile"
    value = aws_iam_instance_profile.Instance-prod
  }

  setting {
    namespace = "aws:ec2:instances"
    name = "InstanceTypes"
    value = "t3.micro"
  }

  # Here we enable a health check path for the nodejs app 
  #setting {
    #namespace = "aws:elasticbeanstalk:application"
    #name = "Application Healthcheck URL"
    #value = "HTTPS:443/health"
  #}

  setting {
    namespace = "aws:elasticbeanstalk:command"
    name = "DeploymentPolicy"
    value = "AllAtOnce"
  }

  setting {
    namespace = "aws:elasticbeanstalk:command"
    name = "IgnoreHealthCheck"
    value = "false"
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name = "EnvironmentType"
    value = "LoadBalanced"
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name = "LoadBalancerType"
    value = "application"
  }

  # Here another place to put a health check path 
  #setting {
    #namespace = "aws:elasticbeanstalk:environment:process:default"
    #name = "HealthCheckPath"
    #value = "/"
  #}

  setting {
    namespace = "aws:elasticbeanstalk:environment:process:process_name"
    name = "Port"
    value = "80"
  }

   setting {
    namespace = "aws:elasticbeanstalk:environment:process:process_name"
    name = "Port"
    value = "443"
  }

  setting {
    namespace = "aws:elasticbeanstalk:managedactions:platformupdate"
    name = "UpdateLevel"
    value = "patch"
  }

  setting {
    namespace = "aws:elasticbeanstalk:managedactions:platformupdate"
    name = "UpdateLevel"
    value = "minor"
  }

  # Insert the certificate from AWS ACM
  #setting {
    #namespace = "aws:elbv2:listener:default"
    #name = "SSLCerticateArns"
    #value = "aws_acm_certificate_validation.example.certificate_arn"
  #}

  setting {
    namespace = "aws:elbv2:listener:listener_port"
    name = "ListenerProtocol"
    value = "HTTPS"
  }

  setting {
    namespace = "aws:elbv2:listener:listener_port"
    name = "InstanceProtocol"
    value = "HTTPS"
  }

  setting {
    namespace = "aws:elbv2:listener:listener_port"
    name = "ListenerEnabled"
    value = "true"
  }
}