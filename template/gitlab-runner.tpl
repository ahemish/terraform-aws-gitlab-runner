mkdir -p /etc/gitlab-runner
cat > /etc/gitlab-runner/config.toml <<- EOF

${runners_config}

EOF

${pre_install}

curl -L https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.rpm.sh | bash
yum install gitlab-runner-${gitlab_runner_version} -y
curl -L https://github.com/docker/machine/releases/download/v${docker_machine_version}/docker-machine-`uname -s`-`uname -m` >/tmp/docker-machine && \
  chmod +x /tmp/docker-machine && \
  cp /tmp/docker-machine /usr/local/bin/docker-machine && \
  ln -s /usr/local/bin/docker-machine /usr/bin/docker-machine
yum install docker -y
usermod -a -G docker ec2-user

${post_install}

service docker start
service gitlab-runner restart
chkconfig gitlab-runner on
