# Pipeline Components: Ansible-lint

[![][gitlab-repo-shield]][repository]
![Project Stage][project-stage-shield]
![Project Maintenance][maintenance-shield]
[![License][license-shield]](LICENSE)
[![GitLab CI][gitlabci-shield]][gitlabci]

## Docker status

[![Image Size][size-shield]][dockerhub]
[![Docker Pulls][pulls-shield]][dockerhub]

## Usage

The image is for running Ansible-lint, The image is based on alpine:3.16.

## Examples

```yaml
ansible-lint:
  stage: linting
  image: registry.gitlab.com/pipeline-components/ansible-lint:latest
  script:
    - ansible-lint --show-relpath
```

if your ansible setup is in a subfolder of the git repository, use for example
```yaml
ansible-lint:
  stage: linting
  image: registry.gitlab.com/pipeline-components/ansible-lint:latest
  script:
    - ansible-lint --show-relpath my-ansible/folder
```

For using Junit reporting in gitlab:
```yaml
ansible-lint:
  stage: linting
  image: registry.gitlab.com/pipeline-components/ansible-lint:latest
  artifacts:
    when: always
    reports:
      junit: ansible-lint.xml
  script:
    - ansible-lint -v --show-relpath -f pep8 --nocolor
      | ansible-lint-junit -o ansible-lint.xml
```

Display Results in the Code Quality section of Gitlab MRs (but also show the results in the console output):
```yaml
ansible-lint:
  stage: linting
  image: registry.gitlab.com/pipeline-components/ansible-lint:latest
  script:
    - ansible-lint -f codeclimate | python -m json.tool | tee "${CI_PROJECT_DIR}/codeclimate-results.json"
  artifacts:
    name: "$CI_JOB_NAME artifacts from $CI_PROJECT_NAME on $CI_COMMIT_REF_SLUG"
    reports:
      codequality:
        - "${CI_PROJECT_DIR}/codeclimate-results.json"
    paths:
      - "${CI_PROJECT_DIR}/codeclimate-results.json"
```

## Versioning

This project uses [Semantic Versioning][semver] for its version numbering.

## Support

Got questions?

Check the [discord channel][discord]

You could also [open an issue here][issue]

## Contributing

This is an active open-source project. We are always open to people who want to
use the code or contribute to it.

We've set up a separate document for our [contribution guidelines][contributing-link].

Thank you for being involved! 😍

## Authors & contributors

The original setup of this repository is by [Robbert Müller][mjrider].

The Build pipeline is large based on [Community Hass.io Add-ons
][hassio-addons] by [Franck Nijhof][frenck].

For a full list of all authors and contributors,
check [the contributor's page][contributors].

## License

This project is licensed under the [MIT License](./LICENSE) by [Robbert Müller][mjrider].

[contributing-link]: https://pipeline-components.dev/contributing/
[contributors]: https://gitlab.com/pipeline-components/ansible-lint/-/graphs/main
[discord]: https://discord.gg/vhxWFfP
[dockerhub]: https://hub.docker.com/r/pipelinecomponents/ansible-lint
[frenck]: https://github.com/frenck
[gitlab-repo-shield]: https://img.shields.io/badge/Source-Gitlab-orange.svg?logo=gitlab
[gitlabci-shield]: https://img.shields.io/gitlab/pipeline/pipeline-components/ansible-lint.svg
[gitlabci]: https://gitlab.com/pipeline-components/ansible-lint/-/commits/main
[hassio-addons]: https://github.com/hassio-addons
[issue]: https://gitlab.com/pipeline-components/ansible-lint/issues
[license-shield]: https://img.shields.io/badge/License-MIT-green.svg
[maintenance-shield]: https://img.shields.io/maintenance/yes/2025.svg
[mjrider]: https://gitlab.com/mjrider
[project-stage-shield]: https://img.shields.io/badge/project%20stage-production%20ready-brightgreen.svg
[pulls-shield]: https://img.shields.io/docker/pulls/pipelinecomponents/ansible-lint.svg?logo=docker
[repository]: https://gitlab.com/pipeline-components/ansible-lint
[semver]: http://semver.org/spec/v2.0.0.html
[size-shield]: https://img.shields.io/docker/image-size/pipelinecomponents/ansible-lint.svg?logo=docker
