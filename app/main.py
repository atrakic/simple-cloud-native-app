import sys
from flask import Flask
from flask import jsonify, redirect, url_for

data = [
    {"id": "0", "name": "google.com"},
    {"id": "1", "name": "JobZilla.com"},
    {"id": "2", "name": "Dice.com"},
    {"id": "3", "name": "LinkedIn.com"},
]

app = Flask(__name__)


@app.route("/")
def index():
    return redirect(url_for("jobsites", id="0"))


@app.route("/api/v1/<id>", methods=["GET"])
def jobsites(id):
    return jsonify(list(filter(lambda x: x["id"] == id, data)))


@app.route("/version")
def hello():
    version = "{}.{}".format(sys.version_info.major, sys.version_info.minor)
    return jsonify(
        version=version,
    )


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=80)
