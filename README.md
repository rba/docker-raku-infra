# docker-raku-infra
Base images for raku infra

```

                             ┌───────────────────────┐                             
                             │                       │                             
                             │      alpine:3.10      │                             
                             │                       │                             
                             └───────────────────────┘                             
                                         │                                         
                                         │                                         
            ┌────────────────────────────┼────────────────────────────┐            
            │                            │                            │            
            │                            │                            │            
            ▼                            ▼                            ▼            
┌───────────────────────┐    ┌───────────────────────┐    ┌───────────────────────┐
│                       │    │                       │    │                       │
│   alpine-perl-mojo    │    │     alpine-nginx      │    │     alpine-rakudo     │
│                       │    │                       │    │                       │
└───────────────────────┘    └───────────────────────┘    └───────────────────────┘


Use cases:
    build: alpine-rakudo
    run:   alpine-perl-mojo | alpine-nginx
```

## Accessing the GitHub Docker Registry

In order to use GitHub packages with Docker, one [has to create an access token](https://help.github.com/en/github/authenticating-to-github/creating-a-personal-access-token-for-the-command-line) and [login using the GitHub username and this token](https://help.github.com/en/packages/using-github-packages-with-your-projects-ecosystem/configuring-docker-for-use-with-github-packages). As long as images just have to be pulled, the `read:packages` scope is sufficient.
