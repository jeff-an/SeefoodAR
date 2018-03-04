from gensim.models import KeyedVectors
import numpy as np

model = KeyedVectors.load_word2vec_format('data/wv.txt', binary=False)

def embed(string, default=np.zeros(300)):
	"""
	Return embedding for a word.
	"""
	if string in model:
		return model.wv[string]
	else:
		return default

