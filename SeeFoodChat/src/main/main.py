from ..helpers import embed
import numpy as np
from sklearn.metrics.pairwise import cosine_similarity


genres = {
    "japanese": ["asian", "japan", "japanese", "sushi"],
    "korean": ["asian", "korean", "korea"],
    "chinese": ["asian", "chinese", "china"],
    "american": ["american", "america", "burger", "mcdonalds"],
    "comfort": ["comfort", "cheap", "fast"],
    "indian": ["spicy", "indian", "india", "curry"],
}
portions = {
    "small": ["small", "little", "bit"],
    "medium": ["medium", "enough", "middle"],
    "large": ["large", "lot"],
}
misc = {
    "spicy": ["spicy", "hot"],
    "organic": ["organic", "natural"],
    "glutenfree": ["gluten free", "gluten-free"],
    "vegetarian": ["vegetarian", "vegan"],
    "no": ["nope", "no", "fuck off", "bye", "thanks", "stop", "done"],
}

for key, samples in genres.items():
  vecs = []
  for sample in samples:
    vecs += [embed(x) for x in sample.split(" ")]
  genres[key] = np.mean(vecs, axis=0)
for key, samples in portions.items():
  vecs = []
  for sample in samples:
    vecs += [embed(x) for x in sample.split(" ")]
  portions[key] = np.mean(vecs, axis=0)


def handle(query, type):
  type = str(type).strip()
  query = str(query).lower().strip()
  query_vec = np.mean([embed(x) for x in query.split(" ")], axis=0)
  if type == "genre":
    res = handle_genres(query_vec)
    return res, "Got it, you want %s food" % res
  elif type == "portion":
    res = handle_portion(query_vec)
    return res, "Got it, you want a %s amount of food" % res
  else:
    res = handle_general(query)
    if "no" in res:
      return ",".join(res), "Alright."
    elif len(res) is 0:
      return ",".join(res), "I don't understand"
    else:
      return ",".join(res), "Alright, you want something: " + ", ".join(res)


def handle_genres(query_vec):
  results = {}
  for key, vec in genres.items():
    results[key] = cosine_similarity([query_vec], [vec])[0][0]
  print(sorted(results.items(), key=lambda x: x[1]))
  return sorted(results.items(), key=lambda x: x[1])[-1][0]


def handle_portion(query_vec):
  results = {}
  for key, vec in portions.items():
    results[key] = cosine_similarity([query_vec], [vec])[0][0]
  print(sorted(results.items(), key=lambda x: x[1]))
  return sorted(results.items(), key=lambda x: x[1])[-1][0]


def handle_general(query):
  results = []
  for key, samples in misc.items():
    for opt in samples:
      if opt in query:
        results.append(key)
        break
  return results

