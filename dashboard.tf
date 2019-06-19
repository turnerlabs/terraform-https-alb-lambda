/**
 * This module creates a CloudWatch dashboard for you app,
 * showing its CPU and memory utilization and various HTTP-related metrics.
 *
 * The graphs of HTTP requests are stacked.  Green indicates successful hits
 * (HTTP response codes 2xx), yellow is used for client errors (HTTP response
 * codes 4xx) and red is used for server errors (HTTP response codes 5xx).
 * Stacking is used because, when things are running smoothly, those graphs
 * will be predominately green, making the dashboard easier to check
 * at a glance or at a distance.
 *
 */

resource "aws_cloudwatch_dashboard" "cloudwatch_dashboard" {
  dashboard_name = "${local.ns}"

  dashboard_body = <<EOF
{
  "widgets": [
    {
      "type": "metric",
      "x": 12,
      "y": 0,
      "width": 12,
      "height": 6,
      "properties": {
        "metrics": [
          [
            "AWS/Lambda",
            "Throttles",
            "FunctionName",
            "${aws_lambda_function.lambda.id}",
            { "color": "#ff7f0e", "stat": "Average", "period": 60 }
          ],
          [
            ".",
            "Invocations",
            ".",
            ".",
            { "color": "#2ca02c", "stat": "Average", "period": 60 }
          ],
          [
            ".",
            "Errors",
            ".",
            ".",
            { "period": 60, "stat": "Average", "color": "#d62728" }
          ]
        ],
        "view": "timeSeries",
        "stacked": false,
        "region": "${var.region}",
        "period": 300,
        "title": "Lambda",
        "yAxis": {
          "left": {
            "min": 0,
            "max": 100
          }
        }
      }
    },
    {
      "type": "metric",
      "x": 0,
      "y": 6,
      "width": 12,
      "height": 6,
      "properties": {
        "view": "timeSeries",
        "stacked": false,
        "metrics": [
          [
            "AWS/ApplicationELB",
            "TargetResponseTime",
            "LoadBalancer",
            "${aws_alb.main.arn_suffix}",
            { "period": 60, "stat": "p50" }
          ],
          ["...", { "period": 60, "stat": "p90", "color": "#c5b0d5" }],
          ["...", { "period": 60, "stat": "p99", "color": "#dbdb8d" }]
        ],
        "region": "${var.region}",
        "period": 300,
        "yAxis": {
          "left": {
            "min": 0,
            "max": 3
          }
        },
        "title": "Function response times"
      }
    },
    {
      "type": "metric",
      "x": 0,
      "y": 0,
      "width": 12,
      "height": 6,
      "properties": {
        "view": "timeSeries",
        "stacked": true,
        "metrics": [
          [
            "AWS/ApplicationELB",
            "HTTPCode_Target_5XX_Count",
            "LoadBalancer",
            "${aws_alb.main.arn_suffix}",
            { "period": 60, "stat": "Sum", "color": "#d62728" }
          ],
          [
            ".",
            "HTTPCode_Target_4XX_Count",
            ".",
            ".",
            { "period": 60, "stat": "Sum", "color": "#bcbd22" }
          ],
          [
            ".",
            "HTTPCode_Target_3XX_Count",
            ".",
            ".",
            { "period": 60, "stat": "Sum", "color": "#98df8a" }
          ],
          [
            ".",
            "HTTPCode_Target_2XX_Count",
            ".",
            ".",
            { "period": 60, "stat": "Sum", "color": "#2ca02c" }
          ]
        ],
        "region": "${var.region}",
        "title": "Load balancer responses",
        "period": 300,
        "yAxis": {
          "left": {
            "min": 0
          }
        }
      }
    },
    {
      "type": "metric",
      "x": 12,
      "y": 6,
      "width": 12,
      "height": 6,
      "properties": {
        "metrics": [
          [
            "AWS/Lambda",
            "Throttles",
            "FunctionName",
            "${aws_lambda_function.lambda.id}",
            {
              "color": "#ff7f0e",
              "stat": "Average",
              "period": 60,
              "visible": false
            }
          ],
          [
            ".",
            "Invocations",
            ".",
            ".",
            {
              "color": "#2ca02c",
              "stat": "Average",
              "period": 60,
              "visible": false
            }
          ],
          [
            ".",
            "Duration",
            ".",
            ".",
            { "color": "#9467bd", "stat": "Average", "period": 60 }
          ]
        ],
        "view": "timeSeries",
        "stacked": false,
        "region": "${var.region}",
        "period": 300,
        "title": "Function Duration",
        "yAxis": {
          "left": {
            "min": 0,
            "max": 100
          }
        }
      }
    }
  ]
}
EOF
}
