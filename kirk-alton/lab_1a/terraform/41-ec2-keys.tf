# # Uncomment and update with your local key information to register your key

# # # Register Public Key with AWS
# resource "aws_key_pair" "tf_armageddon_key" {
#   key_name   = "tf-armageddon-key"
#   public_key = file("~/.ssh/tf-armageddon-key.pub")

#   tags = {
#     Name      = "tf-armageddon-key"
#     Component = "access"
#   }
# }