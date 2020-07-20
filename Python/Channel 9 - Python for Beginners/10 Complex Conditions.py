gpa = float(input('What was your Grade Point Average '))
lowest_grade = float(input('What was your lowest grade? '))
if gpa >= .85 and lowest_grade >= .70:
    honour_roll = True
else:
    honour_roll = False
if honour_roll:
    print('You made the honour roll!')