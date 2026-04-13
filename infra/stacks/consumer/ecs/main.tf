data "aws_region" "current" {}

# ECR

module "ecr" {
  source = "../../../modules/ecr"

  name_prefix = var.name_prefix
}

# ECS Cluster

module "cluster" {
  source = "../../../modules/ecs/cluster"

  name_prefix = var.name_prefix
}

# CloudWatch Logs

module "log_group" {
  source = "../../../modules/cloudwatch/log-group"

  name_prefix = var.name_prefix
}

# Task Execution Role

data "aws_iam_policy_document" "ecs_task_execution_assume" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_task_execution" {
  name               = "${var.name_prefix}-ecs-task-execution-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_execution_assume.json
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# ECS Service

module "service" {
  source = "../../../modules/ecs/service"

  name_prefix        = var.name_prefix
  cluster_id         = module.cluster.id
  execution_role_arn = aws_iam_role.ecs_task_execution.arn
  image              = "${module.ecr.repository_url}:latest"
  container_name     = var.name_prefix
  subnet_ids         = var.subnet_ids
  security_group_ids = [var.ecs_security_group_id]
  log_group_name     = module.log_group.name
  region             = data.aws_region.current.name
}
