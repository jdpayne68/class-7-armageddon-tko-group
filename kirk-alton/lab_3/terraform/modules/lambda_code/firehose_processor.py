# ---------------------------------------------------------------------------
# LAMBDA — FIREHOSE PROCESSOR (PASS-THROUGH)
# ---------------------------------------------------------------------------
# Minimal Firehose processor:
#   - Returns records unchanged
#   - Always responds with result="Ok"
#   - Enables future transformation without redesign
# ---------------------------------------------------------------------------


def handler(event, context):
    return {
        "records": [
            {
                "recordId": record["recordId"],
                "result": "Ok",
                "data": record["data"],
            }
            for record in event["records"]
        ]
    }


# ---------------------------------------------------------------------------
# NOTES — FUTURE ENHANCEMENTS
# ---------------------------------------------------------------------------
# - Filter sensitive fields
# - Normalize logs
# - Enrich data (GeoIP, tags, correlation IDs)
# - Route failures to DLQ
# ---------------------------------------------------------------------------