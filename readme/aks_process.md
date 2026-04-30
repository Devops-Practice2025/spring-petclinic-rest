## Certificate resource loading process and troubleshooting done while in the project
1. In Ingress resource annotate with lets encrypt 
2. use Cluster issuer as lets encrypt and url to reach it and http01 resolver as nginx so it understands to use nginx ingress contoller
3. First ingress reaches cert manager intern it will go to lets encrypt to issue a certificate.
4. tls secret resource in ingress will store the certificate received from lets encrypt
5. Solver resource will be created as a pod and gets exposed with ingress 
6. With the secret being exposed as 