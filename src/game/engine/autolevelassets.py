fulltext = ""

mode = "E"
bottom = 1
top = 2

for i in range(bottom, top + 1):
    fulltext += f"      public static var {mode}{i}:Class = Assets_{mode}{i};"
    fulltext += "\n"

print(fulltext)
