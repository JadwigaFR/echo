# README

This api has been created to fulfill Babbel's coding challenge. See `echo.md`.

## Dependencies
- ruby 3.1.2
- rails 7.0.x
- postgresl

## How to set up
- Install dependencies
    ```bash
    bundle install
    ```
- Configure database (copy sample file and replace values)
    ```bash
    cp config/database.sample.yml config/database.yml
    ```
- Create and migrate database
  ```bash
  rails db:create rails db:migrate
  ```
- Get the server running
  ```bash
  rails s
  ```

## How to run the tests
```bash
bundle exec rspec
```
