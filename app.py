from flask import Flask, jsonify
import os

app = Flask(__name__)

@app.route("/")
def show_env():
    # Pega todas as variáveis de ambiente e retorna como JSON
    return jsonify(dict(os.environ))

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
