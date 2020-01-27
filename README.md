## Fee calculating Api
Ruby Rails application for REST API with Trailblazer Operations,
ActiveRecord, RSpec
### Dependencies:
- Ruby 2.6.3
- PostgreSQL

### Description
The application creates contracts and invoices and calculates fees

### Installation:
- Clone poject
- Run bundler:

 ```shell
 $ bundle install
 ```
- Create database.yml:
```shell
$ cp config/database.yml.sample config/database.yml
```

- Run application:

 ```shell
 $ rails server
 ```

##### Tests:
To execute tests, run following commands:
 
```shell
 $ bundle exec rake db:migrate RAILS_ENV=test #(the first time only)
 $ bundle exec rspec
```

### Explanation of the approach:
I've decided to apply the service base approach such as Trailblazer operations.
I was guided by the principles of application scaling and easy integration of new features. 

#### Common logic:
For the application developing, I was guided by the following logic:
Since the uniqueness of contracts is determined by the combination of its number and period, I excluded absolutely any overlap of periods.
I also suggested that a new infinite contract overlaps any other existing infinite contract with the same number, 
as well as any other regular contract with the same number, the end date of which was equal to or greater than the start date of the new contract.
Thus, any contract with such overlapped period is marked as inactive and the new contract supersedes it.
Such a solution allows us to keep only one contract relevant by period and number.
It also seemed to me logical that creating an invoice and calculating the amount of fees made sense only
for active contracts.

#### Validation logic:
For validation, except the validation rules described in the assignment I also was guided only 
by logic that was absolutely obvious to me.
For example, that the start date of a contract can't be later than the end date,
or that an invoice amount can't be a negative number, etc.

At that time, I didn't apply validations for cases that weren't absolutely clear to me. 
For example: I allowed that a period of a contract could be shorter than days_included value, etc  
Such logical validations can be easily added after clarifications. 

#### Testing logic:
According the service base idea I've applied the main part of tests to services.
Essentially it combines both unit and integration tests. 
Endpoints testing contains the JSON schema testing only.
### License

The software is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
