{pkgs, ...}:
{
    home.packages = with pkgs; [
        # Terminal
        termite                 # A simple VTE-based terminal
        termius                 # A cross-platform SSH client with cloud data sync and more
        wtf                     # The personal information dashboard for your terminal
        gh                      # GitHub CLI tool
        htop                    # An interactive process viewer
        neofetch                # A fast, highly customizable system info script
        # tmux                    # Terminal multiplexer
        which                   # Shows the full path of (shell) commands

        # Development
        jq                      # A lightweight and flexible command-line JSON processor
        git-crypt               # Transparent file encryption in git
        git-sizer               # Compute various size metrics for a Git repository
        lazygit                 # Simple terminal UI for git commands
        python39Full            # A high-level dynamically-typed programming language
        openssl_3               # A cryptographic library that implements the SSL and TLS protocols
        
        # Ops tools
        # awscli2                                 # Unified tool to manage your AWS services
        aws-vault                               # A vault for securely storing and accessing AWS credentials in development environments
        ansible                                 # Radically simple IT automation
        tflint                                  # Terraform linter focused on possible errors, best practices, and so on
        packer                                  # A tool for creating identical machine images for multiple platforms from a single source configuration
        helmfile                                # Deploy Kubernetes Helm charts
        terragrunt                              # A thin wrapper for Terraform that supports locking for Terraform state and enforces best practices
        terraform                               # Tool for building, changing, and versioning infrastructure
        krew                                    # Package manager for kubectl plugins
        kubectl                                 # Kubernetes CLI
        kubectx                                 # Fast way to switch between clusters and namespaces in kubectl!
        kubernetes-helm                         # A package manager for kubernetes
        # vagrant                                 # A tool for building complete development environments
        minikube                                # A tool that makes it easy to run Kubernetes locally
        docker-compose                          # Multi-container orchestration for Docker
        cloud-nuke                              # A tool for cleaning up your cloud accounts by nuking (deleting) all resources within it
    ];
}