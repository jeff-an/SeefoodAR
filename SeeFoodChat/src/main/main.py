from ..helpers import embed
import numpy as np
from sklearn.metrics.pairwise import cosine_similarity


def handle(query, type):
  type = str(type).strip()
  query = str(query).strip()

  if type == "genre":
    return handle_genres(query)
  elif type == "portion":
    return handle_portion(query)
  else:
    return handle_general(query)

def handle_genres(query):
  genres = {}
  for n in ["chinese", "korean", "american", "sushi", "mexican"]:
    genres[n] = cosine_similarity([np.mean([embed(x) for x in query.split(" ")], axis=0)], [embed(n)])[0][0]
  return sorted(genres.items(), key=lambda x: x[1])[0][0]

def handle_portion(query):
  genres = {}
  for n in ["large", "small", "medium"]:
    genres[n] = cosine_similarity([np.mean([embed(x) for x in query.split(" ")], axis=0)], [embed(n)])[0][0]
  return sorted(genres.items(), key=lambda x: x[1])[0][0]
  
def handle_general(query):
  return "Sure"

