## Automation Workflow

In most cases, workflow begins with the developer forking the repo and checking out the develop branch of their own repo.
Submit a PR after locally testing your changes (see [CONTRIBUTING.md)

  1. PRs are run through the rake tests
  2. Once a PR has passed rake tests the PR can be merged into develop
  3. merge to develop will spawn a Jenkins build and Dockerhub Build of the site
  4. once images are pushed to registry, site is deployed to kubernetes cluster for review
       - [public test site URL]
  5. Once site is reviewed, a PR to master will run through the tests, 
  6. if tests pass, merge to master will produce images with "katest" and "master" tags 
  7. production website is deployed to IPFS 
  8. html-proofer checks the site links on the live site, verify site shows current commit
     - [TODO] current commit needs to be added to site footer
     - [TODO] second rake task to provide more thorough tests/tests of live site 
  9. IPFS update announcement goes to Twitter and Telegram 
  10. Fin
