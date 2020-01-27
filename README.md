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

####Logics:
For the application developing, I was guided by the following logic:
Since the uniqueness of contracts is determined by the combination of its number and period, I excluded absolutely any overlap of periods.
I also suggested that a new infinite contract overlaps any existing infinite contract, 
as well as any regular contract, the end date of which was equal to or greater than the start date of the new contract.
Thus, if any overlapping periods exist, all overlapped contracts are marked as inactive.
This allows us to keep only one contract relevant by period and number.
It also seemed logical to me that creating an invoice and calculating the amount of the fees made sense only for active contracts.
I preferred to keep in the invoice the calculation of each fees as a separate fields, as well as the total amount of the fee.

#### Validation logic:
For validation, except the validation aspects described in the assignment I also was guided only 
by logic that was absolutely obvious to me.
For example, that the start date of the contract can't be later than the end date,
or that the invoice amount can't be a negative number, etc.

At that time, I didn't apply any validations for cases that weren't absolutely clear to me. 
For example: 'is it possible if in some cases an additional or fixed fee is not charged and can be zero?',
or 'can a period of a contract be shorter than days_included value?' 
Such logical validations can be easily added after clarifications. 

#### Testing logic:
According the service base idea I've applied the main part of the tests to services.
Essentially it combines both unit and integration tests. 
Endpoints testing contains the JSON schema testing only.
### License

The software is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
