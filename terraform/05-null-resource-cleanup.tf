#Cleanup Temp Files 

resource "null_resource" "temp_file_janitor" {
  depends_on = [shipa_app.tf-app]
  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = <<EOT

#API Address
echo File Contents Redacted, Ready for Next Run > ${path.module}/api-address-temp.txt

#Token
echo File Contents Redacted, Ready for Next Run > ${path.module}/token.txt

#CA 
echo File Contents Redacted, Ready for Next Run > ${path.module}/cert.txt

#Format API Endpoint
echo File Contents Redacted, Ready for Next Run > ${path.module}/api-address-formatted.txt


EOT
  }
}
