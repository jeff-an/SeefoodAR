from flask import request, jsonify
from flask_api import FlaskAPI
from flask_cors import CORS
from .main import handle

app = FlaskAPI(__name__)
cors = CORS(app)


@app.route("/chat", methods=['POST'])
def get_temp():
  print("\nNew request made.")
  query = str(request.data.get('query'))
  type = str(request.data.get('type'))
  if str(type).strip() not in ["genre", "portion", "etc"]:
    return jsonify({'error': "Invalid type specification"})
  response = handle(query, type)

  return jsonify({'response': response})


if __name__ == "__main__":
  app.run(host='0.0.0.0', port=5000)

