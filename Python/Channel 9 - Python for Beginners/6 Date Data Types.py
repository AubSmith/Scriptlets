from datetime import datetime
current_date = datetime.now()
print('Today is: ' + str(current_date))



from datetime import datetime, timedelta
today = datetime.now()
print('Today is: ' + str(today))
one_day = timedelta(days=1)
yesterday = today - one_day
print('Yesterday was: ' + str(yesterday))



one_week = timedelta(weeks=1)
last_week = today - one_week
print('Last week was: ' + str(last_week))



print('Second: ' + str(today.second))
print('Minute: ' + str(today.minute))
print('Hour: ' + str(today.hour))
print('Day: ' + str(current_date.day))
print('Month: ' + str(current_date.month))
print('Year: ' + str(current_date.year))



from datetime import datetime
birthday = input('When is your birthday (dd/mm/yyyy)? ')
birthday_date = datetime.strptime(birthday, '%d/%m/%Y')

print('Birthday: ' + str(birthday_date))



from datetime import datetime,timedelta
birthday = input('When is your birthday (dd/mm/yyyy)? ')
birthday_date = datetime.strptime(birthday, '%d/%m/%Y')
print('Birthday: ' + str(birthday_date))
one_day = timedelta(days=1)
birthday_eve = birthday_date - one_day
print('Day before birthday: ' + str(birthday_eve))
