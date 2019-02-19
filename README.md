# Token POC

This POC shows a simple demonstration of forthcoming support for API keys in Ambassador Pro. In this demo, long-lived API keys are sent by the client. These API keys are then exchanged for short-lived API keys. These short-lived API keys are cached for performance. This enables Ambassador Pro users to easily write business logic around token validation and invalidation without impacting scalability and performance.

## Quick start

1. Create the `ambassador-pro-registry-credentials` secret in your cluster, if you haven't done so already.
2. Add your license key to the `ambassador-pro.yaml` file.
3. Apply all the YAML in the cluster in order:
   
   ```
   kubectl apply -f ambassador-pro.yaml
   kubectl apply -f ambassador-pro-auth.yaml
   kubectl apply -f ambassador-service.yaml
   kubectl apply -f authenticate.yaml
   kubectl apply -f hello.yaml
   kubectl apply -f hello-policy.yaml
   ```

4. Get the IP address of your LoadBalancer: `kubectl get svc ambassador`

5. `curl` to the load balancer with a simulated API key, e.g.,

   ```
   curl $IP/hello/ -H "Authorization: foo"
   curl $IP/hello/ -H "Authorization: bar"
   curl $IP/hello/ -H "Authorization: baz"
   ```

   The supplied authorization token is intercepted and replaced by a "short-lived API key" (currently hard-coded to "Yay!").

## Behind the scenes

* The caching & authentication management functionality is encapsulated in `token-plugin` as part of Ambassador Pro.

* `token-plugin` delegates to a custom `authenticate.go` service that contains business logic. A sample `authenticate.go` service is included in this repository.

* The custom `authenticate.go` service is supplied with the original token, and
  therefore has the option to check for revocation, etc.

* If the original token is still considered valid, it returns a
  short-lived token and a timeout.

* `token-plugin` caches the short-lived token for the duration of
  the timeout.

* This design is intended to allow the `authenticate.go` service to
  capture business logic around token invalidation and the like
  without impacting critical path authentication performance. The
  sample implementation includes a 250ms simulated processing delay
  and a 30 second timeout by default. These values can be tweaked by
  changing the environment variables specified in the
  `authenticate.yaml` deployment.

* The supplied Makefile can be used to update/play with hello.go
  and/or authenticate.go: `make DOCKER_REGISTRY=...`, and then update
  `authenticate.yaml` and/or `hello.yaml` to point to the new image.
