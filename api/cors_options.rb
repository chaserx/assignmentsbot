require 'json'

# NOTE(chaserx): running SAM local start-api doesn't honor the API CORS config settings
#   so, this method for the OPTIONS request does that for us.
#   the downside is that the repeated configuration for every endpoint to call this method.
#
def handler(event:, context:)
  {
    statusCode: 200,
    headers: {
      "X-Requested-With": "*",
      "Access-Control-Allow-Headers": "Content-Type,X-Amz-Date,Authorization,X-Api-Key,x-requested-with",
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Methods": "POST,GET,OPTIONS"
    },
    body: ""
  }
end
