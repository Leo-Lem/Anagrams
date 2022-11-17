allowed = set('abcdefghijklmnopqrstuvwxyzäöüß')
words = ["aaba", "aab", "asdaá", "as", "á?asfsa"]
words2 = words.copy()

for word in words:
    cond1 = len(word) >= 4
    cond2 = set(word) <= allowed
    if not(cond1 and cond2): words2.remove(word)
    print(word)
    print(words)
    print(words2)