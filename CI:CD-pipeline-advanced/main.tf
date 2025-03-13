provider "aws" {        #Chooses provider and sets region
  region = "us-east-2"
}
resource "aws_eks_cluster" "my-cluster" {  #Creates EKS cluster
    name = "lucidtech-cluster"  #Name of the cluster
    role_arn = aws_iam_role.eks_cluster_role.arn    #Role ARN

    vpc_config {    #VPC configuration
        subnet_ids = ["subnet-0946aae8f37d00c19", "subnet-00e58e2f9647b3942"]  #Subnet ID
    }
    depends_on = [aws_iam_role_policy_attachment.eks_cluster_policy]   #Depends on IAM role policy attachment
}

resource "aws_iam_role" "eks_cluster_role" {  #IAM role for EKS cluster
    name = "lucidtech-cluster-role"    #Name of the role
    assume_role_policy = jsonencode ({  #Policy file
        Version = "2012-10-17"    #Version
        Statement = [   #Statement
            {  
                Effect = "Allow"    
                Principal = {
                    Service = "eks.amazonaws.com"   
                }
                Action = "sts:AssumeRole"
            }
        ]
    })  
}
resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
 policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"  #Policy ARN
 role = aws_iam_role.eks_cluster_role.name    #Role name 
}
