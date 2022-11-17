
import re, enchant, json

#configuration
language = "es" #ISO Code #german: "de", english: "en", spanish: "es", french: "fr"

#program
textfile = "" #input txt file
if language == "en": textfile = "lotr"
elif language == "de": textfile = "buddenbrooks"
elif language == "es": textfile = "donquixote"
elif language == "fr": textfile = "lesmiserables"

previewItems = 20 #number of list items to preview
jsonfile = f"start-{language}" #output json file
dict = enchant.Dict(language)

with open(f"{textfile}.txt", "r") as textFile:
    words = textFile.read().split()
    print(f"\n1. initial: {len(words)} words")
    print(words[0:previewItems])

    #converts all letters to lowercase
    words2 = [word.lower() for word in words]
    print(f"\n2. lowercased: {len(words2)} words")
    print(words2[0:previewItems])

    #removes non-alphabet characters
    words3 = []
    for word in words2:
        words3.append(''.join(filter(str.isalpha, word)))
    print(f"\n3. filtered: {len(words3)} words")
    print(words3[0:previewItems])

    #removes all words not having the required length
    words4 = []
    for word in words3:
        if len(word) == 8:
            words4.append(word)
    print(f"\n4. 8 letters long: {len(words4)} words")
    print(words4[0:previewItems])

    #removes all words not in the dictionary
    words5 = []
    for word in words4:
        if dict.check(word):
            words5.append(word)
    print(f"\n5. dictionary checked: {len(words5)} words")
    print(words5[0:previewItems])

    #removes duplicate words
    words6 = list(set(words5))
    print(f"\n6. no duplicates: {len(words6)} words")
    print(words6[0:previewItems])

#writing to a json file
with open(f"{jsonfile}.json", "w", encoding="utf-8") as jsonFile:
    data = words6
    data.sort()
    json.dump(data, jsonFile, ensure_ascii=False)
    print(f"\n{jsonfile}.json created with {len(data)} words.")