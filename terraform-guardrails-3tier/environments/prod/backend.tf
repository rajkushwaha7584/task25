terraform {

  backend "local" {

    path = "terraform.tfstate"

  }

}

# Later we'll replace this with:

# S3 Backend
# DynamoDB State Locking

# This is how companies normally work, but we'll first build everything locally.