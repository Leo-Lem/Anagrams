import json

with open("dict-en.json") as f:
    data = json.load(f)
    entries = list(data.keys())

with open("words-en.json", "w", encoding="utf-8") as f:
    data2 = json.dumps(entries)
    json.dump(data2, f, ensure_ascii=False)