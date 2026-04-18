# ---------------------------------------------------------------------------
# LAMBDA — FIREHOSE PROCESSOR (NO-OP / PASS-THROUGH)
# ---------------------------------------------------------------------------
# This Lambda is a minimal, no-op Firehose processor that:
#   - Returns records unchanged
#   - Always responds with result="Ok"
#   - Enables future transformation logic without redesigning delivery stream
# ---------------------------------------------------------------------------


def handler(event, context):
    return {
        "records": [
            {
                "recordId": record["recordId"],
                "result": "Ok",
                "data": record["data"]
            }
            for record in event["records"]
        ]
    }

# ---------------------------------------------------------------------------
# NOTES
# ---------------------------------------------------------------------------
# For future enhancements consider:
#   - Filtering sensitive fields
#   - Log normalization
#   - Enrichment (GeoIP, tagging, correlation IDs)
#   - Error routing to DLQ
# ---------------------------------------------------------------------------
