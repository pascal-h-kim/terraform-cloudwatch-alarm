terraform {
  source = "../../../../../../../../SERVICE/cloudwatch/metric/alarm/expression_multiple_dimension"
}

include {
  path = "${find_in_parent_folders()}"
}

dependency "sns_topic_alb" {
  config_path = "../../../../sns/alarm-to-slack/alb"
}

inputs = {
  alarm_name          = "[jarvis-learning] Error Rate"
  alarm_description   = "[jarvis-learning] Error Rate"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  unit                = "Count"
  period              = 300
  datapoints_to_alarm = 1

  cw_namespace        = "AWS/ApplicationELB"
  statistic           = "Sum"

  query = {
    id                = "e1"
    expression        = "(m2/(m3+0.1))*100"
    label             = "Error Rate"
  }
  metric_query = [
    {
      metric_name     = "HTTPCode_Target_4XX_Count"
      dimension       = {
        TargetGroup   = "targetgroup/jarvis-learning-prd/eeb18052bb4e7272"
        LoadBalancer  = "app/jarvis-learning-prd/f1c7dc12242fb662"
      }
    },
    {
      metric_name     = "HTTPCode_Target_5XX_Count"
      dimension       = {
        TargetGroup   = "targetgroup/jarvis-learning-prd/eeb18052bb4e7272"
        LoadBalancer  = "app/jarvis-learning-prd/f1c7dc12242fb662"
      }
    },
    {
      metric_name     = "RequestCount"
      dimension       = {
        TargetGroup   = "targetgroup/jarvis-learning-prd/eeb18052bb4e7272"
        LoadBalancer  = "app/jarvis-learning-prd/f1c7dc12242fb662"
      }
    }
  ]

  # enable_info              = false
  # threshold_info           = 0
  # ok_actions_info          = false
  # alarm_actions_info       = []
  
  # enable_warn              = false
  # threshold_warn           = 0
  # ok_actions_warn          = false
  # alarm_actions_warn       = [dependency.sns_topic_alb.outputs.sns_topic_arn]

  enable_crit              = true
  threshold_crit           = 10
  ok_actions_crit          = true
  alarm_actions_crit       = [dependency.sns_topic_alb.outputs.sns_topic_arn]

}

