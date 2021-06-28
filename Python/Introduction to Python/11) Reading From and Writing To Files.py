f = open("countries.txt", "r")

countries = []

for line in f:
    line = line.strip()
    print(line)
    countries.append(line)

f.close()
print(len(countries))

for country in countries:
    if country[0] == "T":
        print(country)



s = open("scores.txt", "w")

while True:
    participant = input("Participant name > ")
    if participant == "quit":
        print("Quitting...")
        break

    score = input("Score for " + participant + "> ")
    f.write(participant + "," + score + "\n")

s.close()



r = open("scores.txt", "r")

participants = {}

for line in r:
    # print(line.strip(line.split(",")))
    entry = line.strip().split(",")
    participant = entry[0]
    score = entry[1]
    participants[participant] = score
    print(participant + ": " + score)

r.close()
print(participants)