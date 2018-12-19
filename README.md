# assignmentsbot
send email daily from assignments google calendar

## NOTES

# copy .env.sample to .env and replace with your own settings

# use SSM to store environment variables

aws ssm put-parameter --name "assignmentsbotAPIKey" --type "String" --value "abc123" --profile chaserx

aws ssm put-parameter --name "assignmentsbotCalendar" --type "String" --value "blahblahGoogleCalendarblah" --profile chaserx

aws ssm put-parameter --name "mailgunAPIKey" --type "String" --value "key-abc123xyz" --profile chaserx

aws ssm put-parameter --name "mailgunDomain" --type "String" --value "mail.mydomain.com" --profile chaserx

# bundle for production

bundle install --without development --deployment --path vendor/bundle 

to capture native extensions:

docker run -v `pwd`:`pwd` -w `pwd` -i -t lambci/lambda:build-ruby2.5 bundle install --without development --deployment

# package it up 

sam package --template-file template.yml --output-template-file packaged.yml --s3-bucket assignmentsbot-cloudformation --profile chaserx

# deploy 

sam deploy --template-file packaged.yml --stack-name assignmentsbot-sam --capabilities CAPABILITY_IAM --profile chaserx

# set a cloudwatch rule to trigger lambda at 4pm EST / 9pm UTC for homework calendar check

This can be set multiple ways. Manually in the console, on the command line and in the template.yml file. Here, using an `event` property in the template file. 

```yaml
  Events:
    Weekday4pmCron:
      Type: Schedule
      Properties:
        Schedule: cron(0 21 ? * MON-FRI *)
```

