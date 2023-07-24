# Работа с группой виртуальных машин с автоматическим масштабированием

С помощью представленной конфигурации для [Terraform](https://www.terraform.io/) вы развернете [группу ВМ с политикой автоматического масштабирования](https://cloud.yandex.ru/docs/compute/concepts/instance-groups/scale#auto-scale) при превышении допустимой нагрузки.

ВМ будут развернуты в двух зонах доступности, а нагрузка на них будет регулироваться с помощью [сетевого балансировщика нагрузки](https://cloud.yandex.ru/docs/network-load-balancer/concepts/) Yandex Network Load Balancer.

Terraform позволяет быстро создать облачную инфраструктуру в Yandex Cloud и управлять ею с помощью файлов конфигураций. В файлах конфигураций хранится описание инфраструктуры на языке HCL (HashiCorp Configuration Language). Terraform и его провайдеры распространяются под лицензией [Mozilla Public License](https://github.com/hashicorp/terraform/blob/main/LICENSE). 

Подробную информацию о ресурсах провайдера смотрите в документации на сайте [Terraform](https://www.terraform.io/docs/providers/yandex/index.html) или в [зеркале](https://terraform-provider.yandexcloud.net).

При изменении файлов конфигураций Terraform автоматически определяет, какая часть вашей конфигурации уже развернута, что следует добавить или удалить.

Чтобы настроить масштабирование группы ВМ с помощью Terraform:

1. [Установите Terraform](https://cloud.yandex.ru/docs/tutorials/infrastructure-management/terraform-quickstart#install-terraform) и укажите источник для установки провайдера Yandex Cloud (раздел [Настройте провайдер](https://cloud.yandex.ru/docs/tutorials/infrastructure-management/terraform-quickstart#configure-provider), шаг 1).

1. Подготовьте файлы с описанием инфраструктуры:
    1. Склонируйте репозиторий с файлами конфигурации для Terraform:
        
        ```bash
        git clone https://github.com/yandex-cloud-examples/yc-terraform-vm-autoscale.git
        ```

    1. Перейдите в директорию с репозиторием. В ней должны появиться файлы:
        - `vm-autoscale.tf` — конфигурация создаваемой инфраструктуры;
        - `declaration.yaml` — описание Docker-контейнера с веб-сервером, который будет запущен на ВМ для имитации нагрузки на сервис;
        - `config.tpl` — описание параметров пользователя ВМ;
        - `vm-autoscale.auto.tfvars` — пользовательские данные.

        В конфигурации используются [группы безопасности](https://cloud.yandex.ru/docs/vpc/concepts/security-groups), они находятся на [стадии Preview](https://cloud.yandex.ru/docs/overview/concepts/launch-stages). [Запросите в технической поддержке](https://yc.yandex-team.ru/support/create-ticket) доступ к этой функции или удалите в конфигурационном файле блоки ресурсов `yandex_vpc_security_group` и строки с параметрами `security_group_ids`.

    Более подробную информацию о параметрах используемых ресурсов в Terraform см. в документации провайдера:
    - [yandex_iam_service_account](https://terraform-provider.yandexcloud.net/Resources/iam_service_account)
    - [yandex_resourcemanager_folder_iam_member](https://terraform-provider.yandexcloud.net/Resources/resourcemanager_folder_iam_member)
    - [yandex_vpc_network](https://terraform-provider.yandexcloud.net/Resources/vpc_network)
    - [yandex_vpc_subnet](https://terraform-provider.yandexcloud.net/Resources/vpc_subnet)
    - [yandex_vpc_security_group](https://terraform-provider.yandexcloud.net/Resources/vpc_security_group)
    - [yandex_compute_instance_group](https://terraform-provider.yandexcloud.net/Resources/compute_instance_group)
    - [yandex_lb_network_load_balancer](https://terraform-provider.yandexcloud.net/Resources/lb_network_load_balancer)

1. В файле `vm-autoscale.auto.tfvars` задайте пользовательские параметры:
    - `folder_id` — [идентификатор каталога](https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id).
    - `vm_user` — имя пользователя ВМ.
    - `ssh_key` — содержимое файла с открытым SSH-ключом для аутентификации пользователя на ВМ. Подробнее см. [Создание пары ключей SSH](https://cloud.yandex.ru/docs/compute/operations/vm-connect/ssh#creating-ssh-keys).

1. Создайте ресурсы:
    1. В терминале перейдите в директорию с загруженным репозиторием.
    1. Проверьте корректность конфигурационного файла с помощью команды:

        ```bash
        terraform validate
        ```

        Если конфигурация является корректной, появится сообщение:

        ```bash
        Success! The configuration is valid.
        ```

    1. Выполните команду:

        ```bash
        terraform plan
        ```

        В терминале будет выведен список ресурсов с параметрами. На этом этапе изменения не будут внесены. Если в конфигурации есть ошибки, Terraform на них укажет.
    1. Примените изменения конфигурации:

        ```bash
        terraform apply
        ```

    1. Подтвердите изменения: введите в терминале слово `yes` и нажмите **Enter**.
1. [Проверьте работу группы ВМ и сетевого балансировщика](https://cloud.yandex.ru/docs/tutorials/infrastructure-management/vm-autoscale#check-service).
1. [Проверьте работу автоматического масштабирования](https://cloud.yandex.ru/docs/tutorials/infrastructure-management/vm-autoscale#check-highload).