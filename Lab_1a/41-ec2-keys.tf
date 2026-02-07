# Uncomment and update with your local key information to register your key

# # Register Public Key with AWS
# resource "aws_key_pair" "armageddon-tko-key-pair.pem" {
#   key_name   = "armageddon-tko-key-pair.pem"
#   public_key = file("~/.ssh/armageddon-tko-key-pair.pem")

#   tags = {
#     Name      = "armageddon-tko-key-pair"
#     Component = "access"
#   }
# }

resource "aws_key_pair" "armageddon_tko_key_pair" {
  key_name   = "armageddon-tko-key-pair.pem"
  public_key = file(pathexpand("~/.ssh/armageddon-tko-key-pair.pub"))

    tags = {
        Name      = "armageddon-tko-key-pair"
        Component = "access"
    }
}
