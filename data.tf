#accesskey path
data "vault_generic_secret" "my_access_key" {
  path = "secret/mysecret"
}
#secretkey path 
data "vault_generic_secret" "my_secret_key" {
  path = "secret/mysecret"
  
}
