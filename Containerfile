FROM registry.fedoraproject.org/fedora-toolbox:35

##TMD## INSTALL PODMAN - BEGIN

## Source: https://github.com/containers/podman/blob/main/contrib/podmanimage/stable/Dockerfile

RUN dnf -y update; \
    rpm --restore shadow-utils 2>/dev/null; \
    yum -y install podman fuse-overlayfs --exclude container-selinux; \
    dnf clean all; \
    rm -rf /var/cache /var/log/dnf* /var/log/yum.*

RUN useradd podman; \
    echo podman:10000:5000 > /etc/subuid; \
    echo podman:10000:5000 > /etc/subgid;

ADD https://raw.githubusercontent.com/containers/podman/main/contrib/podmanimage/stable/containers.conf /etc/containers/containers.conf

ADD https://raw.githubusercontent.com/containers/podman/main/contrib/podmanimage/stable/podman-containers.conf /home/podman/.config/containers/containers.conf

RUN mkdir -p /home/podman/.local/share/containers; \
    chown podman:podman -R /home/podman

VOLUME /var/lib/containers

VOLUME /home/podman/.local/share/containers

RUN chmod 644 /etc/containers/containers.conf; \
    sed -i -e 's|^#mount_program|mount_program|g' -e '/additionalimage.*/a "/var/lib/shared",' -e 's|^mountopt[[:space:]]*=.*$|mountopt = "nodev,fsync=0"|g' /etc/containers/storage.conf

RUN mkdir -p /var/lib/shared/overlay-images /var/lib/shared/overlay-layers /var/lib/shared/vfs-images /var/lib/shared/vfs-layers; \
    touch /var/lib/shared/overlay-images/images.lock; \
    touch /var/lib/shared/overlay-layers/layers.lock; \
    touch /var/lib/shared/vfs-images/images.lock; \
    touch /var/lib/shared/vfs-layers/layers.lock

ENV _CONTAINERS_USERNS_CONFIGURED=""

##TMD## INSTALL PODMAN - END

##TMD## INSTALL VSCODE - BEGIN

RUN rpm --import https://packages.microsoft.com/keys/microsoft.asc; \
    sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'; \
    dnf install code; \
    dnf clean all; \
    rm -rf /var/cache /var/log/dnf* /var/log/yum.*

##TMD## INSTALL VSCODE - END

##TMD## INSTALL DBEAVER - BEGIN

RUN dnf -y update; \
    dnf -y install https://dbeaver.io/files/dbeaver-ce-latest-stable.x86_64.rpm; \
    dnf clean all; \
    rm -rf /var/cache /var/log/dnf* /var/log/yum.*

##TMD## INSTALL DBEAVER - END

##TMD## INSTALL GOLANG AND GH - BEGIN

RUN dnf -y update; \
    dnf -y install golang gh; \
    dnf clean all; \
    rm -rf /var/cache /var/log/dnf* /var/log/yum.*

##TMD## INSTALL GOLANG AND GH  - END
