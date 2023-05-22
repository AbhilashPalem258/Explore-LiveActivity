export TEAM_ID=27699ZW9VR
export TOKEN_KEY_FILE_NAME=/Users/abhilashpalem/Desktop/Explore-LiveActivity/AuthKey_AMCPC592X8.p8
export AUTH_KEY_ID=AMCPC592X8
export DEVICE_TOKEN=80aeb0120895618ec1ff522b5c0b0272a607135b8241c9738578db21c1615cfd1ca7d9c064efb8d50bf74a2b7c291a2baf80fae70d4b7ae9c4f50c6f525efc50f879763a9c187a30704ed159e98afe64
export APNS_HOST_NAME=api.sandbox.push.apple.com


export JWT_ISSUE_TIME=$(date +%s)
export JWT_HEADER=$(printf '{ "alg": "ES256", "kid": "%s" }' "${AUTH_KEY_ID}" | openssl base64 -e -A | tr -- '+/' '-_' | tr -d =)
export JWT_CLAIMS=$(printf '{ "iss": "%s", "iat": %d }' "${TEAM_ID}" "${JWT_ISSUE_TIME}" | openssl base64 -e -A | tr -- '+/' '-_' | tr -d =)
export JWT_HEADER_CLAIMS="${JWT_HEADER}.${JWT_CLAIMS}"
export JWT_SIGNED_HEADER_CLAIMS=$(printf "${JWT_HEADER_CLAIMS}" | openssl dgst -binary -sha256 -sign "${TOKEN_KEY_FILE_NAME}" | openssl base64 -e -A | tr -- '+/' '-_' | tr -d =)
export AUTHENTICATION_TOKEN="${JWT_HEADER}.${JWT_CLAIMS}.${JWT_SIGNED_HEADER_CLAIMS}"

//timestamp: https://www.epochconverter.com/
/*
- The event here can be update or end
*/

curl -v \
--header "apns-topic:com.shuttl.ios.push-type.liveactivity" \
--header "apns-push-type:liveactivity" \
--header "authorization: bearer $AUTHENTICATION_TOKEN" \
--data \
'{har
    "aps": {
        "timestamp": 1670915007,
        "event": "update",
        "content-state": {
            "rideMessage": "Relax, Everything is as per schedule",
            "etaText": "38 Min"
        },
        "alert": {
            "title": "Live activity title",
            "subtitle": "Live activity subtitle",
            "body": "Your pizza order will arrive soon.",
        }
    }
}' \
--http2 \
https://${APNS_HOST_NAME}/3/device/$DEVICE_TOKEN
