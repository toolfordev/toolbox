FROM registry.fedoraproject.org/fedora-toolbox:35

RUN rpm --import https://packages.microsoft.com/keys/microsoft.asc; \
    sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'; \
    dnf -y update; \
    dnf -y install code; \
    dnf -y install golang; \
    dnf -y install https://dbeaver.io/files/dbeaver-ce-latest-stable.x86_64.rpm; \
    dnf clean all; \
    rm -rf /var/cache /var/log/dnf* /var/log/yum.*
