# Basic Web Scraper

## Description
This scrapper accepts a Trail URL from `poderjudicialvirtual.com/` and creates
a new record from it.


## Features
- The Trial should contain the title, actor, defendant, expedient, summary, and court.
- The web scraper will not create any record unless find at least one of the searched fields.
- It removes undesired/duplicated data for the actor, defendant and expedient fields.
- Scraps Notifications for the trial and saves it to a record. 

## How to use it
Go to `localhost:3000` and enter a valid url on the text field. You will see the new trial being created.

## Requirements
- Ruby 2.7.0
- Rails 6
- PostgreSQL

## Setup
```shell script
bundle install
bundle exec rails db:setup
yarn install
rails s
```

## Testing
Running rspec tests
```shell script
bundle exec rspec --format doc
```

## Road map
This project can be improved in several ways.
- Improve success and error messaging for the user.
- Refactor TrialsSpider to do not need to mix class and instance methods. This project uses `kimuraframework` gem 
for the web scraping that are implemented on that way.
- Add styling to UI.
- Implement detection for the page's bot detection. There is no way to the user to know wether site
has banned you due to "suspect activity".
