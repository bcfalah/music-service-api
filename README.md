# music-service-api
API for a great music streaming service

# Development Environment Setup

## Initial Setup

1. Clone the repository: `git clone https://github.com/bcfalah/music-service-api.git`
1. Install rbenv/rvm, ruby 2.4.1 and bundler
1. Install postgresql and make sure it's running
1. Configure application database: `cp ./config/database.yml.sample ./config/database.yml` and customize as required
1. Run application setup: `./bin/setup` (It will install dependencies and prepare the database, among other things)
1. Verify that all the tests are ok by running `bundle exec rspec spec`
1. Start the application: `bundle exec rails server`

**Applying updates:** Running `./bin/update` will apply missing updates

## Contributing

1. `git checkout master`
1. `git checkout -b <feature-branch>`
1. [perform changes]
1. `git add <whatever makes sense>`
1. `git commit`
1. `git push origin <feature-branch>`
1. [create a pull request from `<feature-branch>` to master]

## API Documentation

1. Generate documentation running `bundle exec rake documentation:generate`
1. Run server and access to the root to view the Swagger interactive documentation

## Deployment

Make sure `heroku-cli` is installed

## Remotes Setup
1. origin: https://github.com/bcfalah/music-service-api.git
1. heroku-production: https://git.heroku.com/music-api-production.git

## Manual Deployment

These steps should work as a guide to have updates applied.

1. `heroku maintenance:on -a music-api-production` [enable maintenance mode]
1. `git push heroku-production master` [deploy to heroku]
1. `heroku run -a music-api-production bundle exec rake db:migrate` [mantainance tasks]
1. `heroku restart -a music-api-production` [restart]
1. `heroku maintenance:off -a music-api-production` [disable maintenance mode]

**Note:** Using production environment for this example. But any other environment should work just the same.

# License
