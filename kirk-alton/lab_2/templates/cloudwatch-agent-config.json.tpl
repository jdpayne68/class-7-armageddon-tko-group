{
  "agent": {
    "metrics_collection_interval": 30,
    "logfile": "/opt/aws/amazon-cloudwatch-agent/logs/amazon-cloudwatch-agent.log"
  },

  "metrics": {
    "append_dimensions": {
      "InstanceId": "$${aws:InstanceId}",
      "InstanceType": "$${aws:InstanceType}",
      "ImageId": "$${aws:ImageId}",
      "AutoScalingGroupName": "$${aws:AutoScalingGroupName}"
    },

    "metrics_collected": {
      "cpu": {
        "resources": ["*"],
        "measurement": [
          { "name": "cpu_usage_idle", "unit": "Percent" },
          { "name": "cpu_usage_user", "unit": "Percent" },
          { "name": "cpu_usage_system", "unit": "Percent" }
        ],
        "totalcpu": true,
        "metrics_collection_interval": 30
      },

      "mem": {
        "measurement": [
          "mem_used",
          "mem_available",
          "mem_total",
          "mem_used_percent"
        ],
        "metrics_collection_interval": 30
      },

      "disk": {
        "resources": ["/"],
        "measurement": ["used", "free", "total"],
        "metrics_collection_interval": 60
      },

      "net": {
        "resources": ["eth0"],
        "measurement": ["bytes_sent", "bytes_recv"],
        "metrics_collection_interval": 60
      }
    }
  },

  "logs": {
    "logs_collected": {
      "files": {
        "collect_list": [
          {
            "file_path": "/var/log/messages",
            "log_group_name": "/ec2-system-logs-${name_suffix}",
            "log_stream_name": "{instance_id}-messages",
            "timezone": "UTC"
          },
          {
            "file_path": "/opt/aws/amazon-cloudwatch-agent/logs/amazon-cloudwatch-agent.log",
            "log_group_name": "/aws/ec2/cloudwatch-agent/rds-app-${name_suffix}",
            "log_stream_name": "{instance_id}-agent",
            "timezone": "UTC"
          }
        ]
      }
    }
  }
}
