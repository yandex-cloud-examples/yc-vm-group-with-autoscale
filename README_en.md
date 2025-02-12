# Running an instance group with autoscaling in Yandex Compute Cloud using Network Load Balancer

Using this [Terraform](https://www.terraform.io/) configuration, you will deploy an [instance group with an autoscaling policy](https://cloud.yandex.ru/docs/compute/concepts/instance-groups/scale#auto-scale) to apply if the load limit is exceeded.

VM instances will be deployed in two availability zones, with the load distributed using [Yandex Network Load Balancer](https://cloud.yandex.ru/docs/network-load-balancer/concepts/).

For more information about the provider resources, see the documentation on the [Terraform](https://www.terraform.io/docs/providers/yandex/index.html) website or [its mirror](https://terraform-provider.yandexcloud.net).

If you modify the configuration files, Terraform automatically detects which part of your configuration is already deployed and what should be added or removed.

For a detailed tutorial, see [Running an instance group with autoscaling](https://yandex.cloud/ru/docs/tutorials/infrastructure-management/vm-autoscale).

To set up scaling for your instance group using Terraform:

1. [Install Terraform](https://cloud.yandex.ru/docs/tutorials/infrastructure-management/terraform-quickstart#install-terraform) and specify the source for installing the Yandex Cloud provider (see [Configure a provider](https://cloud.yandex.ru/docs/tutorials/infrastructure-management/terraform-quickstart#configure-provider), _Step 1_).

1. Prepare files with the infrastructure description:
    1. Clone the repository with Terraform configuration files:
        
        ```bash
        git clone https://github.com/yandex-cloud-examples/yc-vm-group-with-autoscale.git
        ```

    1. Go to the directory with the repository. Make sure it contains the following files:
        - `vm-autoscale.tf`: New infrastructure configuration.
        - `declaration.yaml`: Description of the Docker container with a web server that will run on the VM to simulate load on the service.
        - `config.tpl`: Description of VM user parameters.
        - `vm-autoscale.auto.tfvars`: User data.

    For more information about the parameters of resources used in Terraform, see the relevant provider documentation:
    - [yandex_iam_service_account](https://terraform-provider.yandexcloud.net/Resources/iam_service_account)
    - [yandex_resourcemanager_folder_iam_member](https://terraform-provider.yandexcloud.net/Resources/resourcemanager_folder_iam_member)
    - [yandex_vpc_network](https://terraform-provider.yandexcloud.net/Resources/vpc_network)
    - [yandex_vpc_subnet](https://terraform-provider.yandexcloud.net/Resources/vpc_subnet)
    - [yandex_vpc_security_group](https://terraform-provider.yandexcloud.net/Resources/vpc_security_group)
    - [yandex_compute_instance_group](https://terraform-provider.yandexcloud.net/Resources/compute_instance_group)
    - [yandex_lb_network_load_balancer](https://terraform-provider.yandexcloud.net/Resources/lb_network_load_balancer)

1. In the `vm-autoscale.auto.tfvars` file, set the following user-defined properties:
    - `folder_id`: [Folder](https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id) ID.
    - `vm_user`: VM user name.
    - `ssh_key`: Contents of the file with a public SSH key to authenticate the user on the VM. For details, see [Creating an SSH key pair](https://cloud.yandex.ru/docs/compute/operations/vm-connect/ssh#creating-ssh-keys).

1. Create resources:
    1. In the terminal, navigate to the directory containing the downloaded repository.
    1. Make sure the configuration file is correct using this command:

        ```bash
        terraform validate
        ```

        If the configuration is correct, you will get this message:

        ```bash
        Success! The configuration is valid.
        ```

    1. Run this command:

        ```bash
        terraform plan
        ```

        The terminal will display a list of resources with parameters. No changes will be made at this step. If there are errors in the configuration, Terraform will point them out.
    1. Apply the configuration changes:

        ```bash
        terraform apply
        ```

    1. Confirm the changes: type `yes` into the terminal and press **Enter**.
1. [Test your instance group and network load balancer](https://cloud.yandex.ru/docs/tutorials/infrastructure-management/vm-autoscale#check-service).
1. [Test auto scaling](https://cloud.yandex.ru/docs/tutorials/infrastructure-management/vm-autoscale#check-highload).
