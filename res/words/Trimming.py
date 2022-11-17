
import json

def removeLongWords(words):
    words = [word for word in words if len(word) <= 8]
    return words


with open("words-fr.json", "r") as f:
    data = json.load(f)
    words = list(data)
    words2 = removeLongWords(words)

with open("words-fr (mod).json", "w") as f:
    json.dump(words2, f, ensure_ascii=False)